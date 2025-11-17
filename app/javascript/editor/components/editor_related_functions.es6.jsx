import EditorBase from "./editor_base.es6";
import React from "react";
import I18n from "../../components/i18n/i18n";
export default class EditorRelatedFunctions extends EditorBase {
  constructor(props) {
    super(props);
    let elements = {};
    if (this.props.content != null) {
      elements = this.props.content.elements;
    }
    this.state = {
      elements: elements,
      edit: this.props.edit,
      shouldShowSearchPopup: false,
      searchTerm: "",
      searchResult: [],
      concept: "Text",
      target: "/search/",
      filterCatText: "in category",
      categoryFilter: 0
    };
  }
  componentWillReceiveProps(nextProps) {
    let elements = {};
    if (nextProps.content != null) {
      elements = nextProps.content.elements;
    }
    this.setState({
      elements: elements,
      edit: nextProps.edit,
      shouldShowSearchPopup: false,
      searchTerm: "",
      searchResult: [],
      concept: "Text",
      target: "/search/",
      filterCatText: "in category",
      categoryFilter: 0
    });
  }
  formElChange(type, ev) {
    let state = { ...this.state.elements };
    if (ev.target.value != "") {
      state[type] = ev.target.value;
    } else {
      delete state[type];
    }

    this.setState({ elements: state });
  }
  saveText() {
    this.props.updateState(
      {
        elements: this.state.elements
      },
      this.props.position
    );
    this.toggleEdit();
  }
  toggleSearchPopup() {
    this.setState({ shouldShowSearchPopup: !this.state.shouldShowSearchPopup });
  }
  setSearchTerm(evt) {
    this.setState({ searchTerm: evt.target.value });
  }
  setStateCb() {}
  search(evt) {
    evt.preventDefault();
    let searchData =
      this.state.categoryFilter != 0
        ? { category: this.state.categoryFilter }
        : "";
    $.ajax({
      url:
        "/" +
        I18n.current +
        this.state.target +
        this.state.searchTerm +
        ".json",
      data: searchData
    }).done(result => {
      this.setState({ searchResult: result });
    });
  }
  selectedArticle(result, evt) {
    let id = evt.target.value;
    let el = { ...this.state.elements };
    if (evt.target.checked) {
      el[result.id] = {
        id: result.id,
        slug: result.slug,
        medium_url: result.medium_url,
        disp_title: result.disp_title,
        excerpt: result.excerpt
      };
    } else {
      delete el[result.id];
    }
    this.setState({ elements: el }, () => {
      this.setStateCb();
    });
  }
  removeElement(id, evt) {
    let el = { ...this.state.elements };
    delete el[id];
    this.setState({ elements: el }, () => {
      this.setStateCb();
    });
  }
  setSearchType(evt) {
    evt.preventDefault();
    let path = evt.target.href;
    let concept = evt.target.text;
    this.setState({ target: path, concept: concept });
  }
  setFilterCategory(evt) {
    let catId = evt.target.getAttribute("data-id");
    let text = evt.target.getAttribute("data-lable");
    this.setState({ filterCatText: "in " + text, categoryFilter: catId });
  }
  renderEditResult() {
    return Object.keys(this.state.elements).map((key, index) => {
      return (
        <div className="well">
          <div className="row">
            <div className="col-xs-4">
              <img
                className="img-preview img-responsive"
                src={this.state.elements[key].medium_url}
              />
            </div>
            <div className="col-xs-7">
              <h3>{this.state.elements[key].title}</h3>
              <p>{this.state.elements[key].excerpt}</p>
            </div>
            <button
              type="button"
              className="close"
              onClick={this.removeElement.bind(
                this,
                this.state.elements[key].id
              )}
            >
              &times;
            </button>
          </div>
        </div>
      );
    });
  }
  renderSearchResult() {
    if (!this.state.searchResult.length) return;
    var i = 0;
    return this.state.searchResult.map(result => {
      var check = this.state.elements.hasOwnProperty(result.id) ? true : false;
      i++;
      return (
        <li key={i}>
          <input
            type="checkbox"
            onChange={this.selectedArticle.bind(this, result)}
            name="article"
            value={result.id}
            id={"checkbox" + result.id}
            className="styled-checkbox"
            checked={check}
          />
          <label htmlFor={"checkbox" + result.id}>{result.title}</label>
        </li>
      );
    });
  }
  renderSearchPopUp() {
    if (!this.state.shouldShowSearchPopup) {
      return;
    }
    return (
      <div
        id="rel-article-modal"
        className="modal fade in"
        role="dialog"
        style={{ display: "block" }}
      >
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <button
                type="button"
                className="close"
                data-dismiss="modal"
                onClick={this.toggleSearchPopup.bind(this)}
              >
                &times;
              </button>
              <div id="custom-search-input" className="col-md-10">
                <form onSubmit={this.search.bind(this)}>
                  <div className="input-group col-md-12">
                    <div className="input-group-btn search-panel">
                      <button
                        type="button"
                        className="btn btn-default dropdown-toggle"
                        data-toggle="dropdown"
                      >
                        <span id="search_concept">
                          Filter by {this.state.concept}
                        </span>{" "}
                        <span className="caret" />
                      </button>
                      <ul className="dropdown-menu" role="menu">
                        <li>
                          <a
                            href="/search/"
                            onClick={this.setSearchType.bind(this)}
                          >
                            Text
                          </a>
                        </li>
                        <li>
                          <a
                            href="/tag/"
                            onClick={this.setSearchType.bind(this)}
                          >
                            Tag
                          </a>
                        </li>
                      </ul>
                    </div>
                    <input
                      type="text"
                      className="form-control input-lg"
                      placeholder="Search"
                      onChange={this.setSearchTerm.bind(this)}
                    />
                    <div className="input-group-btn search-panel">
                      <button
                        type="button"
                        className="btn btn-default dropdown-toggle"
                        data-toggle="dropdown"
                      >
                        <span id="search_concept">
                          {this.state.filterCatText}
                        </span>{" "}
                        <span className="caret" />
                      </button>
                      <ul className="dropdown-menu" role="menu">
                        <li
                          data-id="0"
                          data-lable="category"
                          onClick={this.setFilterCategory.bind(this)}
                        >
                          Deselect
                        </li>
                        {this.props.category.map(cat => {
                          return (
                            <li
                              data-id={cat.id}
                              data-lable={cat.name}
                              key={cat.id}
                              onClick={this.setFilterCategory.bind(this)}
                            >
                              {cat.name}
                            </li>
                          );
                        })}
                      </ul>
                    </div>
                    <span className="input-group-btn">
                      <button
                        className="btn btn-info btn-lg"
                        type="button"
                        onClick={this.search.bind(this)}
                      >
                        <i className="glyphicon glyphicon-search" />
                      </button>
                    </span>
                  </div>
                </form>
              </div>
            </div>
            <div className="modal-body">
              <ul className="unstyled-ul modal-list">
                {this.renderSearchResult()}
              </ul>
            </div>
            <div className="modal-footer">
              <button
                type="button"
                className="btn btn-default"
                data-dismiss="modal"
                onClick={this.toggleSearchPopup.bind(this)}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
