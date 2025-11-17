import EditorBase from "./editor_base.es6";
import React from "react";
import LoadScript from "../../components/shared_components/load_script";
export default class Legacy extends EditorBase {
  constructor(props) {
    super(props);
    let content = "";
    if (typeof this.props.content["text"] != "undefined") {
      content = this.props.content["text"];
    } else {
      content = this.props.content;
    }

    this.state = {
      text: content,
      textlenght: $("<span>" + this.props.content + "</span>").text().length,
      lang: this.props.lang
    };
    this.ckedit = null;
  }
  shouldComponentUpdate(nextProps, nextState) {
    if (this.state.textlenght != nextState.textlenght) {
      return false;
    }
    return true;
  }
  componentWillReceiveProps(nextProps) {
    let content = "";
    if (typeof nextProps.content["text"] != "undefined") {
      content = nextProps.content["text"];
    } else if (typeof nextProps.content != "undefined") {
      content = nextProps.content;
    }
    if (content != this.state.text) {
      this.setState({ text: content, lang: nextProps.lang });
      if (nextProps.lang != this.state.lang) {
        this.ckedit.setData(content);
      }
    }

    //     this.setState({ text: content });
  }
  componentDidUpdate() {
    if (this.state.edit) {
      this.initEditor();
    }
  }
  componentDidMount() {
    this.initEditor();
  }
  initEditor() {
    if (this.ckedit != null) {
      return;
    }
    let ls = new LoadScript();
    ls.ckEditor(() => {
      CKEDITOR.plugins.addExternal("find", "/assets/js/find/", "plugin.js");
      CKEDITOR.plugins.addExternal("iframe", "/assets/js/iframe/", "plugin.js");
      CKEDITOR.plugins.addExternal("font", "/assets/js/font/", "plugin.js");
      CKEDITOR.plugins.addExternal("widget", "/assets/js/widget/", "plugin.js");
      CKEDITOR.plugins.addExternal(
        "widgetselection",
        "/assets/js/widgetselection/",
        "plugin.js"
      );
      CKEDITOR.plugins.addExternal(
        "lineutils",
        "/assets/js/lineutils/",
        "plugin.js"
      );
      CKEDITOR.plugins.addExternal("image2", "/assets/js/image2/", "plugin.js");
      CKEDITOR.plugins.addExternal(
        "openlink",
        "/assets/js/openlink/",
        "plugin.js"
      );
      CKEDITOR.plugins.addExternal(
        "justify",
        "/assets/js/justify/",
        "plugin.js"
      );
      this.ckedit = CKEDITOR.replace("legacyEditor", {
        height: 260,
        extraPlugins:
          "find,iframe,font,widget,widgetselection,lineutils,image2,openlink,justify"
      });
      let content = "";
      if (typeof this.props.content["text"] != "undefined") {
        content = this.props.content["text"];
      } else {
        content = this.props.content;
      }
      this.ckedit.setData(content);
      this.ckedit.config.extraAllowedContent = [
        "div(*)",
        "span(*)",
        "address(*)",
        "br(*)",
        "*{*}",
        "*[id]"
      ];
      this.ckedit.config.versionCheck = false;
      this.ckedit.on("change", evt => {
        let val = this.ckedit.getData();
        let test = this.ckedit.document.getBody().getText();
        let length = test.length - this.state.textlenght;
        if (val != this.state.text) {
          this.props.updateCurChar(length);
          this.props.updateState(
            {
              text: val,
              edit: false
            },
            this.props.position
          );
          this.setState({ textlenght: this.state.textlenght + length });
        }
      });
    });
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <textarea
        cols="80"
        id="legacyEditor"
        name="legacyEditor"
        rows="10"
        value={this.state.text}
      >
        {this.state.text}
      </textarea>
    );
  }
  createMarkup() {
    return { __html: this.state.text };
  }
  render() {
    return (
      <div>
        <div className={this.state.edit ? "hidden" : "legacy"}>
          <div onClick={this.toggleEdit.bind(this)}>
            <div dangerouslySetInnerHTML={this.createMarkup.call(this)} />
          </div>
        </div>
        <div className={this.state.edit ? "" : "hidden"}>
          {this.renderEditor()}
        </div>
      </div>
    );
  }
}
