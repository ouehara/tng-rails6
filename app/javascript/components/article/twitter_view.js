import React from "react";
import LoadScript from "../shared_components/load_script";
export default class TwitterView extends React.Component {
  constructor(props) {
    super(props);
    let ls = new LoadScript();
    ls.loadTwitter();
    this.state = { id: this.props.id };
  }

  componentDidMount() {
    setTimeout(() => {
      this.loadTweet();
    }, 20);
  }
  componentWillReceiveProps(nextProps) {
    if (nextProps.id != this.state.id) {
      this.setState({ id: nextProps.id }, () => this.loadTweet());
    }
  }
  loadTweet() {
    if (typeof twttr == "undefined") {
      setTimeout(() => {
        this.loadTweet();
      }, 150);
      return;
    }
    var id = this.state.id;
    var index = this.props.index;
    twttr.widgets
      .createTweet(id, document.getElementById(index), {
        align: "left"
      })
      .then(function(el) {});
  }
  render() {
    return (
      <div style={{ width: "100%", display: "flex" }} id={this.props.index} />
    );
  }
}
