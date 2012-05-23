/*jshint node:true */
module.exports = function( grunt ) {

var // modules
	fs = require( "fs" ),
	path = require( "path" ),
	spawn = require( "child_process" ).spawn,
	
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

grunt.registerTask( "default", "build-wordpress" );
grunt.registerTask( "build-wordpress", "clean lint xmllint build-entries build-categories" );
grunt.registerTask( "deploy", "wordpress-deploy" );

};
