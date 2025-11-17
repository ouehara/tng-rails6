import React from 'react';

export default class AreaTabNavItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      active: false,
    };

    if (props.getClickedThumb){
      props.getClickedThumb(this.catchActive.bind(this));
    }
    this.catchActive = this.catchActive.bind(this);
  }

  switchAreaIconSvg(category_id){
    switch(category_id){
      case 'things':
        return (
          <svg className="icon" x="0px" y="0px" viewBox="0 0 202.6 202.6">
            <path d="M73.4,122.7c7.9-14.4,19-30.6,23.5-44.7c8.9-27.4,3.2-43.6-17.3-48c-15.9-3.4-34,8.9-44.2,42.1c-4,12.9-3.2,29.6-3,40.5L73.4,122.7z"/>
            <path d="M28.1,131.2c-0.1,0.3-5,20.1-5,20.1c-2.4,10.6,4.3,21.2,14.9,23.6l2.6,0.6c10.6,2.4,21.2-4.3,23.6-14.9c0,0,4.9-19.8,5-20.1L28.1,131.2z"/>
            <path d="M155.7,123.9c8.5-5.9,19-17.7,25.6-29.4c14-25.2,13.2-49.3,0.5-59.4c-12.3-9.8-32.9-5.1-46.9,20c-7.2,13-12.4,32.3-14.5,45.7L155.7,123.9z"/>
            <path d="M143.8,140.9c-0.2,0.3-12.4,18.3-12.4,18.3c-6.1,9-18.4,11.3-27.4,5.2l-2.2-1.5c-9-6.1-11.3-18.4-5.2-27.4c0,0,12.3-18,12.4-18.2L143.8,140.9z"/>
          </svg>
        );
      case 'f_d':
        return (
          <svg className="icon" x="0px" y="0px" viewBox="0 0 202.6 202.6">
            <path d="M139.8,22.5c-17.6,0-31.9,17.7-31.9,37.6c0,12.1,5.7,22.8,12.7,29.5c6.1,5.8,9.9,10.4,10.6,20.1v72.5h17.3v-72.5c0.8-9.8,4.5-14.3,10.6-20.1c7-6.7,12.7-17.4,12.7-29.5C171.7,40.1,157.4,22.5,139.8,22.5z"/>
            <path d="M79.6,30.1v38.1h-8.9V30c0-5.6-3.8-7.3-7.4-7.3c-3.6,0-7.4,1.7-7.4,7.3v38.2h-8.9V30.1c0-10.1-14.3-9.7-14.3,0.1c0,11.8,0,32.6,0,32.6c-0.1,18.1,4.3,22.8,11.4,28.4c5.8,4.5,10.7,7.1,10.7,18.4v72.5l17.3,0v-72.5c0-11.3,4.9-13.9,10.7-18.4c7.1-5.6,11.5-10.3,11.4-28.4c0,0,0-20.8,0-32.6C93.9,20.4,79.6,20.1,79.6,30.1z"/>
          </svg>
        );
      case 'h_r':
        return (
          <svg className="icon" x="0px" y="0px" viewBox="0 0 202.6 202.6">
            <path d="M167.1,76V24.5H35.9V76c-9.4,7.9-15.4,19.8-15.4,33.1v8.6v8.1v55.7H46v-24.7c0-1.4,1.2-2.6,2.6-2.6h105.7c1.4,0,2.6,1.2,2.6,2.6v24.7h25.5v-55.7v-8.1v-8.6C182.5,95.8,176.5,83.9,167.1,76z M77.5,47.4c0.6-6.1,5.4-11,11.5-11.5c4-0.4,8.9-0.7,14.4-0.7c5.5,0,10.4,0.3,14.4,0.7c6.1,0.6,10.9,5.4,11.5,11.6l1.2,11.8c0,2.7-2.3,4.9-5,4.7c-6.1-0.3-16.5-0.9-22.2-0.9c-5.7,0-16,0.5-22.2,0.9c-2.7,0.1-5-2-5-4.7L77.5,47.4z M160,111.3H42.9c-5.2,0-7.6-3.6-6.1-10.2c1.5-6.6,6.5-18.1,16.9-21.6c11.5-3.8,22.6-6.7,49.8-6.7c27.2,0,36,3.2,46.3,6.8c10.5,3.7,15.1,14.4,16.3,21.4C167.2,108.1,165.3,111.3,160,111.3z"/>
          </svg>
        );
      case 'shopping':
        return (
          <svg className="icon" x="0px" y="0px" viewBox="0 0 202.6 202.6">
            <path d="M128,64.2H29l-10.6,114h120.3L128,64.2zM51.6,88.1c-2.5,0-4.4-2-4.4-4.4c0-2.4,2-4.4,4.4-4.4c2.5,0,4.4,2,4.4,4.4C56,86.1,54,88.1,51.6,88.1zM105.4,88.1c-2.5,0-4.4-2-4.4-4.4c0-2.4,2-4.4,4.4-4.4s4.4,2,4.4,4.4C109.8,86.1,107.9,88.1,105.4,88.1z"/>
            <path className="st1" d="M109.2,59.2c0-17-13.8-30.7-30.8-30.7c-17,0-30.7,13.8-30.7,30.7"/>
            <path d="M174.8,105.3h-38.1l7.3,72.9h40.3L174.8,105.3z"/>
            <path d="M133.9,83c2.8-1.4,5.3-2,8.5-2c11.2,0,20.4,9.1,20.4,20.4l-6.6,0c0-7.6-6.2-13.7-13.7-13.7c-2.7,0-5.4,0.4-7.6,1.9"/>
          </svg>
        );
      default:
        return;
    }
  }

  catchActive(){
    this.props.catchOnClick(this.props.elements.category_id);
  }

  render() {
    let div_classes = 'area-articleCatList_item';
    if(this.props.isActive){
      div_classes += ' active';
    }
    return (
      <li className={div_classes} data-cat={this.props.elements.category_id} onClick={this.catchActive}>
        <span className="icon_wrapper">
          {this.switchAreaIconSvg(this.props.elements.category_id)}
        </span>
        {this.props.elements.category}
      </li>
    );
  }
}