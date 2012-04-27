/*jshint node:true */
module.exports = function( grunt ) {

var // modules
	fs = require( "fs" ),
	path = require( "path" ),
	spawn = require( "child_process" ).spawn,
	
	// files
	entryFiles = grunt.file.expandFiles( "entries/*.xml" );

grunt.loadNpmTasks( "grunt-wordpress" );

grunt.initConfig({
	lint: {
		grunt: "grunt.js"
	},
	xmllint: {
		all: entryFiles
	},
	wordpress: grunt.file.readJSON( "config.json" )
});

grunt.registerTask( "xmllint", function() {
	var task = this,
		taskDone = task.async();
	grunt.utils.async.forEachSeries( entryFiles, function( fileName, fileDone ) {
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
		targetDir = "dist/post/";

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
			grunt.verbose.write( "Writing " + targetFileName + "..." );
			fs.writeFile( targetFileName, result, function( err ) {
				if ( err ) {
					grunt.verbose.error();
					grunt.log.error( err );
					fileDone();
					return;
				}
				grunt.verbose.ok();
				fileDone();				
			});
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

grunt.registerTask( "default", "build" );
grunt.registerTask( "build", "lint xmllint build-entries" );
grunt.registerTask( "deploy", "wordpress-deploy" );

};
