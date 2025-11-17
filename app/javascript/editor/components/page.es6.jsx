import EditorBase from "./editor_base.es6";
import ComponentMenu from "./component_menu.es6";
import React from "react";
export default class Page extends EditorBase {
  constructor(props) {
    super(props);
    this.state = { shouldShowComponentAction: false };
  }
  render() {
    return (
      <div
        onMouseOver={this.showComponentAction.bind(this)}
        onMouseLeave={this.hideComponentAction.bind(this)}
      >
        <div className="page-seperator" />
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
                  saveAction={false}
                  cancelAction={false}
                />
              );
            }
          })()}
        </div>
      </div>
    );
  }
}
