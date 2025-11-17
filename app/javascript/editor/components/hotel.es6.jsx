import React from "react";
import EditorBase from "./editor_base.es6";
import HotelPopup from "./hotel_popup.es6";
import I18n from "../../components/i18n/i18n";
export default class Hotel extends EditorBase {
  constructor(props) {
    super(props);
    this.state = {
      searchTerm: "",
      searchResult: [],
      edit: this.props.edit,
      noresult: false,
      showModal: false
    };
  }
  saveText() {}
  setSearchTerm(event) {
    this.setState({ searchTerm: event.target.value });
  }
  search() {
    let $that = this;
    $that.setState({ noresult: false });
    $.ajax({
      url: "/hotels/" + $that.state.searchTerm + "/",
      type: "GET"
    }).done(function(data) {
      $that.setState({ searchResult: data, noresult: data.length == 0 });
    });
  }
  setSearchResult(hotel) {
    this.setState({ searchResult: [hotel] });
  }
  renderSearchResult() {
    if (this.state.searchResult.length == 0) {
      if (this.state.noresult) {
        return "Hotel not found";
      }
      return;
    }
    if (this.state.searchResult.length == 1) {
      return this.renderDetails();
    }
    return this.state.searchResult.map((hotel, i) => {
      return (
        <div
          className="hotel-result"
          onClick={this.setSearchResult.bind(this, hotel)}
        >
          {hotel.name}{" "}
          <span className="hotel-result-services">
            ({this.getServices(hotel.hotel_details)})
          </span>
        </div>
      );
    });
  }
  getServices(hotel) {
    return hotel.map((detail, index) => {
      let service = I18n.t("hotel.name" + detail.service);
      let suffix = index == 0 ? "," : "";
      return service + suffix;
    });
  }
  getDetails(hotel) {
    //<div className="col-xs-12">http://google.com/maps/?q={h.lat},{h.long}</div>
    return hotel.hotel_details.map(h => {
      return (
        <div>
          <div className="service-headline">
            <b>{h.service == 1 ? "Agoda" : "Booking"}</b>
          </div>
          <div className="rate-wrapper clearfix">
            <div className="col-xs-6">
              <i>Lowest rate:</i>{" "}
            </div>
            <div className="col-xs-6">
              {h.min_rate}
              {h.currency}
            </div>
          </div>
          <div className="hotel-map-wrapper clearfix">
            <div className="col-xs-12">
              <i>Maps url:</i>{" "}
            </div>
            <div className="col-xs-12">
              http://google.com/maps/?q={h.address + " " + hotel.name}
            </div>
          </div>
          <div className="hotel-image-wrapper clearfix">
            <div className="col-xs-12">
              <i>Image:</i>{" "}
            </div>
            <div className="col-xs-12">
              <img
                src={h.image}
                className="img-responsive"
                onClick={this.addImage.bind(this, h)}
              />
            </div>
          </div>
          <div className="clearfix">
            <div className="col-xs-12">
              <div
                className="add-affiliate book-with"
                onClick={this.addAffiliate.bind(this, h, hotel)}
              >
                add {I18n.t("hotel.name" + h.service)} button
              </div>
            </div>
          </div>
          <hr />
        </div>
      );
    });
  }
  addAffiliate(details, hotel) {
    let component = {
      type: "HotelAffiliate",
      position: this.props.position(),
      id: this.props.position(),
      content: { url: details.url, type: details.service, name: hotel.name },
      edit: false
    };
    this.props.updateState(component, this.props.position());
  }
  addLink(hotel) {
    let h = hotel;
    let details = h.hotel_details[0];
    let component = {
      type: "Link",
      position: this.props.position(),
      id: this.props.position(),
      content: {
        url: "/hotel/" + h.id,
        title: h.name,
        desc: details.description.substring(0, 140) + "...",
        imgPreview: details.image
      },
      edit: false
    };
    this.props.updateState(component, this.props.position());
  }
  addImage(details) {
    let source = {
      url: details.url,
      text: details.service == 1 ? "Agoda" : "Booking"
    };
    let image = details.image;
    let searchRes = "";
    let searchType = "url";
    let component = {
      type: "Images",
      position: this.props.position(),
      id: this.props.position(),
      content: {
        image: image,
        searchType: searchType,
        src: source,
        searchRes: searchRes
      },
      edit: false
    };
    this.props.updateState(component, this.props.position());
  }
  openModal() {
    this.setState({ showModal: true });
  }
  closeModal() {
    this.setState({ showModal: false });
  }
  renderDetails() {
    let hotel = this.state.searchResult[0];
    return (
      <div>
        <h3>
          {hotel.name}{" "}
          <span
            className="icon-share-alt hotel-add-icon open-modal"
            onClick={() => {
              this.openModal();
            }}
          />
        </h3>
        <div
          className="btn btn-default"
          onClick={this.addLink.bind(this, hotel)}
        >
          add Linkbox
        </div>

        {this.getDetails(hotel)}
      </div>
    );
  }
  renderEditor() {
    if (!this.props.editor) return;
    return (
      <div className="hotel-search">
        <div className="open-hotel-search" onClick={this.toggleEdit.bind(this)}>
          Hotels
        </div>
        <div
          className={
            !this.state.edit
              ? "hotel-search-wrapper width0"
              : "hotel-search-wrapper"
          }
        >
          <div>
            <div className="form-inline">
              <input
                type="text"
                onChange={this.setSearchTerm.bind(this)}
                placeholder="hotel search term"
                className="col-xs-12 form-group form-control"
                name="query"
                defaultValue={this.state.searchTerm}
              />
              <button
                id="search-button"
                onClick={this.search.bind(this)}
                className="btn btn-primary"
              >
                <span
                  className="glyphicon glyphicon-search"
                  aria-hidden="true"
                />{" "}
              </button>
            </div>
            {this.renderSearchResult()}
          </div>
        </div>
      </div>
    );
  }
  render() {
    let url = this.state.url;
    let quote = this.state.quote;
    let comment = this.state.comment;
    return (
      <div>
        {this.state.showModal ? (
          <HotelPopup
            hotelName={this.state.searchResult[0].name}
            closeModal={this.closeModal.bind(this)}
            addAffiliate={this.addAffiliate.bind(this)}
          />
        ) : (
          ""
        )}
        {this.renderEditor()}
      </div>
    );
  }
}
