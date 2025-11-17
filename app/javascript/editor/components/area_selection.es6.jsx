import React from "react";
export default class AreaSelection extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      showArea: false,
      areas: this.props.areas,
      page: 1,
      maxPage: Math.floor(this.props.areas.length / 20),
      curElements: [],
      selected: this.props.articleArea
    };
  }
  componentDidMount() {
    this._areaSelection.addEventListener("scroll", event => {
      var element = event.target;
      if (element.scrollHeight - element.scrollTop === element.clientHeight) {
        this.setState(
          { page: this.state.page + 1 },
          this.renderOptions.bind(this)
        );
      }
    });
    this.renderOptions();
  }
  selectElement(id) {
    this.toggleArea();
    if (this.props.type == "articleCategory") {
      this.props.onChange(this.state.areas[id]);
    } else {
      this.props.onChange(this.props.type, this.state.areas[id]);
    }
    this.setState(
      {
        selected: this.state.areas[id],
        areas: this.props.areas,
        page: 1,
        maxPage: Math.floor(this.props.areas.length / 20),
        curElements: []
      },
      this.renderOptions.bind(this)
    );
  }
  onSearch(term) {
    if (this.timer) {
      clearTimeout(this.timer);
    }
    this.timer = setTimeout(() => {
      let val = this._search.value.toLowerCase().trim();
      var re = new RegExp(val, "g");
      if (val == "") {
        this.setState(
          {
            areas: this.props.areas,
            page: 1,
            maxPage: Math.floor(this.props.areas.length / 20),
            curElements: []
          },
          this.renderOptions.bind(this)
        );
        return;
      }
      var searched = this.props.areas.filter(s => {
        return s[this.props.nameEl].toLowerCase().match(re);
      });
      this.setState(
        {
          areas: searched,
          page: 1,
          maxPage: Math.floor(searched.lenth / 20),
          curElements: []
        },
        this.renderOptions.bind(this)
      );
    }, 200);
  }
  toggleArea() {
    this.setState({ showArea: !this.state.showArea });
    this._areaSelection.scrollTop = 0;
  }
  renderOptions() {
    let ret = [];
    for (let i = (this.state.page - 1) * 20; i < this.state.page * 20; i++) {
      let className = "headline";
      let prefix = "";
      let padding = 5;
      if (typeof this.state.areas[i] == "undefined") {
        break;
      }
      if (
        this.state.areas[i].ancestry != null &&
        this.state.areas[i].ancestry != this.state.areas[i].id &&
        this.state.areas[i].ancestry.indexOf("/") == -1
      ) {
        className = "sub-headline";
      } else if (
        this.state.areas[i].ancestry != null &&
        this.state.areas[i].ancestry.indexOf("/") != -1
      ) {
        className = "final";
        padding = 10 * (this.state.areas[i].ancestry.match(/\//g) || []).length;
      }
      if (
        this.state.selected != null &&
        typeof this.state.selected.id != "undefined" &&
        this.state.areas[i].id == this.state.selected.id
      ) {
        prefix = <span className="glyphicon glyphicon-ok" />;
      }
      ret.push(
        <li
          key={i}
          style={{ paddingLeft: padding + "px" }}
          className={className}
          onClick={this.selectElement.bind(this, i)}
        >
          {prefix} {this.state.areas[i][[this.props.nameEl]]}
        </li>
      );
    }

    let newState = this.state.curElements.concat(ret);
    this.setState({ curElements: newState });
  }
  render() {
    let classes = this.state.showArea
      ? "area-selection open"
      : "area-selection";
    return (
      <ul
        className={classes}
        ref={ref => {
          this._areaSelection = ref;
        }}
      >
        <li className="selected" onClick={this.toggleArea.bind(this)}>
          {this.state.selected != null
            ? this.state.selected[this.props.nameEl]
            : "please select"}
        </li>
        <li>
          <input
            type="text"
            onChange={this.onSearch.bind(this)}
            className="search-list"
            defaultValue=""
            placeholder="Search"
            ref={ref => {
              this._search = ref;
            }}
          />
        </li>
        {this.state.curElements}
      </ul>
    );
  }
}
