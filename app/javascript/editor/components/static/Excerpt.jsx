import React from "react";
export default class Excerp extends React.Component {
  constructor(props) {
    super(props);
    this.state = { val: this.props.defaultValue };
  }
  componentWillReceiveProps(nextProps) {
    if (this.props.defaultValue != nextProps.defaultValue) {
      this.setState({ val: nextProps.defaultValue });
    }
  }
  handleChange(event) {
    let val = event.target.value;
    this.props.updateCurChar(val.length - this.state.val.length);
    this.setState({ val: val });
  }
  renderExcerp() {
    if (this.props.editor) {
      return (
        <textarea
          className="col-sm-12 form-group form-control editor-textarea"
          placeholder="Excerpt"
          id="excerp"
          value={this.state.val}
          onChange={this.handleChange.bind(this)}
        />
      );
    }
    return <p className="excerp">{this.state.val}</p>;
  }
  render() {
    return this.renderExcerp();
  }
}
