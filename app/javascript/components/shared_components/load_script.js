var LoadScript = function() {};
LoadScript.prototype.vimeoAccessToken = null;
LoadScript.mapLoaded = false;
LoadScript.prototype.createScript = function(src, callback) {
  var script = document.createElement("script");
  script.type = "text/javascript";
  if (callback) script.onload = callback;
  document.getElementsByTagName("head")[0].appendChild(script);
  script.src = src;
};

LoadScript.prototype.loadGapi = function() {
  window.onYoutubeApiLoaded = function() {
    gapi.client.setApiKey("AIzaSyBq3cb_DOLqvAo_x55mCYpUHUVMlA1f65c");
    gapi.client.load("youtube", "v3", function() {});
  };
  this.createScript(
    "https://apis.google.com/js/client.js?onload=onYoutubeApiLoaded"
  );
};

LoadScript.prototype.loadMapsApi = function(cb) {
  if (
    (typeof google != "undefined" && typeof google.maps == "object") ||
    LoadScript.mapLoaded
  ) {
    return;
  }
  LoadScript.mapLoaded = true;
  window.onMapsApiLoad = function() {
    if (typeof cb == "function") {
      cb();
    }
  };
  this.createScript(
    "https://maps.googleapis.com/maps/api/js?key=AIzaSyD9cjpu-HTxdu1_B9tzzaq5WkLhOKu1pac&libraries=places&callback=onMapsApiLoad"
  );
};

LoadScript.prototype.loadTwitter = function() {
  this.createScript("https://platform.twitter.com/widgets.js");
};

LoadScript.prototype.setVimoeAccessToken = function(cb) {
  $.ajax({
    url: "https://api.vimeo.com/oauth/authorize/client",
    headers: {
      Authorization:
        "basic " +
        btoa(
          "f815a04521a02089f6b7cc93667f28f5d244171d" +
            ":" +
            "ppB4E4UGxE+AxvPnAdF+sQ/PY/VH54lJwUZWkG0fsN10tgYBh4QLyUTl9q6Uya75o0u1j6flEYW39MEP8vCUnsaNBa8IMYO2MJLIOYsEOAJRKalZuYcBkhXN1VIN/+Tk"
        )
    },
    method: "POST",
    data: { grant_type: "client_credentials" },
    success: function(data) {
      cb(data.access_token);
    }
  });
};

LoadScript.prototype.ckEditor = function(cb) {
  this.createScript("https://cdn.ckeditor.com/4.11.4/standard/ckeditor.js", cb);
};

LoadScript.prototype.yahooWeather = function(area, cb) {
  window.weatherLoad = function(data) {
    if (typeof cb == "function") {
      cb(data);
    }
  };
  this.createScript(
    "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='" +
      area +
      " , Jp') AND u='c'&format=json&callback=weatherLoad"
  );
};
export default LoadScript;
/*
LoadScript.prototype.agoda = function (){
  <script type="text/javascript">
    agoda_ad_client = "1755750_74288";
    agoda_ad_width = 300;
    agoda_ad_height = 250;
</script>
this.createScript("//banner.agoda.com/js/show_ads.js")
<script type="text/javascript" src="//banner.agoda.com/js/show_ads.js"></script>
}*/
