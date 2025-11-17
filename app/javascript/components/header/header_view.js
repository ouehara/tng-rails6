import React from "react";

import HeaderNavBar from "./header_nav_bar.es6.jsx";
import HeaderDrawerSp from "./header_drawer_sp.es6.jsx";
import HeaderTools from "./header_tools.es6.jsx";
import LazyLoad from "react-lazyload";
import { items } from "../conf/nav.js";
import I18n from "../i18n/i18n";
export default class Header extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_pc: window.matchMedia("(min-width: 768px)").matches,
      is_open_menu: false,
      header_h: 0,
      hov_navbar_item: false,
      is_compact_bar: false,
      is_open_nav: false,
    };

    this.handleToggleMenu = this.handleToggleMenu.bind(this);
    this.handleToggleNav = this.handleToggleNav.bind(this);
    this.handleScroll = this.handleScroll.bind(this);
  }

  componentDidMount() {
    window.addEventListener("scroll", this.handleScroll);
    window.addEventListener("resize", () => {
      this.updateState();
    });
    setTimeout(() => {
      this.updateState();
    }, 2000);
  }

  componentWillUnmount() {
    window.removeEventListener("scroll", this.handleScroll);
    window.removeEventListener("resize", () => {
      this.updateState();
    });
  }

  updateState() {
    if (typeof this.headerElement == "undefined") {
      return;
    }
    this.setState({
      is_pc: window.matchMedia("(min-width: 768px)").matches,
      header_h: this.headerElement.clientHeight,
    });
  }

  handleScroll(e) {
    if (typeof this.headerElement == "undefined") {
      return;
    }
    const elm =
      "scrollingElement" in e.target
        ? e.target.scrollingElement
        : document.documentElement;
    const scrolled = elm.scrollTop;
    const newState = {
      scroll_h: scrolled,
      header_h: this.headerElement.clientHeight,
    };
    const scroll_offset = this.state.header_h;
    if (this.state.is_open_nav && scrolled > scroll_offset) {
      newState.is_compact_bar = true;
      newState.is_open_nav = false;
    } else {
      if (scrolled > scroll_offset) {
        newState.is_compact_bar = true;
      } else {
        newState.is_compact_bar = false;
      }
    }
    this.setState({ ...newState });
  }

  handleToggleMenu(open) {
    this.setState({ is_open_menu: !open });
  }

  handleToggleNav(open) {
    this.setState({ is_open_nav: !open });
  }

  renderNavItem(data) {
    if (!Object.keys(data).length) return;
    return Object.keys(data).map((key, index) => {
      const d = data[key];

      return (
        <HeaderDrawerSp elements={d} key={index} isPc={this.state.is_pc} />
      );
    });
  }

  renderDrawer() {
    if (this.state.is_pc) return;
    let areaPath =
      I18n.current == "en" ? "/area" : "/" + I18n.current + "/area";
    const classes = this.state.is_open_menu
      ? "header_nav_drawer_sp active"
      : "header_nav_drawer_sp";
    return (
      <div className={classes}>
        <div className="nav_drawer_top">
          <HeaderTools type="search" />
        </div>
        <div className="nav_item">
          <div className="nav_item">
            <a href={areaPath} className="nav_item_title" id="g-a_top">
              <span className="nav-text"> {I18n.t("area.area")}</span>
            </a>
          </div>
          {this.renderNavItem(JSON.parse(this.props.elements.header_drawer))}
        </div>
        <HeaderTools type="lang" />
      </div>
    );
  }

  renderCloseLayer() {
    if (this.state.is_pc || (!this.state.is_pc && !this.state.is_open_menu))
      return;
    return (
      <div
        className="header_close_layer"
        onTouchMove={this.handleToggleMenu}
        onClick={this.handleToggleMenu}
      />
    );
  }

  render() {
    const elements = JSON.parse(this.props.elements.header_drawer);
    return (
      <LazyLoad height={400} offset={200}>
        <header
          className="header"
          ref={(headerElement) => (this.headerElement = headerElement)}
        >
          <HeaderNavBar
            elements={elements}
            isPc={this.state.is_pc}
            headerH={this.state.header_h}
            isOpenMenu={this.state.is_open_menu}
            catchClicked={this.handleToggleMenu}
            isCompactBar={this.state.is_compact_bar}
            isOpenNav={this.state.is_open_nav}
            catchToggleNav={this.handleToggleNav}
          />
          {this.renderDrawer()}
          {this.renderCloseLayer()}
        </header>
      </LazyLoad>
    );
  }
}
