var CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: "./src/js/main.coffee",
  devtool: "#cheap-module-eval-source-map",
  output: {
    path: "./dist/",
    filename: 'main.js'
  },
  devServer: {
    // bind to all hostnames for webpack-dev-server
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
        {
          from: 'public',
          // We only copy modified files during a webpack-dev-server build.
          // Setting this to `true` copies all files.
          copyUnmodified: true
        }
      ])
  ]
};
