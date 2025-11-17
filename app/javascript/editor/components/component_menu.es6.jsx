import React from "react";
export default class ComponentMenu extends React.Component {
  constructor(props) {
    super(props);
    this.saveShortcut();
    this.saveKeys = {
      Control: false,
      s: false
    };
    this.state = {
      showExtendedMenu: false,
      marked: this.props.isMarked
    };
  }

  shouldRenderSavaAndCancelAction() {
    if (!this.props.saveAction) {
      return;
    }
    return (
      <span>
        <li
          title="Shortcut: ctrl+s"
          className="btn btn-success"
          onClick={this.props.saveAction}
          ref={ref => {
            this._save = ref;
          }}
        >
          save
        </li>
        <li className="btn btn-danger" onClick={this.props.cancelAction}>
          cancel
        </li>
      </span>
    );
  }
  componentDidUpdate() {
    this.saveShortcut();
  }
  saveShortcut() {
    if (!this.props.saveAction) {
      this.removeEvent();
      return;
    }
    this.removeEvent();
    document.body.addEventListener("keydown", this.keyDownEvent.bind(this));
    document.body.addEventListener("keyup", this.disableSaveKeys.bind(this));
  }
  keyDownEvent(ev) {
    if (typeof this.saveKeys[ev.key] != "undefined") {
      this.saveKeys[ev.key] = true;
    }
    if (this.saveKeys["Control"] && this.saveKeys["s"] && this._save != null) {
      ev.preventDefault();
      this._save.click();
      this.disableSaveKeys();
      this.removeEvent();
    }
  }
  disableSaveKeys() {
    this.saveKeys.Control = false;
    this.saveKeys.s = false;
  }
  removeEvent() {
    document.body.removeEventListener("keydown", this.keyDownEvent);
    document.body.removeEventListener("keyup", this.disableSaveKeys);
  }

  toggleShowExtendedMenu() {
    this.setState({ showExtendedMenu: !this.state.showExtendedMenu });
  }
  componentAction(action, pos) {
    let mark = this.state.marked;
    if (action == "mark") {
      mark = !mark;
    }
    this.setState({ showExtendedMenu: false, marked: mark });

    this.props.onComponentAction(action, pos);
  }
  renderExtendedMenu() {
    if (
      typeof this.props.renderExtendedMenu == "undefined" ||
      !this.state.showExtendedMenu
    ) {
      return;
    }
    return this.props.renderExtendedMenu(this.props.position);
  }

  render() {
    return (
      <div className="clearfix">
        <span
          className="btn btn-default add-comp-button"
          title="add component"
          onClick={this.toggleShowExtendedMenu.bind(this)}
        >
          <span className="glyphicon glyphicon-plus" aria-hidden="true" />
          <img src="/assets/insert_arrow.png" className="add-bellow-arrow" />
        </span>
        <ul className="btn-group pull-right component-menu">
          <li
            className="btn btn-default"
            title="up"
            onClick={() => this.componentAction("up", this.props.position)}
          >
            <span
              className={
                this.state.marked
                  ? "glyphicon glyphicon-menu-up active-glyph-record"
                  : "glyphicon glyphicon-menu-up"
              }
              aria-hidden="true"
            />
          </li>
          <li
            className="btn btn-default"
            title="down"
            onClick={() => this.componentAction("down", this.props.position)}
          >
            <span
              className={
                this.state.marked
                  ? "glyphicon glyphicon-menu-down active-glyph-record"
                  : "glyphicon glyphicon-menu-down"
              }
              aria-hidden="true"
            />
          </li>
          <li
            className="btn btn-default"
            title="top"
            onClick={() => this.componentAction("top", this.props.position)}
          >
            <span className="glyphicon glyphicon-open" aria-hidden="true" />
          </li>
          <li
            className="btn btn-default"
            title="bottom"
            onClick={() => this.componentAction("bottom", this.props.position)}
          >
            <span className="glyphicon glyphicon-save" aria-hidden="true" />
          </li>
          {this.shouldRenderSavaAndCancelAction()}
          <li
            className="btn btn-default"
            title="delete"
            onClick={() => this.componentAction("del", this.props.position)}
          >
            <span
              className={
                this.state.marked
                  ? "glyphicon glyphicon-trash active-glyph-record"
                  : "glyphicon glyphicon-trash"
              }
              aria-hidden="true"
            />
          </li>
          <li
            className="btn btn-default"
            title="mark"
            onClick={() => this.componentAction("mark", this.props.position)}
          >
            <span
              className={
                this.state.marked
                  ? "glyphicon glyphicon-record active-glyph-record"
                  : "glyphicon glyphicon-record"
              }
              aria-hidden="true"
            />
          </li>
        </ul>
        <span className="pos-extended-menu">{this.renderExtendedMenu()}</span>
      </div>
    );
  }
}
