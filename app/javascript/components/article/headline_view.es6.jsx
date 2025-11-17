import React from "react";

export default class HeadlineView extends React.Component {
  getHeading(text) {
    if (this.props.type === "heading") {
      return (
        <h2 className={"article-heading"} id={"hl" + this.props.compid}>
          {text}
        </h2>
      );
    }
    if (this.props.type === "h4") {
      return <h4 id={"hl" + this.props.compid}>{text}</h4>;
    }
    return <h3 id={"hl" + this.props.compid}>{text}</h3>;
  }
  render() {
    return this.getHeading(this.props.text);
  }
}
