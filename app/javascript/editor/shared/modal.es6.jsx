import React from "react";
class Modal extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    if (!this.props.isOpen) {
      return <div />;
    }
    return (
      <div>
        <div
          className="modal fade in"
          tabIndex="-1"
          role="dialog"
          style={{ display: "block", paddingLeft: "0px" }}
        >
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <button
                  type="button"
                  onClick={() => this.props.onClose()}
                  className="close"
                  data-dismiss="modal"
                  aria-label="Close"
                >
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 className="modal-title">{this.props.title}</h4>
              </div>
              {this.props.children}
            </div>
          </div>
        </div>
      </div>
    );
  }
}
export default Modal;
/*
Modal.propTypes = {
  isOpen: React.PropTypes.bool,
  onClose: React.PropTypes.func,
  title: React.PropTypes.string,
}
Modal.defaultProps = {
  isOpen: false, 
};*/
