import React from "react";
export default class EditorBase extends React.Component {
  constructor(props) {
    super(props);
  }
  toggleEdit() {
    if (!this.props.editor) {
      return;
    }
    if (!this.state.edit) {
      this.props.updateEditState(
        {
          edit: true
        },
        this.props.position
      );
    }
    this.setState({ edit: !this.state.edit });
  }
  showComponentAction(evt) {
    if (!this.props.editor) {
      return;
    }
    this.setState({ shouldShowComponentAction: true });
  }
  hideComponentAction(evt) {
    if (!this.props.editor) {
      return;
    }
    this.setState({ shouldShowComponentAction: false });
  }
}
