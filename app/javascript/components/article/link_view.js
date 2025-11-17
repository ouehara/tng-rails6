import React from "react";
import Truncate from "react-truncate";
import LazyLoad from "react-lazyload";
import I18n from "../i18n/i18n";

export default class LinkView extends React.Component {
  render() {
    const { mobile = false } = this.props;
    return (
      <LazyLoad once>
        <a
          href={this.props.url}
          target="_blank"
          className="article-link-wrapper in-related-article-wrapper"
        >
          <div
            className="well border-black"
            data-text={I18n.t("related_label")}
          >
            <div className="row">
              <div className="col-xs-4">
                <img
                  className="img-preview img-responsive"
                  src={this.props.img}
                />
              </div>
              <div className="col-xs-8">
                <h3>
                  <Truncate lines={2} width={mobile ? 200 : 500}>
                    {this.props.title}
                  </Truncate>
                </h3>
                <div className="desc hidden-xs">
                  <Truncate lines={2} width={500} ellipsis={<span>...</span>}>
                    {this.props.desc}
                  </Truncate>
                </div>
              </div>
            </div>
          </div>
        </a>
      </LazyLoad>
    );
  }
}
