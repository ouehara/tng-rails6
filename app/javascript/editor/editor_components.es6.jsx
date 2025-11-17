import React from "react";
export default class EditorComponents extends React.Component {
  render() {
    return (
      <div className="btn-group">
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Title",
            this.props.pos
          )}
          title="Headline"
        >
          <i className="fa fa-header" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Text",
            this.props.pos
          )}
          title="text"
        >
          <i className="fa fa-font" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Link",
            this.props.pos
          )}
          title="Link"
        >
          <i className="fa fa-link" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Quote",
            this.props.pos
          )}
          title="Quote"
        >
          <i className="fa fa-quote-right" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Video",
            this.props.pos
          )}
          title="Video"
        >
          <i className="fa fa-video-camera" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "InstagramVideo",
            this.props.pos
          )}
          title="Instagram Video"
        >
          <i className="fa fa-video-camera" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Images",
            this.props.pos
          )}
          title="Image"
        >
          <i className="fa fa-picture-o" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Twitter",
            this.props.pos
          )}
          title="Twitter"
        >
          <i className="fa fa-twitter-square" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Maps",
            this.props.pos
          )}
          title="Maps"
        >
          <i className="fa fa-map-marker" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Page",
            this.props.pos
          )}
          title="Page Seperator"
        >
          -
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "BasicInformation",
            this.props.pos
          )}
          title="Basic Information"
        >
          <i className="fa fa-info-circle" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "FlowList",
            this.props.pos
          )}
          title="Custom Informations"
        >
          <i className="glyphicon glyphicon-list-alt" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "RelatedArticles",
            this.props.pos
          )}
          title="Related Articles"
        >
          <i className="fa fa-newspaper-o" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "EditorButtons",
            this.props.pos
          )}
          title="Buttons"
        >
          <i className="fa fa-tag" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "RelatedGroup",
            this.props.pos
          )}
          title="Group"
        >
          <i className="fa fa-object-group" aria-hidden="true" />
        </div>
        <div
          className="btn btn-default"
          onClick={this.props.onComponentClick.bind(
            null,
            "Otomo",
            this.props.pos
          )}
          title="Otomo"
        >
          O
        </div>
      </div>
    );
  }
}

/*
EditorComponents.propTypes = {
  onComponentClick: React.PropTypes.func
};
*/
