var rimraf = require( "rimraf" );

/*jshint node:true */
module.exports = function( grunt ) {
"use strict";

var entryFiles = grunt.file.expandFiles( "entries/*.xml" );

grunt.loadNpmTasks( "grunt-wordpress" );
grunt.loadNpmTasks( "grunt-jquery-content" );
grunt.loadNpmTasks( "grunt-check-modules" );

grunt.initConfig({
	lint: {
		grunt: "grunt.js"
	},
	xmllint: {
		all: [].concat( entryFiles, "categories.xml", "entries2html.xsl", "notes.xsl" )
	},
	xmltidy: {
		all: [].concat( entryFiles, "categories.xml" )
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

grunt.registerTask( "default", "build-wordpress" );
grunt.registerTask( "build", "build-pages build-xml-entries build-xml-categories build-xml-full build-resources" );
grunt.registerTask( "build-wordpress", "check-modules clean lint xmllint build" );
grunt.registerTask( "tidy", "xmllint xmltidy" );

};
