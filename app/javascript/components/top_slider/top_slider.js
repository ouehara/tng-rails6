import React from "react";
//import ReactIdSwiperCustom from 'react-id-swiper/lib/ReactIdSwiper.custom';
import { Carousel } from "react-responsive-carousel";

// For swiper version 5.x

class TopSlider extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  getImageType(type) {
    switch (type) {
      case 2:
        return "is-todo";
        break;
      case 5:
        return "is-tips";
        break;
      case 4:
        return "is-shopping";
        break;
      case 1:
        return "is-food";
        break;
      case 3:
        return "is-hotel";
        break;
      default:
        return "";
    }
  }
  renderImage(mobile, url) {
    return <img src={url} alt="" />;
  }
  renderMainList() {
    const { topSlider } = this.props;
    const isMobile = this.isMobileDevice();
    const suffix = !isMobile ? "?d=1035x460" : "?d=750x400";
    if (!Object.keys(topSlider).length) return;
    return topSlider.map((el, index) => {
      const p_classes = `top-heroMain_category ${this.getImageType(
        el.category_id
      )}`;
      return (
        <div className="swiper-slide" key={index}>
          <a href={el.get_path} id={el.id} className="">
            <div style={{ zIndex: "9999" }} className="top-heroMain_item faker">
              {this.renderImage(isMobile, el.original_url + suffix)}
            </div>
            <div className="top-heroMain_item">
              <div className="top-heroMain_content">
                <p className="top-heroMain_lead truncate-overflow">
                  {el.disp_title}
                </p>
              </div>
            </div>
          </a>
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
  renderCar() {
    const widthPercentage = (1035 * 100) / window.innerWidth;
    return (
      <Carousel
        infiniteLoop
        autoPlay
        interval={6000}
        showStatus={false}
        showThumbs={false}
        showIndicators={true}
        swipeable={true}
        emulateTouch
        showArrows={!this.props.mobile}
        centerSlidePercentage={widthPercentage}
        centerMode={!this.props.mobile}
      >
        {this.renderMainList()}
      </Carousel>
    );
  }
  render() {
    return <div>{this.renderCar()}</div>;
  }
}
export default TopSlider;
