import EditorBase from "./editor_base.es6";
import TextView from "../../components/article/text_view.es6";
import ComponentMenu from "./component_menu.es6";
import React from "react";
import LoadScript from "../../components/shared_components/load_script";
export default class Text extends EditorBase {
  constructor(props) {
    super(props);
    let text = "";
    this.ckedit = null;
    if (this.props.editor) {
      this.ls = new LoadScript();
    }
    if (this.props.content != null) {
      text = this.props.content.text;
    }
    this.state = {
      text: text,
      edit: this.props.edit,
      oldText: text,
      textlength: $("<span>" + this.props.content + "</span>").text().length,
      editorId: "editor" + this.props.position,
      mode: "wysiwyg",
    };
  }
  componentWillReceiveProps(nextProps) {
    let text = "";
    if (!this.state.edit && this.ckedit != null) {
      this.ckedit.destroy();
      this.ckedit = null;
    }

    if (nextProps.content != null && !this.state.edit) {
      text = nextProps.content.text;
    }

    if (!this.state.edit) {
      this.setState({
        text: text,
        edit: nextProps.edit,
        oldText: text,
        textlength: $("<span>" + nextProps.content + "</span>").text().length,
        editorId: "editor" + this.props.position,
      });
    }
  }
  setText(text, textlength) {
    this.setState({ text: text, textlength: textlength });
  }
  cancelAction() {
    this.setState({ text: this.state.oldText });
    this.props.updateEditState(
      {
        edit: false,
      },
      this.props.position
    );
    this.customToggleEdit();
    this.props.updateEditState(
      {
        edit: false,
      },
      this.props.position
    );
  }
  saveText() {
    if (this.state.mode == "source") {
      alert("Please switch to visual mode before you save!");
      return;
    }
    this.setState({ oldText: this.state.text });
    this.props.updateState(
      {
        text: this.state.text,
      },
      this.props.position
    );
    this.customToggleEdit();
  }
  componentDidMount() {
    if (this.state.edit) {
      this.initCkEditor();
    }
  }
  componentDidUpdate() {
    if (this.state.edit) {
      this.initCkEditor();
    }
  }

  initCkEditor() {
    if (this.ckedit != null) {
      return;
    }
    this.ls.ckEditor(() => {
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
      this.ckedit = CKEDITOR.replace(this._textarea, {
        height: 260,
        removePlugins: 'image',
        extraPlugins:
          "find,iframe,font,widget,widgetselection,lineutils,image2,openlink,justify",
      });
      this.ckedit.setData(this.state.text);
      this.ckedit.on("change", (evt) => {
        let val = this.ckedit.getData();
        let test = this.ckedit.document.getBody().getText();
        let length = test.length - this.state.textlength;
        this.props.updateCurChar(length);
        this.setText(val, this.state.textlength + length);
      });
      this.ckedit.config.extraAllowedContent = [
        "div[*](*)",
        "span(*)",
        "address(*)",
        "video[*]{*}",
        "source[*]{*}",
        "a[*](*)",
        "br(*)",
        "script[*](*)",
        "*{*}",
        "*[id]",
        "details",
        "summary",
        "audio[*]{*}",
        "svg[*](*)",
        "g[*](*)",
        "path[*](*)",
        "blockquote[*](*)",
        "ins[*](*)",
        "h4(*)",
        "p(*)"
      ];
      this.ckedit.config.versionCheck = false;
      this.ckedit.addCommand("myGreetingCommand", {
        exec: (editor, data) => {
          this.saveText();
        },
      });
      this.ckedit.addCommand("insertCoupon", {
        exec: function (editor) {
          editor.insertHtml(
            '<div class="coupon_wrapper">' +
            '<div class="ribbon"> tsunagu Japan Coupon</div>' +
            '<p style="text-align: center;"><strong><span style="font-size:72px">5</span><span style="font-size:48px">% off</span></strong></p>' +
            '<div class="coupon_highlight">' +
            '<p style="text-align: center;">Show this coupon along with your passport<br />' +
            "at the register before payment.</p>" +
            '<p style="text-align: center;"><img alt="" height="163" src="https://internationalbarcodes.com/wp-content/uploads/sites/95/2013/11/SSCC-Pallet-Barcode.jpg" width="350" /></p>' +
            "</div>" +
            '<p style="text-align: center;"><span style="font-size:12px">valid until Decemebr 2019</span></p>' +
            "</div>"
          );
        },
      });
      this.ckedit.ui.addButton("Coupon", {
        label: "Coupon",
        icon: "//" + window.location.host + "/assets/coupon.png",
        command: "insertCoupon",
        toolbar: "insert,100",
      });
      this.ckedit.addCommand("myGreetingCommand", {
        exec: (editor, data) => {
          this.saveText();
        },
      });
      this.ckedit.addCommand("insertLinkBlock", {
        exec: function (editor) {
          editor.insertHtml(
            '<div class="linkBlock_wrapper">' +
            '<p class="linkBlock_label">Our Top Tips</p>' +
            '<h4 class="linkBlock_heading">Link Block Heading</h4>' +
            '<p>linkBlock text text text text text text text text text text</p>' +
            '<div class="linkBlock_action"><a href="https://www.tsunagujapan.com/" target="_blank" rel="sponsored" class="btn-spacing btn book-with btn-normal">More Details</a></div>' +
            '</div>'
          );
        },
      });
      this.ckedit.ui.addButton("LinkBlock", {
        label: "LinkBlock",
        icon: "//" + window.location.host + "/assets/external-link.png",
        command: "insertLinkBlock",
        toolbar: "insert,101",
      });
      this.ckedit.addCommand("myGreetingCommand", {
        exec: (editor, data) => {
          this.saveText();
        },
      });
      this.ckedit.on("mode", () => {
        this.setState({ mode: this.ckedit.mode });
      });
      this.ckedit.keystrokeHandler.keystrokes[CKEDITOR.CTRL + 83] =
        "myGreetingCommand";
    });
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden" : ""}>
          {this.state.text == "" ? "click to edit" : ""}
          <textarea
            ref={(ref) => (this._textarea = ref)}
            defaultValue={this.state.text}
            className="col-xs-12 editor-textarea"
            id={this.state.editorId}
          />
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
                  cancelAction={
                    this.state.edit ? this.cancelAction.bind(this) : false
                  }
                  renderExtendedMenu={this.props.renderComponents}
                />
              );
            }
          })()}
        </div>
      </div>
    );
  }
  customToggleEdit() {
    this.toggleEdit();
    if (!this.props.editor) {
      return;
    }
    if (!this.state.edit) {
      this.props.updateEditState(
        {
          edit: true,
        },
        this.props.position
      );
    } else {
      if (this.ckedit != null) this.ckedit.destroy();
    }
    this.setState({ edit: !this.state.edit }, () => {
      window.requestAnimationFrame(() => {
        if (this.state.edit) {
          document.querySelector(".editor-open").scrollIntoView();
        }
      });
    });
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
        <div
          className={this.state.edit ? "hidden" : ""}
          onClick={this.customToggleEdit.bind(this)}
        >
          <TextView text={this.state.text} />
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
