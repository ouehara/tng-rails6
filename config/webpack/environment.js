const { environment } = require("@rails/webpacker");
const webpack = require("webpack");
//environment.splitChunks();
const PurifyCSSPlugin = require("purifycss-webpack");
const path = require("path");
const glob = require("glob-all");
environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
  })
);
environment.plugins.append(
  "IgnorePlugin",
  new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
);

environment.plugins.append(
  "PurifyCSS",
  new PurifyCSSPlugin({
    //     // Give paths to parse for rules. These should be absolute!
    paths: glob.sync([
      path.join(__dirname, "../../app/views/**/*.html.erb"),
      path.join(__dirname, "../../app/javascript/components/**/*.js"),
      path.join(__dirname, "../../app/javascript/components/**/*.jsx"),
      path.join(__dirname, "../../app/javascript/editor/**/*.js"),
      path.join(__dirname, "../../app/javascript/editor/**/*.jsx"),
    ]),
    minimize: !(
      process.env.RAILS_ENV === "development" ||
      process.env.RAILS_ENV === "development_sk"
    ),
    purifyOptions: {
      whitelist: ["control-dots", "dot"],
    },
  })
);

environment.config.resolve.alias = {
  react: "preact/compat",
  "react-dom": "preact/compat",
};
module.exports = environment;
