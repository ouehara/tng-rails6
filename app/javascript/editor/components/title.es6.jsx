import EditorBase from "./editor_base.es6";
import HeadlineView from "../../components/article/headline_view.es6";
import ComponentMenu from "./component_menu.es6";
import React from "react";
export default class Title extends EditorBase {
  constructor(props) {
    super(props);
    let headingType = "heading";
    let text = "";
    if (this.props.content != null) {
      headingType = this.props.content.headingType;
      text = this.props.content.text;
    }
    this.state = {
      headingType: headingType,
      text: text,
      edit: this.props.edit,
      textlength: text.length,
    };
  }
  componentWillReceiveProps(nextProps) {
    if (this.state.edit) {
      return;
    }
    let headingType = "heading";
    let text = "";
    if (nextProps.content != null) {
      headingType = nextProps.content.headingType;
      text = nextProps.content.text;
    }
    this.setState({
      headingType: headingType,
      text: text,
      edit: nextProps.edit,
      textlength: text.length,
    });
  }
  selectHeading(evt) {
    this.setState({ headingType: evt.target.value });
  }
  saveHeading(videoId) {
    this.setState({
      text: this._heading.value,
    });
    this.props.updateState(
      {
        text: this._heading.value,
        headingType: this.state.headingType,
      },
      this.props.position
    );
    this.toggleEdit();
  }
  changeEv(ev) {
    let val = ev.target.value;
    let length = val.length - this.state.textlength;
    this.props.updateCurChar(length);
    this.setState({ textlength: this.state.textlength + length, text: val });
  }
  cancel() {
    this.toggleEdit();
    let length = this.state.text.length - this.state.textlength;
    this.props.updateCurChar(length);
    this.setState({ textlength: this.state.textlength + length });
    this.props.updateEditState(
      {
        edit: false,
      },
      this.props.position
    );
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden" : ""}>
          <label>
            Heading Type:
            <select
              value={this.state.headingType}
              onChange={this.selectHeading.bind(this)}
            >
              <option value="heading">Heading</option>
              <option value="subheading">Subheading</option>
              <option value="h4">H4</option>
            </select>
          </label>
          <input
            type="text"
            onChange={(ev) => {
              this.changeEv(ev);
            }}
            className="col-sm-12"
            className="form-control"
            ref={(ref) => (this._heading = ref)}
            value={this.state.text}
          />
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
                    this.state.edit ? this.saveHeading.bind(this) : false
                  }
                  cancelAction={
                    this.state.edit ? this.cancel.bind(this) : false
                  }
                  renderExtendedMenu={this.props.renderComponents}
                />
              );
            }
          })()}
        </div>
      </div>
    );
  }
  render() {
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
            {this.state.text == "" ? (
              "click here to edit"
            ) : (
              <HeadlineView
                text={this.state.text}
                type={this.state.headingType}
                pos={this.props.position}
                compid={this.props.compid}
              />
            )}
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
