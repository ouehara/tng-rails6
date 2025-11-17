import React from "react";
export default class TextView extends React.Component {
  createMarkup() {
    let text = this.props.text;
    return { __html: text };
  }
  render() {
    return (
      <div
        className="blog-text"
        dangerouslySetInnerHTML={this.createMarkup()}
      />
    );
  }
}
