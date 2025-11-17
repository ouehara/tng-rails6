import React from "react";
import LazyLoad from "react-lazyload";
import I18n from "../i18n/i18n";
export default class RestaurantList extends React.Component {
  constructor(props) {
    super(props);
  }

  renderGrid() {
    if (!Object.keys(this.props.elements).length) return;
    return Object.keys(this.props.elements).map((key, index) => {
      const classes = [
        "col-sm-6 col-xs-12 top-restaurantList_grid",
        this.props.elements[key].type
      ].join(" ");
      const gridList = this.renderGridList(this.props.elements[key].item);
      return (
        <div className={classes} key={index}>
          {gridList}
        </div>
      );
    });
  }

  renderGridList(data) {
    if (!Object.keys(data).length) return;
    return Object.keys(data).map((key, index) => {
      const classes = ["top-restaurantList_item", data[key]["grid_name"]].join(
        " "
      );
      const url =
        I18n.current == "en"
          ? data[key]["url"]
          : "/" + I18n.current + data[key]["url"];

      // const url = data[key]["url"];
      const thumbnail = data[key]["thumbnail"];
      return (
        <div className={classes} key={data[key]["id"]}>
          <a href={url} id={data[key]["id"]}>
            <LazyLoad once={true} offset={200} height={100}>
              <div
                className="top-restaurantList_image"
                style={{ backgroundImage: `url(${thumbnail})` }}
              />
              <p className="top-restaurantList_text">
                {I18n.t(data[key]["disp_title"])}
              </p>
            </LazyLoad>
          </a>
        </div>
      );
    });
  }

  render() {
    return <div className="row top-restaurantList">{this.renderGrid()}</div>;
  }
}
