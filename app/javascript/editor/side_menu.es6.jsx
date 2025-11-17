import React from "react";
import Datetime from "react-datetime";
import AreaSelection from "./components/area_selection.es6";
import TaggedInput from "./components/tagged_input.es6";
import SidebarRelatedArticles from "./components/sidebar_related_articles.es6";
import dayjs from "dayjs";
import I18n from "../components/i18n/i18n";
export default class SideMenu extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      tags: props.currentTags,
      category: props.currentCateogry,
      sponsored_content: this.props.sponsoredContent,
      author: this.props.user,
      translator: this.props.translator,
      promo: this.props.promo,
      tagGroupEdit: false,
      selectedTagGroups: this.props.articleTagGroups,
      tmpSelectedGroup: this.props.articleTagGroups,
      relatedArticles: this.props.relatedArticles
    };
  }
  componentWillReceiveProps(props) {
    if (props != this.props) {
      this.setState({
        tags: props.currentTags,
        category: props.currentCateogry,
        sponsored_content: props.sponsoredContent,
        author: props.user,
        translator: props.translator,
        promo: props.promo,
        tagGroupEdit: false,
        selectedTagGroups: props.articleTagGroups,
        tmpSelectedGroup: props.articleTagGroups,
        relatedArticles: props.relatedArticles
      });
    }
  }
  setPromo(evt) {
    this.props.onChange("isPromotional", evt.target.value);
    this.setState({ promo: event.target.value });
  }
  setRelated(value) {
    this.props.onChange("relatedArticles", value);
    this.setState({ relatedArticles: value });
  }
  setTags(type, val) {
    this.props.onChange(type, val);
    this.setState({ [type]: val });
  }
  setCateogry(evt) {
    this.props.onChange("articleCategory", evt.id);
    this.props.onChange("articleTagGroups", []);
    this.setState({
      category: event.id,
      selectedTagGroups: [],
      tmpSelectedGroup: [],
      tagGroupEdit: false
    });
  }
  setPr() {
    this.props.onChange("sponsoredContent", !this.state.sponsored_content);
    this.setState({ sponsored_content: !this.state.sponsored_content });
  }
  setUser(evt) {
    this.props.onChange("author", evt.target.value);
    this.setState({ author: event.target.value });
  }
  setTranslator(evt) {
    this.props.onChange("translator", evt.target.value);
    this.setState({ translator: event.target.value });
  }
  setTagGroups() {
    let { tmpSelectedGroup } = this.state;
    this.props.onChange("articleTagGroups", tmpSelectedGroup);
    this.setState({
      selectedTagGroups: tmpSelectedGroup,
      tagGroupEdit: false
    });
  }
  renderCategoryOptions() {
    return this.props.category.map(cat => {
      return (
        <option value={cat.id} key={cat.id}>
          {" "}
          {cat.page_name}{" "}
        </option>
      );
    });
  }
  setTagGroupEdit(val) {
    this.setState({ tagGroupEdit: val });
  }
  setTmp(tg) {}
  renderTagGroupOptions() {
    if (this.state.tagGroupEdit) {
      return (
        <div>
          <div>
            {this.props.tagGroups
              .filter(tg => tg.category_id == this.state.category)
              .map(tg => {
                return (
                  <label key={tg.id} className="tag-groups-label">
                    <input
                      type="checkbox"
                      value={tg.id}
                      disabled={
                        typeof this.state.tmpSelectedGroup[0] != "undefined" &&
                        this.state.tmpSelectedGroup[0].id == "none"
                      }
                      defaultChecked={
                        typeof this.state.selectedTagGroups.find(
                          g => g.id == tg.id
                        ) != "undefined"
                      }
                      onChange={evt => {
                        let temp = [...this.state.tmpSelectedGroup];
                        var index = this.state.tmpSelectedGroup.findIndex(
                          g => g.id == tg.id
                        );

                        if (index != -1) {
                          temp.splice(index, 1);
                        } else {
                          temp.push(tg);
                        }
                        this.setState({ tmpSelectedGroup: temp });
                      }}
                    />{" "}
                    {tg.name}
                  </label>
                );
              })}
            <label key="none" className="tag-groups-label">
              <input
                type="checkbox"
                value="none"
                defaultChecked={
                  typeof this.state.selectedTagGroups.find(
                    g => g.id == "none"
                  ) != "undefined"
                }
                onChange={evt => {
                  var index = this.state.tmpSelectedGroup.findIndex(
                    g => g.id == "none"
                  );
                  if (index != -1) {
                    this.setState({
                      tmpSelectedGroup: []
                    });
                  } else {
                    this.setState({
                      tmpSelectedGroup: [{ id: "none", name: I18n.t("none") }]
                    });
                  }
                }}
              />
              {I18n.t("none")}
            </label>
          </div>
          <button onClick={this.setTagGroups.bind(this)}>
            {I18n.t("confirm")}
          </button>
        </div>
      );
    } else {
      return (
        <span
          className="tag_groups_selection"
          onClick={() => {
            this.setTagGroupEdit(true);
          }}
        >
          {this.state.selectedTagGroups.length == 0
            ? "edit tag groups"
            : this.state.selectedTagGroups.map(grp => grp.name + ", ")}
        </span>
      );
    }
  }
  renderUserSelect() {
    return this.props.users.map((u, i) => {
      return (
        <option value={u.id} key={i}>
          {" "}
          {u.username}
        </option>
      );
    });
  }
  getDate() {
    if (
      this.props.schedule != null &&
      typeof this.props.schedule[I18n.current] != "undefined"
    ) {
      // console.log("hello" + dayjs(this.props.schedule[I18n.current]));
      return new Date(this.props.schedule[I18n.current]);
      // return dayjs(this.props.schedule[I18n.current]);
    }

    return dayjs();
  }
  dateOnChange(mom) {
    if (typeof mom === "object") {
      this.props.updateDate(mom.format());
    }
  }
  render() {
    return (
      <div>
        <h5 className="black-border">Publish on</h5>

        <Datetime
          defaultValue={this.getDate()}
          onChange={this.dateOnChange.bind(this)}
        />

        <div className="form-group">
          <h5 className="black-border">Category</h5>
          <AreaSelection
            nameEl="page_name"
            type={"articleCategory"}
            areas={this.props.category}
            onChange={this.setCateogry.bind(this)}
            articleArea={
              this.props.category.filter(
                el => el.id == this.props.currentCateogry
              )[0]
            }
          />
        </div>
        <div className="form-group">
          <h5 className="black-border">Area</h5>
          <AreaSelection
            nameEl="name"
            type={"articleArea"}
            areas={this.props.areas}
            onChange={this.props.onChange}
            articleArea={this.props.articleArea}
          />
        </div>

        <div className="form-group">
          <h5 className="black-border">Author</h5>
          <select
            className="form-control"
            onChange={this.setUser.bind(this)}
            value={this.state.author}
          >
            {this.renderUserSelect()}
          </select>
        </div>

        <div className="form-group">
          <h5 className="black-border">Translator</h5>
          <select
            className="form-control"
            onChange={this.setTranslator.bind(this)}
            value={this.state.translator}
          >
            {this.renderUserSelect()}
          </select>
        </div>
        <div className="form-group">
          <h5 className="black-border">Tag Groups</h5>
          {this.renderTagGroupOptions()}
        </div>
        <div className="form-group">
          <h5 className="black-border">Tags</h5>
          <TaggedInput
            autofocus={false}
            searchPath={this.props.tags}
            backspaceDeletesWord={true}
            placeholder={"Tags"}
            tags={this.state.tags}
            onEnter={() => {}}
            onAddTag={(n, t) => {
              this.setTags("tags", t);
            }}
            onRemoveTag={(n, t) => {
              this.setTags("tags", t);
            }}
            tagOnBlur={false}
            clickTagToEdit={false}
            unique={true}
            classes={"my-css-namespace"}
            removeTagLabel={"\u274C"}
            onBeforeAddTag={function(tagText) {
              return true;
            }}
            onBeforeRemoveTag={function(tagText) {
              return true;
            }}
          />
        </div>

        <div className="form-group">
          <h5 className="black-border">Related Articles</h5>
          <SidebarRelatedArticles
            category={this.props.category}
            content={this.state.relatedArticles}
            onUpdate={this.setRelated.bind(this)}
          />
        </div>
        <div className="form-group">
          <h5 className="black-border">Top Page Promotional</h5>
          <select onChange={this.setPromo.bind(this)} value={this.state.promo}>
            <option value="-1">----</option>
            <option value="pos_first">1</option>
            <option value="pos_second">2</option>
            <option value="pos_third">3</option>
            <option value="pos_fourth">4</option>
            <option value="pos_fifth">5</option>
          </select>
        </div>

        <button
          className="btn btn-default"
          onClick={this.props.generateNavigation}
        >
          generate table of contents{" "}
        </button>
        <h5 className="black-border">PR</h5>
        <input
          type="checkbox"
          onChange={this.setPr.bind(this)}
          className="form-control"
          value="true"
          checked={this.state.sponsored_content}
        />
      </div>
    );
  }
}
