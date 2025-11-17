import React from "react";
import I18n from "../i18n/i18n";
export default class MoreBtn extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};

    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.props.catchOnClick();
  }

  render() {
    return (
      <div className="add_button">
        <button className="btn" onClick={this.handleClick}>
          {I18n.t("more_btn")}
          <span className="line" />
        </button>
      </div>
    );
  }
}
