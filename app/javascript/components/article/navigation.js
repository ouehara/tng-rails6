import React from "react";
import I18n from "../i18n/i18n";
export default class Navigation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }
  createMarkup() {
    let text = this.props.content;
    return { __html: text };
  }
  render() {
    return (
      <div className="table-of-contents">
        <h2 className="article-heading">{I18n.t("toc")}</h2>
        <div dangerouslySetInnerHTML={this.createMarkup()} />
      </div>
    );
  }
}
