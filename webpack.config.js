module.exports = {
  entry: "./src/js/main.coffee",
  devtool: "#cheap-module-eval-source-map",
  output: {
    path: "./build/assets/",
    publicPath: "/public/assets/js/",
    filename: 'main.js'
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
  }
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
