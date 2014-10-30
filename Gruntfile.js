'use strict';
var webpack = require("webpack");
var webpackConfig = require("./webpack.config.js");

module.exports = function (grunt) {
    grunt.loadNpmTasks('grunt-webpack');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.initConfig({
        clean: ['./public'],
        copy: {
            main: {
                files: [
                    {expand: true, flatten: true, src: ['assets/partials/**'], dest: 'public/partials', filter: 'isFile'},
                    {expand: true, flatten: true, src: ['assets/img/ajax_loader.gif'], dest: 'public/img/'}
                ],
            },
        },
        webpack: {
            options: webpackConfig,
            build: {
                plugins: webpackConfig.plugins.concat(
                    new webpack.DefinePlugin({
                     "process.env": {
                        // This has effect on the react lib size
                        "NODE_ENV": JSON.stringify("production")
                     }
                   }),
                   new webpack.optimize.DedupePlugin(),
                   new webpack.optimize.UglifyJsPlugin()
                 )
            },
            "build-dev": {
                devtool: "sourcemap",
                debug: true
            }
        },
		watch: {
			app: {
				files: ["assets/**/*"],
				tasks: ["webpack:build-dev"],
				options: {
					spawn: false,
				}
			}
		},
        "webpack-dev-server": {
            options: {
                webpack: webpackConfig,
                publicPath: "/" + webpackConfig.output.publicPath
            },
            start: {
                keepAlive: true,
                webpack: {
                    devtool: "eval",
                    debug: true
                }
            }
        }
    });

    grunt.registerTask('default', ['clean', 'copy', 'webpack:build-dev', 'watch:app']);
    grunt.registerTask('production', ['clean', 'copy', 'webpack:build']);
}
