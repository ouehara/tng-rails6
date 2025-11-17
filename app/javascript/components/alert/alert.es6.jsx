import React from "react";

class Alert extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    let classes = "alert " + this.props.classes;
    return <div className={classes}>{this.props.message}</div>;
  }
}
export default Alert;

/*
Alert.propTypes = {
  classes: React.PropTypes.string,
  message: React.PropTypes.string
}*/
