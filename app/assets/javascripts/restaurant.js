var app = (window.app = {});
app.dropDowns = function() {
  $(".container").on("click", ".dropdown-menu li a", function(e) {
    var t = $(this).attr("href");
    if (t == "#") {
      e.preventDefault();
    }
    var target = $(this).html();

    //Adds active class to selected item
    $(this)
      .parents(".dropdown-menu")
      .find("li")
      .removeClass("active");
    $(this)
      .parent("li")
      .addClass("active");
    $(this)
      .parents(".dropdown")
      .find("input")
      .val(target);

    //Displays selected text on dropdown-toggle button
    $(this)
      .parents(".dropdown")
      .find(".btn")
      .html(target + ' <span class="caret"></span>');
  });
};
app.SavorLocation = function() {
  this._input = $("#location");
  this._initAutocomplete();
};

app.SavorCuisine = function() {
  this._input = $("#cuisine");
  this._initAutocomplete();
};

app.SavorCuisine.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: $.proxy(this._source, this),
        appendTo: "#cuisine-search-results",
        select: $.proxy(this._select, this)
      })
      .autocomplete("instance")._renderItem = function(ul, item) {
      return $("<li aria-label='" + item.label + "'>")
        .append("<div>" + item.label + "</div > ")
        .appendTo(ul);
      return ul;
    };
  },
  _source: function(request, response) {
    $.getJSON(
      I18n.current != "en"
        ? "/" + I18n.current
        : "" + "/restaurant/autocomplete/cuisine/?term=" + request.term,
      function(data) {
        response(
          $.map(data, function(item, i) {
            var label =
              item.large_category != null
                ? item.large_category
                : item.small_category;
            var id =
              typeof item.large_category_code != "undefined"
                ? item.large_category_code
                : item.small_category_code;
            var cat = item.large_category != null ? "large" : "small";
            return { label: label, id: id, cat: cat };
          })
        );
      }
    );
  },
  _select: function(e, ui) {
    this._input.val(ui.item.label);

    var cu = $("#cuisine_id_");
    cu.attr("name", ui.item.cat == "large" ? "cuisine_id" : "sub_cuisine_id");
    cu.val(ui.item.id);
    return false;
  }
};

app.SavorLocation.prototype = {
  _initAutocomplete: function() {
    this._input.on("keydown", function() {
      $("#loc_type_").val("");
    });
    this._input
      .autocomplete({
        source: $.proxy(this._source, this),
        appendTo: "#location-search-results",
        select: $.proxy(this._select, this),
        change: $.proxy(this._change, this)
      })
      .autocomplete("instance")._renderMenu = function(ul, items) {
      var that = this,
        currentCategory = "";

      $.each(items, function(index, item) {
        var li;
        if (item.category != currentCategory) {
          ul.append(
            "<li class='ui-autocomplete-category bold' aria-label='ff'>" +
              item.category +
              "</li>"
          );
          currentCategory = item.category;
        }
        li = that._renderItemData(ul, item);
        if (item.category) {
          li.attr("aria-label", item.category + " : " + item.label);
        }
      });
    };
  },
  _source: function(request, response) {
    $.getJSON(
      I18n.current != "en"
        ? "/" + I18n.current
        : "" + "/restaurant/autocomplete/landmark/?term=" + request.term,
      function(data) {
        response(
          $.map(data, function(item, i) {
            if (item.length == 0) {
              return;
            }
            return $.map(item, function(loc) {
              label = "";
              if (i == "prefectures") {
                label = loc.pref;
              }
              if (i == "town") {
                label = loc.township;
              }
              if (i == "subTown") {
                label = loc.sub_township;
              }
              if (i == "landmark") {
                label = loc["spot_name"];
              }
              return { label: label, category: i };
            });
          })
        );
      }
    );
  },
  _select: function(e, ui) {
    this._input.val(ui.item.label);

    $("#loc_type_").val(ui.item.category);
    return false;
  }
};
$(document).ready(function() {
  $(".open-search").click(function() {
    $(".rest-closed").removeClass("rest-closed");
  });
});
