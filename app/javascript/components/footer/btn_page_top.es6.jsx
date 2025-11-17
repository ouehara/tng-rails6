import React from "react";

export default class BtnPageTop extends React.Component {
  render() {
    let classes = "container container--pagetop";
    if (this.props.isShown) {
      classes += " show";
    }
    if (this.props.isSticked) {
      classes += " stick";
    }
    return (
      <div className={classes}>
        <div className="btn_page_top">
          <a href="#top">PAGE TOP</a>
        </div>
      </div>
    );
  }
}
