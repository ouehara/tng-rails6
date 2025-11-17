import React from "react";
import dayjs from "dayjs";
import link_path from "../shared_components/link_path";
import LazyLoad from "react-lazyload";
import Adsense from "../ads/adsense";
import I18n from "../i18n/i18n";

export default class ArticleSubItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      type: this.props.type,
    };
  }
  getFormattedDate(el) {
    let d = el.published_at;
    let date = dayjs(el.published_at).format("MMM DD, YYYY");
    if (el.schedule[I18n.current]) {
      d = el.schedule[I18n.current];
      date = dayjs(d).format("MMM DD, YYYY");
    }
    return <span>{date}</span>;
  }
  getThumbUrl(el) {
    return this.props.mobile
      ? el.thumb_url + "&d=142x90"
      : el.thumb_url + "&d=400x400";
  }
  renderRelatedList() {
    if (typeof this.props.elements.related_articles_out_content == "undefined")
      return;
    if (!this.props.elements.related_articles_out_content.length) return;
    return this.props.elements.related_articles_out_content.map((el, index) => {
      if (index == 1 || index == 4) {
        return (
          <article className="clip-articleList_item">
            <Adsense
              className={"ads-infeed"}
              style={{ display: "block" }}
              format={"fluid"}
              layoutKey={"-gb+5c+49-b5+3t"}
              client={"ca-pub-4177280178292675"}
              slot={"4995592996"}
            />
          </article>
        );
      }
      return (
        <article className="clip-articleList_item" key={index}>
          <a
            href={link_path(this.props.elements.articlePath, [
              { key: ":param", value: el.slug },
            ])}
            className="clip-article"
          >
            <div className="clip-article_images">
              <LazyLoad height={150} offset={150}>
                <img src={this.getThumbUrl(el)} alt={el.disp_title} className="clip-article_image" />
              </LazyLoad>
            </div>
            <div className="clip-article_content">
              <div className="article-list-item-body-sub">
                <span class="article-list-item-body-sub-area">{el.cached_area.name}</span>
                <p className="header_date">{this.getFormattedDate(el)}</p>
              </div>
              <h3 className="clip-article_heading">{el.disp_title}</h3>
              <p className="clip-article_text">{el.excerpt}</p>
            </div>
          </a>
        </article>
      );
    });
  }

  switchRender() {
    if (this.state.type === "author") {
      return (
        <div className="post-sub_content post-sub_author">
          <div className="post-sub_author__image">
            <img
              src={this.props.elements.thumbnail}
              alt={this.props.elements.name}
            />
          </div>
          <dl className="post-sub_author__content">
            <dt className="content_name">{this.props.elements.name}</dt>
            <dd className="content_text">{this.props.elements.profile}</dd>
          </dl>
        </div>
      );
    } else if (this.state.type === "related") {
      return (
        <div className="post-sub_content">
          {this.props.showRelatedAd && (
            <div style={{ marginBottom: "30px" }}>
              <Adsense
                className={""}
                style={{ display: "block" }}
                client={"ca-pub-4177280178292675"}
                slot={"3620840140"}
                format={"autorelaxed"}
              />
            </div>
          )}

          {this.renderRelatedList()}
        </div>
      );
    }
  }

  render() {
    const text =
      this.state.type === "author"
        ? "About the author"
        : I18n.t("hotel-lp.related");
    // console.log(I18n.current);
    const cl = this.state.type === "related" ? "related_posts" : "";
    return (
      <LazyLoad height={400} offset={200}>
        <section className={cl}>
          <h2>{text}</h2>
          {this.switchRender()}
        </section>
      </LazyLoad>
    );
  }
}
