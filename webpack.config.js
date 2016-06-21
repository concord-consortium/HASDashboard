var CopyWebpackPlugin = require('copy-webpack-plugin');
var path = require('path');
module.exports = {
  entry: "./src/js/main.coffee",
  devtool: "#cheap-module-eval-source-map",
  output: {
    path: "./dist/",
    filename: 'main.js'
  },
  // Configuration for webpack-dev-server
  devServer: {
    // serve static content from the public directory.
    contentBase: "./public",
    // bind to all hostnames
    host: "0.0.0.0"
  },
  module: {
    loaders: [
      { test: /\.html$/, loader: 'file-loader' },
      { test: /\.js$/, loader: 'babel-loader' },
      { test: /\.coffee$/, loader: "coffee-loader" },
      { test: /\.styl$/, loader: 'style-loader!css-loader!stylus-loader' }, // use ! to chain loaders
      { test: /\.css$/, loader: 'style-loader!css-loader' },
      { test: /\.(png|jpg)$/, loader: 'url-loader?limit=8192' } // inline base64 URLs for <=8k images, direct URLs for the rest
    ]
  },
  plugins: [
      new CopyWebpackPlugin([
          // File examples
          { from: 'public/index.html' },
          { from: 'public/robots.txt' },
          { from: 'public/humans.txt' },
          { from: 'public/browserconfig.xml' },
          { from: 'public/*.png' },
          { from: 'public/favicon.ico' }
      ])
  ]
};

/*

plugins: [
  new webpack.ProvidePlugin({
    "_": "underscore"
  }),
  new webpack.ProvidePlugin({
    "$": "jquery"
  })
]

*/
