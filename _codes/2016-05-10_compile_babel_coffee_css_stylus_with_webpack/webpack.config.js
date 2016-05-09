module.exports = {
  entry: {
    app: ["./src/entry.js"]
  },
  output: {
    filename: "build/[name].js"
  },
  devtool: "#source-map",
  moudle: {
    loaders: [
      {test: /\.js$/, loader: "babel", exclude: /node_modules/},
      {test: /\.coffee$/, loader: "coffee"},
      {test: /\.css$/, loader: "style!css"},
      {test: /\.styl$/, loader: "style!css!stylus"}
    ]
  },
  resolve: {
    extensions: ['', '.js', '.jsx', '.coffee', '.css', '.styl']
  }
};
