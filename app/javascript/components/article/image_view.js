import React from "react";
import LazyLoad from "react-lazyload";
import Truncate from "react-truncate";
import instaErrorImg from "images/shared/icon_instagram_grey.svg";
import { INSTAGRAM_API_CONFIG } from "../conf/instagram_config";

export default class ImageView extends React.Component {
  constructor(props) {
    super(props);
    let image = props.image;
    if (props.mobile) {
      image = props.image + "&d=400x400";
      image = image.replace("/medium/", "/original/");
    } else {
      image = props.image + "&d=750x750";
      image = image.replace("/medium/", "/original/");
    }
    image = image.replace(/^http:\/\//i, "https://");
    this.state = {
      runInsta: false,
      image,
      savorAdState: props.savorAdState,
      src_url: "",
      alt: props.alt || "",
      boxLink: props.boxLink || "",
      name: "",
    };
  }

  componentDidMount() {
    if (this.props.searchRes !== "") {
      this.addInstagram(this.props.searchRes);
    }
  }

  componentDidUpdate(prevProps, prevState) {
    // instaHtmlが新たにセットされたときのみembed.jsを読み込む
    if (
      this.state.instaHtml &&
      this.state.instaHtml !== prevState.instaHtml
    ) {
      // すでにembed.jsが読み込まれていれば再実行、なければscriptタグ追加（1回のみ）
      if (window.instgrm && window.instgrm.Embeds && typeof window.instgrm.Embeds.process === "function") {
        window.instgrm.Embeds.process();
      } else if (!document.getElementById("instagram-embed-script")) {
        const script = document.createElement("script");
        script.id = "instagram-embed-script";
        script.src = "https://www.instagram.com/embed.js";
        script.async = true;
        script.onload = function() {
          if (window.instgrm && window.instgrm.Embeds && typeof window.instgrm.Embeds.process === "function") {
            window.instgrm.Embeds.process();
          }
        };
        document.body.appendChild(script);
      }
    }
  }

  componentWillReceiveProps(newProps) {
    if (
      newProps.image !== this.props.image ||
      newProps.savorAdState !== this.props.savorAdState ||
      newProps.boxLink !== this.props.boxLink
    ) {
      let image = newProps.image;
      if (this.props.mobile) {
        image = newProps.image + "&d=351x351";
      } else {
        image = newProps.image + "&d=750x750";
      }
      this.setState(
        {
          image,
          savorAdState: newProps.savorAdState,
          runInsta: false,
          boxLink: newProps.boxLink || "",
        },
        () => {
          if (this.props.searchRes !== "") {
            this.addInstagram(newProps.searchRes);
          }
        }
      );
    }
  }

  showSource() {
    const { src } = this.props;
    if (src != null && src.text !== "") {
      return (
        <figcaption className="img-source">
          {src.url === "" ? (
            src.text
          ) : (
            <a href={src.url} target="_blank">
              {src.text}
            </a>
          )}
        </figcaption>
      );
    }
    return <figcaption className="img-source">&nbsp;</figcaption>;
  }

  click = (evt) => {
    const { savorAdState } = this.state;
    const { src, analyticsCategory, analyticsLabel } = this.props;
    if (
      evt.target.tagName === "A" &&
      (savorAdState === 1 || savorAdState === 2)
    ) {
      ga("send", "event", "savor_ads_ume", "click", src.url);
    }
    if (
      evt.target.tagName === "A" &&
      (savorAdState === 3 || savorAdState === 4)
    ) {
      ga("send", "event", "bangs_ad", "click", src.url);
    }
    if (savorAdState === 5) {
      ga("send", "event", {
        eventCategory: analyticsCategory,
        eventAction: "click",
        eventLabel: analyticsLabel,
        transport: "beacon",
      });
    }
  };

  renderAdBanner() {
    const conf = {};
    if (this.state.alt !== "undefined") {
      conf.alt = this.state.alt;
    }
    return (
      <a href={this.props.src.url} onClick={this.click}>
        <img {...conf} src={this.state.image} className="img-responsive" />
      </a>
    );
  }

  renderAd() {
    if (this.state.savorAdState === 5) {
      return this.renderAdBanner();
    }
    if (this.state.savorAdState >= 6) {
      return this.renderSimpleBanner();
    }
    const imageWrapperClass =
      this.state.savorAdState % 2 === 0
        ? "col-xs-12 space-bottom-xs"
        : "col-xs-12 col-sm-4 space-bottom-xs";
    const textWrapperClass =
      this.state.savorAdState % 2 === 0
        ? "col-xs-12 ads-text-wrapper"
        : "col-xs-12 col-sm-8 ads-text-wrapper";
    const title =
      this.props.src.url !== this.props.image ? this.props.src.url : "";
    const conf = {};
    if (this.state.alt !== "undefined") {
      conf.alt = this.state.alt;
    }
    return (
      <div className={"well imagead0" + this.state.savorAdState}>
        <div className="row">
          <div className="col-xs-12">
            <h3 className="ads-headline">{title}</h3>
          </div>
          <div className={imageWrapperClass}>
            <img {...conf} src={this.state.image} className="img-responsive" />
          </div>
          <div
            className={textWrapperClass}
            onClick={this.click}
            dangerouslySetInnerHTML={{ __html: this.props.src.text }}
          />
        </div>
      </div>
    );
  }

  renderSimpleBanner() {
    let classImage = "col-xs-12 col-sm-4 space-bottom-xs";
    let classText = "col-xs-12 col-sm-8 ads-text-wrapper";
    if (this.state.savorAdState === 7) {
      classImage = "col-xs-12 space-bottom-xs";
      classText = "col-xs-12 ads-text-wrapper";
    }
    const conf = {};
    if (this.state.alt !== "undefined") {
      conf.alt = this.state.alt;
    }
    if (this.state.boxLink !== "") {
      return this.renderRelatedBox();
    }
    return (
      <div className={"imagead0" + this.state.savorAdState}>
        <div className="row">
          <div className={classImage}>
            <img {...conf} src={this.state.image} className="img-responsive" />
          </div>
          <div
            className={classText}
            onClick={this.click}
            dangerouslySetInnerHTML={{ __html: this.props.src.text }}
          />
        </div>
      </div>
    );
  }

  renderRelatedBox() {
    return (
      <a
        href={this.state.boxLink}
        target="_blank"
        className="article-link-wrapper in-related-article-wrapper green_border"
      >
        <div className="well border-black" data-text="tJcrafts Recommended">
          <div className="row">
            <div className="col-xs-4 in-prev-image">
              <img
                className="img-preview img-responsive"
                src={this.state.image}
              />
            </div>
            <div className="col-xs-8 related_body">
              <h3>
                <Truncate lines={2} width={this.state.width}>
                  {this.props.src.url}
                </Truncate>
              </h3>
              <div className="desc hidden-xs">
                <Truncate lines={2} width={500} ellipsis={<span>...</span>}>
                  <div
                    dangerouslySetInnerHTML={{ __html: this.props.src.text }}
                  ></div>
                </Truncate>
              </div>
            </div>
          </div>
        </div>
      </a>
    );
  }

  handleError = () => {
    this.setState({ image: "" });
  };

  addInstagram(url) {
    if (this.state.runInsta) return;
    this.setState({ runInsta: true });
    fetch(
      `${INSTAGRAM_API_CONFIG.baseUrl}?url=${encodeURIComponent(url)}&hidecaption=true&access_token=${INSTAGRAM_API_CONFIG.accessToken}`
    )
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok");
        return response.json();
      })
      .then((data) => {
        this.setState({
          runInsta: true,
          // image: data.thumbnail_url,
          // image_w: data.thumbnail_width,
          // image_h: data.thumbnail_height,
          // name: data.author_name,
          instaHtml: data.html, // oEmbedのhtmlフィールド
        });
        // console.log("Instagram oEmbed data:", data);
      })
      .catch((error) => {
        // エラーハンドリング
        console.error('Instagram oEmbed fetch error:', error);
      });
  }

  getLazyLoadHeight() {
    return window.innerWidth <= 800 && window.innerHeight <= 60 ? 300 : 500;
  }

  renderSource() {
    if (this.props.ad === true) {
      return this.renderAd();
    }
    if (this.props.searchRes !== "" && this.props.searchRes != null) {
      return (
        <div className="insta_button-2">
          {/* <p>
            <a
              href={`https://www.instagram.com/${this.state.name}`}
              target="_blank"
            >
              <span className="fa fa-instagram" />
              <span className="insta_label">{this.state.name}</span>
            </a>
          </p> */}

          {/* {this.state.image !== "" ? (
            <p>
              <img
                onError={this.handleError}
                src={this.state.image}
                className="img-responsive"
                width={this.state.image_w}
                height={this.state.image_h}
              />
            </p>
          ) : (
            <div className="insta_error">
              <img
                src={require("app/javascript/images/shared/icon_instagram_grey.svg")}
                className="img-responsive"
              />
            </div>
          )} */}

          {/* 追加: oEmbedのhtmlフィールドを埋め込み表示 */}
          {this.state.instaHtml !== "" ? (
            <div
              className="insta_embedHtml"
              dangerouslySetInnerHTML={{ __html: this.state.instaHtml }}
            />
          ) : (
            <div className="insta_error">
              <img
                src={instaErrorImg}
                className="img-responsive"
              />
            </div>
          )}
          <p className="insta_link">
            <a
              href={this.props.searchRes}
              target="_blank"
              rel="noopener noreferrer"
            >
              embedded from Instagram
            </a>
          </p>
        </div>
      );
    }
    // 既存の通常画像表示処理
    // 画像がない場合は何も表示しない
    if (this.state.image === "" && !this.props.editor) {
      return <div />;
    }
    const imgProps = {
      src: this.state.image,
      className: "img-responsive",
    };
    if (this.props.imageAttributes && this.props.imageAttributes["width"] !== "auto") {
      imgProps.width = this.props.imageAttributes["width"];
    }
    const conf = {};
    if (this.state.alt !== "undefined") {
      conf.alt = this.state.alt;
    }
    return (
      <LazyLoad offset={100} height={this.getLazyLoadHeight()}>
        <figure>
          <img {...imgProps} {...conf} />
          {this.showSource()}
        </figure>
      </LazyLoad>
    );
  }

  render() {
    return this.renderSource();
  }
}
