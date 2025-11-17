import React from "react";
export default class VideoView extends React.Component {
  getVideoUrl() {
    switch (this.props.videoType) {
      case "url":
        return this.props.video;
      case "yt":
        return "https://www.youtube.com/embed/" + this.props.video;
      case "vimeo":
        return (
          "https://player.vimeo.com/video/" +
          this.props.video.replace("/videos/", "")
        );
    }
  }
  render() {
    return (
      <div className="video-wrapper">
        <iframe
          width="560"
          height="315"
          src={this.getVideoUrl()}
          frameborder="0"
          allowfullscreen
        />
      </div>
    );
  }
}
