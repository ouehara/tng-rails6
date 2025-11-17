import React from "react";
import { Carousel } from "react-responsive-carousel";
import ArticleItem from "../article_list/article_item.es6";

class AreaTabView extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      type: this.props.type,
      is_sidebar: this.props.type === "sidebar",
      is_pc: this.props.mobile == null
    };
  }

  renderList() {
    return this.props.elements.map((item, index) => {
      return (
        <ArticleItem
          lang={this.props.lang}
          articlePath={this.props.articlePath}
          elements={item}
          isPc={this.state.is_pc}
          type="articleBlock"
          key={index}
        />
      );
    });
  }
  render() {
    if (this.state.is_pc) {
      return <div className="row">{this.renderList()}</div>;
    }
    return (
      <div className="slider-3">
        <Carousel
          showThumbs={false}
          showStatus={false}
          showIndicators={!this.state.is_pc}
          centerMode={true}
          infiniteLoop={!this.state.is_pc}
          selectedItem={1}
          centerSlidePercentage={!this.state.is_pc ? 80 : 33}
          showArrows={!this.state.is_pc}
        >
          {this.renderList()}
        </Carousel>
      </div>
    );
  }
}
export default AreaTabView;
