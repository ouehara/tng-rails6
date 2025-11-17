import React from "react";
import LoadScript from "../shared_components/load_script";
export default class MapView extends React.Component {
  constructor(props) {
    super(props);
    this.mapsId = this.props.name.replace(/,/g, "");
    this.mapsId = "map" + this.mapsId.replace(/\s/g, "");
  }
  initMap() {
    $that = this;
    /*new google.maps.Map(document.querySelector("#" + this.mapsId), {
      center:  $that.props.location ,
      zoom: 13,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });*/
  }
  componentDidMount() {
    if (typeof google != "undefined" && typeof google.maps == "object") {
      return;
    }
    let ls = new LoadScript();
    ls.loadMapsApi(this.initMap.bind(this));
  }
  renderMap() {
    if (this.props.location == "") {
      return <span />;
    }
    return (
      <div className="responsive-maps">
        <iframe
          width="600"
          height="450"
          frameBorder="0"
          style={{ border: 0 }}
          src={
            "https://www.google.com/maps/embed/v1/place?q=place_id:" +
            this.props.location +
            "&key=AIzaSyD9cjpu-HTxdu1_B9tzzaq5WkLhOKu1pac"
          }
          allowFullScreen
        />
      </div>
    );
  }
  render() {
    return this.renderMap();
  }
}
