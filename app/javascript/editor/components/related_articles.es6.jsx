import EditorRelatedFunctions from "./editor_related_functions.es6";
import RelatedArticlesView from "../../components/article/related_articles_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
import I18n from "../../components/i18n/i18n";
export default class RelatedArticles extends EditorRelatedFunctions {
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div
          className="editor"
          className={!this.state.edit ? "hidden" : "editor"}
        >
          <button
            className="btn btn-default"
            onClick={this.toggleSearchPopup.bind(this)}
          >
            Select Article
          </button>
          {this.renderSearchPopUp()}
          {this.renderEditResult()}
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
            {!this.state.edit ? (
              <RelatedArticlesView
                locale={I18n.current}
                elements={this.state.elements}
              />
            ) : (
              ""
            )}
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
