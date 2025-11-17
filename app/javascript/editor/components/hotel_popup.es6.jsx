import EditorBase from "./editor_base.es6";
import React from "react";
export default class HotelPopup extends EditorBase {
  constructor(props) {
    super(props);
    this.state = {
      text: "",
      service: 3,
      freeForm: "",
      showErrorFreeForm: false,
      showErrorUrl: false
    };
  }
  save() {
    let details;
    if (!this.validateUrl()) {
      return;
    }
    if (this.state.service != -1) {
      details = { url: this.state.text, service: this.state.service };
    } else {
      if (!this.checkFreeform()) {
        return;
      }
      details = { url: this.state.text, service: this.state.freeForm };
    }

    this.props.addAffiliate(details, { hotel: { name: this.props.hotelName } });
    this.props.closeModal();
  }
  validateUrl() {
    if (this.state.text.trim() == "") {
      this.setState({ showErrorUrl: true });
      return false;
    }
    return true;
  }
  checkFreeform() {
    if (this.state.freeForm.trim() == "") {
      this.setState({ showErrorFreeForm: true });
      return false;
    }
    return true;
  }
  handleChange(event) {
    this.setState({ text: event.target.value });
  }
  handleChangeSelect(event) {
    this.setState({ service: event.target.value, freeForm: "" });
  }
  handleChangeFreeform(event) {
    this.setState({ freeForm: event.target.value });
  }
  renderFreeform() {
    if (this.state.service != -1) {
      return;
    }

    return (
      <div className="form-group">
        {this.state.showErrorFreeForm ? (
          <span className="badge badge-pill badge-danger">
            must not be empty
          </span>
        ) : (
          ""
        )}
        <input
          className="form-control"
          onChange={this.handleChangeFreeform.bind(this)}
          type="text"
          name="free text"
          placeholder="button text"
        />
      </div>
    );
  }
  render() {
    return (
      <div
        className="modal fade in bs-example-modal-sm modal-block"
        tabindex="-1"
        role="dialog"
      >
        <div className="modal-dialog" role="document">
          <div className="modal-content">
            <div className="modal-header">
              <button
                type="button"
                className="close"
                data-dismiss="modal"
                aria-label="Close"
                onClick={this.props.closeModal}
              >
                <span aria-hidden="true">&times;</span>
              </button>
              <h4 className="modal-title">{this.props.hotelName}</h4>
            </div>
            <div className="modal-body">
              <div className="form-group">
                {this.state.showErrorUrl ? (
                  <span className="badge badge-pill badge-danger">
                    must not be empty
                  </span>
                ) : (
                  ""
                )}
                <input
                  className="form-control"
                  onChange={this.handleChange.bind(this)}
                  type="text"
                  name="url"
                  placeholder="affiliate url"
                />
              </div>
              {this.renderFreeform()}
              <div class="form-group">
                <label for="exampleSelect1">Service</label>
                <select
                  className="form-control"
                  onChange={this.handleChangeSelect.bind(this)}
                >
                  <option value="3">Relux</option>
                  <option value="-1">free text</option>
                </select>
              </div>
            </div>
            <div className="modal-footer">
              <button
                type="button"
                className="btn btn-default"
                data-dismiss="modal"
                onClick={this.props.closeModal}
              >
                Close
              </button>
              <button
                type="button"
                className="btn btn-primary"
                onClick={this.save.bind(this)}
              >
                Save changes
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
