import EditorBase from "./editor_base.es6";
import VideoView from "../../components/article/video_view";
import VideoSearchResult from "./VideoSearchResult";
import LoadScript from "../../components/shared_components/load_script";
import ComponentMenu from "./component_menu.es6";
import React from "react";
let btnText = {
  url: "Embed",
  yt: "search",
  vimeo: "search"
};
let placeholderText = {
  url: "paste url",
  yt: "search term",
  vimeo: "search term"
};
export default class Video extends EditorBase {
  constructor(props) {
    super(props);
    let video = false;
    let searchType = "url";
    if (this.props.content != null) {
      video = this.props.content.video;
      searchType = this.props.content.videoType;
    }

    this.state = {
      searchResults: [],
      edit: this.props.edit,
      video: video,
      searchType: searchType
    };
  }
  componentWillReceiveProps(nextProps) {
    let video = false;
    let searchType = "url";
    if (nextProps.content != null) {
      video = nextProps.content.video;
      searchType = nextProps.content.videoType;
    }

    this.setState({
      searchResults: [],
      edit: nextProps.edit,
      video: video,
      searchType: searchType
    });
  }
  setSearchType(type) {
    this.setState({ searchType: type, searchResults: [] });
  }
  componentWillMount() {
    let ls = new LoadScript();
    ls.loadGapi();
    ls.setVimoeAccessToken(accessToken => {
      this.setState({ vimeoAccessToken: accessToken });
    });
  }
  handleAPILoaded() {
    $("#search-button").attr("disabled", false);
  }
  search() {
    switch (this.state.searchType) {
      case "url":
        this.setState({ video: this.getByUrl(this._videoUrl.value) });
        this.toggleEdit();
        break;
      case "yt":
        this.searchYt();
        break;
      case "vimeo":
        this.searchVimeo();
        break;
    }
  }
  getByUrl(url) {
    var regExp = /^.*(youtu\.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    var match = url.match(regExp);
    if (match && match[2].length == 11) {
      return "//www.youtube.com/embed/" + match[2];
    }
    var vimeoRegex = /(?:vimeo)\.com.*(?:videos|video|channels|)\/([\d]+)/i;
    var parsed = url.match(vimeoRegex);
    return "//player.vimeo.com/video/" + parsed[1];
  }
  searchYt() {
    var q = this._videoUrl.value;
    var request = gapi.client.youtube.search.list({
      q: q,
      part: "snippet",
      maxResults: 50
    });

    request.execute(
      function(response) {
        var str = JSON.stringify(response.result);
        this.setState({ searchResults: response.result });
      }.bind(this)
    );
  }
  searchVimeo() {
    var q = this._videoUrl.value;
    var that = this;
    $.ajax({
      url: "https://api.vimeo.com/videos",
      headers: {
        Authorization: "Bearer " + that.state.vimeoAccessToken
      },
      data: { query: q },
      success: function(data) {
        that.setState({ searchResults: { items: data.data } });
      }
    });
  }
  renderSearchResult() {
    if (this.state.searchResults.length == 0) {
      return;
    }
    return this.state.searchResults.items.map((result, i) => {
      let img, desc, id;
      if (this.state.searchType === "yt") {
        img = result.snippet.thumbnails.medium.url;
        desc = result.snippet.title;
        id = result.id.videoId;
      } else {
        img = result.pictures.sizes[1].link;
        desc = result.description;
        id = result.uri;
      }
      return (
        <div onClick={this.addVideo.bind(this, id)} key={i}>
          <VideoSearchResult img={img} desc={desc} />
        </div>
      );
    });
  }

  addVideo(videoId) {
    this.setState({
      video: videoId,
      videoType: this.state.searchType
    });
    this.props.updateState(
      {
        video: videoId,
        videoType: this.state.searchType
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
          <div className="col-sm-3">
            Select search type (currently: {this.state.searchType})
            <ul className="search-type-menu">
              <li onClick={this.setSearchType.bind(this, "url")}>
                <img
                  src="/assets/url.png"
                  className="padding-left"
                  height="60"
                />
              </li>
              <li onClick={this.setSearchType.bind(this, "yt")}>
                <img src="/assets/youtube-logo.png" height="60" />
              </li>
              <li onClick={this.setSearchType.bind(this, "vimeo")}>
                <img src="/assets/vimeo.png" height="60" />
              </li>
            </ul>
          </div>
          <div className="col-sm-9">
            <div className="form-inline">
              <input
                ref={ref => (this._videoUrl = ref)}
                placeholder={placeholderText[this.state.searchType]}
                className="form-control"
              />
              <button
                id="search-button"
                onClick={this.search.bind(this)}
                className="btn btn-primary"
              >
                {btnText[this.state.searchType]}
              </button>
            </div>
            {this.renderSearchResult()}
          </div>
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
                  saveAction={
                    this.state.edit ? this.addVideo.bind(this) : false
                  }
                  renderExtendedMenu={this.props.renderComponents}
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
        onMouseOver={this.showComponentAction.bind(this)}
        onMouseLeave={this.hideComponentAction.bind(this)}
        className={
          this.props.className +
          (this.state.shouldShowComponentAction ? " highglight-el" : "")
        }
      >
        <div className={this.state.edit ? "hidden" : ""}>
          <div onClick={this.toggleEdit.bind(this)}>
            {!this.state.video ? (
              "click here to edit"
            ) : (
              <VideoView
                video={this.state.video}
                videoType={this.state.searchType}
              />
            )}
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
