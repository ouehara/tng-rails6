import EditorBase from "./editor_base.es6";
import ComponentMenu from "./component_menu.es6";
import React from "react";
import I18n from "../../components/i18n/i18n";
export default class Navigation extends EditorBase {
  constructor(props) {
    super(props);
    this.state = {};
  }
  createMarkup() {
    let text = this.props.content;
    return { __html: text };
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        {(() => {
          if (
            (typeof this.props.onComponentAction == "function" &&
              this.state.shouldShowComponentAction) ||
            this.state.edit
          ) {
            return (
              <ComponentMenu
                onComponentAction={this.props.onComponentAction}
                position={this.props.position}
                saveAction={this.state.edit ? this.saveText.bind(this) : false}
                cancelAction={
                  this.state.edit
                    ? () => {
                        this.cancelAction.bind(this);
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

  render() {
    //
    return (
      <div
        className="table-of-contents"
        onMouseOver={this.showComponentAction.bind(this)}
        onMouseLeave={this.hideComponentAction.bind(this)}
      >
        <h2 className="article-heading">{I18n.t("toc")}</h2>
        <div dangerouslySetInnerHTML={this.createMarkup()} />
        {this.renderEditor()}
      </div>
    );
  }
}
