import React from "react";

export default class VideoSearchResult extends React.Component {
  render() {
    return (
      <div>
        <div className="col-xs-4" title={this.props.desc}>
          <img src={this.props.img} className="img-responsive" />
          <p className="ellipsis">{this.props.desc} </p>
        </div>
      </div>
    );
  }
}
