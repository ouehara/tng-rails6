import React from "react";
import I18n from "../i18n/i18n";
export default class InformationView extends React.Component {
  findUrls(text) {
    var source = (text || "").toString();
    var urlArray = [];
    var url;
    var matchArray;

    // Regular expression to find FTP, HTTP(S) and email URLs.
    var regexToken = /^https?\:\/\/(www\.|maps\.)?google(\.[a-z]+){1,2}\/maps\/.*/gm;

    // Iterate through any URLs in the text.
    while ((matchArray = regexToken.exec(source)) !== null) {
      var token = matchArray[0];
      urlArray.push(token);
    }

    return urlArray.length > 0 ? urlArray[0] : "";
  }
  getTranslation(key) {
    if (typeof this.props.translation != "undefined") {
      return this.props.translation[key];
    }
    return I18n.t("basic-information." + key);
  }
  renderSource() {
    let order = [
      "name",
      "hours",
      "closed",
      "checkin",
      "checkout",
      "price",
      "address",
      "access",
      "url-ja",
      "url-en",
      "url-th",
      "url-zh-hant",
      "url-zh-hans",
      "url-vi",
      "url-ko",
      "url-id",
      "others"
    ];
    if (Object.keys(this.props.elements).length === 0) {
      return;
    }
    let i = 0;
    return order.map(key => {
      i++;
      //show always japanese
      if (!this.props.elements.hasOwnProperty(key)) return;
      if (key.indexOf("url") !== -1) {
        if (
          this.props.locale == "ja" ||
          (this.props.locale == "en" &&
            (key == "url-en" || key == "url-ja")) ||
          (this.props.locale == "th" &&
            (key == "url-th" || key == "url-ja" || key == "url-en")) ||
          (this.props.locale == "vi" &&
            (key == "url-vi" || key == "url-ja" || key == "url-en")) ||
          (this.props.locale == "ko" &&
            (key == "url-ko" || key == "url-ja" || key == "url-en")) ||
          (this.props.locale == "id" &&
            (key == "url-id" || key == "url-ja" || key == "url-en")) ||
          (this.props.locale == "zh-hant" &&
            (key == "url-zh-hant" || key == "url-ja")) ||
          (this.props.locale == "zh-hans" &&
            (key == "url-zh-hans" || key == "url-ja")) ||
          (this.props.locale == "zh-hant" &&
            !this.props.elements.hasOwnProperty("url-zh-hant") &&
            (key == "url-en" || key == "url-ja" || key == "url-zh-hans")) ||
          (this.props.locale == "zh-hant" &&
            !this.props.elements.hasOwnProperty("url-zh-hant") &&
            (key == "url-en" || key == "url-ja")) ||
          (this.props.locale == "zh-hans" &&
            !this.props.elements.hasOwnProperty("url-zh-hans") &&
            (key == "url-en" || key == "url-ja"))
        ) {
          let arr = this.props.elements[key].split(",");
          return (
            <tr className="basic-information" key={++i}>
              <th className="bold">{this.getTranslation(key)}</th>
              <td className="basic-text flex-column">
                {arr.map((a, k) => {
                  return (
                    <a href={a} target="_blank" key={++i}>
                      {a}
                    </a>
                  );
                })}
              </td>
            </tr>
          );
        }
      } else if (key == "address") {
        var googleUrl = this.findUrls(this.props.elements[key]);
        var link =
          googleUrl != "" ? (
            <a target="_blank" title="google maps" href={googleUrl}>
              Google Maps
            </a>
          ) : (
            ""
          );
        return (
          <tr className="basic-information" key={++i}>
            <td className="bold">{this.getTranslation(key)} </td>
            <td className="basic-text">
              {this.props.elements[key].replace(googleUrl, "")} {link}
            </td>
          </tr>
        );
      } else {
        return (
          <tr className="basic-information" key={++i}>
            <th className="bold">{this.getTranslation(key)} </th>
            <td className="basic-text">{this.props.elements[key]}</td>
          </tr>
        );
      }
    });
  }
  render() {
    return <table className="basic-infowrapper">{this.renderSource()}</table>;
  }
}
