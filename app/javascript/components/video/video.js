import React from "react";

class Video extends React.Component {
  constructor(props) {
    super(props);
    this.videoContainer = React.createRef();
    this.toggleShowVideo = this.toggleShowVideo.bind(this);
    this.state = {
      showVideo: this.props.autoplay,
      scrollTo: "",
      renderTop: this.props.autoplay !== ""
    };
  }

  componentDidMount() {
    this.checkForPlay();
  }

  componentDidUpdate() {
    this.checkForPlay();
  }

  isInViewport(offset = 0) {
    if (!this.videoContainer.current) return false;
    const top = this.videoContainer.current.getBoundingClientRect().top;
    return top + offset >= 0 && top - offset <= window.innerHeight;
  }

  checkForPlay() {
    if (this.state.showVideo !== "") {
      this.videoContainer.current.scrollIntoView({
        behavior: "smooth",
        block: "center",
        inline: "center"
      });
      window.setTimeout(() => {
        if (!this.isInViewport()) {
          this.checkForPlay();
        }
      }, 300);
    }
  }

  toggleShowVideo(evt) {
    const url = evt.target.getAttribute("data-url");
    const old = this.state.showVideo;
    this.setState({ showVideo: url });
    if (url === "") {
      document.querySelector("#th-" + old).scrollIntoView({
        behavior: "smooth",
        block: "center",
        inline: "center"
      });
    }
  }

  renderVideo(url) {
    return (
      <div className="flex-full-width video-fullwidth-wrapper" id={"vi-" + url} ref={this.videoContainer}>
        <div className="hide-video" data-url="" onClick={this.toggleShowVideo}>&times;</div>
        <div className="video-wrapper video-page-size">
          <iframe className="ytplayer" type="text/html" src={`https://www.youtube.com/embed/${url}?playsinline=1`} frameBorder="0" allow="autoplay; fullscreen"></iframe>
        </div>
      </div>
    );
  }

  mobile() {
    return window.matchMedia("(max-width: 500px)").matches;
  }

  renderThumb(url) {
    return <img src={`https://i.ytimg.com/vi/${url}/hqdefault.jpg`} className="img-responsive" data-url={url} onClick={this.toggleShowVideo} />;
  }

  renderChild(video) {
    return (
      <div className="tour-child flex-column" key={video.link} id={"th-" + video.link}>
        <div className="tour-header">{this.mobile() ? this.renderVideo(video.link) : this.renderThumb(video.link)}</div>
        <div className="tour-body">
          <h3>{video.title}</h3>
          <small className="video-user-name">{video.user}</small>
        </div>
      </div>
    );
  }

  render() {
    const { videos, autoplay } = this.props;
    let resultsRender = [];
    let shouldShow = false;
    const { showVideo, renderTop } = this.state;
    for (let i = 0; i < videos.length; i++) {
      if (showVideo === autoplay && i === 0 && renderTop) {
        resultsRender.push(this.renderVideo(showVideo));
      }

      resultsRender.push(this.renderChild(videos[i]));
      shouldShow = shouldShow || showVideo === videos[i].link;

      if ((i % 3 === 2 || i === videos.length - 1) && shouldShow && showVideo !== autoplay && !this.mobile()) {
        shouldShow = false;
        resultsRender.push(this.renderVideo(showVideo));
      }
    }

    return <div className="tour-wrapper">{resultsRender}</div>;
  }
}

export default Video;
