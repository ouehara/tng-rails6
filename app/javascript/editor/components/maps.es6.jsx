import EditorBase from "./editor_base.es6";
import MapView from "../../components/article/map_view";
import ComponentMenu from "./component_menu.es6";
import React from "react";
import LoadScript from "../../components/shared_components/load_script";
export default class Maps extends EditorBase {
  constructor(props) {
    super(props);
    this.map = null;
    this.mapsId = "maps" + this.props.position;
    this.searchId = "search" + this.props.position;
    this.searchBox = null;
    let loc = "";
    let name = "";
    if (this.props.content != null) {
      loc = this.props.content.location;
      name = this.props.content.name;
    }
    this.state = { location: loc, search: name };
  }
  componentWillMount() {
    if (typeof google != "undefined" && typeof google.maps == "object") {
      return;
    }
    let ls = new LoadScript();
    ls.loadMapsApi();
  }
  initMap() {
    this.map = new google.maps.Map(document.querySelector("#" + this.mapsId), {
      center: { lat: 35.6668475, lng: 139.6576066 },
      zoom: 13,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    setTimeout(this.initSearch.bind(this), 0);
  }
  toggleEdit() {
    if (!this.props.editor) {
      return;
    }
    let edit = !this.state.edit;
    this.setState({ edit: edit });
    if (edit) {
      if (this.map != null) {
        setTimeout(google.maps.event.trigger.bind(this.map, "resize"), 100);
        return;
      }
      setTimeout(this.initMap.bind(this), 100);
    }
  }
  initSearch() {
    this.searchBox = new google.maps.places.SearchBox(
      document.querySelector("#" + this.searchId)
    );
    let $that = this;
    this.map.addListener("bounds_changed", function() {
      $that.searchBox.setBounds($that.map.getBounds());
    });
    var markers = [];
    // Listen for the event fired when the user selects a prediction and retrieve
    // more details for that place.
    this.searchBox.addListener("places_changed", function() {
      var places = $that.searchBox.getPlaces();

      if (places.length == 0) {
        return;
      }
      $that.setState({ search: places[0].formatted_address });
      // Clear out the old markers.
      markers.forEach(function(marker) {
        marker.setMap(null);
      });
      markers = [];

      // For each place, get the icon, name and location.
      var bounds = new google.maps.LatLngBounds();
      places.forEach(function(place) {
        var icon = {
          url: place.icon,
          size: new google.maps.Size(71, 71),
          origin: new google.maps.Point(0, 0),
          anchor: new google.maps.Point(17, 34),
          scaledSize: new google.maps.Size(25, 25)
        };

        // Create a marker for each place.
        markers.push(
          new google.maps.Marker({
            map: $that.map,
            icon: icon,
            title: place.name,
            position: place.geometry.location
          })
        );

        if (place.geometry.viewport) {
          // Only geocodes have viewport.
          bounds.union(place.geometry.viewport);
        } else {
          bounds.extend(place.geometry.location);
        }
      });
      $that.map.fitBounds(bounds);
    });
    var geocoder = new google.maps.Geocoder();
    google.maps.event.addListener(this.map, "click", function(event) {
      markers.forEach(function(marker) {
        marker.setMap(null);
      });
      markers = [];
      geocoder.geocode(
        {
          latLng: event.latLng
        },
        function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
            if (results[0]) {
              $that.setState({ search: results[0].formatted_address });
              markers.push(
                new google.maps.Marker({
                  map: $that.map,
                  icon: "http://maps.gstatic.com/mapfiles/circle.png",
                  title: results[0].name,
                  position: results[0].geometry.location
                })
              );
            }
          }
        }
      );
    });
  }
  addMap(videoId) {
    let $that = this;
    $.ajax({
      url:
        "https://maps.googleapis.com/maps/api/geocode/json?address=" +
        this.state.search +
        "&key=AIzaSyD9cjpu-HTxdu1_B9tzzaq5WkLhOKu1pac",
      success: function(data) {
        let loc;
        $that.setState({
          location: data.results[0].place_id
        });
        $that.props.updateState(
          {
            location: data.results[0].place_id,
            name: $that.state.search
          },
          $that.props.position
        );
        $that.toggleEdit();
      }
    });
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className={this.state.edit ? "editor-open" : ""}>
        <div className={!this.state.edit ? "hidden" : ""}>
          <input
            type="text"
            className="maps-search"
            id={this.searchId}
            ref={ref => this._search}
          />
          <div
            className="google-maps"
            id={this.mapsId}
            ref={ref => (this._mapContainer = ref)}
            style={{ height: "500px" }}
          />
        </div>
        <div className="row remove-margin-right">
          <div className="col-xs-12">
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
                    renderExtendedMenu={this.props.renderComponents}
                    saveAction={
                      this.state.edit ? this.addMap.bind(this) : false
                    }
                    cancelAction={
                      this.state.edit
                        ? () => {
                            this.toggleEdit.bind(this);
                            this.props.updateEditState(
                              {
                                edit: false
                              },
                              this.props.position
                            );
                          }
                        : false
                    }
                  />
                );
              }
            })()}
          </div>
        </div>
      </div>
    );
  }
  render() {
    return (
      <div
        onMouseOver={this.showComponentAction.bind(this)}
        onMouseLeave={this.hideComponentAction.bind(this)}
        className={
          this.props.className +
          (this.state.shouldShowComponentAction
            ? " highglight-el maps-wrapper row"
            : " maps-wrapper row")
        }
      >
        <div className={this.state.edit ? "hidden" : "map-view col-xs-8"}>
          <div onClick={this.toggleEdit.bind(this)}>
            {this.state.search == "" && !this.state.edit ? (
              "click to edit"
            ) : (
              <MapView
                location={this.state.location}
                name={this.state.search}
              />
            )}
          </div>
        </div>
        {this.renderEditor()}
      </div>
    );
  }
}
