import EditorBase from "./editor_base.es6";
import TwitterView from "../../components/article/twitter_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
import LoadScript from "../../components/shared_components/load_script";
export default class Twitter extends EditorBase {
  constructor(props) {
    super(props);
    let tweet = false;
    if (this.props.content != null) {
      tweet = this.props.content.tweet;
    }

    this.state = { searchResults: [], edit: this.props.edit, tweet: tweet };
  }
  componentWillReceiveProps(nextProps) {
    if (typeof nextProps.content != "undefined") {
      this.setState({ tweet: nextProps.content.tweet });
    }
  }
  setSearchType(type) {
    this.setState({ searchType: type });
  }
  componentWillMount() {
    let ls = new LoadScript();
    ls.loadTwitter();
  }
  search() {
    this.addTweet(this._search.value);
    /*let that = this;
    $.ajax({
      url: "/api/adapters/twitter/search.json?query=" + that._search.value,
      type: "GET",
    })
      .done(function (data) {
        that.setState({ searchResults: data });
      });*/
  }

  renderSearchResult() {
    return this.state.searchResults.map((d, i) => {
      return (
        <div className="col-xs-4" onClick={this.addTweet.bind(this, d.id_str)}>
          <TwitterView id={d.id_str} index={i} key={i} />
        </div>
      );
    });
  }

  addTweet(id) {
    this.setState({
      a: "av",
      tweet: id
    });
    this.props.updateState(
      {
        tweet: id
      },
      this.props.position
    );
    this.toggleEdit();
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden row" : "row"}>
          <div className="form-inline">
            <input
              ref={ref => (this._search = ref)}
              placeholder="twitter-id"
              className="form-control"
            />
            <button
              id="search-button"
              onClick={this.search.bind(this)}
              className="btn btn-primary"
            >
              Search
            </button>
          </div>
          {this.renderSearchResult()}
        </div>
        <div className="row remove-margin-right">
          {(() => {
            if (
              (typeof this.props.onComponentAction == "function" &&
                this.state.shouldShowComponentAction) ||
              this.state.edit
            ) {
              return (
                <ComponentMenu
                  isMarked={
                    typeof this.props.markedComponent[this.props.position] !=
                    "undefined"
                  }
                  onComponentAction={this.props.onComponentAction}
                  position={this.props.position}
                  renderExtendedMenu={this.props.renderComponents}
                  saveAction={
                    this.state.edit ? this.addTweet.bind(this) : false
                  }
                  cancelAction={
                    this.state.edit
                      ? () => {
                          this.toggleEdit.bind(this);
                          this.props.updateEditState(
                            {
                              edit: false
                            },
                            this.props.position
                          );
                        }
                      : false
                  }
                />
              );
            }
          })()}
        </div>
      </div>
    );
  }
  render() {
    return (
      <div
        style={{ width: "100%" }}
        onMouseOver={this.showComponentAction.bind(this)}
        onMouseLeave={this.hideComponentAction.bind(this)}
        className={
          this.props.className +
          (this.state.shouldShowComponentAction ? " highglight-el" : "")
        }
      >
        <div className={this.state.edit ? "hidden" : ""}>
          <div onClick={this.toggleEdit.bind(this)}>
            {!this.state.tweet ? (
              "click here to edit"
            ) : (
              <TwitterView
                id={this.state.tweet}
                index={"tweet-view-" + this.state.tweet}
              />
            )}
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
