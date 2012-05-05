/*jshint node:true */
module.exports = function( grunt ) {

var // modules
	fs = require( "fs" ),
	path = require( "path" ),
	spawn = require( "child_process" ).spawn,
	libxmljs = require( "libxmljs" ),
	
	// files
	entryFiles = grunt.file.expandFiles( "entries/*.xml" ),
	categoryFiles = grunt.file.expandFiles( "categories/*.xml" ),
	
	xmlFiles = [].concat( entryFiles, categoryFiles );
	
function pathSlug( fileName ) {
	return path.basename( fileName, path.extname( fileName ) );
}

grunt.loadNpmTasks( "grunt-clean" );
grunt.loadNpmTasks( "grunt-wordpress" );

grunt.initConfig({
	clean: {
		folder: "dist"
	},
	lint: {
		grunt: "grunt.js"
	},
	xmllint: {
		all: xmlFiles
	},
	wordpress: grunt.utils._.extend({
		dir: "dist/wordpress"
	}, grunt.file.readJSON( "config.json" ) )
});

grunt.registerTask( "xmllint", function() {
	var task = this,
		taskDone = task.async();
	grunt.utils.async.forEachSeries( xmlFiles, function( fileName, fileDone ) {
		grunt.verbose.write( "Linting " + fileName + "..." );
		grunt.utils.spawn({
			cmd: "xmllint",
			args: [ "--noout", fileName ]
		}, function( err, result ) {
			if ( err ) {
				grunt.verbose.error();
				grunt.log.error( err );
				fileDone();
				return;
			}
			grunt.verbose.ok();
			fileDone();
		});
	}, function() {
		if ( task.errorCount ) {
			grunt.warn( "Task \"" + task.name + "\" failed." );
			taskDone();
			return;
		}
		grunt.log.writeln( "Lint free files: " + entryFiles.length );
		taskDone();
	});
});

grunt.registerTask( "build-entries", function() {
	var task = this,
		taskDone = task.async(),
		// TODO make `entry` a custom post type instead of (ab)using `post`?
		targetDir = grunt.config( "wordpress.dir" ) + "/posts/post/";

	grunt.file.mkdir( targetDir );

	grunt.utils.async.forEachSeries( entryFiles, function( fileName, fileDone ) {
		grunt.verbose.write( "Reading " + fileName + "..." );
		grunt.utils.spawn({
			cmd: "xsltproc",
			args: [ "entries2html.xsl", fileName ]
		}, function( err, result ) {
			var targetFileName;
			if ( err ) {
				grunt.verbose.error();
				grunt.log.error( err );
				fileDone();
				return;
			}
			grunt.verbose.ok();
			targetFileName = targetDir + path.basename( fileName );
			targetFileName = targetFileName.substr( 0, targetFileName.length - "xml".length ) + "html";
			grunt.file.write( targetFileName, result );
			fileDone();
		});
	}, function() {
		if ( task.errorCount ) {
			grunt.warn( "Task \"" + task.name + "\" failed." );
			taskDone();
			return;
		}
		grunt.log.writeln( "Built " + entryFiles.length + " entries." );
		taskDone();
	});
});

grunt.registerTask( "build-categories", function() {
	var task = this,
		taskDone = task.async(),
		categories = {},
		outFilename = grunt.config( "wordpress.dir" ) + "/taxonomies.json";

	grunt.utils.async.forEachSeries( categoryFiles, function( fileName, fileDone ) {
		var xml = grunt.file.read( fileName ),
			xmlDoc = libxmljs.parseXmlString( xml ),
			id = xmlDoc.get( "//category/@id" ).text(),
			parent = xmlDoc.get( "//category/@parent" ).text(),
			name = xmlDoc.get( "//category/@name" ).text(),
			slug = xmlDoc.get( "//category/@slug" ).text(),
			desc = xmlDoc.get( "//category/desc" ).text(),
			fileNameSlug = pathSlug( fileName ),
			errors = [];

		grunt.verbose.write( "Validating " + fileName + "..." );
		if ( slug !== fileNameSlug ) {
			errors.push( "slug attribute (" + slug + ") doesn't match filename slug (" + fileNameSlug + ")" );
		}
		if ( errors.length ) {
			grunt.verbose.error();
			errors.forEach(function( error ) {
				grunt.log.error( error );
			});
			fileDone();
			return;
		}
		grunt.verbose.ok();

		categories[id] = {
			id: id,
			name: name,
			parent: parent,
			slug: slug,
			desc: desc,
			children: []
		};
		
		fileDone();
	}, function() {
		if ( task.errorCount ) {
			grunt.warn( "Task \"" + task.name + "\" failed." );
			taskDone();
			return;
		}

		var id, category, parent,
			taxonomies = {
				"category": [
					{ "name": "Uncategorized", "slug": "Uncategorized" }
				]
			};
		
		function catTree( id ) {
			var category = categories[ id ];
			var cat = {
				name: category.name
			};
			if ( category.slug.length ) {
				cat.slug = category.slug;
			}
			if ( category.desc.length ) {
				cat.description = category.desc;
			}
			if ( category.children.length ) {
				cat.children = [];
				category.children.forEach(function( childId ){
					cat.children.push( catTree( childId ) );
				});
			}
			return cat;
		}
		
		for ( id in categories ) {
			category = categories[ id ];
			parent = categories[ category.parent ];
			if ( parent ) {
				grunt.verbose.write( "Making " + category.name + " a child category of " + parent.name + "..." );
				parent.children.push( id );
			} else {
				grunt.verbose.write( "Making " + category.name + " a top-level category..." );
				category.parent = undefined;
			}
			grunt.verbose.ok();
		}
		
		for ( id in categories ) {
			category = categories[ id ];
			if ( !category.parent ) {
				taxonomies.category.push( catTree( id ) );
			}
		}

		grunt.file.write( outFilename, JSON.stringify( taxonomies ) );
		
		grunt.log.writeln( "Built " + categoryFiles.length + " categories to " + outFilename + "." );
		taskDone();
	});
});

grunt.registerTask( "default", "build" );
grunt.registerTask( "build", "clean lint xmllint build-entries build-categories" );
grunt.registerTask( "deploy", "wordpress-deploy" );

};
