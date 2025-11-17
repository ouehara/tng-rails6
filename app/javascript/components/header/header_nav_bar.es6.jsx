import React from "react";
import HeaderTools from "./header_tools.es6.jsx";
import HeaderNavItem from "./header_nav_item.es6.jsx";
import { items } from "../conf/nav.js";
import I18n from "../i18n/i18n";
export default class HeaderNavBar extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};

    this.handleToggleMenu = this.handleToggleMenu.bind(this);
    this.handleToggleNav = this.handleToggleNav.bind(this);
  }

  renderNavList() {
    if (!Object.keys(this.props.elements).length) return;
    const elements = Object.keys(this.props.elements).map((key, index) => {
      const d = this.props.elements[key];
      return <HeaderNavItem data={d} isPc={this.props.isPc} key={index} />;
    });
    let areaPath =
      I18n.current == "en" ? "/area" : "/" + I18n.current + "/area";
    elements.unshift(
      <HeaderNavItem
        data={{
          page_code: "area",
          page_name: I18n.t("area.area"),
          items: items[0],
          index: {
            url: areaPath,
            id: "g-a_top",
          },
        }}
        isPc={this.props.isPc}
        key="area-1"
      />
    );
    return elements;
  }

  handleToggleMenu() {
    this.props.catchClicked(this.props.isOpenMenu);
  }

  handleToggleNav() {
    this.props.catchToggleNav(this.props.isOpenNav);
  }

  switchBtn(compact, open) {
    if (compact) {
      if (open) {
        return (
          <HeaderTools
            type="close"
            isPc={this.props.isPc}
            isOpenNav={this.props.isOpenNav}
            catchClicked={this.handleToggleNav}
          />
        );
      } else {
        return (
          <HeaderTools
            type="menu"
            isPc={this.props.isPc}
            isOpenNav={this.props.isOpenNav}
            catchClicked={this.handleToggleNav}
          />
        );
      }
    }
  }

  switchBar(is_pc) {
    if (is_pc) {
      return (
        <div className="container container--wide">
          <HeaderTools type="logo" isPc={this.props.isPc} />
          <div className="navbar_right">
            <div className="navbar_tools">
              <HeaderTools type="clip" />
              <HeaderTools type="search" />
              <HeaderTools type="lang" />
              {this.switchBtn(this.props.isCompactBar, this.props.isOpenNav)}
            </div>
            <ul className="navbar_nav navbar-fixed-bottom">
              {this.renderNavList()}
            </ul>
          </div>
        </div>
      );
    } else {
      return (
        <div className="container container--wide">
          <HeaderTools type="logo" isPc={this.props.isPc} />
          <HeaderTools
            type="menu"
            isOpenMenu={this.props.isOpenMenu}
            catchClicked={this.handleToggleMenu}
          />
          <HeaderTools type="clip" />
        </div>
      );
    }
  }

  render() {
    let classes =
      this.props.isPc && this.props.isCompactBar
        ? "navbar navbar--compact"
        : "navbar";
    if (this.props.isPc && this.props.isOpenNav) {
      classes += " active";
    }
    return <div className={classes}>{this.switchBar(this.props.isPc)}</div>;
  }
}
