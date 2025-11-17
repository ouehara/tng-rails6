import React from "react";
import MediumEditor from "../medium-editor";

export default class UploadImage extends React.Component {
  constructor(props) {
    super(props);

    let url = "";
    let source = "";
    let ad = false;
    let img = this.props.image;
    let grid = 1;
    let label = "";
    let category = "";
    let alt = "";
    let boxLink = "";
    if (
      typeof this.props.src != "undefined" &&
      typeof this.props.src.text != "undefined"
    ) {
      url = this.props.src.url;
      source = this.props.src.text;
      ad = this.props.ad;
      grid = this.props.grid;
      label = this.props.analyticsLabel;
      category = this.props.analyticsCategory;
      alt = this.props.alt;
      boxLink = this.props.boxLink;
    }
    this.state = {
      editor: null,
      analyticsLabel: label,
      analyticsCategory: category,
      adlayout: ad,
      showTabContent: 1,
      curPage: 1,
      total: 1,
      error: "",
      results: [],
      sourceUrl: url,
      source: source,
      changed: false,
      image: img,
      savorAdType: 0,
      grid: grid,
      boxLink,
      alt,
      savorAdType: this.props.savorAdType,
    };
  }
  componentDidUpdate() {
    if (this.state.editor == null && this.state.adlayout) {
      const editor = new MediumEditor(".editable", {
        toolbar: {
          buttons: ["bold", "italic", "underline", "anchor"],
        },
        anchor: {
          /* These are the default options for anchor form,
             if nothing is passed this is what it used */
          customClassOption: "btn btn-ads",

          linkValidation: false,
          placeholderText: "Paste or type a link",
          targetCheckbox: false,
          targetCheckboxText: "Open in new window",
        },
      });
      editor.setContent(this.state.source);
      this.setState({ editor: editor });
    }
  }
  componentWillReceiveProps(nextProps) {
    let url = "";
    let source = "";
    let img = nextProps.image;
    let grid = 1;
    let ad = false;
    let label = "";
    let category = "";
    if (
      typeof nextProps.src != "undefined" &&
      typeof nextProps.src.text != "undefined"
    ) {
      url = nextProps.src.url;
      source = nextProps.src.text;
      grid = nextProps.grid;
      ad = this.props.ad;
      label = this.props.analyticsLabel;
      category = this.props.analyticsCategory;
    }

    if (!nextProps.edit) {
      this.setState(
        {
          sourceUrl: url,
          source: source,
          grid: grid,
          adlayout: ad,
          changed: false,
          image: img,
          analyticsLabel: label,
          analyticsCategory: category,
          savorAdType: nextProps.savorAdType,
        },
        () => {
          if (this.state.editor != null && this.state.adlayout) {
            this.state.editor.setContent(this.state.source);
          }
        }
      );
    }
  }
  fileChanged(evt) {
    let fd = new FormData();
    let fileSizeMb = evt.target.files[0].size / 1024 / 1024;
    this.setState({ error: "" });
    if (fileSizeMb > 2) {
      this.setState({ error: "File is bigger than 2MB" });
      return;
    }
    fd.append("img", evt.target.files[0]);
    $.ajax({
      url: "/image.json",
      type: "POST",
      data: fd,
      processData: false,
      contentType: false,
      beforeSend: () => { },
    })
      .done((result) => {
        this.setState({ error: "" });
        this.props.addImage(
          result["original_url"],
          {
            alt: this.state.alt,
            contentUrl: result["original_url"],
            sourceText: this.state.source,
            srcurl: this.state.sourceUrl,
            grid: this.state.grid,
            analyticsCategory: this.state.analyticsCategory,
            analyticsLabel: this.state.analyticsLabel,
            boxLink: this.state.boxLink,
          },
          null,
          this.state.adlayout,
          this.state.savorAdType
        );
      })
      .fail((error) => {
        console.log(error);
        if (error.status == 409) {
          console.log(error);
        }
      });
  }
  setShowTabContent(content, evt) {
    evt.preventDefault();
    this.setState({ showTabContent: content });
    return false;
  }
  loadResults(page) {
    $.ajax({
      url: "/image.json",
      type: "GET",
      data: { page: page },
    })
      .done((result) => {
        this.setState({
          results: JSON.parse(result["img"]),
          curPage: result["current"],
          total: result["total"],
        });
      })
      .fail((error) => {
        if (error.status == 409) {
          console.log(error);
        }
      });
  }
  update() {
    this.props.addImage(
      this.state.image,
      {
        alt: this.state.alt,
        contentUrl: this.state.image,
        sourceText: this.state.source,
        srcurl: this.state.sourceUrl,
        grid: this.state.grid,
        analyticsCategory: this.state.analyticsCategory,
        analyticsLabel: this.state.analyticsLabel,
        boxLink: this.state.boxLink,
      },
      null,
      this.state.adlayout,
      this.state.savorAdType
    );
  }
  renderTabContent() {
    switch (this.state.showTabContent) {
      case 1:
        return this.renderUpload();
      case 2:
        if (!this.state.results.length) {
          this.loadResults(1);
        }
        return (
          <div className="thumbnailList">
            {this.renderList()}
            <div className="clear" />
            <ul className="pagination pagination-sm">{this.renderPage()}</ul>
          </div>
        );
    }
  }
  renderUpload() {
    return (
      <div>
        {this.state.error != "" ? (
          <p className="alert alert-danger">{this.state.error}</p>
        ) : (
          ""
        )}
        <input type="file" onChange={this.fileChanged.bind(this)} />
      </div>
    );
  }
  renderPage() {
    if (this.state.results.length == 0 || this.state.total == 0) {
      return;
    }
    var html = [];
    if (this.state.curPage > 1) {
      html.push(
        <li>
          <a onClick={this.loadResults.bind(this, this.state.curPage - 1)}>
            {this.state.curPage - 1}
          </a>
        </li>
      );
    }
    for (var i = this.state.curPage; i <= this.state.total; i++) {
      if (i == this.state.curPage) {
        html.push(
          <li className="active">
            <a onClick={this.loadResults.bind(this, i)}>{i}</a>
          </li>
        );
      } else {
        html.push(
          <li>
            <a onClick={this.loadResults.bind(this, i)}>{i}</a>
          </li>
        );
      }
      if (i == this.state.curPage + 3) {
        break;
      }
    }
    return html;
  }
  setCategory(evt) {
    this.setState({ analyticsCategory: evt.target.value, changed: true });
  }
  setLabel(evt) {
    this.setState({ analyticsLabel: evt.target.value, changed: true });
  }
  renderList() {
    return this.state.results.map((result, index) => {
      return (
        <div className="col-xs-3" key={index}>
          <img
            src={result["medium_url"]}
            onClick={() => {
              this.props.addImage(
                result["medium_url"],
                {
                  alt: this.state.alt,
                  contentUrl: result["medium_url"],
                  sourceText: this.state.source,
                  srcurl: this.state.sourceUrl,
                  grid: this.state.grid,
                  analyticsCategory: this.state.analyticsCategory,
                  analyticsLabel: this.state.analyticsLabel,
                },
                null,
                this.state.adlayout,
                this.state.savorAdType
              );
            }}
            className="img-responsive"
          />
        </div>
      );
    });
  }
  setSourceUrl(evt) {
    this.setState({ sourceUrl: evt.target.value, changed: true });
  }
  setSource(evt) {
    this.setState({ source: evt.target.value, changed: true });
  }
  setAlt(evt) {
    this.setState({ alt: evt.target.value, changed: true });
  }
  setContent(evt) {
    this.setState({ source: this.state.editor.getContent(), changed: true });
  }
  changeGrid(evt) {
    this.setState({ grid: evt.target.value, changed: true });
  }
  setBoxLink(evt) {
    this.setState({ boxLink: evt.target.value, changed: true });
  }

  renderImageSource() {
    return (
      <div>
        <div className="input-group input-group-sm">
          <span className="input-group-addon" id="basic-addon1">
            <span className="glyphicon glyphicon-link" />
          </span>
          <input
            type="text"
            className="form-control"
            placeholder="url"
            aria-describedby="basic-addon1"
            onChange={this.setSourceUrl.bind(this)}
            value={this.state.sourceUrl}
          />
        </div>
        <div className="input-group input-group-sm">
          <span className="input-group-addon" id="basic-addon1">
            @
          </span>
          <input
            type="text"
            className="form-control"
            placeholder="source"
            aria-describedby="basic-addon1"
            onChange={this.setSource.bind(this)}
            value={this.state.source}
          />
        </div>
        <div className="input-group input-group-sm">
          <span className="input-group-addon" id="basic-addon1">
            Grid
          </span>
          <select
            defaultValue={this.state.grid}
            onChange={this.changeGrid.bind(this)}
          >
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
            <option value="6">6</option>
            <option value="7">7</option>
            <option value="8">8</option>
          </select>
          {this.state.changed && this.state.image != "" ? (
            <div
              className="input-group-addon btn"
              onClick={this.update.bind(this)}
            >
              Update
            </div>
          ) : (
            ""
          )}
        </div>
      </div>
    );
  }
  setSavorAd(evt) {
    this.setState({ savorAdType: evt.target.value, changed: true });
  }
  setBoxActive() { }
  renderAdLayout() {
    return (
      <div>
        <div className="input-group input-group-sm">
          <span className="input-group-addon" id="basic-addon1">
            Grid
          </span>
          <select
            defaultValue={this.state.grid}
            onChange={this.changeGrid.bind(this)}
          >
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
            <option value="6">6</option>
            <option value="7">7</option>
            <option value="8">8</option>
          </select>
        </div>
        <input
          class="form-control"
          type="text"
          onChange={this.setSourceUrl.bind(this)}
          defaultValue={this.state.sourceUrl}
          placeholder={this.state.savorAdType != 5 ? "headline" : "url"}
        />
        {this.state.savorAdType != 5 ? (
          <div className={"editable"} onInput={this.setContent.bind(this)} />
        ) : (
          ""
        )}
        {this.state.savorAdType == 5 ? (
          <input
            class="form-control"
            type="text"
            onChange={this.setCategory.bind(this)}
            defaultValue={this.state.analyticsCategory}
            placeholder="analytics category"
          />
        ) : (
          ""
        )}
        {this.state.savorAdType == 5 ? (
          <input
            class="form-control"
            type="text"
            onChange={this.setLabel.bind(this)}
            defaultValue={this.state.analyticsLabel}
            placeholder="analytics label"
          />
        ) : (
          ""
        )}
        {this.state.savorAdType == 6 ? (
          <input
            class="form-control"
            type="text"
            onChange={this.setBoxLink.bind(this)}
            defaultValue={this.state.boxLink}
            placeholder="link to"
          />
        ) : (
          ""
        )}
        <br />
        <select
          onChange={this.setSavorAd.bind(this)}
          defaultValue={this.state.savorAdType}
        >
          <option value="0">--</option>
          <option value="1">savor small</option>
          <option value="2">savor big</option>
          <option value="3">bangs small</option>
          <option value="4">bangs big</option>
          <option value="5">ad banner</option>
          <option value="6">banner horizontal</option>
          <option value="7">banner vertical</option>
        </select>

        {this.state.changed && this.state.image != "" ? (
          <div
            className="input-group-addon btn"
            onClick={this.update.bind(this)}
          >
            Update
          </div>
        ) : (
          ""
        )}
      </div>
    );
  }
  changeLayout() {
    this.setState({ adlayout: !this.state.adlayout });
  }
  renderSetImgSource() {
    return (
      <div>
        <input
          type="checkbox"
          checked={this.state.adlayout}
          onChange={this.changeLayout.bind(this)}
        />{" "}
        ad layout
        {!this.state.adlayout
          ? this.renderImageSource()
          : this.renderAdLayout()}
      </div>
    );
  }
  render() {
    return (
      <div>
        <div className="input-group">
          <input
            type="text"
            className="form-control"
            placeholder="alt text"
            aria-describedby="basic-addon1"
            onChange={this.setAlt.bind(this)}
            value={this.state.alt}
          />
        </div>
        {this.renderSetImgSource()}

        <ul className="nav nav-tabs">
          <li>
            <a href="" onClick={this.setShowTabContent.bind(this, 1)}>
              Upload
            </a>
          </li>
          <li>
            <a href="" onClick={this.setShowTabContent.bind(this, 2)}>
              Select Image
            </a>
          </li>
        </ul>
        <div className="tab-content" />
        {this.renderTabContent()}
      </div>
    );
  }
}
