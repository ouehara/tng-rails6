process.env.NODE_ENV = process.env.NODE_ENV || "development";
const BundleAnalyzerPlugin = require("webpack-bundle-analyzer")
  .BundleAnalyzerPlugin;

const environment = require("./environment");
//environment.plugins.append("BundleAnalyzerPlugin", new BundleAnalyzerPlugin());
module.exports = environment.toWebpackConfig();
