import EditorBase from "./editor_base.es6";
import InformationView from "../../components/article/information_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
import I18n from "../../components/i18n/i18n";
export default class BasicInformation extends EditorBase {
  constructor(props) {
    super(props);
    let elements = {};
    if (this.props.content != null) {
      elements = this.props.content.elements;
    }
    this.state = { elements: elements, edit: this.props.edit };
  }
  componentWillReceiveProps(nextProps) {
    let elements = {};
    if (nextProps.content != null) {
      elements = nextProps.content.elements;
    }
    this.setState({ elements: elements, edit: nextProps.edit });
  }
  formElChange(type, ev) {
    let state = { ...this.state.elements };
    if (ev.target.value != "") {
      state[type] = ev.target.value;
    } else {
      delete state[type];
    }

    this.setState({ elements: state });
  }
  saveText() {
    this.props.updateState(
      {
        elements: this.state.elements
      },
      this.props.position
    );
    this.toggleEdit();
  }
  renderEditor() {
    if (!this.props.editor) return;
    let name = this.state.elements.hasOwnProperty("name")
      ? this.state.elements["name"]
      : "";
    let hours = this.state.elements.hasOwnProperty("hours")
      ? this.state.elements["hours"]
      : "";
    let closed = this.state.elements.hasOwnProperty("closed")
      ? this.state.elements["closed"]
      : "";
    let price = this.state.elements.hasOwnProperty("price")
      ? this.state.elements["price"]
      : "";
    let address = this.state.elements.hasOwnProperty("address")
      ? this.state.elements["address"]
      : "";
    let access = this.state.elements.hasOwnProperty("access")
      ? this.state.elements["access"]
      : "";
    let urlJa = this.state.elements.hasOwnProperty("url-ja")
      ? this.state.elements["url-ja"]
      : "";
    let urlEn = this.state.elements.hasOwnProperty("url-en")
      ? this.state.elements["url-en"]
      : "";
    let urlTh = this.state.elements.hasOwnProperty("url-th")
      ? this.state.elements["url-th"]
      : "";
    let urlZhHant = this.state.elements.hasOwnProperty("url-zh-hant")
      ? this.state.elements["url-zh-hant"]
      : "";
    let urlZhHans = this.state.elements.hasOwnProperty("url-zh-hans")
      ? this.state.elements["url-zh-hans"]
      : "";
    let urlVi = this.state.elements.hasOwnProperty("url-vi")
      ? this.state.elements["url-vi"]
      : "";
    let urlKo = this.state.elements.hasOwnProperty("url-ko")
      ? this.state.elements["url-ko"]
      : "";
    let urlId = this.state.elements.hasOwnProperty("url-id")
      ? this.state.elements["url-id"]
      : "";
    let others = this.state.elements.hasOwnProperty("others")
      ? this.state.elements["others"]
      : "";
    let checkin = this.state.elements.hasOwnProperty("checkin")
      ? this.state.elements["checkin"]
      : "";
    let checkout = this.state.elements.hasOwnProperty("checkout")
      ? this.state.elements["checkout"]
      : "";
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <form
          className={!this.state.edit ? "hidden" : "editor"}
        >
          <div className="form-group">
            <label htmlFor="basic-name">
              {I18n.t("basic-information.name")}
            </label>
            <textarea
              className="form-control"
              id="basic-name"
              onChange={this.formElChange.bind(this, "name")}
              defaultValue={name}
            />
          </div>
          <div className="form-group">
            <label htmlFor="basic-opening-hours">
              {I18n.t("basic-information.hours")}
            </label>
            <textarea
              className="form-control"
              id="basic-opening-hours"
              onChange={this.formElChange.bind(this, "hours")}
              defaultValue={hours}
            />
          </div>
          <div className="form-group">
            <label htmlFor="basic-closed-on">
              {I18n.t("basic-information.closed")}
            </label>
            <textarea
              className="form-control"
              id="basic-closed-on"
              onChange={this.formElChange.bind(this, "closed")}
              defaultValue={closed}
            />
          </div>
          <div className="form-group">
            <label htmlFor="check-in">
              {I18n.t("basic-information.checkin")}
            </label>
            <textarea
              className="form-control"
              id="check-in"
              onChange={this.formElChange.bind(this, "checkin")}
              defaultValue={checkin}
            />
          </div>
          <div className="form-group">
            <label htmlFor="check-out">
              {I18n.t("basic-information.checkout")}
            </label>
            <textarea
              className="form-control"
              id="check-in"
              onChange={this.formElChange.bind(this, "checkout")}
              defaultValue={checkout}
            />
          </div>
          <div className="form-group">
            <label htmlFor="basic-price">
              {I18n.t("basic-information.price")}
            </label>
            <textarea
              className="form-control"
              id="basic-price"
              onChange={this.formElChange.bind(this, "price")}
              defaultValue={price}
            />
          </div>
          <div className="form-group">
            <label htmlFor="basic-address">
              {I18n.t("basic-information.address")}
            </label>
            <textarea
              className="form-control"
              id="basic-address"
              onChange={this.formElChange.bind(this, "address")}
              defaultValue={address}
            />
          </div>
          <div className="form-access">
            <label htmlFor="basic-access">
              {I18n.t("basic-information.access")}
            </label>
            <textarea
              className="form-control"
              id="basic-access"
              onChange={this.formElChange.bind(this, "access")}
              defaultValue={access}
            />
          </div>
          <div className="form-url">
            <label htmlFor="basic-url">
              {I18n.t("basic-information.url-ja")}
            </label>
            <input
              type="text"
              className="form-control"
              id="basic-url"
              onChange={this.formElChange.bind(this, "url-ja")}
              defaultValue={urlJa}
            />
          </div>
          <div className="form-url">
            <label htmlFor="basic-url-en">
              {I18n.t("basic-information.url-en")}
            </label>
            <input
              type="text"
              className="form-control"
              id="basic-url-en"
              onChange={this.formElChange.bind(this, "url-en")}
              defaultValue={urlEn}
            />
          </div>
          <div className="form-url">
            <label for="basic-url-th">
              {I18n.t("basic-information.url-th")}
            </label>
            <input
              type="text"
              className="form-control"
              id="basic-url-th"
              onChange={this.formElChange.bind(this, "url-th")}
              defaultValue={urlTh}
            />
          </div>
          <div className="form-zh-hant">
            <label htmlFor="basic-url-zh-hant">
              {I18n.t("basic-information.url-zh-hant")}
            </label>
            <input
              type="text"
              className="form-control"
              id="basic-url-zh-hant"
              onChange={this.formElChange.bind(this, "url-zh-hant")}
              defaultValue={urlZhHant}
            />
          </div>
          <div className="form-zh-hans">
            <label htmlFor="basic-url-zh-hans">
              {I18n.t("basic-information.url-zh-hans")}
            </label>
            <input
              type="text"
              className="form-control"
              id="basic-url-zh-hans"
              onChange={this.formElChange.bind(this, "url-zh-hans")}
              defaultValue={urlZhHans}
            />
          </div>
          <div className="form-vi">
            <label htmlFor="basic-url-vi">
              {I18n.t("basic-information.url-vi")}
            </label>
            <input
              type="text"
              className="form-control"
              id="basic-url-vi"
              onChange={this.formElChange.bind(this, "url-vi")}
              defaultValue={urlVi}
            />
          </div>
          <div className="form-ko">
            <label htmlFor="basic-url-ko">
              {I18n.t("basic-information.url-ko")}
            </label>
            <input
              type="text"
              className="form-control"
              id="basic-url-ko"
              onChange={this.formElChange.bind(this, "url-ko")}
              defaultValue={urlKo}
            />
          </div>
          <div className="form-id">
            <label htmlFor="basic-url-id">
              {I18n.t("basic-information.url-id")}
            </label>
            <input
              type="text"
              className="form-control"
              id="basic-url-id"
              onChange={this.formElChange.bind(this, "url-id")}
              defaultValue={urlId}
            />
          </div>
          <div className="form-others">
            <label htmlFor="basic-address">
              {I18n.t("basic-information.others")}
            </label>
            <textarea
              id="basic-address"
              className="form-control"
              onChange={this.formElChange.bind(this, "others")}
              defaultValue={others}
            />
          </div>
        </form>
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
            {
              <InformationView
                locale={I18n.current}
                elements={this.state.elements}
              />
            }
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
