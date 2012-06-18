/*jshint node:true */
module.exports = function( grunt ) {

var // modules
	pygmentize = require( "pygmentize" ),

	// files
	pageFiles = grunt.file.expandFiles( "pages/*.html" ),
	entryFiles = grunt.file.expandFiles( "entries/*.xml" ),
	noteFiles = grunt.file.expandFiles( "notes/*.xml" ),

	xmlFiles = [].concat( entryFiles, noteFiles, "cat2tax.xsl", "categories.xml", "entries2html.xsl", "xml2json.xsl" );

grunt.loadNpmTasks( "grunt-clean" );
grunt.loadNpmTasks( "grunt-wordpress" );
grunt.loadNpmTasks( "grunt-jquery-content" );

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
	xmltidy: {
		all: [].concat( entryFiles, noteFiles, "categories.xml" )
	},
	"build-pages": {
		all: grunt.file.expandFiles( "pages/*" )
	},
	"build-xml-entries": {
		all: entryFiles
	},
	"build-resources": {
		all: grunt.file.expandFiles( "resources/*" )
	},
	wordpress: grunt.utils._.extend({
		dir: "dist/wordpress"
	}, grunt.file.readJSON( "config.json" ) )
});

grunt.registerTask( "default", "build-wordpress" );
grunt.registerTask( "build-wordpress", "clean lint xmllint build-pages build-xml-entries build-xml-categories build-resources" );
grunt.registerTask( "tidy", "xmllint xmltidy" );

};
