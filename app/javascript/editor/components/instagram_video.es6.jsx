import EditorBase from "./editor_base.es6";
import InstagramVideoView from "../../components/article/instagram_video_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
export default class InstagramVideo extends EditorBase {
  constructor(props) {
    super(props);
    let url = "";
    if (this.props.content != null) {
      url = this.props.content.url;
    }
    this.state = {
      url: url,
      edit: this.props.edit
    };
  }
  componentWillReceiveProps(nextProps) {
    if (this.state.edit) {
      return;
    }
    let url = "";
    if (nextProps.content != null) {
      url = nextProps.content.url;
    }
    this.setState({
      url: url,
      edit: nextProps.edit
    });
  }
  saveHeading(videoId) {
    this.setState({
      url: this._url.value
    });
    this.props.updateState(
      {
        url: this._url.value
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
            className="col-sm-12 form-control"
            ref={ref => (this._url = ref)}
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
              <InstagramVideoView
                url={this.state.url}
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
