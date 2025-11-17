import React from "react";
import AdList from "../ads/ad_list_view";

export default class SidebarAds extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_pc: window.matchMedia("(min-width: 768px)").matches
    };
  }

  componentDidMount() {
    window.addEventListener("scroll", this.handleScroll);
    window.addEventListener("resize", () => {
      this.updateState();
    });
    setTimeout(() => {
      this.updateState();
    }, 2000);
  }

  componentWillUnmount() {
    window.removeEventListener("scroll", this.handleScroll);
    window.removeEventListener("resize", () => {
      this.updateState();
    });
  }

  updateState() {
    this.setState({
      is_pc: window.matchMedia("(min-width: 768px)").matches
    });
  }

  render() {
    return (
      <div className="sidebar_advertisement">
        <AdList
          elements={this.props.elements}
          type="sidebar"
          isPc={this.state.is_pc}
        />
      </div>
    );
  }
}
