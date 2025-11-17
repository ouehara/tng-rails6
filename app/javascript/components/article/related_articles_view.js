import React from "react";
import "whatwg-fetch";
import dayjs from "dayjs";
import Truncate from "react-truncate";
import I18n from "../i18n/i18n";
import LazyLoad from "react-lazyload";

export default class RelatedArticlesView extends React.Component {
  constructor(props) {
    super(props);
    const { elements } = this.props;
    const { mobile = false } = this.props;
    const a = this.fetch();
    this.state = { elements: {}, width: mobile ? 200 : 500 };
  }

  componentDidMount() {}
  async fetch() {
    if (!Object.keys(this.props.elements).length) return;
    const fetched = Object.keys(this.props.elements).map(async (key, index) => {
      let response = await fetch(
        "/" +
          this.props.locale +
          "/related/" +
          this.props.elements[key].id +
          ".json"
      );
      return await response.json();
    });

    const elements = await Promise.all(fetched);
    this.setState({ elements: elements, width: this.state.width + 1 });
  }
  getFormattedDate(element) {
    let d = element.published_at;
    let date = dayjs(element.published_at).format("MMM DD, YYYY");
    if (element.schedule && element.schedule[I18n.current]) {
      d = element.schedule[I18n.current];
      date = dayjs(d).format("MMM DD, YYYY");
    }
    return <span>{date}</span>;
  }

  renderLinkView() {
    const { mobile = false } = this.props;
    if (!Object.keys(this.state.elements).length) return;
    return Object.keys(this.state.elements).map((key, index) => {
      return (
        <a
          key={index}
          href={
            "https://www.tsunagujapan.com/" +
            this.props.locale +
            "/" +
            this.state.elements[key].slug
          }
          target="_blank"
          className="article-link-wrapper in-related-article-wrapper"
        >
          <div
            className="well border-black"
            data-text={I18n.t("related_label")}
          >
            <div className="row">
              <div className="col-xs-4 in-prev-image">
                <img
                  className="img-preview img-responsive"
                  src={this.state.elements[key].medium_url}
                />
              </div>
              <div className="col-xs-8 related_body">
                <p className="date  hidden-xs">
                  {this.getFormattedDate(this.state.elements[key])}
                </p>
                <h3>
                  <Truncate lines={2} width={this.state.width}>
                    {this.state.elements[key].disp_title}
                  </Truncate>
                </h3>
                <div className="desc hidden-xs">
                  <Truncate lines={2} width={500} ellipsis={<span>...</span>}>
                    {this.state.elements[key].excerpt}
                  </Truncate>
                </div>
              </div>
            </div>
          </div>
        </a>
      );
    });
  }
  render() {
    return (
      <LazyLoad once height={100}>
        {this.renderLinkView()}
      </LazyLoad>
    );
  }
}
