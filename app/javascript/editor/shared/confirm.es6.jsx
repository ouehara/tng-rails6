import React from "react";
import ReactDOM from "react-dom";
import ConfirmModal from "./confirm_modal.es6";
class Confirm extends React.Component {
  constructor(props) {
    super(props);
  }
  abort() {
    return this.promise.reject();
  }

  confirm() {
    return this.promise.resolve();
  }
  componentDidMount() {
    this.promise = new $.Deferred();
    this.cfg.focus();
  }

  render() {
    var modalBody;
    if (this.props.description) {
      modalBody = <div className="modal-body">{this.props.description}</div>;
    }
    return (
      <ConfirmModal>
        <div className="modal-header">
          <h4 className="modal-title">{this.props.message}</h4>
        </div>
        {modalBody}
        <div className="modal-footer">
          <div className="text-right">
            <button
              role="abort"
              type="button"
              className="btn btn-default"
              onClick={this.abort.bind(this)}
            >
              {this.props.abortLabel}
            </button>

            <button
              role="confirm"
              type="button"
              className="btn btn-primary"
              ref={button => {
                this.cfg = button;
              }}
              onClick={this.confirm.bind(this)}
            >
              {this.props.confirmLabel}
            </button>
          </div>
        </div>
      </ConfirmModal>
    );
  }
}
Confirm.defaultProps = {
  confirmLabel: "OK",
  abortLabel: "Cancel"
};

var confirmation = function(message, options) {
  var cleanup, component, props, wrapper;
  if (options == null) {
    options = {};
  }
  props = $.extend(
    {
      message: message
    },
    options
  );
  wrapper = document.body.appendChild(document.createElement("div"));
  component = ReactDOM.render(<Confirm {...props} />, wrapper);
  cleanup = function() {
    ReactDOM.unmountComponentAtNode(wrapper);
    return setTimeout(function() {
      return wrapper.remove();
    });
  };
  return component.promise.always(cleanup).promise();
};
export default confirmation;
