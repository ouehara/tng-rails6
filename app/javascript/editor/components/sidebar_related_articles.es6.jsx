import EditorRelatedFunctions from "./editor_related_functions.es6";
import ComponentMenu from "./component_menu.es6";
import React from "react";
export default class SidebarRelatedArticles extends EditorRelatedFunctions {
  renderEditor() {
    return (
      <div>
        <div className="editor">
          <button
            className="btn btn-default"
            onClick={this.toggleSearchPopup.bind(this)}
          >
            Select Article
          </button>
          {this.renderSearchPopUp()}
          {this.renderEditResult()}
        </div>
      </div>
    );
  }
  componentWillReceiveProps(nextProps) {
    let elements = {};
    if (nextProps.content != null) {
      elements = nextProps.content.elements;
    }
    this.setState({
      elements: elements,
      edit: nextProps.edit,
      shouldShowSearchPopup: this.state.shouldShowSearchPopup,
      searchTerm: this.state.searchTerm,
      searchResult: this.state.searchResult,
      concept: this.state.concept,
      target: this.state.target,
      filterCatText: this.state.filterCatText,
      categoryFilter: this.state.categoryFilter
    });
  }
  setStateCb() {
    this.props.onUpdate({ elements: this.state.elements });
  }
  renderEditResult() {
    if (this.state.elements == null) {
      return;
    }
    return Object.keys(this.state.elements).map((key, index) => {
      return (
        <div className="row">
          <div className="col-xs-12">
            {this.state.elements[key].title}
            <button
              type="button"
              className="close"
              onClick={this.removeElement.bind(
                this,
                this.state.elements[key].id
              )}
            >
              &times;
            </button>
            <hr />
          </div>
        </div>
      );
    });
  }
  render() {
    return <div>{this.renderEditor()}</div>;
  }
}
