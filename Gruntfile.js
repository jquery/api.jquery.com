module.exports = function( grunt ) {

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
	"build-posts": {
		page: "pages/**"
	},
	"build-xml-entries": {
		all: "entries/**"
	},
	"build-resources": {
		all: "resources/**"
	},
	wordpress: (function() {

		// There's no config for CI, but we don't need one for basic testing
		var config = {};
		try {
			config = require( "./config" );
		} catch ( error ) {}
		config.dir = "dist/wordpress";
		return config;
	})()
});

grunt.registerTask( "lint", [ "xmllint" ]);

grunt.registerTask( "build", [
	"build-posts",
	"build-resources",
	"build-xml-entries",
	"build-xml-categories",
	"build-xml-full"
]);

};
