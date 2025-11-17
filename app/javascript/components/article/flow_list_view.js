import React from "react";
export default class FlowListView extends React.Component {
  findUrls(text) {
    var source = (text || "").toString();
    var urlArray = [];
    var url;
    var matchArray;

    // Regular expression to find FTP, HTTP(S) and email URLs.
    var regexToken = /(https?\:\/\/(www\.|maps\.)?google(\.[a-z]+){1,2}\/maps\/.*)(?=<(?:"[^"]*"['"]*|'[^']*'['"]*|[^'">])+>|\s)/gm;

    // Iterate through any URLs in the text.
    while ((matchArray = regexToken.exec(source)) !== null) {
      var token = matchArray[0];
      urlArray.push(token);
    }
    return urlArray.length > 0 ? urlArray[0] : "";
  }
  renderSource() {
    if (Object.keys(this.props.elements).length === 0) {
      return;
    }
    let i = 0;
    return this.props.elements.map(el => {
      i++;
      var googleUrl = this.findUrls(el.content);
      var link =
        googleUrl != ""
          ? '<a target="_blank" className="" title="google maps" href="' +
            googleUrl +
            '" > Google Maps</a> '
          : "";
      return (
        <tr className="basic-information" key={i}>
          <th className="bold">{el.label}</th>
          <td
            className="basic-text"
            dangerouslySetInnerHTML={{
              __html: el.content.replace(googleUrl, "") + " " + link
            }}
          />
        </tr>
      );
    });
  }
  render() {
    return <table className="basic-infowrapper">{this.renderSource()}</table>;
  }
}
