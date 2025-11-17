import React from "react";
import HeaderDrawerTab from "./header_drawer_tab.es6.jsx";

export default class HeaderNavItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_open: false, //default
      is_pc: this.props.isPc
    };
  }

  render() {
    return (
      <li className="navbar_item" data-category={this.props.data.page_code}>
        <a
          className="navbar_link"
          data-category={this.props.data.page_code}
          href={this.props.data.index.url}
          id={this.props.data.index.id}
        >
          <span>{this.props.data.page_name}</span>
        </a>
        <HeaderDrawerTab elements={this.props.data} isPc={this.state.is_pc} />
      </li>
    );
  }
}
