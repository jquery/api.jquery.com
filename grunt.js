var rimraf = require( "rimraf" );

module.exports = function( grunt ) {

var entryFiles = grunt.file.expandFiles( "entries/*.xml" );

grunt.loadNpmTasks( "grunt-check-modules" );
grunt.loadNpmTasks( "grunt-jquery-content" );
grunt.loadNpmTasks( "grunt-wordpress" );

grunt.initConfig({
	xmllint: {
		all: [].concat( entryFiles, "categories.xml", "entries2html.xsl", "notes.xsl" )
	},
	"build-pages": {
		all: grunt.file.expandFiles( "pages/**" )
	},
	"build-xml-entries": {
		all: entryFiles
	},
	"build-resources": {
		all: grunt.file.expandFiles( "resources/**" )
	},
	wordpress: grunt.utils._.extend({
		dir: "dist/wordpress"
	}, grunt.file.readJSON( "config.json" ) )
});

grunt.registerTask( "clean", function() {
	rimraf.sync( "dist" );
});

grunt.registerTask( "build", "build-pages build-xml-entries build-xml-categories build-xml-full build-resources" );
grunt.registerTask( "build-wordpress", "check-modules clean xmllint build" );

};
