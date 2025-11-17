import React from "react";
import LazyLoad from "react-lazyload";
import I18n from "../i18n/i18n";
export default class ThumbnailListView extends React.Component {
  constructor(props) {
    super(props);
    this.state = { type: props.type };
  }

  renderRecommendedArea() {
    if (!Object.keys(this.props.elements).length) return;
    return Object.keys(this.props.elements).map((key, index) => {
      const d = this.props.elements[key];

      if (this.state.type == "is-area-cat") {
        d.url = d.url_category;
      } else {
        d.url = "/" + I18n.current + "/" + d.url;
      }
      if (this.props.elements[key].size === "large") {
        return (
          <div
            className="col-sm-6 col-xs-12 top-thumbnailList_item is-area_lg"
            key={this.props.elements[key].id}
          >
            <CommonElements data={d} type={this.state.type} />
          </div>
        );
      } else {
        return (
          <div
            className="col-sm-3 col-xs-6 top-thumbnailList_item is-area_md"
            key={this.props.elements[key].id}
          >
            <CommonElements data={d} type={this.state.type} />
          </div>
        );
      }
    });
  }

  renderTravelTips() {
    if (!Object.keys(this.props.elements).length) return;

    return Object.keys(this.props.elements).map((key, index) => {
      const d = this.props.elements[key];
      d.url = "/" + I18n.current + d.url;
      return (
        <div
          className="col-sm-4 col-xs-6 top-thumbnailList_item is-travel"
          key={d.id}
        >
          <CommonElements data={d} type={this.state.type} />
        </div>
      );
    });
  }

  renderFeaturedTopics() {
    if (!Object.keys(this.props.elements).length) return;
    return Object.keys(this.props.elements).map((key, index) => {
      const d = this.props.elements[key];
      d.url = "/" + I18n.current + d.url;
      return (
        <div
          className="col-sm-3 col-xs-6 top-thumbnailList_item is-featured"
          key={d.id}
        >
          <CommonElements data={d} type={this.state.type} />
        </div>
      );
    });
  }

  switchType() {
    if (this.state.type === "is-area" || this.state.type === "is-area-cat") {
      return this.renderRecommendedArea();
    } else if (this.state.type === "is-travel") {
      return this.renderTravelTips();
    } else if (this.state.type === "is-featured") {
      return this.renderFeaturedTopics();
    }
  }

  render() {
    return <div className="row top-thumbnailList">{this.switchType()}</div>;
  }
}

function CommonElements(props) {
  let is_area = props.type === "is-area";

  return (
    <a href={props.data.url} id={props.data.id}>
      <LazyLoad height={10} offset={100}>
        <img
          src={props.data.thumbnail}
          alt=""
          className="img-preview img-responsive"
        />
        <p>{I18n.t(props.data.disp_title)}</p>
      </LazyLoad>
    </a>
  );
}
