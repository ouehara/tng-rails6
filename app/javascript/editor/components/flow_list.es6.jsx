import React from "react";
import EditorBase from "./editor_base.es6";
import FlowListView from "../../components/article/flow_list_view";
import ComponentMenu from "./component_menu.es6";
import MediumEditor from "../medium-editor";

class FlowListInput extends React.Component {
  constructor(props) {
    super(props);
    this.editor = null;
  }
  componentDidMount() {
    if (this.editor == null) {
      this.editor = new MediumEditor(this.mainEdit, {
        toolbar: {
          buttons: ["bold", "italic", "underline", "anchor"]
        },
        anchor: {
          /* These are the default options for anchor form,
             if nothing is passed this is what it used */
          customClassOption: "btn btn-ads",

          linkValidation: false,
          placeholderText: "Paste or type a link",
          targetCheckbox: false,
          targetCheckboxText: "Open in new window"
        }
      });
      if (typeof this.props.el != "undefined") {
        this.editor.setContent(this.props.el.content);
      } else {
        this.editor.setContent("");
      }
    }
  }
  changedEditor(index, ev) {
    let t = { target: { value: "" } };
    t["target"]["value"] = this.editor.getContent();
    this.props.change(index, t);
  }
  render() {
    return (
      <div className="form-group">
        <div
          className="btn btn btn-danger pull-right"
          onClick={() => this.props.remove()}
        >
          <span className="glyphicon glyphicon-remove" aria-hidden="true" />
        </div>
        <label> Label </label>
        <input
          className="form-control"
          type="text"
          value={typeof this.props.el == "undefined" ? "" : this.props.el.label}
          onChange={ev => this.props.change("label", ev)}
        />
        <label> content </label>
        <div
          style={{ height: "auto" }}
          className="editor-flow-list form-control"
          id="basic-name"
          ref={ref => {
            this.mainEdit = ref;
          }}
          onInput={ev => this.changedEditor("content", ev)}
        />
      </div>
    );
  }
}
export default class FlowList extends EditorBase {
  constructor(props) {
    super(props);
    let elements = [{ label: "", content: "" }];
    if (this.props.content != null) {
      elements = this.props.content.elements;
    }
    this.state = { elements: elements, edit: this.props.edit };
  }
  componentWillReceiveProps(nextProps) {
    let elements = [{ label: "", content: "" }];
    if (nextProps.content != null) {
      elements = nextProps.content.elements;
    }
    this.setState({ elements: elements, edit: nextProps.edit });
  }
  appendInput() {
    var newInput = { label: "", content: "" };
    this.setState({ elements: this.state.elements.concat([newInput]) });
  }
  formElChange(el, index, ev) {
    let elements = this.state.elements;
    elements[index][el] = ev.target.value;
    this.setState({ elements: elements });
  }
  removeEl(index) {
    if (this.state.elements.length <= 1) {
      return;
    }
    let a = this.state.elements.slice();
    a.splice(index, 1);
    this.setState({ elements: a });
  }
  save() {
    this.props.updateState(
      {
        elements: this.state.elements
      },
      this.props.position
    );
    this.toggleEdit();
  }
  flowListRender() {
    if (
      this.state.elements.length <= 0 ||
      !(this.state.elements instanceof Array)
    ) {
      return;
    }
    return this.state.elements.map((input, index) => (
      <FlowListInput
        el={input}
        change={(type, ev) => this.formElChange(type, index, ev)}
        remove={() => this.removeEl(index)}
      />
    ));
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden" : "editor"}>
          <form>
            <div id="dynamicInput">
              {this.state.edit ? this.flowListRender() : ""}
            </div>
          </form>
          <button
            onClick={() => this.appendInput()}
            className="btn btn-default"
          >
            Add row
          </button>
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
                  saveAction={this.state.edit ? this.save.bind(this) : false}
                  renderExtendedMenu={this.props.renderComponents}
                  cancelAction={
                    this.state.edit
                      ? () => {
                          this.toggleEdit();
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
            {<FlowListView elements={this.state.elements} />}
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
