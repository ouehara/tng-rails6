import EditorBase from "./editor_base.es6";
import ComponentMenu from "./component_menu.es6";
import React from "react";
export default class RelatedGroup extends EditorBase {
  constructor(props) {
    super(props);
    let elements = {};
    let tmpSelected = [];
    if (this.props.content != null) {
      elements = this.props.content.elements;
      tmpSelected = elements.group;
    }

    this.state = {
      elements: elements,
      edit: this.props.edit,
      tmpSelected: tmpSelected,
      groups: []
    };
    this.getRelatedGroups();
  }
  componentDidMount() {
    this.getRelatedGroups();
  }
  getRelatedGroups() {
    $.ajax({
      url: "/api/adapters/related_group/list"
    }).done(data => {
      this.setState({ groups: data });
    });
  }
  saveText() {
    this.props.updateState(
      {
        elements: { group: this.state.tmpSelected }
      },
      this.props.position
    );
    this.toggleEdit();
  }
  componentWillReceiveProps(nextProps) {
    let elements = [];
    if (nextProps.content != null) {
      elements = nextProps.content.elements;
    }
    this.setState({
      elements: elements,
      edit: nextProps.edit
    });
  }
  renderOptions() {
    return this.state.groups.map(el => {
      return <option value={el[1]}>{el[0]}</option>;
    });
  }
  changedOptions(val, el) {
    let old = [...this.state.tmpSelected];
    old[val] = el.target.value;
    this.setState({ tmpSelected: old });
  }
  getDefaultValue(key) {
    return this.state.tmpSelected[key] == undefined
      ? 0
      : this.state.tmpSelected[key];
  }
  renderEditor() {
    if (!this.props.editor) return;

    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div
          className="editor"
          className={!this.state.edit ? "hidden" : "editor"}
        >
          <select
            onChange={this.changedOptions.bind(this, 0)}
            value={this.getDefaultValue(0)}
          >
            <option value="0"> Select </option>
            {this.renderOptions()}
          </select>
          <select
            onChange={this.changedOptions.bind(this, 1)}
            value={this.getDefaultValue(1)}
          >
            <option value="0"> Select </option>
            {this.renderOptions()}
          </select>
          <select
            onChange={this.changedOptions.bind(this, 2)}
            value={this.getDefaultValue(2)}
          >
            <option value="0"> Select </option>
            {this.renderOptions()}
          </select>
          <select
            onChange={this.changedOptions.bind(this, 3)}
            value={this.getDefaultValue(3)}
          >
            <option value="0"> Select </option>
            {this.renderOptions()}
          </select>
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
          <div onClick={this.toggleEdit.bind(this)}>"NO view implemented"</div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
