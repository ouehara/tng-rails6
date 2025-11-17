import React from "react";
import I18n from "../i18n/i18n";

export default class FooterNavItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_pc: window.matchMedia("(min-width: 768px)").matches,
    };
  }
  renderSubNav() {
    return this.props.elements.map((el, id) => {
      // 言語毎に表示させないhッターリンクを指定する
      if (I18n.current == "ja" && el.id == "f_login") {
      } else if ((I18n.current == "ja" && el.id == "f_jobs") || (I18n.current == "zh-hans" && el.id == "f_jobs") || (I18n.current == "th" && el.id == "f_jobs") || (I18n.current == "vi" && el.id == "f_jobs") || (I18n.current == "ko" && el.id == "f_jobs") || (I18n.current == "id" && el.id == "f_jobs")) {
      } else if ((I18n.current == "ja" && el.id == "f_dmc") || (I18n.current == "zh-hant" && el.id == "f_dmc") || (I18n.current == "zh-hans" && el.id == "f_dmc") || (I18n.current == "th" && el.id == "f_dmc") || (I18n.current == "vi" && el.id == "f_dmc") || (I18n.current == "ko" && el.id == "f_dmc") || (I18n.current == "id" && el.id == "f_dmc")) {
      } else {
        if (el.new_tab) {
          return (
            <li key={id} className="sub_nav_item sub_nav_item--index">
              <a href={el.url} id={el.id} target="_blank">
                {el.page_name}
              </a>
            </li>
          );
        } else {
          return (
            <li key={id} className="sub_nav_item sub_nav_item--index">
              <a href={el.url} id={el.id}>
                {el.page_name}
              </a>
            </li>
          );
        }
      }
    });
  }

  render() {
    let nav_item_classes = "nav_item sp_accordion";
    nav_item_classes += " open";

    return <ul className={nav_item_classes}>{this.renderSubNav()}</ul>;
  }
}
