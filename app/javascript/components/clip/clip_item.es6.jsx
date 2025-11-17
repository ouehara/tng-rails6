import React from "react";
import LazyLoad from "react-lazyload";
import I18n from "../i18n/i18n";

export default class ClipItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};

    this.handleClickRemove = this.handleClickRemove.bind(this);
  }

  handleClickRemove() {
    this.props.catchClickRemove(this.props.elements.id);
  }

  render() {
    const remove_id = `clip_remove_${this.props.elements.id}`;
    const category_class = `header_category ${this.props.elements.category_class}`;
    return (
      <article
        className="clip_articleList-item"
        data-post_id={this.props.elements.id}
      >
        <a
          href={"/" + I18n.current + "/" + this.props.elements.slug}
          className="clip-article"
        >
          <div className="clip-article_images">
            <LazyLoad height={200} offset={100}>
              <img
                src={this.props.elements.thumbnail}
                alt={this.props.elements.disp_title}
              />
            </LazyLoad>
          </div>
          <div className="clip-article_content">
            <div className="clip-article_header">
              <p className={category_class}>
                {this.props.elements.category_full_name}
              </p>
              <p className="header_date">{this.props.elements.date}</p>
            </div>
            <h2 className="clip-article_heading">
              {this.props.elements.disp_title}
            </h2>
            <p className="clip-article_text">{this.props.elements.excerpt}</p>
          </div>
        </a>
        <button
          className="clip-article_remove"
          id={remove_id}
          onClick={this.handleClickRemove}
        >
          <span className="remove_inner">Remove</span>
        </button>
      </article>
    );
  }
}
