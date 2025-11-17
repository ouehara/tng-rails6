export class CustomImageClient {
  constructor() {
    this.params = {};
    this.params.count = 50;
    this.params.offset = 0;
    this.params.mkt = "en-us";
    this.params.safeSearch = "Moderate";
    this.api_key = "";
  }

  search(search, cb) { }
  getImageUrlFromRessource(result) {
    return result.contentUrl;
  }
  getSource(result) {
    var $that = this;
    return new Promise(function (resolve, reject) {
      let res = {};
      let url =
        typeof result.srcurl != "undefined" && result.srcurl != ""
          ? result.srcurl
          : "";
      let text =
        typeof result.sourceText != "undefined" && result.sourceText != ""
          ? result.sourceText
          : "";
      res = { person: { username: { _content: text } }, text: "", srcurl: url };
      resolve(res);
    });
  }
}
export class InstagramClient {
  getSource(result) {
    return new Promise(function (resolve, reject) {
      let res = {};
      res = {
        person: { username: { _content: "Instagram" } },
        text: "Instagram ",
        srcurl: null
      };
      resolve(res);
    });
  }
}
export class BingClient {
  constructor() {
    this.params = {};
    this.params.count = 50;
    this.params.offset = 0;
    this.params.mkt = "en-us";
    this.params.safeSearch = "Moderate";
    this.api_key = "73da52338c5e42b388b59150141f1157";
  }

  search(search, cb) {
    let params = this.params;
    params.q = search;
    let key = this.api_key;

    const url = "https://api.cognitive.microsoft.com/bing/v5.0/images/search?" +
                new URLSearchParams(params).toString();

    fetch(url, {
      method: "POST",
      headers: {
        "Ocp-Apim-Subscription-Key": key,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({})
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .then(data => {
      cb(data.value);
    })
    .catch(error => {
      console.error('Bing API error:', error);
    });
  }
  getImageUrlFromRessource(result) {
    return result.contentUrl;
  }
  getSource(result) {
    var $that = this;
    return new Promise(function (resolve, reject) {
      let res = {};
      let text = "";
      try {
        text = new URL($that.getImageUrlFromRessource(result)).hostname;
      } catch (err) {
        text = $that.getImageUrlFromRessource(result);
      }
      res = {
        person: { username: { _content: text } },
        text: "",
        srcurl: $that.getImageUrlFromRessource(result)
      };
      resolve(res);
    });
  }
}
export class FlickrClient {
  constructor() {
    this.params = {};
    this.params.api_key = "c4ea684fdfd2ac93b50bf6de7469f09e";
    this.params.format = "json";
    this.params.per_page = 50;
    this.params.nojsoncallback = 1;
  }

  search(search, page, cb) {
    let params = this.params;
    params.method = "flickr.photos.search";
    params.text = search;
    params.license = "4,6,7";
    params.page = page;

    const url = "https://api.flickr.com/services/rest?" +
                new URLSearchParams(params).toString();

    fetch(url, {
      method: "GET"
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .then(data => {
      cb(data);
    })
    .catch(error => {
      console.error('Flickr API error:', error);
    });
  }

  getImageUrlFromRessource(result) {
    return (
      "https://farm" +
      result.farm +
      ".static.flickr.com/" +
      result.server +
      "/" +
      result.id +
      "_" +
      result.secret +
      "_c.jpg"
    );
  }
  getSource(result) {
    return this.getUserName(result.owner);
    /*return this.getUserName(result.owner,(res)=>{
        return {url:"https://www.flickr.com/people/"+result.owner,text: res.username._content}
      });*/
  }
  getUserName(uid, cb) {
    let params = this.params;
    params.user_id = uid;
    params.method = "flickr.people.getInfo";

    const url = "https://api.flickr.com/services/rest?" +
                new URLSearchParams(params).toString();

    return fetch(url, {
      method: "GET"
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    });
  }
}

export function getImageFormUrl(url, callback) {
  var img = new Image();
  //img.setAttribute('crossOrigin', 'anonymous');
  img.crossOrigin = "Anonymous";
  img.onload = function (a) {
    var canvas = document.createElement("canvas");
    canvas.width = this.width;
    canvas.height = this.height;
    var ctx = canvas.getContext("2d");
    ctx.drawImage(this, 0, 0);

    var dataURI = canvas.toDataURL("image/jpg");

    // convert base64/URLEncoded data component to raw binary data held in a string
    var byteString;
    if (dataURI.split(",")[0].indexOf("base64") >= 0)
      byteString = atob(dataURI.split(",")[1]);
    else byteString = unescape(dataURI.split(",")[1]);

    // separate out the mime component
    var mimeString = dataURI
      .split(",")[0]
      .split(":")[1]
      .split(";")[0];

    // write the bytes of the string to a typed array
    var ia = new Uint8Array(byteString.length);
    for (var i = 0; i < byteString.length; i++) {
      ia[i] = byteString.charCodeAt(i);
    }

    return callback(new Blob([ia], { type: mimeString }));
  };

  img.src = url;
}
