import EditorBase from "./editor_base.es6";
import ComponentMenu from "./component_menu.es6";
import React from "react";
import I18n from "../../components/i18n/i18n";
export default class HotelAffiliate extends EditorBase {
  constructor(props) {
    super(props);
    let url = "";
    let type = "";
    if (this.props.content != null) {
      url = this.props.content.url;
      type = this.props.content.type;
    }
    this.state = {
      url: url,
      type: type,
      edit: this.props.edit
    };
  }
  analyticsText() {
    if (
      this.props.content != null &&
      typeof this.props.content.name != "undefined"
    ) {
      return (
        I18n.current +
        "." +
        this.props.analytics +
        "." +
        this.getButtonText() +
        "." +
        this.props.content.name
      );
    }
    return (
      I18n.current +
      "." +
      this.props.analytics +
      "." +
      this.getButtonText() +
      "." +
      this.props.id
    );
  }
  analytics() {
    ga("send", "event", "article_hotel", "click", this.analyticsText());
  }
  componentWillReceiveProps(nextProps) {
    /*let headingType = nextProps.content.headingType;
    let text = nextProps.content.text;
    this.setState({ text: text, headingType: headingType })*/
  }
  saveHeading(videoId) {}
  changeEv(ev) {}
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className="row">
        {(() => {
          if (
            (typeof this.props.onComponentAction == "function" &&
              this.state.shouldShowComponentAction) ||
            this.state.edit
          ) {
            return (
              <ComponentMenu
                isMarked={
                  typeof this.props.markedComponent[this.props.position] !=
                  "undefined"
                }
                onComponentAction={this.props.onComponentAction}
                position={this.props.position}
                saveAction={
                  this.state.edit ? this.saveHeading.bind(this) : false
                }
                cancelAction={
                  this.state.edit
                    ? () => {
                        this.saveHeading.bind(this);
                        this.props.updateEditState(
                          {
                            edit: false
                          },
                          this.props.position
                        );
                      }
                    : false
                }
              />
            );
          }
        })()}
      </div>
    );
  }
  getButtonText() {
    if (typeof this.state.type === "number" && this.state.type % 1 == 0) {
      return I18n.t("hotel.bookWith" + this.state.type);
    }
    return this.state.type;
  }
  render() {
    return (
      <div
        onMouseOver={this.showComponentAction.bind(this)}
        onMouseLeave={this.hideComponentAction.bind(this)}
        className={this.props.className + " hotel-affiliate"}
      >
        <a
          href={this.state.url}
          target="_blank"
          onClick={this.analytics.bind(this)}
        >
          <span className="book-with">{this.getButtonText()}</span>
        </a>
        {this.renderEditor()}
      </div>
    );
  }
}
