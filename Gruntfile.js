var rimraf = require( "rimraf" );

module.exports = function( grunt ) {

grunt.loadNpmTasks( "grunt-check-modules" );
grunt.loadNpmTasks( "grunt-jquery-content" );

grunt.initConfig({
	xmllint: {
		all: [
			"entries/**",
			"includes/**",
			"categories.xml",
			"entries2html.xsl",
			"notes.xsl"
		]
	},
	"build-pages": {
		all: "pages/**"
	},
	"build-xml-entries": {
		all: "entries/**"
	},
	"build-resources": {
		all: "resources/**"
	},
	wordpress: (function() {
		var config = require( "./config" );
		config.dir = "dist/wordpress";
		return config;
	})()
});

grunt.registerTask( "clean", function() {
	rimraf.sync( "dist" );
});

grunt.registerTask( "build", [
	"build-pages",
	"build-resources",
	"build-xml-entries",
	"build-xml-categories",
	"build-xml-full"
]);

grunt.registerTask( "build-wordpress", [
	"check-modules",
	"xmllint",
	"clean",
	"build"
]);

};
