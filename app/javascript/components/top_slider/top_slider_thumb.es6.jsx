import React from "react";

class TopSliderThumb extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      active: false
    };

    if (props.getClickedThumb) {
      props.getClickedThumb(this.catchActive.bind(this));
    }
    this.catchActive = this.catchActive.bind(this);
  }

  getInitialState() {
    return {
      active_thumb_id: ""
    };
  }

  catchActive() {
    this.props.catchOnClick(this.props.elements.id);
  }
  render() {
    const div_classes =
      this.props.isFirst === 0
        ? "swiper-slide swiper-slide-thumb-active"
        : "swiper-slide";
    const p_classes = `top-heroThumbnail_area ${this.props.type}`;
    return (
      <div className={div_classes} onClick={this.catchActive}>
        <div className="top-heroThumbnail_item">
          <img
            src={this.props.elements.top_thumb_url}
            alt={this.props.elements.cached_area.name}
          />
          <p className={p_classes}>{this.props.elements.cached_area.name}</p>
        </div>
      </div>
    );
  }
}
export default TopSliderThumb;
