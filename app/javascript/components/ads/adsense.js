import React from "react";

// <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
// add to top of the page
class Adsense extends React.Component {
  componentDidMount() {
    if (window) (window.adsbygoogle = window.adsbygoogle || []).push({});
  }

  render() {
    return (
      <ins className={`${this.props.className} adsbygoogle`}
        style={this.props.style}
        data-ad-client={this.props.client}
        data-ad-slot={this.props.slot}
        data-ad-layout={this.props.layout}
        data-ad-layout-key={this.props.layoutKey}
        data-ad-format={this.props.format}
        data-full-width-responsive={this.props.responsive}></ins>
    );
  }
}
/*
Adsense.propTypes = {
  style: PropTypes.object,
  client: PropTypes.string.isRequired,
  slot: PropTypes.string.isRequired,
  format: PropTypes.string
};
Adsense.defaultProps = {
  style: { display: "block" },
  format: "auto"
};*/
export default Adsense;
