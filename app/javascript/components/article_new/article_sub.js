import React from "react";
import ArticleSubItem from "./article_sub_item.es6.jsx";
import PropTypes from "prop-types";
export default class ArticleSub extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      type: this.props.type,
    };
  }
  render() {
    return (
      <div>
        <ArticleSubItem
          mobile={this.props.mobile}
          type="related"
          showRelatedAd={this.props.showRelatedAd}
          elements={this.props.elements}
        />
      </div>
    );
  }
}
ArticleSub.propTypes = {
  mobile: PropTypes.bool,
};
ArticleSub.defaultProps = {
  mobile: false,
};
