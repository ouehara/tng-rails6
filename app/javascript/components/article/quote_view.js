import React from "react";

export default class QuoteView extends React.Component {
  render() {
    return (
      <blockquote>
        <p>{this.props.quote}</p>
        <footer>
          <cite title="Source Title">{this.props.url}</cite>
        </footer>
      </blockquote>
    );
  }
}
