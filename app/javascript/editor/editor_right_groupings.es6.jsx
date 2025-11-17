import React from "react";

export default class EditorRightGroupings extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selected: this.props.selected,
      groups: [],
      showArea: false,
      page: 1,
      maxPage: 1,
      curElements: [],
      allElements: []
    };
    this.getRelatedGroups();
    //this.state = { showArea: false, areas: this.props.areas, page: 1, maxPage: Math.floor(this.props.areas.length / 20), curElements: [], selected: this.props.articleArea }
  }
  getRelatedGroups() {
    $.ajax({
      url: "/api/adapters/related_group/list/"
    }).done(data => {
      this.setState(
        {
          curElements: [],
          allElements: data,
          groups: data,
          maxPage: Math.floor(data.length / 20)
        },
        () => {
          this.renderOptions();
        }
      );
    });
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
    this.props.changed(id, this.props.pos);

    this.setState(
      {
        selected: id,
        page: 1,
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
            page: 1,
            groups: this.state.allElements,
            curElements: []
          },
          this.renderOptions.bind(this)
        );
        return;
      }
      var searched = this.state.allElements.filter(s => {
        return s[0].toLowerCase().match(re);
      });
      this.setState(
        {
          groups: searched,
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

    ret = this.state.groups.map(el => {
      return (
        <li key={el[1]} onClick={this.selectElement.bind(this, el[1])}>
          {el[0]}
        </li>
      );
    });

    this.setState({ curElements: ret });
  }
  getSelectedName() {
    if (this.state.selected == 0) {
      return "Please select";
    }
    if (this.state.allElements.length <= 0) {
      return "Please select";
    }
    let el = this.state.allElements.filter(a => a[1] == this.state.selected);
    return el[0][0];
  }
  renderLayout() {}
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
          {this.getSelectedName()}
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
