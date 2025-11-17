import "@babel/polyfill";
var componentRequireContext = require.context("editor", true);
window.$ = $;
require("@rails/ujs").start();
require("turbolinks").start();
var ReactRailsUJS = require("react_ujs");
require("jquery-ui");
if (navigator.serviceWorker) {
  navigator.serviceWorker.getRegistrations().then(function(registrations) {
    for (let registration of registrations) {
      registration.unregister();
    }
  });
}
ReactRailsUJS.useContext(componentRequireContext);
