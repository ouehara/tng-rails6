import React from "react";
import HeaderDrawerItem from "./header_drawer_item.es6.jsx";

export default class HeaderDrawerTab extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_pc: this.props.isPc
    };
  }

  renderNavCol(data) {
    if (typeof data == "undefined") {
      return;
    }

    if (!Object.keys(data).length) return;
    return Object.keys(data).map((key, index) => {
      const col_name = `col_${index}`;
      const a = Array.isArray(data[key]) ? data[key] : [data[key]];
      return (
        <div className="nav_col--pc" data-col={col_name} key={index}>
          {this.renderNavItem(a)}
        </div>
      );
    });
  }

  renderNavItem(data) {
    if (!Object.keys(data).length) return;
    return Object.keys(data).map((key, index) => {
      return (
        <HeaderDrawerItem
          elements={data[key]}
          key={index}
          isPc={this.state.is_pc}
        />
      );
    });
  }

  render() {
    return (
      <div className="nav_tab" data-tab={this.props.elements.page_code}>
        <div className="nav_tab_inner container">
          {this.renderNavCol(this.props.elements.items)}
        </div>
      </div>
    );
  }
}
