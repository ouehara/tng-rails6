import React from "react";

export default class ArticleSns extends React.PureComponent {
  renderSnsList() {
    if (!this.props.elements.type.length) return;
    const title_encoded = encodeURIComponent(this.props.elements.page_title);
    return Object.keys(this.props.elements.type).map((key, index) => {
      let classes = `post_sns-item ${this.props.elements.type[key].class_name}`;
      let url = "";

      if (
        this.props.locale != "zh-hans" &&
        this.props.elements.type[key].name == "Weibo"
      ) {
        return "";
      }

      switch (this.props.elements.type[key].name) {
        case "Weibo":
          url = `http://service.weibo.com/share/share.php?url=${this.props.elements.page_url}&appkey=&title=${title_encoded}&pic=&ralateUid=&language=zh_cn`;
          break;
        case "Facebook":
          url = `http://www.facebook.com/share.php?u=${this.props.elements.page_url}&title=${title_encoded}`;
          break;
        case "X":
          url = `http://twitter.com/share?url=${this.props.elements.page_url}&text=${title_encoded}`;
          break;
        case "Pinterest":
          url = `javascript:void((function()%7Bvar%20e=document.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src','//assets.pinterest.com/js/pinmarklet.js?r='+Math.random()*99999999);document.body.appendChild(e)%7D)());`;
          break;
      }

      return (
        <li className={classes} key={index}>
          <a href={url} target="_blank">
            {this.props.elements.type[key].link_text}
          </a>
        </li>
      );
    });
  }

  render() {
    return <ul className={`post_sns ${this.props.position}`}>{this.renderSnsList()}</ul>;
  }
}
