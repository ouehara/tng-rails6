import EditorBase from "./editor_base.es6";
import LinkView from "../../components/article/link_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
export default class Link extends EditorBase {
  constructor(props) {
    super(props);
    let imagePreview = null;
    let url = "";
    let title = "click here to edit";
    let desc = "";
    if (this.props.content != null) {
      imagePreview = this.props.content.imgPreview;
      url = this.props.content.url;
      title = this.props.content.title;
      desc = this.props.content.desc;
    }
    this.state = {
      imgPreview: imagePreview,
      url: url,
      title: title,
      desc: desc,
      edit: this.props.edit,
    };
  }
  componentWillReceiveProps(nextProps) {
    let imagePreview = null;
    let url = "";
    let title = "click here to edit";
    let desc = "";
    if (nextProps.content != null) {
      imagePreview = nextProps.content.imgPreview;
      url = nextProps.content.url;
      title = nextProps.content.title;
      desc = nextProps.content.desc;
    }
    this.setState({
      imgPreview: imagePreview,
      url: url,
      title: title,
      desc: desc,
      edit: nextProps.edit,
    });
  }
  getOgp(evt) {
    if (this.timer) {
      clearTimeout(this.timer);
    }
    this.timer = setTimeout(() => {
      let url = encodeURIComponent(this._url.value);
      $.ajax(
        "https://opengraph.io/api/1.0/site/" +
          url +
          "?app_id=587dc66bdd25380e00b9ef70"
      ).done((data) => {
        this.handleOpgData(data);
      });
    }, 500);
  }
  handleOpgData(ogpData) {
    let ogp = ogpData.htmlInferred;
    let img = ogp.image;
    console.log(ogp);
    if (typeof ogpData.hybridGraph.error == "undefined") {
      ogp = ogpData.hybridGraph;
      img = ogp.image.secure_url;
    }
    if (typeof ogpData.openGraph.error == "undefined") {
      ogp = ogpData.openGraph;
      img = ogp.image.secure_url;
    }
    this.setState({
      imgPreview: img,
      title: ogp.title,
      desc: ogp.description,
      url: this._url.value,
    });
  }
  saveText() {
    this.setState({
      imgPreview: this._img.src,
      title: this._title.value,
      desc: this._desc.value,
      url: this._url.value,
    });
    this.props.updateState(
      {
        imgPreview: this._img.src,
        title: this._title.value,
        desc: this._desc.value,
        url: this._url.value,
      },
      this.props.position
    );
    this.toggleEdit();
  }
  renderEditor() {
    if (!this.props.editor) return;
    let img = this.state.imgPreview;
    let title = this.state.title;
    let desc = this.state.desc;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden" : "col-sm-12"}>
          <div className="col-xs-3">
            <img
              className="img-preview img-responsive"
              src={img}
              ref={(ref) => (this._img = ref)}
            />
          </div>
          <div className="col-xs-9">
            <input
              type="text"
              placeholder="url"
              className="col-xs-12 form-group form-control"
              name="url"
              ref={(ref) => (this._url = ref)}
              onChange={this.getOgp.bind(this)}
            />
            <input
              type="text"
              placeholder="page title"
              className="col-xs-12 form-group form-control"
              name="title"
              ref={(ref) => (this._title = ref)}
              defaultValue={title}
            />
            <textarea
              name="description"
              placeholder="description"
              className="col-xs-12 form-group form-control"
              ref={(ref) => (this._desc = ref)}
              defaultValue={desc}
            />
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
                    this.state.edit ? this.saveText.bind(this) : false
                  }
                  renderExtendedMenu={this.props.renderComponents}
                  cancelAction={
                    this.state.edit
                      ? () => {
                          this.toggleEdit.bind(this);
                          this.props.updateEditState(
                            {
                              edit: false,
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
    let img = this.state.imgPreview;
    let title = this.state.title;
    let desc = this.state.desc;
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
            <LinkView
              img={img}
              title={title}
              desc={desc}
              url={this.state.url}
            />
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}

Link.timer = false;
