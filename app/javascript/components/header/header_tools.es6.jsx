import React from "react";
import store from "../shared/store";

import IconLang from "../icon/lang";
import IconClip from "../icon/clip";
import IconSearch from "../icon/search";
import LogoPc from "../icon/logo_pc";
import LogoSp from "../icon/logo_sp";
import I18n from "../i18n/i18n";
export default class HeaderTools extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      type: this.props.type,
      clipped_num: 0,
      lang_active: false,
      lang_selected: I18n.current,
      searchVal: "",
    };

    this.catchToggleMenu = this.catchToggleMenu.bind(this);
    this.catchToggleNav = this.catchToggleNav.bind(this);
    this.toggleLangActive = this.toggleLangActive.bind(this);
    this.handleClickedStyledOp = this.handleClickedStyledOp.bind(this);
    this.handleTextChange = this.handleTextChange.bind(this);
    this.handleSearchSubmit = this.handleSearchSubmit.bind(this);
  }

  componentDidUpdate(prevProps) {
    if (this.props.type !== prevProps.type) {
      this.setState({ type: this.props.type });
    }
  }

  componentDidMount() {
    if (this.state.type !== "clip") return;
    const clipped = store.get("clips");
    const num = clipped ? Object.keys(clipped).length : 0;
    this.setState({ clipped_num: num });
    store.watch(() => {
      this.onClipsChanged();
    });
  }

  onClipsChanged() {
    if (this.state.type !== "clip") return;
    const clipped = store.get("clips");
    this.setState({ clipped_num: Object.keys(clipped).length });
  }

  toggleLangActive() {
    this.setState({
      lang_active: !this.state.lang_active,
    });
  }

  handleClickedStyledOp(e) {
    const the_rel = e.target.getAttribute("rel");
    this.setState({
      lang_selected: the_rel,
      lang_active: false,
    });
    e.target.value = the_rel;
    const event = { target: { value: the_rel } };
    this.redirect(event);
    this.selectEl.value = the_rel;
  }

  handleSearchSubmit(e) {
    e.preventDefault();
    if (this.state.searchVal != "") {
      location.href = "/" + I18n.current + "/search/" + this.state.searchVal;
    }
  }

  handleTextChange(e) {
    this.setState({ searchVal: e.target.value });
  }

  renderClip() {
    return (
      <div className="nav_clip nav_tool_item">
        <a href={"/" + I18n.current + "/clips/"} id="g_clip">
          <span className="isvg loaded isvg">
            <IconClip />
          </span>
          <span className="nav_clip_num">{this.state.clipped_num}</span>
        </a>
      </div>
    );
  }

  renderSearch() {
    return (
      <div className="nav_search nav_tool_item">
        <form className="nav_search_form" onSubmit={this.handleSearchSubmit}>
          <input
            onChange={this.handleTextChange}
            type="text"
            className="search"
            placeholder="Search"
            id="g_search"
          />
          <button className="nav_search_icon">
            <span className="isvg">
              <IconSearch />
            </span>
          </button>
        </form>
      </div>
    );
  }
  redirect(evt) {
    let path = location.pathname;
    if (I18n.current != "en") {
      let reg = new RegExp(I18n.current + "/");
      path = path.replace(reg, "");
    } else {
      let reg = new RegExp("/en");
      path = path.replace(reg, "");
    }
    location.href = location.origin + "/" + evt.target.value + path;
  }
  renderLang() {
    const langs = {
      en: {
        text: "English",
        id: "g_en",
      },
      "zh-hant": {
        text: "繁體中文",
        id: "g_hant",
      },
      "zh-hans": {
        text: "简体中文",
        id: "g_hans",
      },
      th: {
        text: "ไทย",
        id: "g_th",
      },
      ko: {
        text: "한국어",
        id: "g_ko",
      },
      vi: {
        text: "Tiếng Việt",
        id: "g_vi",
      },
      id: {
        text: "Indonesian",
        id: "g_id",
      },
    };
    const selectClasses = this.state.lang_active ? "select active" : "select";
    const styledSelectBoxClasses = this.state.lang_active
      ? "select-styled active"
      : "select-styled";
    let styledSelectBoxText = "";
    if (this.state.lang_selected != "ja") {
      styledSelectBoxText = langs[this.state.lang_selected].text;
    }
    const styledOptionsStyles = this.state.lang_active
      ? { display: "block" }
      : { display: "none" };

    return (
      <div className="nav_lang nav_tool_item">
        <div className={selectClasses}>
          <select
            onChange={this.redirect.bind(this)}
            className="select_lang select-hidden"
            ref={(selectEl) => (this.selectEl = selectEl)}
          >
            {this.renderLangOption(langs)}
          </select>
          <div
            className={styledSelectBoxClasses}
            onClick={this.toggleLangActive}
          >
            <div className="nav_lang_icon">
              <span className="isvg">
                <IconLang />
              </span>
            </div>
            {styledSelectBoxText}
          </div>
          <ul className="select-options" style={styledOptionsStyles}>
            {this.renderLangStyledOp(langs)}
          </ul>
          {this.props.isPc && (
            <div className="nav_lang_layer" onClick={this.toggleLangActive} />
          )}
        </div>
      </div>
    );
  }

  renderLangStyledOp(langs) {
    if (!Object.keys(langs).length) return;
    return Object.keys(langs).map((key, index) => {
      return (
        <li rel={key} key={index} onClick={this.handleClickedStyledOp}>
          {langs[key].text}
        </li>
      );
    });
  }

  renderLangOption(langs) {
    if (!Object.keys(langs).length) return;
    return Object.keys(langs).map((key, index) => {
      return (
        <option value={key} id={langs[key].id} key={index}>
          {langs[key].text}
        </option>
      );
    });
  }

  renderMenuBtn() {
    const click_e = this.props.isPc
      ? this.catchToggleNav
      : this.catchToggleMenu;
    return (
      <div className="btn_open_drawer nav_tool_item" onClick={click_e}>
        <div className="line" />
        <div className="text">Menu</div>
      </div>
    );
  }

  renderCloseBtn() {
    const click_e = this.props.isPc
      ? this.catchToggleNav
      : this.catchToggleMenu;
    return (
      <div className="btn_close nav_tool_item" onClick={click_e}>
        <div className="line" />
        <div className="text">Close</div>
      </div>
    );
  }

  renderLogo() {
    const url = "/" + I18n.current;
    const id = "g_home";
    if (this.props.isPc) {
      return (
        <h1 className="navbar_left logo">
          <a className="nav_link nav_logo" href={url} id={id}>
            <span className="isvg">
              <LogoPc />
            </span>
          </a>
        </h1>
      );
    } else {
      return (
        <h1 className="nav_logo sp">
          <a className="nav_link" href={url} id={id}>
            <span className="isvg">
              <LogoSp />
            </span>
          </a>
        </h1>
      );
    }
  }

  catchToggleMenu() {
    this.props.catchClicked(this.props.isOpenMenu);
  }

  catchToggleNav() {
    this.props.catchClicked(this.props.isOpenNav);
  }

  render() {
    if (this.state.type === "clip") {
      return this.renderClip();
    } else if (this.state.type === "search") {
      return this.renderSearch();
    } else if (this.state.type === "lang") {
      return this.renderLang();
    } else if (this.state.type === "menu") {
      return this.renderMenuBtn();
    } else if (this.state.type === "close") {
      return this.renderCloseBtn();
    } else if (this.state.type === "logo") {
      return this.renderLogo();
    }
  }
}
