import React from "react";
import { Carousel } from "react-responsive-carousel";
import ArticleItem from "./article_item.es6.jsx";

class ArticleListSwiper extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_pc: window.matchMedia("(min-width: 768px)").matches
    };
  }

  renderList() {
    if (!Object.keys(this.props.elements).length) return;
    return Object.keys(this.props.elements).map((key, index) => {
      return (
        <ArticleItem
          articlePath={this.props.articlePath}
          elements={this.props.elements[key]}
          isPc={this.state.is_pc}
          type="articleBlock"
          key={index}
        />
      );
    });
  }

  render() {
    if (this.state.is_pc) {
      return <div className="row articleBlock">{this.renderList()}</div>;
    } else {
      return (
        <div className="slider-3">
          <div className="articleBlock">
            <Carousel
              showThumbs={false}
              showStatus={false}
              showIndicators={false}
            >
              {this.renderList()}
            </Carousel>
          </div>
        </div>
      );
    }
  }
}
export default ArticleListSwiper;
