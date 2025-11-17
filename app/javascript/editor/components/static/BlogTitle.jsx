import React from "react";

export default class BlogTitle extends React.Component {
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
    let length = 0;
    if (this.state.val != null && typeof this.state.val != "undefined") {
      length = this.state.val.length;
    }
    this.props.updateCurChar(val.length - length);
    this.setState({ val: val });
  }
  renderTitle() {
    if (this.props.editor) {
      return (
        <input
          type="text"
          className="col-sm-12 form-group form-control"
          placeholder="Title"
          id="title"
          value={this.state.val}
          onChange={this.handleChange.bind(this)}
        />
      );
    }
    return <h1 className="article-title">{this.state.val}</h1>;
  }
  render() {
    return this.renderTitle();
  }
}
