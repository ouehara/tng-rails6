import React from "react";
import store from "../shared/store";
import ClipCountManager from "../shared/clip_count_manager";
import I18n from "../i18n/i18n";
import IconClip from "../icon/clip";
import IconQuestion from "../icon/question";

export default class ClipWidget extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_pc: false,
      post_id: this.props.elements.post.id,
      scroll_h: 0,
      window_w: 0,
      window_h: 0,
      page_h: 0,
      footer_h: 0,
      stick_y: 0,
    };

    this.handleClickedClip = this.handleClickedClip.bind(this);
    this.handleScroll = this.handleScroll.bind(this);
    this.updateState = this.updateState.bind(this);
  }

  componentDidMount() {
    // 初期化時にクリップ数を設定
    ClipCountManager.updateNavClipCount();

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

    // ネイティブJavaScriptでフッター高さを取得
    const footerElement = document.querySelector(".footer");
    const footerHeight = footerElement ? footerElement.offsetHeight : 0;

    this.setState({
      scroll_h: scrolled,
      footer_h: footerHeight,
      page_h: document.documentElement.scrollHeight,
    });
  }

  updateState() {
    const isPc = window.matchMedia("(min-width: 768px)").matches;

    // ネイティブJavaScriptでフッター高さを取得
    const footerElement = document.querySelector(".footer");
    const footerHeight = footerElement ? footerElement.offsetHeight : 0;

    this.setState({
      is_pc: isPc,
      window_w: window.innerWidth,
      window_h: window.innerHeight,
      page_h: document.documentElement.scrollHeight,
      footer_h: footerHeight,
      stick_y: 30,
    });
  }

  handleClickedClip() {
    const post_data = this.props.elements.post;
    post_data.thumbnail = this.props.elements.thumb;
    post_data["lang"] = I18n.current;

    ClipCountManager.addClip(this.state.post_id, post_data);
  }

  render() {
    const is_sticked =
      this.state.scroll_h + this.state.window_h >=
      this.state.page_h - (this.state.footer_h + this.state.stick_y);
    const classes =
      is_sticked && !this.state.is_pc ? "clip_widget stick" : "clip_widget";
    const track_id_clip = `clip_${this.state.post_id}`;
    const track_id_info = "clip_question";
    return (
      <div className={classes}>
        <div
          className="btn_clip btn_clip_add"
          data-post_id={this.state.post_id}
          onClick={this.handleClickedClip}
          id={track_id_clip}
        >
          <div className="inner">
            <span className="isvg">
              <IconClip />
            </span>
            <p className="text">CLIP</p>
          </div>
        </div>
      </div>
    );
  }
}
