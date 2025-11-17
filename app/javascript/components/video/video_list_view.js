import React from "react";
import { Carousel } from "react-responsive-carousel";
import LazyLoad from "react-lazyload";

class VideoListView extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_sidebar: props.type === "sidebar",
      is_pc: props.mobile == null,
    };
    this.renderThumbs = this.renderThumbs.bind(this);
  }

  isMobileDevice = () => (
    typeof window.orientation !== "undefined" ||
    navigator.userAgent.indexOf("IEMobile") !== -1
  );

  renderAdList = () => {
    const { elements } = this.props;
    if (!elements.length) return null;
    const classes = this.state.is_sidebar && this.state.is_pc ? "ad_item video-slide" : "swiper-slide video-slide";
    return elements.map((element, index) => (
      <div key={index} className={classes}>
        <iframe
          className="ytplayer"
          type="text/html"
          src={`https://www.youtube.com/embed/${element.link}`}
          frameBorder="0"
          allowFullScreen
          width="100%"
          height={this.state.is_pc ? "407" : "245"}
        />
        <h4>{element.title}</h4>
      </div>
    ));
  };

  renderThumbs = () => this.props.elements.map((element, index) => (
    <img
      src={`https://i.ytimg.com/vi/${element.link}/hqdefault.jpg`}
      alt=""
      key={index}
    />
  ));

  render() {
    return this.state.is_sidebar && this.state.is_pc ? (
      <div>{this.renderAdList()}</div>
    ) : (
      <div className="slider-3">
        <LazyLoad offset={100}>
          <Carousel
            showIndicators={false}
            showStatus={false}
            renderThumbs={this.renderThumbs}
            thumbWidth="33"
            infiniteLoop={true}
            showThumbs={this.state.is_pc}
          >
            {this.renderAdList()}
          </Carousel>
        </LazyLoad>
      </div>
    );
  }
}

export default VideoListView;
