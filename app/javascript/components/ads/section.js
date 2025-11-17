import React from "react";
import { Carousel } from "react-responsive-carousel";
import LazyLoad from "react-lazyload";

class Section extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      type: this.props.type,
      is_sidebar: this.props.type === "sidebar",
      is_pc: this.props.mobile == null,
    };
  }

  renderAdList() {
    const { elements } = this.props;
    if (!Object.keys(this.props.elements).length) return;
    const classes =
      this.state.is_sidebar && this.state.is_pc ? "ad_item" : "swiper-slide";
    return elements.map((element, index) => {
      return (
        <div className={classes} key={index}>
          <LazyLoad height={10} offset={100}>
            <a href={element.link} id={element.id}>
              <img
                src={element.image_url + "&d=400x400"}
                className="img-responsive"
              />
              <h4>{element.title}</h4>
            </a>
          </LazyLoad>
        </div>
      );
    });
  }
  isMobileDevice() {
    return (
      typeof window.orientation !== "undefined" ||
      navigator.userAgent.indexOf("IEMobile") !== -1
    );
  }
  render() {
    if (this.state.is_sidebar && this.state.is_pc) {
      return <div>{this.renderAdList()}</div>;
    } else {
      let shouldShowArrows =
        this.props.elements.length > 3 || this.props.mobile;

      let params = {};
      if (this.state.is_pc) {
        params = {
          width:
            Math.min(100, 100 / (4 - Object.keys(this.props.elements).length)) +
            "%",
          centerSlidePercentage:
            100 / Math.min(3, Object.keys(this.props.elements).length),
        };
      } else {
        shouldShowArrows = true;
        params = {
          width:
            Math.min(100, 100 / (4 - Object.keys(this.props.elements).length)) +
            "%",
          centerSlidePercentage: 65,
        };
      }
      params.selectedItem =
        Math.round(Object.keys(this.props.elements).length / 2) - 1;
      return (
        <div className="slider-3">
          <Carousel
            showThumbs={false}
            showStatus={false}
            centerMode={true}
            dynamicHeight={true}
            infiniteLoop={shouldShowArrows}
            {...params}
            emulateTouch
            showArrows={shouldShowArrows}
          >
            {this.renderAdList()}
          </Carousel>
        </div>
      );
    }
  }
}
export default Section;
