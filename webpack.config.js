webpack = require('webpack')
module.exports = {
    entry: {
        app: './assets/js/index.coffee',
        vendor: './assets/js/vendor.coffee'
    },
    output: {
        path: 'public/',
        filename: 'bundle.js',
    },	
    plugins:[new webpack.optimize.CommonsChunkPlugin(/* chunkName= */"vendor", /* filename= */"vendor.bundle.js")],
    module: {
        loaders: [
            // Exports Angular
            { test: /[\/]angular\.js$/, loader: "exports?angular" },
            // Script Loaders
            { test: /\.coffee$/, loader: "coffee" },
            // Markup Loaders
            { test: /\.html$/, loader: "ng-cache?prefix=[dir]/[dir]"},
            //{ test: /\.jade$/, loader: "template-html" },
            // Style Loaders, style! inlines the css into the bundle files
            { test: /\.css$/, loader: "style!css" },
            { test: /\.scss$/, loader: "style!css!sass" },
            //{ test: /\.less$/, loader: "style!css!less" },
            { test: /\.woff(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "url-loader?limit=10000&minetype=application/font-woff" },
            { test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file-loader" },
            { test: /\.png$/, loader: 'url?name=img/[name].[ext]&mimetype=image/png' },
            { test: /\.gif$/, loader: 'url?name=img/[name].[ext]&mimetype=image/gif' },
            { test: /\.jpg/, loader: 'url?name=img/[name].[ext]&mimetype=image/jpg' }
        ]
    }
};
