var webpack = require('webpack')
var path    = require('path')

module.exports = {
  catch: true,
  entry: {
    app: ["./_assets/entry.js"]
  },
  output: {
    filename: "./assets/[name].js"
  },
  devtool: "#source-map",
  moudle: {
    loaders: [
      {test: /\.js$/, loader: "babel", exclude: /node_modules/},
      {test: /\.coffee$/, loader: "coffee"},
      {test: /\.css$/, loader: "style!css"}
    ]
  },
  resolve: {
    extensions: ['', '.js', '.jsx', '.coffee', '.css', '.styl']
  }
};
