import React from "react";
import store from "../shared/store";
import ClipCountManager from "../shared/clip_count_manager";
import ClipItem from "./clip_item.es6.jsx";
import MoreBtn from "../shared/more_btn.es6.jsx";
import I18n from "../i18n/i18n";

export default class ClipList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      clipped: store.get("clips") ? store.get("clips") : {},
      loaded: {},
      per_load: 6,
      loaded_num: 0,
      total_clipped: 0
    };

    this.handleClickRemove = this.handleClickRemove.bind(this);
    this.handleClickedMoreBtn = this.handleClickedMoreBtn.bind(this);
  }

  componentDidMount() {
    const amount = this.state.loaded_num + this.state.per_load;
    this.setState({
      loaded_num:
        this.state.per_load > Object.keys(this.state.clipped).length
          ? Object.keys(this.state.clipped).length
          : amount,
      total_clipped: Object.keys(this.state.clipped).length
    });
  }

  handleClickRemove(post_id) {
    let clip_array = this.state.clipped;
    delete clip_array[post_id];
    this.setState({
      clipped: clip_array
    });
    store.set("clips", clip_array);

    // ClipCountManagerを使用してナビゲーションのクリップ数を更新
    ClipCountManager.updateNavClipCount();
  }

  handleClickedMoreBtn() {
    const new_loaded_num =
      this.state.loaded_num + this.state.per_load > this.state.total_clipped
        ? this.state.total_clipped
        : this.state.loaded_num + this.state.per_load;
    this.setState({ loaded_num: new_loaded_num });
  }

  renderClipItems() {
    if (!Object.keys(this.state.clipped).length) {
      return <p className="message">{this.props.elements.no_clips_message}</p>;
    }

    return Object.keys(this.state.clipped).map((key, index) => {
      if (index > this.state.loaded_num - 1) return;

      if (
        this.state.clipped[key].lang != I18n.current &&
        typeof this.state.clipped[key].lang != "undefined"
      )
        return;
      return (
        <ClipItem
          elements={this.state.clipped[key]}
          key={index}
          catchClickRemove={this.handleClickRemove}
        />
      );
    });
  }

  renderMoreBtn() {
    if (
      this.state.loaded_num === this.state.total_clipped ||
      this.state.total_clipped <= this.state.per_load
    )
      return;
    return <MoreBtn type="clip" catchOnClick={this.handleClickedMoreBtn} />;
  }

  render() {
    return (
      <div className="clip_articleList">
        <div>{this.renderClipItems()}</div>
        {this.renderMoreBtn()}
      </div>
    );
  }
}
