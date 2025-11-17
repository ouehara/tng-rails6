import React from "react";

export default class ButtonView extends React.Component {
  createMarkup() {
    let text = this.props.text;
    return { __html: text };
  }
  analytics() {
    if (this.props.analyticsCat != "") {
      ga(
        "send",
        "event",
        this.props.analyticsCat,
        "click",
        this.props.analyticsText
      );
    }
  }
  render() {
    let conf = {};
    if (this.props.rel != "") {
      conf = { rel: this.props.rel };
    }
    return (
      <div className={this.props.position}>
        <a
          {...conf}
          className={
            "btn-spacing btn " + this.props.type + " " + this.props.size
          }
          href={this.props.url}
          onClick={this.analytics.bind(this)}
        >
          {this.props.text}
        </a>
      </div>
    );
  }
}
