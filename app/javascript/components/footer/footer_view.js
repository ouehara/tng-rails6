import React from "react";
import FooterNavItem from "./footer_nav_item.es6.jsx";
import BtnPageTop from "./btn_page_top.es6.jsx";
import { footer } from "../conf/nav";
import I18n from "../i18n/i18n";
import LazyLoad from "react-lazyload";

export default class Footer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_pc: window.matchMedia("(min-width: 768px)").matches,
      scroll_h: 0,
      window_w: 0,
      window_h: 0,
      page_h: 0,
      footer_h: 0,
      pagetop_stick_y: 0
    };

    this.handleScroll = this.handleScroll.bind(this);
    this.updateState = this.updateState.bind(this);
  }

  componentDidMount() {
    if (document.querySelector(".talkappibot") != null) {
      document.querySelector(".talkappibot").classList.add("hidden");
    }
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

  handleScroll(e) {
    const elm =
      "scrollingElement" in e.target
        ? e.target.scrollingElement
        : document.documentElement;
    const scrolled = elm.scrollTop;
    const is_shown = scrolled > window.innerHeight / 3;
    if (document.querySelector(".talkappibot") != null) {
      if (is_shown) {
        document.querySelector(".talkappibot").classList.remove("hidden");
      } else {
        document.querySelector(".talkappibot").classList.add("hidden");
      }
    }
    this.setState({
      scroll_h: scrolled,
      footer_h:
        typeof this.footerElement == "undefined"
          ? 200
          : this.footerElement.clientHeight,
      page_h: document.documentElement.scrollHeight
    });
  }

  updateState() {
    const isPc = window.matchMedia("(min-width: 768px)").matches;
    const ptbtn_h = isPc ? 60 : 44;
    const ptbtn_btm_y = 25;
    const pagetop_y = isPc ? ptbtn_h / 2 - (ptbtn_h + ptbtn_btm_y) : 0;
    this.setState({
      is_pc: isPc,
      window_w: window.innerWidth,
      window_h: window.innerHeight,
      page_h: document.documentElement.scrollHeight,
      footer_h:
        typeof this.footerElement == "undefined"
          ? 200
          : this.footerElement.clientHeight,
      pagetop_stick_y: pagetop_y
    });
  }

  renderNavCol() {
    return <div className="nav_col--pc">{this.renderNavList(footer)}</div>;
  }

  renderNavList(data) {
    return <FooterNavItem elements={data} />;
  }

  render() {
    const is_shown = this.state.scroll_h > this.state.window_h / 3;
    const is_sticked =
      this.state.scroll_h + this.state.window_h >=
      this.state.page_h - (this.state.footer_h + this.state.pagetop_stick_y);
    return (
      <LazyLoad height={200}>
        <div
          className="footer__inner"
          ref={footerElement => (this.footerElement = footerElement)}
        >
          <BtnPageTop isShown={is_shown} isSticked={is_sticked} />
          <div className="container">
            <div className="nav">{this.renderNavCol()}</div>
            {this.props.user == null || (
              <li>
                <a href="/users/sign_out/" data-method="delete">
                  <span>Sign out</span>
                </a>
              </li>
            )}
            <FooterSubInfo />
          </div>
        </div>
      </LazyLoad>
    );
  }
}

function FooterSubInfo() {
  return (
    <div className="footer_sub_info">
      <small className="footer_copyright">
        &copy;&nbsp;tsunagu Japan, All Rights Reserved.
      </small>
    </div>
  );
}
