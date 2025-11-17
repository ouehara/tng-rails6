const I18n = {};

I18n["current"] = locales;
const locale = require("./lang/" + locales);
I18n["availableLanguages"] = availableLocale;
I18n["lang"] = locale["default"];
//I18n["lang"] =  <%= @translations.to_json.html_safe %>
I18n.t = function (key) {
  var keys = key.split(".");
  var comp = I18n.lang;
  $(keys).each(function (_, value) {
    if (comp) {
      comp = comp[value];
    }
  });

  if (!comp && console) {
    console.debug("No translation found for key: " + key);
    return "N/A";
  }

  return comp;
};
export default I18n;
