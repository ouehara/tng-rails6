import EditorBase from "./editor_base.es6";
import QuoteView from "../../components/article/quote_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
export default class Quote extends EditorBase {
  constructor(props) {
    super(props);
    let url = "";
    let quote = "";
    if (this.props.content != null) {
      url = this.props.content.url;
      quote = this.props.content.quote;
    }
    this.state = { url: url, quote: quote, commet: "", edit: this.props.edit };
  }
  componentWillReceiveProps(nextProps) {
    let url = "";
    let quote = "";
    if (nextProps.content != null) {
      url = nextProps.content.url;
      quote = nextProps.content.quote;
    }
    this.setState({ url: url, quote: quote, commet: "", edit: nextProps.edit });
  }
  saveText() {
    this.setState({
      url: this._url.value,
      quote: this._quote.value
    });
    this.props.updateState(
      {
        url: this._url.value,
        quote: this._quote.value
      },
      this.props.position
    );
    this.toggleEdit();
  }
  renderEditor() {
    if (!this.props.editor) return;
    let url = this.state.url;
    let quote = this.state.quote;
    let comment = this.state.comment;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden" : ""}>
          <div>
            <textarea
              name="quote"
              placeholder="quote"
              className="col-xs-12 form-group form-control"
              ref={ref => (this._quote = ref)}
              defaultValue={quote}
            />
            <input
              type="text"
              placeholder="source"
              className="col-xs-12 form-group form-control"
              name="url"
              ref={ref => (this._url = ref)}
              defaultValue={url}
            />
          </div>
        </div>
        <div className="row remove-margin-right">
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
                    this.state.edit ? this.saveText.bind(this) : false
                  }
                  renderExtendedMenu={this.props.renderComponents}
                  cancelAction={
                    this.state.edit
                      ? () => {
                          this.toggleEdit.bind(this);
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
      </div>
    );
  }
  render() {
    let url = this.state.url;
    let quote = this.state.quote;
    let comment = this.state.comment;
    return (
      <div
        onMouseOver={this.showComponentAction.bind(this)}
        onMouseLeave={this.hideComponentAction.bind(this)}
        className={
          this.props.className +
          (this.state.shouldShowComponentAction ? " highglight-el" : "")
        }
      >
        <div className={this.state.edit ? "hidden" : ""}>
          <div onClick={this.toggleEdit.bind(this)}>
            <QuoteView
              quote={quote == "" ? "click here to edit" : quote}
              url={url}
            />
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
