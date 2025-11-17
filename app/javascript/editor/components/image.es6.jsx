import EditorBase from "./editor_base.es6";
import ImageView from "../../components/article/image_view";
import UploadImage from "./upload_image_es6";
import React from "react";
import ComponentMenu from "./component_menu.es6";
import ContextMenu from "../shared/context_menu.es6";
import {
  BingClient,
  InstagramClient,
  CustomImageClient,
  FlickrClient,
} from "../image_clients";
import { INSTAGRAM_API_CONFIG } from "../../components/conf/instagram_config";

const DEFAULT_IMAGE_ATTRIBUTES = {
  width: "auto",
  height: "auto",
  position: "none"
};

const imgbtnText = {
  url: "Embed",
  instagram: "Embed",
  flickr: "search",
  bing: "search",
};

const imgplaceholderText = {
  url: "paste url",
  instagram: "paste url",
  flickr: "search term",
  bing: "search term",
};

export default class Images extends EditorBase {
  getInitialState(content) {
    // Instagram投稿の場合はプレースホルダー画像を使用
    const isInstagramContent = content.searchType === "instagram" ||
                              (content.searchRes && content.searchRes.includes("instagram.com"));

    const imageUrl = isInstagramContent
      ? this.getInstagramPlaceholderImage()
      : (content.image || false);

    return {
      ad: content.ad || false,
      alt: content.alt || "",
      boxLink: content.boxLink || "",
      analyticsLabel: content.analyticsLabel || "",
      analyticsCategory: content.analyticsCategory || "",
      contextOpen: false,
      savorAdState: typeof content.savorAdState !== "undefined" ? content.savorAdState : 0,
      searchResults: [],
      edit: this.props.edit,
      prevImage: "",
      image: imageUrl,
      src: content.src || "",
      searchType: content.searchType || "url",
      searchRes: content.searchRes || "",
      imageAttributes: content.imageAttributes || DEFAULT_IMAGE_ATTRIBUTES,
      shouldShowComponentAction: false,
      pageData: { curPage: 1, maxPages: 0 },
      grid: typeof content.grid !== "undefined" ? content.grid : 1,
      lastPropsContentString: JSON.stringify(content) // 比較用
    };
  }

  constructor(props) {
    super(props);
    const content = this.props.content || {};
    this.state = this.getInitialState(content);
  }

  componentWillReceiveProps(nextProps) {
    // ...既存のロジック...
    const content = nextProps.content || {};
    this.setState({
      image: content.image || false,
      savorAdState: typeof content.savorAdState !== "undefined" ? content.savorAdState : 0,
      src: content.src || "",
      searchType: content.searchType || "url",
      prevImage: "",
      grid: typeof content.grid !== "undefined" ? content.grid : 1,
    });
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    const content = nextProps.content || {};
    const contentString = JSON.stringify(content);

    // contentが変更された場合のみ状態を更新
    if (contentString !== prevState.lastPropsContentString) {
      return {
        image: content.image || false,
        savorAdState: typeof content.savorAdState !== "undefined" ? content.savorAdState : 0,
        src: content.src || "",
        searchType: content.searchType || "url",
        prevImage: "",
        grid: typeof content.grid !== "undefined" ? content.grid : 1,
        lastPropsContentString: contentString // 比較用
      };
    }

    return null;
  }

  setSearchType(type) {
    this.setState({
      searchType: type,
      searchRes: "",
      searchResults: [],
      pageData: { curPage: 1, maxPages: 0 },
    });
  }

  search(page) {
    const p = typeof page === "object" ? 1 : page;
    switch (this.state.searchType) {
      case "url":
        this.addImage(this._imageUrl.value, { contentUrl: this._imageUrl.value });
        break;
      case "instagram":
        this.addInstagram(this._imageUrl.value);
        break;
      case "flickr":
        new FlickrClient().search(this._imageUrl.value, p, (data) => {
          this.setState({
            searchResults: data.photos.photo,
            pageData: {
              curPage: data.photos.page,
              maxPages: data.photos.pages,
            },
          });
        });
        break;
      case "bing":
        new BingClient().search(this._imageUrl.value, (data) => {
          this.setState({ searchResults: data });
        });
        break;
      default:
        break;
    }
  }

  getClient() {
    switch (this.state.searchType) {
      case "flickr":
        return new FlickrClient();
      case "instagram":
        return new InstagramClient();
      case "custom":
        return new CustomImageClient();
      default:
        return new BingClient();
    }
  }

  setPrevImage(url) {
    this.setState({ prevImage: url });
  }

  renderSearchResult() {
    if (!this.state.searchResults.length) return;
    const client = this.getClient();
    return this.state.searchResults.map((result, id) => {
      const imageUrl = client.getImageUrlFromRessource(result);
      return (
        <div
          className="col-sm-4 image-search-height"
          onMouseEnter={() => this.setPrevImage(imageUrl)}
          onClick={() => this.addImage(imageUrl, result, "", undefined, undefined)}
          key={id}
        >
          <img src={imageUrl} className="img-responsive" />
        </div>
      );
    });
  }

  setNewPage(page) {
    this.search(page);
  }

  renderPaging() {
    if (!this.state.searchResults.length || !this.state.pageData.maxPages) return;
    const html = [];
    for (let i = this.state.pageData.curPage; i < this.state.pageData.maxPages; i++) {
      html.push(
        <li className={i === this.state.pageData.curPage ? "active" : ""} key={i}>
          <a onClick={() => this.setNewPage(i)}>{i}</a>
        </li>
      );
      if (i === this.state.pageData.curPage + 3) break;
    }
    return html;
  }

  async addInstagram(url) {
    try {
      const response = await fetch(
        `${INSTAGRAM_API_CONFIG.baseUrl}?url=${encodeURIComponent(url)}&access_token=${INSTAGRAM_API_CONFIG.accessToken}`
      );

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();

      // Instagram投稿の場合はプレースホルダー画像を使用
      const instagramPlaceholderImageUrl = this.getInstagramPlaceholderImage();
      this.addImage(instagramPlaceholderImageUrl, data, url);
    } catch (error) {
      console.error('Instagram embed failed:', error);
      // エラー時もプレースホルダー画像を使用
      const instagramPlaceholderImageUrl = this.getInstagramPlaceholderImage();
      this.addImage(instagramPlaceholderImageUrl, { html: "" }, url);
    }
  }

  /**
   * Instagramプレースホルダー画像のURLを取得
   * @returns {string} プレースホルダー画像のURL
   */
  getInstagramPlaceholderImage() {
    // Instagramプレースホルダー画像を使用
    return require('images/shared/placeholder-instagram.png');
  }

  addImage(imageUrl, result, url, is_ad, savorAdState) {
    // ...既存のロジック...
    if (typeof savorAdState === "undefined") savorAdState = 0;
    if (typeof result === "undefined") this.toggleEdit();
    if (typeof is_ad === "undefined" || typeof is_ad !== "boolean") is_ad = false;
    this.setPrevImage(this, "");
    const client = this.getClient();
    const search = typeof url !== "undefined" && url != null ? url : "";
    client.getSource(result).then((res) => {
      const url =
        this.state.searchType === "flickr"
          ? `https://www.flickr.com/photos/${result.owner}/${result.id}`
          : res.srcurl;
      const prefix = this.state.searchType === "flickr" ? "Flickr " : res.text;
      const source = {
        url: url,
        text:
          this.state.searchType === "flickr"
            ? res.person.username._content + " / " + prefix
            : res.person.username._content,
      };
      this.setState({
        image: imageUrl,
        analyticsCategory: result.analyticsCategory || "",
        analyticsLabel: result.analyticsLabel || "",
        alt: result.alt || "",
        boxLink: result.boxLink || "",
        searchType: this.state.searchType,
        src: source,
        searchRes: search,
        ad: is_ad,
        grid: result.grid || 0,
        savorAdState: savorAdState,
      });
      this.props.updateState(
        {
          image: imageUrl,
          boxLink: result.boxLink || "",
          analyticsCategory: result.analyticsCategory || "",
          analyticsLabel: result.analyticsLabel || "",
          alt: result.alt || "",
          searchType: this.state.searchType,
          src: source,
          searchRes: search,
          ad: is_ad,
          grid: result.grid || 0,
          savorAdState: savorAdState,
          imageAttributes: this.state.imageAttributes,
        },
        this.props.position
      );
      this.toggleEdit();
    });
  }

  renderImgSelection() {
    if (this.state.searchType === "custom" && this.state.edit) {
      return (
        <UploadImage
          ad={this.state.ad}
          boxLink={typeof this.state.boxLink !== "undefined" ? this.state.boxLink : ""}
          alt={typeof this.state.alt !== "undefined" ? this.state.alt : ""}
          edit={this.state.edit}
          savorAdType={this.state.savorAdState}
          addImage={this.addImage.bind(this)}
          src={this.state.src}
          grid={this.state.grid}
          analyticsLabel={this.state.analyticsLabel}
          analyticsCategory={this.state.analyticsCategory}
          image={this.state.image}
        />
      );
    }
    return (
      <div>
        <input
          ref={(ref) => (this._imageUrl = ref)}
          placeholder={imgplaceholderText[this.state.searchType]}
          className="form-control"
        />
        <button
          id="search-button"
          onClick={this.search.bind(this)}
          className="btn btn-primary"
        >
          {imgbtnText[this.state.searchType]}
        </button>
      </div>
    );
  }

  renderImgCurrently() {
    if (!this.state.image) return;

    // Instagram投稿の場合はプレースホルダー画像を使用
    const displayImage = this.isInstagramContent()
      ? this.getInstagramPlaceholderImage()
      : this.state.image;

    return (
      <div className="col-sm-9">
        <p>currently selected: </p>
        <div className="previewImg">
          <img src={displayImage} width="100" />
        </div>
      </div>
    );
  }

  /**
   * Instagram投稿かどうかを判定
   * @returns {boolean} Instagram投稿の場合true
   */
  isInstagramContent() {
    return this.state.searchType === "instagram" ||
           (this.state.searchRes && this.state.searchRes.includes("instagram.com"));
  }

  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className="search-prev-img" onClick={() => this.setPrevImage("")}>{this.state.prevImage !== "" ? <img src={this.state.prevImage} /> : ""}</div>
        <div className={!this.state.edit ? "hidden row" : "row"}>
          <div className="col-sm-3 border-right">
            <p className="search-type-current">Select search type <br /><span>(currently: <strong>{this.state.searchType}</strong>)</span></p>
            <ul className="search-type-menu">
              <li onClick={() => this.setSearchType("custom")} className="search-type-item">
                <img src="/assets/label/label-upload.png" className="padding-left" alt="Image Upload" />
              </li>
              <li onClick={() => this.setSearchType("url")} className="search-type-item">
                <img src="/assets/label/label-url.png" className="padding-left" alt="Image URL" />
              </li>
              <li onClick={() => this.setSearchType("instagram")} className="search-type-item">
                <img src="/assets/label/label-instagram.png" className="padding-left" alt="Instagram" />
              </li>
              <li onClick={() => this.setSearchType("flickr")} className="search-type-item">
                <img src="/assets/label/label-flickr.png" className="padding-left" alt="Flickr" />
              </li>
              <li onClick={() => this.setSearchType("bing")} className="search-type-item">
                <img src="/assets/label/label-bing.png" className="padding-left" height="40" alt="Microsoft Bing" />
              </li>
            </ul>
          </div>
          {this.renderImgCurrently()}
          <div className="col-sm-9">
            <div className="form-inline">{this.renderImgSelection()}</div>
            <div className="img-search-results">
              {this.renderSearchResult()}
              <div className="clear" />
              <ul className="pagination pagination-sm">{this.renderPaging()}</ul>
            </div>
          </div>
        </div>
        <div className="row remove-margin-right">
          {(() => {
            if ((typeof this.props.onComponentAction === "function" && this.state.shouldShowComponentAction) || this.state.edit) {
              return (
                <ComponentMenu
                  isMarked={typeof this.props.markedComponent[this.props.position] !== "undefined"}
                  onComponentAction={this.props.onComponentAction}
                  position={this.props.position}
                  saveAction={this.state.edit ? () => {
                    this.toggleEdit(this);
                    this.props.updateEditState({ edit: false }, this.props.position);
                  } : false}
                  renderExtendedMenu={this.props.renderComponents}
                  cancelAction={this.state.edit ? () => {
                    this.toggleEdit(this);
                    this.props.updateEditState({ edit: false }, this.props.position);
                  } : false}
                />
              );
            }
          })()}
        </div>
      </div>
    );
  }

  toggleEdit() {
    if (!this.props.editor || this.state.contextOpen) return;
    if (!this.state.edit) {
      this.props.updateEditState({ edit: true }, this.props.position);
    }
    this.setState({ edit: !this.state.edit });
  }

  inputChange(type, evt) {
    const attributes = { ...this.state.imageAttributes };
    attributes[type] = evt.target.value == 0 ? "auto" : evt.target.value;
    this.setState({ imageAttributes: attributes });
    this.props.updateState(
      {
        image: this.state.image,
        searchType: this.state.searchType,
        src: this.state.source,
        searchRes: this.state.search,
        ad: this.state.is_ad,
        grid: this.state.grid || 0,
        savorAdState: this.state.savorAdState,
        imageAttributes: attributes,
      },
      this.props.position
    );
  }

  renderView() {
    if (!this.props.editor) {
      return !this.state.image ? (
        "click here to edit"
      ) : (
        <ImageView
          imageAttributes={this.state.imageAttributes}
          grid={this.state.grid}
          alt={this.state.alt}
          boxLink={this.state.boxLink}
          analyticsCategory={this.state.analyticsCategory}
          analyticsLabel={this.state.analyticsLabel}
          savorAdState={this.state.savorAdState}
          editor={this.props.editor}
          ad={this.state.ad}
          image={this.state.image}
          src={this.state.src}
          searchRes={this.state.searchRes || ""}
        />
      );
    }
    return (
      <ContextMenu
        defaultValues={this.state.imageAttributes}
        openCb={() => {
          this.setState({ contextOpen: true });
        }}
        closeCb={() => {
          this.setState({ contextOpen: false });
        }}
        inputChange={(type, evt) => {
          this.inputChange(type, evt);
        }}
      >
        {!this.state.image ? (
          "click here to edit"
        ) : (
          <ImageView
            alt={this.state.alt}
            imageAttributes={this.state.imageAttributes}
            grid={this.state.grid}
            boxLink={this.state.boxLink}
            analyticsCategory={this.state.analyticsCategory}
            analyticsLabel={this.state.analyticsLabel}
            savorAdState={this.state.savorAdState}
            editor={this.props.editor}
            ad={this.state.ad}
            image={this.state.image}
            src={this.state.src}
            searchRes={this.state.searchRes || ""}
          />
        )}
      </ContextMenu>
    );
  }

  render() {
    let mainDivClass = "";
    if (this.state.grid !== "1") {
      const size = 12 / this.state.grid;
      mainDivClass = this.state.shouldShowComponentAction
        ? `highglight-el col-xs-${size}`
        : `col-xs-${size}`;
      if (this.state.edit) {
        mainDivClass = mainDivClass.replace(`col-xs-${size}`, "col-xs-12");
      }
      // Instagram oembedの場合はimg-gridクラスを付与しない
      const isInstagramOembed = this.state.searchType === "instagram" ||
                               (this.state.searchRes && this.state.searchRes.includes("instagram.com"));
      if (!isInstagramOembed) {
          mainDivClass += " img-grid";
      }
    } else {
      mainDivClass = this.state.shouldShowComponentAction ? "highglight-el" : "";
    }
    return (
      <div
        onMouseOver={this.showComponentAction.bind(this)}
        onMouseLeave={this.hideComponentAction.bind(this)}
        className={this.props.className + " " + mainDivClass}
      >
        <div className={this.state.edit ? "hidden" : ""}>
          <div onClick={this.toggleEdit.bind(this)}>{this.renderView()}</div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
