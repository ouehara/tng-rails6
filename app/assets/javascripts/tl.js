$(document).on("turbolinks:load", function () {
  /**
   * Improve anchors click behaviour:
   * - Scroll to hash
   * - Prevent useless refresh
   */
  $("body").on("click", "a", function (event) {
    // console.log("a click");
    var $this = $(this);
    var current_url_relative = window.location.href
      .replace(window.location.origin, "")
      .split("#")[0];
    if (
      $(this)
        .attr("href")
        .charAt(0) === "#"
    ) {
      event.preventDefault();

      /**
       * Position to scroll to.
       *
       * - No-hash: 0
       * - Hash: the position of the referenced element (uses HTML id attribute)
       *
       * @type Integer
       */
      var to =
        $this.is('[href*="#"]') && $(this.hash).length
          ? $(this.hash).offset().top - 78
          : 0;

      /**
       * Scroll.
       */
      if (!$(this.hash).length) {
        return;
      }
      $target = $(this.hash);
      $("html,body").animate(
        { scrollTop: to },
        {
          // Set the duration long enough to allow time
          // to lazy load the elements.
          duration: 700,

          // At each animation step, check whether the target has moved.
          step: function (now, fx) {
            // Where is the target now located on the page?
            // i.e. its location will change as images etc. are lazy loaded
            var newOffset = $target.offset().top - 78;

            // If where we were originally planning to scroll to is not
            // the same as the new offset (newOffset) then change where
            // the animation is scrolling to (fx.end).
            if (fx.end !== newOffset) fx.end = newOffset;
          }
        }
      );

      /**
       * Update address bar and history
       */
      if (history.pushState) {
        history.pushState(
          null,
          null,
          current_url_relative + $this.attr("href")
        );
      }
    }
  });
});
$(".go-to-top").click(function (event) {
  event.preventDefault();
  $("html, body").animate({ scrollTop: 0 }, 300);
  return false;
});
$(".more-mobile").click(function () {
  $(".area-list-flex").toggleClass("open");
  if ($(".area-list-flex").hasClass("open")) {
    $(".more-mobile").text("<%= t('sidebar.hide')%>");
  } else {
    $(".more-mobile").text("<%= t('sidebar.more')%>");
  }
});
