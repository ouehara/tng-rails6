import React from "react";
import { Carousel } from "react-responsive-carousel";
import LazyLoad from "react-lazyload";
//import I18n from "../i18n/i18n";

class AdList extends React.Component {
  constructor(props) {
    super(props);
    const { mobile = true, locale = "en" } = this.props;
    this.state = {
      type: this.props.type,
      is_sidebar: this.props.type === "sidebar",
      locale: locale,
      isMobile: mobile,
    };
  }
  renderAdList() {
    const { elements } = this.props;
    if (!Object.keys(this.props.elements).length) return;
    // console.log(this.state);
    const classes =
      this.state.is_sidebar && !this.state.isMobile
        ? "ad_item"
        : "swiper-slide";
    return elements.map((element, index) => {
      return (
        <div className={classes} key={index}>
          <LazyLoad height={10} offset={100}>
            <a
              target="_blank"
              href={element.url}
              id={`ads_` + element.id}
              onClick={() => {
                ga(
                  "send",
                  "event",
                  element.analytics_category,
                  "click",
                  this.state.locale + "_" + element.analytics_label
                );
              }}
            >
              <img src={element.banner_url} alt="" />
            </a>
          </LazyLoad>
        </div>
      );
    });
  }

  render() {
    if (this.state.is_sidebar && !this.props.mobile) {
      return <div>{this.renderAdList()}</div>;
    } else {
      let shouldShowArrows =
        this.props.elements.length > 4 || this.props.mobile;

      let params = {};
      if (!this.state.isMobile) {
        params = {
          width:
            Math.min(100, Object.keys(this.props.elements).length * 25) + "%",
          centerSlidePercentage:
            100 / Math.min(4, Object.keys(this.props.elements).length),
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
      params.selectedItem = this.state.isMobile
        ? Math.round(Object.keys(this.props.elements).length / 2) - 1
        : 0;
      params.showIndicators =
        !this.state.isMobile && Object.keys(this.props.elements).length <= 4
          ? false
          : true;

      return (
        <div className="slider-4">
          <Carousel
            showStatus={false}
            showThumbs={false}
            centerMode={true}
            {...params}
            emulateTouch
            infiniteLoop={shouldShowArrows}
            showArrows={shouldShowArrows}
          >
            {this.renderAdList()}
          </Carousel>
        </div>
      );
    }
  }
}
export default AdList;
