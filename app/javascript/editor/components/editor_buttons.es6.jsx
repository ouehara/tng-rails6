import EditorBase from "./editor_base.es6";
import ButtonView from "../../components/article/button_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
import BUTTON_TYPES from "../../components/shared_components/button_types.es6";
import I18n from "../../components/i18n/i18n";
export default class EditorButtons extends EditorBase {
  types() {
    return BUTTON_TYPES;
  }
  constructor(props) {
    super(props);
    let url = "";
    let text = "";
    let type = this.types()[0];
    let analyticsText = "";
    let analyticsCat = "";
    let size = "btn-normal";
    let position = "";
    let rel = "";
    if (this.props.content != null) {
      url = this.props.content.url;
      text = this.props.content.text;
      type = this.props.content.type;
      analyticsText = this.props.content.analyticsText;
      analyticsCat = this.props.content.analyticsCat;
      if (typeof this.props.content.size != "undefined") {
        size = this.props.content.size;
      }
      if (typeof this.props.content.position != "undefined") {
        position = this.props.content.position;
      }
      if (typeof this.props.content.rel != "undefined") {
        rel = this.props.content.rel;
      }
    }
    this.state = {
      url: url,
      text: text,
      type: type,
      edit: this.props.edit,
      analyticsText: analyticsText,
      analyticsCat: analyticsCat,
      size: size,
      rel,
      position: position,
    };
  }
  componentWillReceiveProps(nextProps) {
    let url = "";
    let text = "";
    let type = this.types()[0];
    let analyticsText = "";
    let analyticsCat = "";
    let position = "";
    let size = "";
    let rel = "";
    if (nextProps.content != null) {
      url = nextProps.content.url;
      text = nextProps.content.text;
      type = nextProps.content.type;
      analyticsText = nextProps.content.analyticsText;
      analyticsCat = nextProps.content.analyticsCat;
      if (typeof nextProps.content.size != "undefined") {
        size = nextProps.content.size;
      }
      if (typeof nextProps.content.position != "undefined") {
        position = nextProps.content.position;
      }
      if (typeof nextProps.content.rel != "undefined") {
        rel = nextProps.content.rel;
      }
    }
    this.setState({
      position: position,
      size: size,
      url: url,
      text: text,
      type: type,
      rel,
      edit: nextProps.edit,
      analyticsText: analyticsText,
      analyticsCat: analyticsCat,
    });
  }
  saveText() {
    this.setState({
      url: this._url.value,
      text: this._text.value,
      type: this._type.value,
      size: this._size.value,
      rel: this._rel.value,
      position: this._position.value,
      analyticsText: this._analyticsText.value,
      analyticsCat: this._analyticsCat.value,
    });
    this.props.updateState(
      {
        url: this._url.value,
        text: this._text.value,
        type: this._type.value,
        rel: this._rel.value,
        position: this._position.value,
        size: this._size.value,
        analyticsText: this._analyticsText.value,
        analyticsCat: this._analyticsCat.value,
      },
      this.props.position
    );
    this.toggleEdit();
  }
  updateState(type, evt) {
    this.setState({ [type]: evt.target.value });
  }
  renderEditor() {
    if (!this.props.editor) return;
    let url = this.state.url;
    let text = this.state.text;
    let type = this.state.type;
    let rel = this.state.rel;
    let defaultTypes = this.types();
    let analyticsText = this.state.analyticsText;
    let analyticsCat = this.state.analyticsCat;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden" : ""}>
          <div>
            <input
              type="text"
              placeholder="button text"
              className="col-xs-12 form-group form-control"
              defaultValue={text}
              onChange={this.updateState.bind(this, "text")}
              ref={(ref) => (this._text = ref)}
            />
            <input
              type="text"
              placeholder="button url"
              className="col-xs-12 form-group form-control"
              name="url"
              onChange={this.updateState.bind(this, "url")}
              ref={(ref) => (this._url = ref)}
              defaultValue={url}
            />
            <input
              type="text"
              placeholder="rel"
              className="col-xs-12 form-group form-control"
              name="rel"
              onChange={this.updateState.bind(this, "rel")}
              ref={(ref) => (this._rel = ref)}
              defaultValue={rel}
            />
            <input
              type="text"
              placeholder="Google analytics category e.g. link_hankyu"
              className="col-xs-6 form-group form-control"
              name="url"
              onChange={this.updateState.bind(this, "analyticsCat")}
              ref={(ref) => (this._analyticsCat = ref)}
              defaultValue={analyticsCat}
            />
            <input
              type="text"
              placeholder="Google analytics label e.g. zh-hant.hakone"
              className="col-xs-6 form-group form-control"
              name="url"
              ref={(ref) => (this._analyticsText = ref)}
              onChange={this.updateState.bind(this, "analyticsText")}
              defaultValue={analyticsText}
            />
            <select
              defaultValue={type}
              ref={(ref) => (this._type = ref)}
              onChange={this.updateState.bind(this, "type")}
            >
              {defaultTypes.map(function (key) {
                return <option value={key}>{I18n.t("buttons." + key)}</option>;
              })}
            </select>
            <select
              onChange={this.updateState.bind(this, "size")}
              defaultValue={this.state.size}
              ref={(ref) => (this._size = ref)}
            >
              <option value="btn-normal">normal</option>
              <option value="btn-lg">large</option>
            </select>
            <select
              onChange={this.updateState.bind(this, "position")}
              defaultValue={this.state.position}
              ref={(ref) => (this._position = ref)}
            >
              <option value="">left</option>
              <option value="text-center">center</option>
            </select>
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
                            edit: false,
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
            <ButtonView
              position={this.state.position}
              size={this.state.size}
              type={this.state.type}
              url={this.state.url}
              text={this.state.text}
              rel={this.state.rel}
              analyticsText={this.state.analyticsText}
              analyticsCat={this.state.analyticsCat}
            />
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
