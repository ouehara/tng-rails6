import React from "react";
import dayjs from "dayjs";
import Title from "./components/title.es6";
import Text from "./components/text.es6";
import Link from "./components/link.es6";
import Quote from "./components/quote.es6";
import Video from "./components/video.es6";
import Images from "./components/image.es6";
import Twitter from "./components/twitter.es6";
import Legacy from "./components/legacy.es6";
import Maps from "./components/maps.es6";
import Page from "./components/page.es6";
import Hotel from "./components/hotel.es6";
import HotelAffiliate from "./components/hotel_affiliate.es6";
import Navigation from "./components/navigation.es6";
import BasicInformation from "./components/information.es6";
import RelatedArticles from "./components/related_articles.es6";
import EditorButtons from "./components/editor_buttons.es6";
import FlowList from "./components/flow_list.es6";
import RelatedGroup from "./components/related_group.es6";
import InstagramVideo from "./components/instagram_video.es6";
import BlogTitle from "./components/static/BlogTitle";
import TitleImage from "./components/static/TitleImage";
import Excerp from "./components/static/Excerpt";
import EditorRightGroupings from "./editor_right_groupings.es6";
import SideMenu from "./side_menu.es6";
import EditorComponents from "./editor_components.es6";
import Alert from "../components/alert/alert.es6";
import Modal from "./shared/modal.es6";
import confirmation from "./shared/confirm.es6";
import link_path from "../components/shared_components/link_path";
import ComponentRegistry from "../components/shared_components/component_registry";
import Otomo from "./components/otomo.es6";
import I18n from "../components/i18n/i18n";
const Registry = new ComponentRegistry();
Registry.register({ Title: Title });
Registry.register({ Text: Text });
Registry.register({ Link: Link });
Registry.register({ Quote: Quote });
Registry.register({ Video: Video });
Registry.register({ Images: Images });
Registry.register({ Twitter: Twitter });
Registry.register({ Legacy: Legacy });
Registry.register({ Maps: Maps });
Registry.register({ Page: Page });
Registry.register({ Hotel: Hotel });
Registry.register({ HotelAffiliate: HotelAffiliate });
Registry.register({ ArtNav: Navigation });
Registry.register({ BasicInformation: BasicInformation });
Registry.register({ RelatedArticles: RelatedArticles });
Registry.register({ EditorButtons: EditorButtons });
Registry.register({ FlowList: FlowList });
Registry.register({ RelatedGroup: RelatedGroup });
Registry.register({ InstagramVideo: InstagramVideo });
Registry.register({ Otomo: Otomo });
function countWords(s) {
  s = s.replace(/(^\s*)|(\s*$)/gi, ""); //exclude  start and end white-space
  s = s.replace(/[ ]{2,}/gi, " "); //2 or more space to 1
  s = s.replace(/\n /, "\n"); // exclude newline with a start spacing
  return s.split(" ").length;
}

export default class Editor extends React.Component {
  constructor(props) {
    super(props);
    let article = this.props.article.article;
    this.localStorageName = "content-" + article.id;
    this.lastrender = 0;
    let obj = this.initBlogHeader(this.props.article);
    let isLegacy = false;
    let components = !this.props.editor
      ? article.contents
      : article.contents[I18n.current];
    let articleGroup = [0, 0, 0, 0];
    if (typeof components == "undefined") {
      components = [];
    }

    let articleTags = this.props.article.tags.map((t) => {
      return t.name;
    });
    let promo = -1;

    //let components = [{content: "here is content", type: "Legacy", position:0, edit: false, id:1}];
    let showModal = false;
    if (localStorage.getItem(this.localStorageName) && this.props.editor) {
      showModal = true;
    }
    if (this.props.promotional != null) {
      promo = this.props.promotional.position;
    }
    if (typeof components[0] != "undefined" && components[0].type == "Legacy") {
      isLegacy = true;
    }
    let pageStats = { pageAm: 1, curPage: 1 };
    if (!this.props.editor) {
      pageStats = this.getPageAmount(components);
    } else {
      articleGroup = this.props.article.article_group;
    }
    this.setLastRender(this.props.page, components);
    let articleCategory = 0;
    if (this.props.editor && this.props.category != null) {
      articleCategory = this.props.category[0].id;
    }

    let slug = this.props.article["slug_" + I18n.current];
    if (
      this.props.article["slug_" + I18n.current] == "" ||
      this.props.article["slug_" + I18n.current] == null
    ) {
      slug = this.props.article["slug_en"];
    }
    if (typeof components == "string") {
      components = [];
    }
    this.state = {
      file: null,
      markedComponent: {},
      template: article.template,
      unlist: article.unlist,
      components: components,
      staticComponents: obj,
      id: article.id,
      showModal: showModal,
      isLegacy: isLegacy,
      canonical: props.canonical,
      title: article.disp_title,
      articleCategory:
        article.category_id == null ? articleCategory : article.category_id,
      tags: articleTags,
      articleTagGroups: this.props.article.tagGroups,
      alert: { show: false, class: "", message: "" },
      currentLanguage: I18n.current,
      articleArea: this.props.article.area,
      sponsoredContent:
        article.sponsored_content == null ? false : article.sponsored_content,
      wordCount: !showModal ? this.getWordCount(components) : 0,
      curChar: !showModal ? this.getCharCount(components) : 0,
      pages: pageStats["pageAm"],
      curPage: this.props.page,
      loading: false,
      lock_version: article.optimistic_lock[I18n.current] || 1,
      slug: slug,
      copy_from: "",
      relatedArticles:
        typeof this.props.relatedArticles != "undefined"
          ? { elements: this.props.relatedArticles }
          : null,
      slugDisabled: true,
      wrapperClass: "",
      user: this.props.user,
      translator:
        this.props.translator != null ? this.props.translator.user_id : 0,
      author: this.props.user != null ? this.props.user.id : 0,
      schedule: article.schedule == null ? {} : article.schedule,
      slug_en: this.props.article["slug_en"],
      isPromotional: promo,
      article_group: articleGroup,
      "slug_zh-hant": this.props.article["slug_zh_hant"],
      "slug_zh-hans": this.props.article["slug_zh_hans"],
      slug_th: this.props.article["slug_th"],
      canoncialHidden: true,
      slug_id: this.props.article["slug_id"],
      languageState: this.props.article.article.is_translated,
      status:
        typeof this.props.article.article.is_translated[I18n.current] !=
          undefined &&
          this.props.article.article.is_translated[I18n.current] == "publish"
          ? "published"
          : "draft",
    };

    $(window).on("popstate", function (e) {
      window.location.href = window.location.href;
    });
    if (this.props.editor) {
      let path =
        this.state.currentLanguage == "en"
          ? "/ping_lock.json"
          : "/" + this.state.currentLanguage + "/ping_lock.json";
      setInterval(() => {
        $.ajax({
          url: path,
          type: "put",
          data: "id=" + this.props.article.article.id,
        }).done((result) => {
          if (typeof result.notification == "undefined") {
            return;
          }
          this.setState({
            alert: {
              show: true,
              class: "alert-danger",
              message: result.notification,
            },
            staticComponents: obj,
          });
        });
      }, 30000);
      document.addEventListener("keydown", (evt) => {
        if (evt.ctrlKey && evt.shiftKey && evt.keyCode == 90) {
          this.reorgIds();
        }
      });
    }
  }

  componentDidMount() {
    $(".size-full").parent("a").css("cursor", "default");
    $(".size-full")
      .parent("a")
      .on("click", function (ev) {
        ev.preventDefault();
      });

    if (!this.props.editor) {
      this.setInsta();
    }
    if (this.props.page > 1) {
      setTimeout(() => {
        document.querySelector(".blog-entry").scrollIntoView();
      });
    }
  }
  changeLegacyArticleToDefault() {
    if (!this.state.isLegacy) {
      return;
    }
    let comp = this.state.components[0];
    let content = "";
    if (typeof comp.content["text"] != "undefined") {
      content = comp.content["text"];
    } else {
      content = comp.content;
    }
    let textComp = [
      {
        content: { text: content },
        id: 1,
        position: 0,
        type: "Text",
        edit: false,
      },
    ];
    this.setState({ components: textComp, isLegacy: false });
  }
  setInsta() {
    $(document).ready(function () {
      $(".insta-button").each(function () {
        var url = $(this).find("img").attr("src");
        var width = $(this).find("img").attr("width");
        $(this).css({ width: width + "px" });
        if (typeof url != "undefined") {
          $(this).append(
            "<a href=" +
            url.replace("/media", "") +
            ' class="insta-link">embedded from Instagram</a>'
          );
        }
      });
    });
  }

  getPageAmount(cmp) {
    let pageAmount = { pageAm: 0 };
    for (var i = 0; i < cmp.length; i++) {
      if (typeof cmp[i].pageAmount != "undefined") {
        pageAmount["pageAm"] = cmp[i].pageAmount + 1;
        break;
      }
    }
    return pageAmount;
  }
  loadFromStorage() {
    let components = JSON.parse(localStorage.getItem(this.localStorageName));
    this.setState({
      components: components,
      showModal: false,
      curChar: this.getCharCount(components, true),
      wordCount: this.getWordCount(components, true),
    });
  }
  removeFromLocalStorage() {
    localStorage.removeItem(this.localStorageName);
    this.setState({ showModal: false });
  }
  copyFromLang(evt) {
    let language = evt.target.value;
    confirmation("Confirmation", {
      description:
        "Do you really want to copy from " +
        I18n.t("lang." + language) +
        " to " +
        I18n.t("lang." + I18n.current),
    })
      .then(
        async function (lang) {
          let language = lang;
          let article = JSON.parse(JSON.stringify(this.props.article.article));
          let components;
          let header;
          let status = "draft";
          let isLegacy = false;
          components = article.contents[language];
          header = this.initBlogHeader(this.props.article, language);
          header[2].val = this.props.article.lang_image[lang];
          if (
            typeof components[0] != "undefined" &&
            components[0].type == "Legacy"
          ) {
            isLegacy = true;
          }
          let slug = this.state["slug_" + language];
          if (
            this.state["slug_" + language] == "" ||
            this.state["slug_" + language] == null
          ) {
            slug = this.state["slug_en"];
          }
          let response = await fetch(`/${language}/json/${article.id}.json`);
          let data = await response.json();

          this.setState(
            {
              components: components,
              staticComponents: header,
              status: status,
              author: data.cached_users.id,
              slug: slug,
              copy_from: language,
            },
            () => {
              /*this.saveArticle(true, () => {
                        window.location = link_path(this.props.editUrl, [{ value: this.state.currentLanguage, key: ":lang" }])
                    })*/
            }
          );
        }.bind(this, language)
      )
      .fail(function () {
        console.log("error");
      });
  }
  changeLanguage(evt, copy) {
    let language = evt.target.value;
    window.location = link_path(this.props.editUrl, [
      { value: language, key: ":lang" },
    ]);
  }
  initBlogHeader(art, lang) {
    let article = art.article;
    let language = lang || I18n.current;
    if (this.props.editor) {
      return [
        {
          type: BlogTitle,
          position: 0,
          id: 0,
          val: article.disp_title != null ? article.disp_title[language] : "",
        },
        {
          type: Excerp,
          position: 1,
          id: 1,
          val: article.excerpt[language] || "",
        },
        { type: TitleImage, position: 2, id: 2, val: art.title_image },
      ];
    }
    return [];
  }
  generateId() {
    return (
      Date.now().toString(36) + Math.random().toString(36).substr(2, 5)
    ).toUpperCase();
  }
  reorgIds() {
    const currentState = [...this.state.components];
    const newState = currentState.map((components, i) => {
      components.id = this.generateId();
      return components;
    });
    this.setState({ components: newState });
  }
  onComponentClick(type, pos, ev) {
    let position = this.state.components.length;
    let currentState;
    if (pos != null) {
      currentState = [...this.state.components];
      currentState.splice(pos + 1, 0, {
        type: type,
        position: pos,
        id: this.generateId(),
        content: null,
        edit: true,
      });

      for (var i = 0; i < currentState.length; i++) {
        currentState[i].position = i;
      }
    } else {
      currentState = [
        ...this.state.components,
        {
          type: type,
          position: position,
          id: this.generateId(),
          content: null,
          edit: true,
        },
      ];
    }
    this.setState({ components: currentState });
  }
  getComponentPosition() {
    return this.state.components.length;
  }
  get_text(el) {
    ret = "";
    var length = el.childNodes.length;
    for (var i = 0; i < length; i++) {
      var node = el.childNodes[i];
      if (node.nodeType != 8) {
        ret += node.nodeType != 1 ? node.nodeValue : get_text(node);
      }
    }
    return ret;
  }
  onComponentAction(actionType, position, ev) {
    switch (actionType) {
      case "up":
      case "down":
        this.moveComponentPosition(actionType === "up", position);
        break;
      case "del":
        this.delElementAtIndex(position);
        break;
      case "top":
        this.moveToTop(position);
        break;
      case "bottom":
        this.moveToBottom(position);
        break;
      case "mark":
        this.mark(position);
        break;
    }
  }
  mark(pos) {
    let marked = { ...this.state.markedComponent };
    if (typeof marked[pos] == "undefined") {
      marked[pos] = true;
    } else {
      delete marked[pos];
    }

    this.setState({ markedComponent: marked });
  }
  delElementAtIndex(position) {
    if (typeof this.state.markedComponent[position] != "undefined") {
      this.delMultiple();
      return;
    }
    let currentState = [...this.state.components];
    let newState = [];
    currentState.map((el) => {
      if (el.position != position) {
        if (el.position > position) {
          el.position -= 1;
        }
        newState.push(el);
        return el;
      }
    });
    this.setState({ components: newState });
    localStorage.setItem(this.localStorageName, JSON.stringify(newState));
  }
  delMultiple() {
    confirmation("Confirmation", {
      description:
        "Do you really want to delete " +
        Object.keys(this.state.markedComponent).length +
        "components",
    }).then(() => {
      let newPosMarked = { ...this.state.markedComponent };
      let keys = Object.keys(newPosMarked);
      let currentState = [...this.state.components];
      let newState = [];
      currentState.map((el) => {
        if (typeof newPosMarked[el.position] == "undefined") {
          newState.push(el);
          return el;
        }
      });
      for (var i = 0; i < newState.length; i++) {
        newState[i].position = i;
      }
      this.setState({ components: newState, markedComponent: {} });
      localStorage.setItem(this.localStorageName, JSON.stringify(newState));
    });
  }
  moveToTop(position) {
    this.setState({ components: this.moveStateComponentIndex(position, 1) });
  }
  moveToBottom(position) {
    this.setState({
      components: this.moveStateComponentIndex(
        position,
        this.state.components.length
      ),
    });
  }
  moveComponentPosition(shouldMoveUp, position) {
    if (typeof this.state.markedComponent[position] != "undefined") {
      this.moveMultiple(shouldMoveUp);
      return;
    }
    this.mvCmp(shouldMoveUp, position);
  }
  moveMultiple(shouldMoveUp) {
    //fix this mess
    let newPosMarked = { ...this.state.markedComponent };
    let keys = Object.keys(newPosMarked);
    keys.sort((a, b) => {
      return shouldMoveUp ? a - b : b - a;
    });
    let array = [...this.state.components];
    for (var k in keys) {
      let key = parseInt(keys[k]);
      let newPosition = key + 1;
      if (shouldMoveUp) {
        newPosition = key - 1;
      }
      delete newPosMarked[key];
      newPosMarked[newPosition] = true;
      var oldIndex = key;
      var newIndex = newPosition;
      if (newIndex >= array.length) {
        newIndex = array.length - 1;
      }

      array[oldIndex].position = newIndex;
      array[newIndex].position = oldIndex;
      array.splice(newIndex, 0, array.splice(oldIndex, 1)[0]);
    }
    for (var i = 0; i < array.length; i++) {
      array[i].position = i;
    }
    localStorage.setItem(this.localStorageName, JSON.stringify(array));
    this.setState({ components: array, markedComponent: newPosMarked }, () => {
      var id = array[Object.keys(newPosMarked)["0"]].id;
      document.querySelector(".marked-component-" + id).scrollIntoView();
      window.scrollBy(0, -150);
    });
  }
  mvCmp(shouldMoveUp, position) {
    let newPosition = position + 1;
    if (shouldMoveUp) {
      newPosition = position - 1;
    }
    this.setState({
      components: this.moveStateComponentIndex(position, newPosition),
    });
    return newPosition;
  }
  moveStateComponentIndex(oldIndex, newIndex) {
    let array = [...this.state.components];
    if (newIndex >= array.length) {
      newIndex = array.length - 1;
    }

    array[oldIndex].position = newIndex;
    array[newIndex].position = oldIndex;
    array.splice(newIndex, 0, array.splice(oldIndex, 1)[0]);
    for (var i = 0; i < array.length; i++) {
      array[i].position = i;
    }
    localStorage.setItem(this.localStorageName, JSON.stringify(array));
    return array;
  }
  updateEditState(content, position) {
    let newState = [...this.state.components];
    newState[position].edit = content.edit;
    this.setState({ components: newState });
    if (newState[position].type == "Legacy") {
      return;
    }
    localStorage.setItem(this.localStorageName, JSON.stringify(newState));
  }
  setContent(content, position) {
    let newState = [...this.state.components];
    newState[position].content = content;
    newState[position].edit = false;
    this.setState({ components: newState });
    if (newState[position].type == "Legacy") {
      return;
    }
    localStorage.setItem(this.localStorageName, JSON.stringify(newState));
  }
  addHotelComponent(content, position) {
    let newState = [...this.state.components];
    newState[position] = content;
    this.setState({ components: newState });
    localStorage.setItem(this.localStorageName, JSON.stringify(newState));
  }
  onChange(type, value) {
    this.setState({ [type]: value });
  }
  saveArticle(draft, callback) {
    let id = this.state.id;
    let fd = new FormData();
    let $that = this;
    let components = this.props.article.article.contents;
    let showError = false;
    components[this.state.currentLanguage] = this.state.components;
    components[this.state.currentLanguage].map((c) => {
      if (c.edit && c.type != "Legacy" && c.type != "Page") {
        showError = true;
      }
    });
    if (showError) {
      this.setState({
        alert: {
          show: true,
          class: "alert-danger",
          message: "Error on save: One or more unsaved components",
        },
        wrapperClass: "error",
      });
      return;
    }
    let pages = components[this.state.currentLanguage].filter((t) => {
      return t.type == "Page";
    });
    let data = components;
    let curLang = data[this.state.currentLanguage];
    let didSetPage = false;
    for (let i = 0; i < curLang.length; i++) {
      if (typeof curLang[i].pageAmount != "undefined") {
        data[this.state.currentLanguage][i].pageAmount = pages.length;
        didSetPage = true;
      }
    }

    if (!didSetPage) {
      data[this.state.currentLanguage].push({ pageAmount: pages.length });
    }

    let excerpt = this.props.article.article.excerpt;
    excerpt[this.state.currentLanguage] = document.querySelector(
      "#excerp"
    ).value;
    let title = this.props.article.article.disp_title;
    if (title == null) {
      title = {};
    }
    title[this.state.currentLanguage] = document.querySelector("#title").value;
    fd.append("contents", JSON.stringify(data));
    fd.append("disp_title", JSON.stringify(title));
    fd.append("excerpt", JSON.stringify(excerpt));
    if (
      this.state.file != null &&
      (typeof callback == "undefined" || callback == null)
    ) {
      fd.append("title_image", this.state.file);
    }
    fd.append("all_tags", this.state.tags);
    let schedule = this.state.schedule;
    if (typeof schedule[this.state.currentLanguage] == "undefined") {
      schedule[this.state.currentLanguage] = dayjs();
    }
    fd.append("schedule", JSON.stringify(schedule));
    if (this.state.articleCategory != null) {
      fd.append("category_id", this.state.articleCategory);
    } else {
      this.setState({
        alert: {
          show: true,
          class: "alert-danger",
          message: <span>Error on Save: Category is missing.</span>,
        },
      });
      return;
    }
    if (this.state.articleArea != null) {
      fd.append("area_id", this.state.articleArea.id);
    } else {
      this.setState({
        alert: {
          show: true,
          class: "alert-danger",
          message: <span>Error on save: Area is missing</span>,
        },
      });
      return;
    }
    fd.append("sponsored_content", this.state.sponsoredContent);
    if (draft) {
      fd.append("draft", this.state.currentLanguage);
    } else {
      fd.append("publish", this.state.currentLanguage);
    }
    fd.append("lock_version", this.state.lock_version);
    //if (this.state.slug != "" && this.state.slug != this.props.article.article.slug && this.state.slug != null && this.state.slug != "undefined") {
    fd.append("slug", this.state.slug);
    //}
    fd.append("author", this.state.author);
    if (this.state.translator != 0) {
      fd.append("translator", this.state.translator);
    }
    if (this.state.author == 0) {
      this.setState({
        alert: {
          show: true,
          class: "alert-danger",
          message: <span>Please select an Author</span>,
        },
      });
      return;
    }
    if (this.state.isPromotional != -1) {
      fd.append("isPromotional", this.state.isPromotional);
    }
    if (this.state.copy_from != "") {
      fd.append("copy_from", this.state.copy_from);
    }
    if (this.state.article_group != 0) {
      fd.append("article_groups", this.state.article_group);
    }
    if (
      this.state.relatedArticles != null &&
      this.state.relatedArticles.elements != null
    ) {
      fd.append(
        "all_related",
        Object.keys(this.state.relatedArticles.elements).map(
          (value) => this.state.relatedArticles.elements[value].id
        )
      );
    }
    if (
      this.state.articleTagGroups.length == 1 &&
      this.state.articleTagGroups[0].id == "none"
    ) {
      fd.append("all_tag_groups", "");
    } else {
      fd.append(
        "all_tag_groups",
        this.state.articleTagGroups.map((g) => g.id)
      );
    }

    fd.append("canonical", this.state.canonical);
    fd.append("unlist", this.state.unlist);
    fd.append("template", this.state.template);
    $.ajax({
      url: "/articles/" + id + ".json",
      type: "PUT",
      data: fd,
      timeout: 20000,
      processData: false,
      contentType: false,
      beforeSend: () => {
        this.setState({ loading: true });
      },
    })
      .done((result) => {
        if (typeof result.updated_at == "undefined") {
          return;
        }
        if (typeof callback != undefined && callback != null) {
          callback();
        }
        $that.props.article.article.disp_title = title;
        $that.props.article.article.excerpt = excerpt;
        let obj = $that.initBlogHeader(
          $that.props.article,
          $that.state.currentLanguage
        );
        obj[2].val = result.medium_url;
        let sl = this.state.currentLanguage.replace("-", "_");
        let slug = result["slug_" + sl];
        if (result["slug_" + sl] == "" || result["slug_" + sl] == null) {
          slug = result["slug_en"];
        }
        if (!this.props.v) {
          window.location = link_path(this.props.editUrl, [
            { value: this.state.currentLanguage, key: ":lang" },
          ]);
        }
        $that.setState({
          lock_version: result.lock_version,
          alert: {
            show: true,
            class: "alert-success",
            message: (
              <span>
                Successfully saved! <br /> Article will be reloaded.{" "}
              </span>
            ),
          },
          staticComponents: obj,
          languageState: result.is_translated,
          slug: slug,
          copy_from: "",
          schedule: result.schedule,
          slug_en: result.slug_en,
          "slug_zh-hant": result.slug_zh_hant,
          "slug_zh-hans": result.slug_zh_hans,
          slug_ja: result.slug_ja,
          slug_th: result.slug_th,
          status:
            typeof result.is_translated[I18n.current] != undefined &&
              result.is_translated[I18n.current] == "publish"
              ? "published"
              : "draft",
        });
        $that.removeAlert();
        localStorage.removeItem(this.localStorageName);
      })
      .fail((error) => {
        console.log(error);
        if (error.status == 409 || error.status == 422) {
          var e =
            error.responseText != ""
              ? error.responseText
              : "Slug already exists";

          $that.setState({
            alert: {
              show: true,
              class: "alert-danger",
              message: (
                <span>
                  {e} <br />
                  <a href={window.location.href}>reload</a>
                </span>
              ),
            },
          });
          if (error.responseText == "") {
            this.enableEditSlug();
          }
        } else {
          $that.setState({
            alert: {
              show: true,
              class: "alert-danger",
              message: (
                <span>
                  Article could not be saved. Unknown error <br />
                  <a href={window.location.href}>reload</a>
                </span>
              ),
            },
          });
        }
      })
      .always(() => {
        this.setState({ loading: false });
      });
  }
  removeAlert() {
    setTimeout(() => {
      this.setState({ alert: { show: false, class: "", message: "" } });
    }, 2000);
  }
  updateSchedule(date) {
    let schedule = { ...this.state.schedule };
    schedule[I18n.current] = date;
    this.setState({ schedule: schedule });
  }
  getCharCount(component, forced) {
    let f = typeof forced == "undefined" ? false : forced;
    let comp =
      typeof this.state == "undefined" || f ? component : this.state.component;
    if (typeof comp == "undefined" || typeof comp != "object") {
      return 0;
    }
    let t = comp.map((comp) => {
      if (comp.content == null) {
        return 0;
      }
      if (comp.type == "Title" || comp.type == "Text") {
        return $("<span>" + comp.content.text + "</span>").text().length;
      }
      if (comp.type == "Legacy") {
        return $("<span>" + comp.content + "</span>").text().length;
      }
      return 0;
    });
    let sum = 0;
    if (t.length) {
      sum = t.reduce((prev, cur) => {
        return prev + cur;
      });
    }
    return sum;
  }
  getWordCount(component, forced) {
    if (!this.props.editor) {
      return;
    }
    if (I18n.current != "en") {
      return;
    }

    let f = typeof forced == "undefined" ? false : forced;
    let comp =
      typeof this.state == "undefined" || f ? component : this.state.component;
    if (typeof comp == "undefined" || typeof comp != "object") {
      return 0;
    }
    let t = comp.map((comp) => {
      if (comp.content == null) {
        return 0;
      }
      if (comp.type == "Title" || comp.type == "Text") {
        return countWords($("<span>" + comp.content.text + "</span>").text());
      }
      if (comp.type == "BasicInformation") {
        var word = 0;
        for (var key in comp.content.elements) {
          if (
            comp.content.elements.hasOwnProperty(key) &&
            !key.includes("url")
          ) {
            word += countWords(comp.content.elements[key]);
          }
        }
        return word;
      }
      if (comp.type == "FlowList") {
        var word = 0;
        for (var key in comp.content.elements) {
          word += countWords(comp.content.elements[key].label);
          word += countWords(comp.content.elements[key].content);
        }
        return word;
      }
      if (comp.type == "Legacy") {
        return countWords($("<span>" + comp.content + "</span>").text());
      }
      return 0;
    });
    let sum = 0;
    if (t.length) {
      sum = t.reduce((prev, cur) => {
        return prev + cur;
      });
    }
    return sum;
  }
  updateCurChar(val) {
    this.setState({ curChar: this.state.curChar + val });
  }
  generateNavigation() {
    let navString = "<ol>";
    let openUl = false;
    var pos = this.state.components.filter((comp) => {
      return comp.type == "ArtNav";
    });
    let page = 1;
    this.state.components.map((components, i) => {
      if (components.type == "Page") {
        page += 1;
      }
      if (components.type == "Title") {
        if (components.content.headingType == "subheading" && !openUl) {
          navString += "<ol>";
          openUl = true;
        } else {
          if (i != 0) {
            navString += "</li>";
          }
        }
        if (components.content.headingType == "heading" && openUl) {
          navString += "</ol></li>";
          openUl = false;
        }

        let anchor = !pos.length ? components.id : components.id;
        let url = "#hl" + anchor;
        if (page > 1) {
          url = page + "/#hl" + anchor;
        }
        navString += '<li><a href="' + url + '">' + components.content.text;
        if (components.type == "ArtNav") {
          return components.position;
        }
      }
    });
    navString += "</ol>";

    let oldPos = pos.length ? pos[0].position : this.state.components.length;
    let id = pos.length ? pos[0].id : this.state.components.length;
    let newComponents = [...this.state.components];
    let navcomp = {
      type: "ArtNav",
      content: navString,
      position: oldPos,
      id: id,
    };
    newComponents[oldPos] = navcomp;
    this.setState({ components: newComponents });
  }
  shouldComponentUpdate(nextProps, nextState) {
    if (!this.props.editor) {
      return true;
    }
    if (this.state.components != nextState.components) {
      nextState.wordCount = this.getWordCount(nextState.components, true);
      return true;
    }

    if (
      this.state.components != nextState.components ||
      this.state.showModal != nextState.showModal ||
      this.state.alert != nextState.alert ||
      this.state.loading != nextState.loading ||
      this.state.slug != nextState.slug ||
      this.state.slugDisabled != nextState.slugDisabled ||
      this.state.markedComponent != nextState.markedComponent ||
      this.state.canoncialHidden != nextState.canoncialHidden ||
      this.state.unlist != nextState.unlist ||
      this.state.template != nextState.template
    ) {
      //this.setState({ curChar: this getCharCount(nextState.components) });
      return true;
    }
    if (this.state.curChar != nextState.curChar) {
      $("#cnt").text(nextState.curChar);
      return false;
    }
    return false;
  }
  renderComponents() {
    if (!this.props.editor) {
      return this.testFunc();
    }

    return this.state.components.map((comp, i) => {
      if (typeof comp.type == "undefined") {
        return;
      }
      let Component = Registry.getComponentByName(comp.type);

      return (
        <Component
          className={
            typeof this.state.markedComponent[comp.position] != "undefined"
              ? "active-glyph-record-bg marked-component-" + comp.id
              : ""
          }
          onComponentAction={(actionType, position) => {
            this.onComponentAction(actionType, position);
          }}
          position={comp.position}
          id={comp.id}
          edit={comp.edit}
          markedComponent={this.state.markedComponent}
          content={comp.content}
          updateState={(content, position) =>
            this.setContent(content, position)
          }
          updateEditState={(content, position) =>
            this.updateEditState(content, position)
          }
          editor={this.props.editor}
          compid={comp.id}
          updateCurChar={(val) => {
            this.updateCurChar(val);
          }}
          key={comp.id}
          analytics={comp.type == "HotelAffiliate" ? this.state.id : ""}
          lang={this.state.currentLanguage}
          category={
            this.props.editor && comp.type == "RelatedArticles"
              ? this.props.category
              : ""
          }
          renderComponents={this.renderEditorComponents.bind(this)}
        />
      );
    });
  }
  testFunc() {
    let cmp = this.state.components;
    let component = [];
    for (var i = this.lastrender; i < cmp.length; i++) {
      var comp = cmp[i];
      if (typeof comp.type == "undefined") {
        continue;
      }
      if (comp.type == "Page") {
        this.lastrender = i + 1;
        break;
      }
      let Component = Registry.getComponentByName(comp.type);
      component.push(
        <Component
          onComponentAction={(actionType, position) => {
            this.onComponentAction(actionType, position);
          }}
          position={comp.position}
          key={comp.id}
          edit={comp.edit}
          compid={comp.id}
          content={comp.content}
          updateState={(content, position) =>
            this.setContent(content, position)
          }
          editor={this.props.editor}
          updateCurChar={(val) => {
            this.updateCurChar(val);
          }}
          key={i}
        />
      );
    }
    return component;
  }
  updateSlug(ev) {
    let value = ev.target.value.replace("/", "");
    this.setState({ slug: value });
  }
  enableEditSlug() {
    this.setState({ slugDisabled: false }, () => {
      this.slugInput.focus();
    });
  }
  disableEditSlug() {
    this.setState({ slugDisabled: true });
  }
  renderSlug() {
    if (!this.props.editor) {
      return;
    }
    return (
      <div className="slug-editable">
        https://www.tsunagujapan.com/
        {this.state.currentLanguage == "en"
          ? ""
          : this.state.currentLanguage + "/"}
        {this.state.template == "otomo_tour" ? "tour/" : ""}
        {!this.state.slugDisabled ? (
          <input
            type="text"
            className="slug"
            value={this.state.slug}
            ref={(input) => {
              this.slugInput = input;
            }}
            onChange={(ev) => {
              this.updateSlug(ev);
            }}
            onBlur={this.disableEditSlug.bind(this)}
          />
        ) : (
          <span onClick={this.enableEditSlug.bind(this)}>
            {this.state.slug}
          </span>
        )}
      </div>
    );
  }
  renderStaticComponents() {
    let url =
      "https://www.tsunagujapan.com/absolutely-stunning-8-wonders-of-visiting-hokkaido-in-summer/";
    return this.state.staticComponents.map((comp) => {
      if (!comp.customRender) {
        return (
          <comp.type
            comp={this.state.components}
            changed={(type, tags) => {
              this.onChange(type, tags);
            }}
            key={comp.id}
            defaultValue={comp.val}
            editor={this.props.editor}
            lang={this.state.currentLanguage}
            updateCurChar={(val) => {
              this.updateCurChar(val);
            }}
          />
        );
      } else {
        return (
          <comp.type
            url={url}
            key={comp.id}
            config={{ title: this.state.title }}
            type="share"
          />
        );
      }
    });
  }
  renderSaveButtons() {
    if (!this.props.v) {
      return (
        <button
          className="btn btn-success btn-xs"
          onClick={this.saveArticle.bind(
            this,
            this.state.status == "published" ? false : true,
            null
          )}
        >
          Restore
        </button>
      );
    }
    return (
      <div>
        <button
          className="btn btn-success btn-xs"
          onClick={this.saveArticle.bind(this, false, null)}
        >
          {this.state.status == "published" ? "Update" : "Publish"}
        </button>
        <button
          className="btn btn-primary btn-xs"
          onClick={this.saveArticle.bind(this, true, null)}
        >
          {this.state.status == "published" ? "Unpublish" : "Save as draft"}
        </button>
        <a
          className="btn btn-default btn-xs"
          href={"/" + this.state.currentLanguage + "/" + this.state.slug}
          target="_blank"
        >
          Preview
        </a>
      </div>
    );
  }
  updateGrouping(val, key) {
    let old = [...this.state.article_group];
    old[key] = val;
    this.setState({ article_group: old });
  }
  changeCanoncial(evt) {
    this.setState({ canonical: evt.target.value });
  }
  toggleCanonicalHidden() {
    this.setState({ canoncialHidden: !this.state.canoncialHidden });
  }
  toggleUnlist() {
    this.setState({ unlist: !this.state.unlist });
  }
  handleTemplateChange(evt) {
    this.setState({ template: evt.target.value });
  }
  renderEditorRight() {
    if (!this.props.editor) {
      return;
    }

    return (
      <div>
        <div className="col-xs-12 col-sm-4 col-sm-push-8 editor-sidebar">
          <div className="editor-action-buttons">
            Status: {this.state.status}
            <br />
            <br />
            {this.renderSaveButtons()}
          </div>
          <h5 className="black-border">Language of this post</h5>
          <select
            value={this.props.currentLanguage}
            defaultValue={this.state.currentLanguage}
            onChange={this.changeLanguage.bind(this)}
          >
            {I18n.availableLanguages.map((lang, i) => {
              return (
                <option value={lang} key={i}>
                  {lang}
                </option>
              );
            })}
          </select>
          <br />
          <div className="copy-content">
            <h5 className="black-border">Copy from language</h5>
            <select
              className="selectpicker"
              value={"-2"}
              onChange={this.copyFromLang.bind(this)}
            >
              <option value="-2">--</option>
              {Object.keys(this.props.article.article.is_translated).map(
                (lang, i) => {
                  if (lang == I18n.current) {
                    return;
                  }
                  return (
                    <option value={lang} key={i}>
                      {lang}
                    </option>
                  );
                }
              )}
            </select>
          </div>
          <h5 className="black-border">Template Settings </h5>
          <input
            type="checkbox"
            checked={this.state.unlist}
            onChange={this.toggleUnlist.bind(this)}
          />
          Unlist <br />
          <select
            defaultValue={this.state.template}
            onChange={this.handleTemplateChange.bind(this)}
          >
            <option value="article">Article</option>
            <option value="landingpage">Landingpage</option>
            <option value="coupon">Coupon</option>
            <option value="otomo_tour">Otomo Tour</option>
          </select>
          <h5 className="black-border">Related Group </h5>
          <EditorRightGroupings
            selected={
              this.state.article_group[0] != undefined
                ? this.state.article_group[0]
                : 0
            }
            changed={this.updateGrouping.bind(this)}
            key={0}
            pos={0}
          />
          <EditorRightGroupings
            selected={
              this.state.article_group[1] != undefined
                ? this.state.article_group[1]
                : 0
            }
            changed={this.updateGrouping.bind(this)}
            key={1}
            pos={1}
          />
          <EditorRightGroupings
            selected={
              this.state.article_group[2] != undefined
                ? this.state.article_group[2]
                : 0
            }
            changed={this.updateGrouping.bind(this)}
            key={2}
            pos={2}
          />
          <EditorRightGroupings
            selected={
              this.state.article_group[3] != undefined
                ? this.state.article_group[3]
                : 0
            }
            changed={this.updateGrouping.bind(this)}
            key={3}
            pos={3}
          />
          <SideMenu
            onChange={(type, tags) => {
              this.onChange(type, tags);
            }}
            tags={this.props.tags}
            sponsoredContent={this.state.sponsoredContent}
            currentTags={this.state.tags}
            category={this.props.category}
            tagGroups={this.props.tagGroups}
            articleTagGroups={this.state.articleTagGroups}
            currentCateogry={this.state.articleCategory}
            schedule={this.state.schedule}
            promo={this.state.isPromotional}
            areas={this.props.area}
            updateDate={this.updateSchedule.bind(this)}
            articleArea={this.state.articleArea}
            relatedArticles={this.state.relatedArticles}
            generateNavigation={() => {
              this.generateNavigation();
            }}
            user={this.state.author}
            translator={this.state.translator}
            users={this.props.user_select}
          />
          <div className="copy-content">
            <h5
              className="black-border"
              onClick={this.toggleCanonicalHidden.bind(this)}
            >
              Canonical <span className="glyphicon glyphicon-alert" />
            </h5>
            <div className={this.state.canoncialHidden ? " hidden" : ""}>
              <small>
                <span
                  className="glyphicon glyphicon-alert"
                  style={{ color: "red" }}
                />
                Use with care
              </small>
              <input
                type="text"
                className="form-control"
                defaultValue={this.state.canonical}
                onChange={this.changeCanoncial.bind(this)}
              />
            </div>
          </div>
          {this.state.isLegacy ? (
            <div
              onClick={this.changeLegacyArticleToDefault.bind(this)}
              className="btn btn-default"
            >
              Convert Legacy article to new
            </div>
          ) : (
            ""
          )}
        </div>
      </div>
    );
    //<HistoryList id={this.state.id} />
  }
  renderEditorComponents(pos) {
    if (!this.props.editor || this.state.isLegacy) {
      return;
    }
    let position = typeof pos == "undefined" ? null : pos;
    return (
      <EditorComponents
        onComponentClick={(data, pos) => {
          this.onComponentClick(data, pos);
        }}
        pos={position}
      />
    );
  }
  toggleModal() {
    this.setState({ showModal: !this.state.showModal });
  }

  renderAlert() {
    if (!this.state.alert.show) return;
    return (
      <Alert
        classes={this.state.alert.class}
        message={this.state.alert.message}
      />
    );
  }
  deselectMarkedComponents() {
    this.setState({ markedComponent: {} });
  }
  renderLangInfo() {
    if (!this.props.editor) {
      return;
    }
    return (
      <div className="cur-editing alert alert-info">
        id: {this.state.id} <br />
        Currently editing: {this.state.currentLanguage} <br />
        char count: <span id="cnt">{this.state.curChar}</span> <br />
        {I18n.current == "en" ? (
          <span>
            {" "}
            word count: <span>{this.state.wordCount}</span>
          </span>
        ) : (
          ""
        )}{" "}
        <br />
        {Object.keys(this.state.markedComponent).length ? (
          <button onClick={this.deselectMarkedComponents.bind(this)}>
            Deselect ({Object.keys(this.state.markedComponent).length})
          </button>
        ) : (
          ""
        )}
      </div>
    );
  }
  renderPagination() {
    if (this.state.pages <= 1) {
      return;
    }
    return (
      <nav className="pagination" style={{ display: "block" }}>
        <div className="page-list">{this.renderPageTag()}</div>
      </nav>
    );
  }
  renderPageTag() {
    if (this.props.editor) {
      return;
    }
    let el = [];
    for (let i = 1; i <= this.state.pages; i++) {
      let linkPrm = i == 1 ? "" : i;

      let link = link_path(this.props.articlePath, [
        { value: this.props.article.article.slug, key: ":param" },
        { value: linkPrm, key: ":page" },
      ]);
      if (this.state.currentLanguage != "en") {
        link = "/" + this.state.currentLanguage + link;
      }
      if (i == this.state.curPage) {
        el.push(
          <span key={i} className="page current">
            {i}{" "}
          </span>
        );
      } else {
        el.push(
          <span key={i} className="page">
            <a
              rel={i > this.state.curPage ? "next" : "prev"}
              href={link}
              className="page"
              onClick={this.changePage.bind(this, i)}
            >
              {i}{" "}
            </a>
          </span>
        );
      }
    }
    return el;
  }
  changePage(page, ev) {
    /* ev.preventDefault()

         this.setLastRender(page)

         this.setState({ curPage: page });
         document.querySelector(".excerp").scrollIntoView()

         history.pushState({}, "", ev.target.href);*/
  }
  setLastRender(page, component) {
    let cmp;
    if (typeof component != "undefined") {
      cmp = component;
    } else {
      cmp = this.state.components;
    }
    if (page == 1) {
      this.lastrender = 0;
      return;
    }
    let seperatorCounter = 1;
    for (let i = 0; i < cmp.length; i++) {
      if (cmp[i].type != "undefined" && cmp[i].type == "Page") {
        seperatorCounter++;
        if (seperatorCounter == page) {
          this.lastrender = i + 1;
          break;
        }
      }
    }
  }
  renderLoading() {
    if (this.state.loading) {
      return (
        <div className="overlay">
          <div className="loader" />
        </div>
      );
    }
  }
  renderHotelSearch() {
    if (!this.props.editor) {
      return;
    }
    return (
      <Hotel
        edit={false}
        editor={true}
        position={this.getComponentPosition.bind(this)}
        updateState={(content, position) =>
          this.addHotelComponent(content, position)
        }
        updateEditState={(content, position) => {
          return;
        }}
      />
    );
  }
  render() {
    let classes = this.props.editor
      ? "col-xs-12 col-sm-8 col-sm-pull-4 " + this.state.wrapperClass
      : "";
    return (
      <div>
        {this.renderLangInfo()}
        {this.renderAlert()}

        {this.renderLoading()}
        <Modal
          isOpen={this.state.showModal}
          onClose={this.toggleModal.bind(this)}
        >
          <div className="modal-body">Do you want to restor your changes?</div>
          <div className="modal-footer">
            <button
              type="button"
              onClick={this.loadFromStorage.bind(this)}
              className="btn btn-primary"
            >
              Yes
            </button>
            <button
              type="button"
              onClick={this.removeFromLocalStorage.bind(this)}
              className="btn btn-default"
            >
              No
            </button>
          </div>
        </Modal>
        {this.renderHotelSearch()}

        {this.renderEditorRight()}

        <div className={classes}>
          <div className="blog-entry">
            {this.renderSlug()}
            {this.renderStaticComponents()}
            <div className="clear" />
            {this.renderComponents()}
          </div>
          {this.renderPagination()}
          {this.renderEditorComponents()}
        </div>
      </div>
    );
  }
}
