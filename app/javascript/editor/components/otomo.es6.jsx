import EditorBase from "./editor_base.es6";
import OtomoWidgetView from "../../components/article/otomo_widget_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
export default class Otomo extends EditorBase {
  constructor(props) {
    super(props);
    let otomoId = "";
    if (this.props.content != null) {
      otomoId = this.props.content.otomoId;
    }
    this.state = {
      otomoId,
      edit: this.props.edit
    };
  }
  componentWillReceiveProps(nextProps) {
    if (this.state.edit) {
      return;
    }
    let otomoId = "";
    if (nextProps.content != null) {
      otomoId = nextProps.content.otomoId;
    }
    this.setState({
      otomoId,
      edit: nextProps.edit
    });
  }
  saveOtomo() {
    this.props.updateState(
      {
        otomoId: this.state.otomoId
      },
      this.props.position
    );
    this.toggleEdit();
  }
  cancel() {
    this.toggleEdit();
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden" : ""}>
          <input
            type="text"
            className="col-sm-12"
            placeholder="otomo widget id"
            className="form-control"
            onChange={evt => {
              this.setState({ otomoId: evt.target.value });
            }}
            value={this.state.otomoId}
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
                    this.state.edit ? this.saveOtomo.bind(this) : false
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
              <OtomoWidgetView
                otomoId={this.state.otomoId}
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
