/*jshint node:true */
module.exports = function( grunt ) {

var	entryFiles = grunt.file.expandFiles( "entries/*.xml" );

grunt.initConfig({
	lint: {
		grunt: "grunt.js"
	},
	xmllint: {
		all: entryFiles
	}
});

grunt.registerTask( "xmllint", function() {
	var taskDone = this.async();
	grunt.utils.async.forEachSeries( entryFiles, function( file, done ) {
		grunt.utils.spawn({
			cmd: "xmllint",
			args: [ "--noout", file ]
		}, function( err, result ) {
			if ( err ) {
				grunt.log.error( err );
				done();
				return;
			}
			done();
		}, taskDone);
	});
});

grunt.registerTask( "default", "lint xmllint" );

};
