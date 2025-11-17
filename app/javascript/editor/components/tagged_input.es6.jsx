import React from "react";
import PropTypes from "prop-types";
import link_path from "../../components/shared_components/link_path";

import ComponentMenu from "./component_menu.es6";
var KEY_CODES = {
  ENTER: 13,
  BACKSPACE: 8,
  TAB: 9
};
class DefaultTagComponent extends React.Component {
  render() {
    var self = this,
      p = self.props;
    var className = "tag" + (p.classes ? " " + p.classes : "");
    return (
      <div className={className}>
        <div className="tag-text" onClick={p.onEdit}>
          {p.item}
        </div>
        <div className="remove" onClick={p.onRemove}>
          {p.removeTagLabel}
        </div>
      </div>
    );
  }
}

export default class TaggedInput extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tags: (this.props.tags || []).slice(0),
      currentInput: "",
      autocomplete: []
    };
  }
  renderAutoComplete() {
    if (typeof this.state.autocomplete != "object") {
      return;
    }
    return this.state.autocomplete.map((i, key) => {
      return (
        <div
          key={i.name}
          className="tag-suggestion-wrapper"
          style={{ bottom: (key + 1) * 30 * -1 }}
        >
          <span
            className="tag-suggestion"
            onClick={this._addTag.bind(this, i.name)}
          >
            {i.name}
          </span>
        </div>
      );
    });
  }
  render() {
    var self = this,
      s = self.state,
      p = self.props;

    var tagComponents = [],
      classes = "tagged-input-wrapper",
      placeholder,
      i;

    if (p.classes) {
      classes += " " + p.classes;
    }

    if (s.tags.length === 0) {
      placeholder = p.placeholder;
    }

    var TagComponent = DefaultTagComponent;

    for (i = 0; i < s.tags.length; i++) {
      tagComponents.push(
        <TagComponent
          key={"tag" + i}
          item={s.tags[i]}
          itemIndex={i}
          onRemove={self._handleRemoveTag.bind(this, i)}
          onEdit={p.clickTagToEdit ? self._handleEditTag.bind(this, i) : null}
          classes={p.unique && i === s.duplicateIndex ? "duplicate" : ""}
          removeTagLabel={p.removeTagLabel || "\u274C"}
        />
      );
    }
    var autocomplete =
      this.state.autocomplete.length == 0 ? "" : this.renderAutoComplete();
    var input = (
      <input
        type="text"
        className="tagged-input"
        ref={ref => (this.input = ref)}
        onKeyUp={this._handleKeyUp.bind(this)}
        onKeyDown={this._handleKeyDown.bind(this)}
        onChange={this._handleChange.bind(this)}
        onBlur={this._handleBlur.bind(this)}
        value={s.currentInput}
        placeholder={placeholder}
        tabIndex={p.tabIndex}
      />
    );

    return (
      <div>
        <div
          className={classes}
          onClick={self._handleClickOnWrapper.bind(this)}
        >
          {tagComponents}
          {input}
          <input type="hidden" className="hidden-all-tags" value={s.tags} />
          {autocomplete}
        </div>
      </div>
    );
  }

  componentDidMount() {
    var self = this,
      s = self.state,
      p = self.props;

    if (p.autofocus) {
      self.refs.input;
    }
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      tags: (nextProps.tags || []).slice(0)
    });
  }

  _handleRemoveTag(index) {
    var self = this,
      s = self.state,
      p = self.props;

    if (p.onBeforeRemoveTag(index)) {
      var removedItems = s.tags.splice(index, 1);

      if (s.duplicateIndex) {
        self.setState({ duplicateIndex: null }, function() {
          p.onRemoveTag && p.onRemoveTag(removedItems[0], self.getTags());
        });
      } else {
        p.onRemoveTag && p.onRemoveTag(removedItems[0], self.getTags());
        self.forceUpdate();
      }
    }
  }

  _handleEditTag(index) {
    var self = this,
      s = self.state,
      p = self.props;
    var removedItems;

    if (s.currentInput) {
      var trimmedInput = s.currentInput.trim();
      if (
        trimmedInput &&
        (this.state.tags.indexOf(trimmedInput) < 0 || !p.unique)
      ) {
        this._validateAndTag(s.currentInput);
      }
    }

    removedItems = s.tags.splice(index, 1);
    if (s.duplicateIndex) {
      self.setState(
        { duplicateIndex: null, currentInput: removedItems[0] },
        function() {
          p.onRemoveTag && p.onRemoveTag(removedItems[0], self.getTags());
        }
      );
    } else {
      self.setState({ currentInput: removedItems[0] }, function() {
        p.onRemoveTag && p.onRemoveTag(removedItems[0], self.getTags());
      });
    }
  }

  _handleKeyUp(e) {
    var self = this,
      s = self.state,
      p = self.props;

    var enteredValue = e.target.value;
    let suggestionEl = "";

    switch (e.keyCode) {
      case KEY_CODES.ENTER:
        if (s.currentInput) {
          self._validateAndTag(s.currentInput, function(status) {
            if (p.onEnter) {
              p.onEnter(e, s.tags);
            }
          });
        }
        break;
    }
  }

  _handleKeyDown(e) {
    var self = this,
      s = self.state,
      p = self.props;
    var poppedValue, newCurrentInput;
    switch (e.keyCode) {
      case KEY_CODES.BACKSPACE:
        if (!e.target.value || e.target.value.length < 0) {
          if (p.onBeforeRemoveTag(s.tags.length - 1)) {
            poppedValue = s.tags.pop();

            newCurrentInput = p.backspaceDeletesWord ? "" : poppedValue;

            this.setState({
              currentInput: newCurrentInput,
              duplicateIndex: null
            });
            if (p.onRemoveTag && poppedValue) {
              p.onRemoveTag(poppedValue, self.getTags());
            }
          }
        }
        break;
      case KEY_CODES.TAB:
        if (self.state.autocomplete.length == 0) {
          break;
        }
        e.preventDefault();
        self._validateAndTag(self.state.autocomplete.name);
        break;
    }
  }
  _addTag(t) {
    this._validateAndTag(t);
    this._resetAutocomplete();
  }
  _resetAutocomplete() {
    // this.setState({ autocomplete: [] });
  }
  _shouldAutocomplete(searchString) {
    if (
      typeof this.props.autoTags != "undefined" &&
      this.props.autoTags.length
    ) {
      let autoProps = this.props.autoTags;
      let searchResult = "";
      if (
        (autoProps.length == 0 || searchString.trim() == "") &&
        this.state.autocomplete.length
      ) {
        this._resetAutocomplete();
        return;
      }
      var re = new RegExp(searchString, "g");
      for (let i in autoProps) {
        if (
          typeof autoProps[i].name != "undefined" &&
          autoProps[i].name != null &&
          autoProps[i].name.match(re)
        ) {
          searchResult = autoProps[i];
          break;
        }
      }
      if (searchResult != "" && searchResult != null) {
        this.setState({ autocomplete: [searchResult] });
      }
    } else {
      if (searchString != "") {
        $.ajax({
          url: link_path(this.props.searchPath, [
            { value: searchString, key: ":param" }
          ])
        }).done(
          function(data) {
            this.setState({ autocomplete: data });
          }.bind(this)
        );
      }
    }
  }
  _handleChange(e) {
    var self = this,
      s = self.state,
      p = self.props;
    var value = e.target.value,
      lastChar = value.charAt(value.length - 1),
      tagText = value.substring(0, value.length - 1);
    this._shouldAutocomplete(tagText + lastChar);
    if (p.delimiters.indexOf(lastChar) !== -1) {
      self._validateAndTag(tagText);
    } else {
      this.setState({
        currentInput: e.target.value
      });
    }
  }

  _handleBlur(e) {
    //this._resetAutocomplete();
    if (this.props.tagOnBlur) {
      var value = e.target.value;
      value && this._validateAndTag(value);
    }
  }

  _handleClickOnWrapper(e) {
    this.refs.input;
  }

  _validateAndTag(tagText, callback) {
    var self = this,
      s = self.state,
      p = self.props;
    var duplicateIndex;
    var trimmedText;

    if (tagText && tagText.length > 0) {
      trimmedText = tagText.trim();
      if (p.unique) {
        // not a boolean, it's a function
        if (typeof p.unique === "function") {
          duplicateIndex = p.unique(this.state.tags, trimmedText);
        } else {
          duplicateIndex = this.state.tags.indexOf(trimmedText);
        }

        if (duplicateIndex === -1) {
          if (!p.onBeforeAddTag(trimmedText)) {
            return;
          }

          s.tags.push(trimmedText);
          self.setState(
            {
              currentInput: "",
              autocomplete: "",
              duplicateIndex: null
            },
            function() {
              p.onAddTag && p.onAddTag(tagText, s.tags);
              callback && callback(true);
            }
          );
        } else {
          self.setState({ duplicateIndex: duplicateIndex }, function() {
            callback && callback(false);
          });
        }
      } else {
        if (!p.onBeforeAddTag(trimmedText)) {
          return;
        }

        s.tags.push(trimmedText);
        self.setState(
          { currentInput: "" },
          function() {
            p.onAddTag && p.onAddTag(tagText, this.getTags());
            callback && callback(true);
          }.bind(this)
        );
      }
    }
  }

  getTags() {
    return this.state.tags;
  }

  getEnteredText() {
    return this.state.currentInput;
  }

  getAllValues() {
    var self = this,
      s = this.state,
      p = this.props;

    if (s.currentInput && s.currentInput.length > 0) {
      return this.state.tags.concat(s.currentInput);
    } else {
      return this.state.tags;
    }
  }
}

TaggedInput.propTypes = {
  onBeforeAddTag: PropTypes.func,
  onAddTag: PropTypes.func,
  onBeforeRemoveTag: PropTypes.func,
  onRemoveTag: PropTypes.func,
  onEnter: PropTypes.func,
  unique: PropTypes.oneOfType([PropTypes.bool, PropTypes.func]),
  autofocus: PropTypes.bool,
  backspaceDeletesWord: PropTypes.bool,
  placeholder: PropTypes.string,
  tags: PropTypes.arrayOf(PropTypes.any),
  autoTags: PropTypes.arrayOf(PropTypes.any),
  removeTagLabel: PropTypes.oneOfType([PropTypes.string, PropTypes.object]),
  delimiters: PropTypes.arrayOf(function(props, propName, componentName) {
    if (typeof props[propName] !== "string" || props[propName].length !== 1) {
      return new Error(
        "TaggedInput prop delimiters must be an array of 1 character strings"
      );
    }
  }),
  tagOnBlur: PropTypes.bool,
  tabIndex: PropTypes.number,
  clickTagToEdit: PropTypes.bool
};
TaggedInput.defaultProps = {
  delimiters: [","],
  unique: true,
  autoTags: [], //needs a sorted array
  autofocus: false,
  backspaceDeletesWord: true,
  tagOnBlur: false,
  clickTagToEdit: false,
  onBeforeAddTag: function(tag) {
    return true;
  },
  onBeforeRemoveTag: function(index) {
    return true;
  },
  onEnter: function(e, tag) {
    return true;
  },
  onAddTag: function() {
    return true;
  },
  onRemoveTag: function() {
    return true;
  }
};
