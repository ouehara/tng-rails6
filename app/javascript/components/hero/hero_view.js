import React from "react";
export default class Hero extends React.Component {
  constructor(props) {
    super(props);
    const { isPc = false } = this.props;
    this.state = {
      type: this.props.elements.type,
      is_pc: isPc,
    };
  }

  renderMap() {
    // if(this.props.elements.page_type === 'index'){
    //   return;
    // }
    const map_style = {
      backgroundImage: `url(${this.props.elements.map_img})`,
    };
    return <div className="hero_map" style={map_style} />;
  }

  renderTitle() {
    if (this.props.elements.page_type === "sub") {
      return (
        <h1 className="title">
          {this.props.elements.category_full}
          <br />
          <span className="place">{this.props.elements.area}</span>
        </h1>
      );
    } else {
      return <h1 className="title">{this.props.elements.category_full}</h1>;
    }
  }

  render() {
    const classes_wrap = `hero ${this.props.elements.category}-hero`;
    const classes_title = `hero_title ${
      this.props.elements.category
    }-hero_title`;
    const classes_container = `hero_container ${
      this.props.elements.category
    }-hero_container`;
    const bg_img = this.state.is_pc
      ? this.props.elements.pc_bg_img
      : this.props.elements.sp_bg_img;
    const title_style = {
      backgroundImage: `linear-gradient(rgba(0, 0, 0, .2),rgba(0, 0, 0, 0.2)), url(${bg_img}) `,
    };
    return (
      <div className={classes_wrap}>
        <div className={classes_title} style={title_style}>
          <div className={classes_container}>
            {this.renderTitle()}

            {this.props.elements.page_type === "sub" && this.renderMap()}
          </div>
        </div>
        {/*
        
        <div className="container">
          <p className="hero_intro">{this.props.elements.intro_text}</p>
          {this.props.elements.ad.img && (
            <div className="hero_ad">
              <a href={this.props.elements.ad.url}>
                <img
                  src={this.props.elements.ad.img}
                  alt={this.props.elements.ad.alt}
                />
              </a>
            </div>
          )}
        </div>
          */}
      </div>
    );
  }
}
