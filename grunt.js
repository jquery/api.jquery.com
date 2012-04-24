/*jshint node:true */
module.exports = function( grunt ) {

var entryFiles = grunt.file.expandFiles( "entries/*.xml" );

grunt.initConfig({
	lint: {
		grunt: "grunt.js"
	},
	xmllint: {
		all: entryFiles
	}
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
			grunt.warn( "Task \"xmllint\" failed." );
			taskDone();
			return;
		}
		grunt.log.writeln( "Lint free." );
		taskDone();
	});
});

grunt.registerTask( "default", "lint xmllint" );

};
