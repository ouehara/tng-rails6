import "@babel/polyfill";
var global = global || this;
var self = self || this;
var window = window || this;
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
