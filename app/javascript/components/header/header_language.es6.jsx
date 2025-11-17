import React from "react";

import IconLang from "../icon/lang";

export default class HeaderLanguage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <div className="nav_lang nav_tool_item">
        <div className="nav_lang_icon">
          <span className="isvg">
            <IconLang />
          </span>
        </div>
        <select className="select_lang">
          <option value="en">English</option>
          <option value="zh-hant">Chinese (Traditional)</option>
        </select>
      </div>
    );
  }
}
