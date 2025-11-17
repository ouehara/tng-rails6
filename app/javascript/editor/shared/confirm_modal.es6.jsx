import React from "react";
export default class ConfirmModal extends React.Component {
  constructor(props) {
    super(props);
  }
  backdrop() {
    return <div className="modal-backdrop in" />;
  }

  modal() {
    var style = { display: "block" };
    return (
      <div
        className="modal in"
        tabIndex="-1"
        role="dialog"
        aria-hidden="false"
        style={style}
      >
        <div className="modal-dialog">
          <div className="modal-content">{this.props.children}</div>
        </div>
      </div>
    );
  }

  render() {
    return (
      <div>
        {this.backdrop()}
        {this.modal()}
      </div>
    );
  }
}
