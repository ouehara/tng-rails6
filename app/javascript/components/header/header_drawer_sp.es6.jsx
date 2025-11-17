import React from "react";

export default class HeaderDrawerSp extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_open: false, //default
      has_sub_pages: !!this.props.elements.items[0],
      is_pc: this.props.isPc,
    };

    this.handleClickedTitle = this.handleClickedTitle.bind(this);
  }

  handleClickedTitle(e) {
    if (!this.state.has_sub_pages || this.state.is_pc) return;

    e.preventDefault();
    const toggle_open = !this.state.is_open;
    this.setState({ is_open: toggle_open });
  }

  renderTitleElement(is_link, data) {
    if (is_link) {
      return (
        <a
          href={data.url}
          className="nav_item_title"
          id={data.id}
          onClick={this.handleClickedTitle}
        >
          <span className="nav-text">{data.page_name}</span>
        </a>
      );
    } else {
      return (
        <div className="nav_item_title" onClick={this.handleClickedTitle}>
          <span className="nav-text">{data.page_name}</span>
        </div>
      );
    }
  }

  renderSubNavIndex() {
    if (this.state.is_pc) return;
    return (
      <li className="sub_nav_item sub_nav_item--index">
        <a
          href={this.props.elements.index.url}
          id={this.props.elements.index.id}
        >
          {this.props.elements.page_name}&nbsp;top
        </a>
      </li>
    );
  }

  renderSubNav() {
    if (!this.state.has_sub_pages) return;
    return (
      <ul className="sub_nav">
        {this.renderSubNavIndex()}
        {this.renderSubList(this.props.elements.items)}
      </ul>
    );
  }

  renderSubList(data) {
    if (!Object.keys(data).length) return;
    return Object.keys(data).map((key, index) => {
      const the_item = Array.isArray(data[key]) ? data[key] : [data[key]];
      if (this.state.is_pc) {
        return (
          <li className="sub_nav_item" key={index}>
            <a href={the_item.index.url} id={the_item.id}>
              {the_item.page_name}
            </a>
          </li>
        );
      } else {
        return Object.keys(the_item).map((key_2, index_2) => {
          return (
            <li className="sub_nav_item" key={index_2}>
              <a href={the_item[key_2].index.url} id={the_item[key_2].id}>
                {the_item[key_2].page_name}
              </a>
            </li>
          );
        });
      }
    });
  }

  render() {
    const has_index_link = this.props.elements.url;
    let nav_item_classes =
      this.state.has_sub_pages && !this.state.is_pc
        ? "nav_item sp_accordion"
        : "nav_item";
    if (this.state.is_open) {
      nav_item_classes += " open";
    }
    return (
      <div className={nav_item_classes}>
        {this.renderTitleElement(has_index_link, this.props.elements)}
        {this.renderSubNav()}
      </div>
    );
  }
}
