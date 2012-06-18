/*jshint node:true */
module.exports = function( grunt ) {

var // modules
	fs = require( "fs" ),
	path = require( "path" ),
	pygmentize = require( "pygmentize" ),
	rimraf = require( "rimraf" ),
	spawn = require( "child_process" ).spawn,

	// files
	pageFiles = grunt.file.expandFiles( "pages/*.html" ),
	entryFiles = grunt.file.expandFiles( "entries/*.xml" ),
	noteFiles = grunt.file.expandFiles( "notes/*.xml" ),
	resourceFiles = grunt.file.expandFiles( "resources/*" ),

	xmlFiles = [].concat( entryFiles, noteFiles, "cat2tax.xsl", "categories.xml", "entries2html.xsl", "xml2json.xsl" );

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
	}, grunt.file.readJSON( "config-stage.json" ) )
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
		grunt.log.writeln( "Lint free files: " + xmlFiles.length );
		taskDone();
	});
});

grunt.registerTask( "build-pages", function() {
	var task = this,
		taskDone = task.async(),
		targetDir = grunt.config( "wordpress.dir" ) + "/posts/page/";

	grunt.file.mkdir( targetDir );

	grunt.utils.async.forEachSeries( pageFiles, function( fileName, fileDone ) {
		var targetFileName = targetDir + path.basename( fileName );
		grunt.verbose.write( "Reading " + fileName + "..." );
		grunt.verbose.ok();
		grunt.verbose.write( "Pygmentizing " + targetFileName + "..." );
		pygmentize.file( fileName, function( error, data ) {
			if ( error ) {
				grunt.verbose.error();
				grunt.log.error( error );
				fileDone();
				return;
			}
			grunt.verbose.ok();

			grunt.file.write( targetFileName, data );

			fileDone();
		});
	}, function() {
		if ( task.errorCount ) {
			grunt.warn( "Task \"" + task.name + "\" failed." );
			taskDone();
			return;
		}
		grunt.log.writeln( "Built " + pageFiles.length + " pages." );
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
		grunt.verbose.write( "Transforming (pass 1: preproc-xinclude.xsl) " + fileName + "..." );
		grunt.utils.spawn({
			cmd: "xsltproc",
			args: [ "preproc-xinclude.xsl", fileName ]
		}, function( err, pass1result ) {
			if ( err ) {
				grunt.verbose.error();
				grunt.log.error( err );
				fileDone();
				return;
			}
			grunt.verbose.ok();

			var targetXMLFileName = "entries_tmp/" + path.basename( fileName );

			grunt.file.write( targetXMLFileName, pass1result );

			grunt.verbose.write( "Transforming (pass 2: entries2html.xsl) " + fileName + "..." );
			grunt.utils.spawn({
				cmd: "xsltproc",
				args: [ "--xinclude", "entries2html.xsl", targetXMLFileName ]
			}, function( err, pass2result ) {
				if ( err ) {
					grunt.verbose.error();
					grunt.log.error( err );
					fileDone();
					return;
				}
				grunt.verbose.ok();

				var targetHTMLFileName = targetDir + path.basename( fileName );
				targetHTMLFileName = targetHTMLFileName.substr( 0, targetHTMLFileName.length - "xml".length ) + "html";

				grunt.verbose.write( "Pygmentizing " + targetHTMLFileName + "..." );
				pygmentize.file( pass2result, function( error, data ) {
					if ( error ) {
						grunt.verbose.error();
						grunt.log.error( error );
						fileDone();
						return;
					}
					grunt.verbose.ok();

					grunt.file.write( targetHTMLFileName, data );

					fileDone();
				});
			});
		});
	}, function() {
		if ( task.errorCount ) {
			grunt.warn( "Task \"" + task.name + "\" failed." );
			taskDone();
			return;
		}
		rimraf.sync( "entries_tmp" );
		grunt.log.writeln( "Built " + entryFiles.length + " entries." );
		taskDone();
	});
});

grunt.registerTask( "build-categories", function() {
	var task = this,
		taskDone = task.async(),
		categories = {},
		outFilename = grunt.config( "wordpress.dir" ) + "/taxonomies.json";

		grunt.utils.spawn({
			cmd: "xsltproc",
			args: [ "--output", "taxonomies.xml", "cat2tax.xsl", "categories.xml" ]
		}, function( err, result ) {
			if ( err ) {
				grunt.verbose.error();
				grunt.log.error( err );
				taskDone();
				return;
			}
			grunt.utils.spawn({
				cmd: "xsltproc",
				args: [ "--output", outFilename, "xml2json.xsl", "taxonomies.xml" ]
			}, function( err, result ) {
			if ( err ) {
				grunt.verbose.error();
				grunt.log.error( err );
				taskDone();
				return;
			}
			fs.unlinkSync( "taxonomies.xml" );
			grunt.verbose.ok();
			taskDone();
		});
	});
});

grunt.registerTask( "build-resources", function() {
	var task = this,
		taskDone = task.async(),
		targetDir = grunt.config( "wordpress.dir" ) + "/resources/";

	grunt.file.mkdir( targetDir );

	grunt.utils.async.forEachSeries( resourceFiles, function( fileName, fileDone )  {
		grunt.file.copy( fileName, targetDir + path.basename( fileName ) );
		fileDone();
	}, function() {
		if ( task.errorCount ) {
			grunt.warn( "Task \"" + task.name + "\" failed." );
			taskDone();
			return;
		}
		grunt.log.writeln( "Built " + resourceFiles.length + " resources." );
		taskDone();
	});
});

grunt.registerTask( "xmltidy", function() {
	var task = this,
		taskDone = task.async(),
		filesToTidy = [].concat( entryFiles, noteFiles, "categories.xml" );

	// Only tidy files that are lint free
	task.requires( "xmllint" );

	grunt.utils.async.forEachSeries( filesToTidy, function( fileName, fileDone )  {
		grunt.verbose.write( "Tidying " + fileName + "..." );
		grunt.utils.spawn({
			cmd: "xmllint",
			args: [ "--format", fileName ]
		}, function( err, result ) {
			if ( err ) {
				grunt.verbose.error();
				grunt.log.error( err );
				fileDone();
				return;
			}
			grunt.verbose.ok();

			grunt.file.write( fileName, result );

			fileDone();
		});
	}, function() {
		if ( task.errorCount ) {
			grunt.warn( "Task \"" + task.name + "\" failed." );
			taskDone();
			return;
		}
		grunt.log.writeln( "Tidied " + filesToTidy.length + " files." );
		taskDone();
	});
});

grunt.registerTask( "default", "build-wordpress" );
grunt.registerTask( "build-wordpress", "clean lint xmllint build-pages build-entries build-categories build-resources" );
grunt.registerTask( "tidy", "xmllint xmltidy" );

};
