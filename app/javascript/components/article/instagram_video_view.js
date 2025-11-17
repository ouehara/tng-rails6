import React from "react";
import { INSTAGRAM_API_CONFIG } from "../conf/instagram_config";

export default class InstagramVideoView extends React.Component {
  constructor(props) {
    super(props);
    this.state = { instaContent: null, url: props.url };
    this._timer = null;
  }

  componentDidMount() {
    if (!window.instgrm) {
      const script = document.createElement("script");
      script.src = "https://platform.instagram.com/en_US/embeds.js";
      script.async = true;
      document.body.appendChild(script);
    }
    this.checkAPI().then(() => this.getInsta());
  }

  componentDidUpdate(prevProps) {
    if (this.props.url !== prevProps.url) {
      this.setState({ url: this.props.url }, () => {
        this.checkAPI().then(() => this.getInsta());
      });
    }
  }

  componentWillUnmount() {
    if (this._timer) {
      clearTimeout(this._timer);
    }
  }

  checkAPI() {
    return new Promise((resolve) => {
      const check = () => {
        this._timer = setTimeout(() => {
          if (window.instgrm) {
            clearTimeout(this._timer);
            resolve();
          } else {
            check();
          }
        }, 50);
      };
      check();
    });
  }

  async getInsta() {
    if (!this.state.url) return;
    try {
      const response = await fetch(
        `${INSTAGRAM_API_CONFIG.baseUrl}?url=${this.state.url}&access_token=${INSTAGRAM_API_CONFIG.accessToken}`
      );
      if (!response.ok) return;
      const data = await response.json();
      this.setState({ instaContent: data }, () => {
        if (window.instgrm && typeof window.instgrm.Embeds !== "undefined") {
          window.instgrm.Embeds.process();
        }
      });
    } catch (e) {
      // エラー時は何もしない
    }
  }

  render() {
    const { instaContent } = this.state;
    if (!instaContent || !instaContent.html) return <div />;
    return <div dangerouslySetInnerHTML={{ __html: instaContent.html }} />;
  }
}
