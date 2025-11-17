import React from "react";
import axios from "axios";
import LazyLoad from "react-lazyload";
// import { Carousel } from "react-responsive-carousel";
import I18n from "../i18n/i18n";
import Adsense from "../ads/adsense";

// Travel Category ID
const travelCategoryId = {
  "en": {
    "hotels": 38,
    "activities": 39,
    "tickets": 40,
    "tours": 240,
    "transportation": 41,
    "shopping": 238,
    "restaurant": 239
  },
  "ja": {
    "hotels": 385,
    "activities": 389,
    "tickets": 392,
    "tours": 393,
    "transportation": 384,
    "shopping": 391,
    "restaurant": 390
  },
  "zh-hant": {
    "hotels": 303,
    "activities": 299,
    "tickets": 346,
    "tours": 361,
    "transportation": 365,
    "shopping": 353,
    "restaurant": 356
  },
  "th": {
    "hotels": 354,
    "activities": 302,
    "tickets": 348,
    "tours": 363,
    "transportation": 367,
    "shopping": 359,
    "restaurant": 357
  },
  "vi": {
    "hotels": 355,
    "activities": 300,
    "tickets": 349,
    "tours": 364,
    "transportation": 368,
    "shopping": 360,
    "restaurant": 358
  },
  "ko": {
    "hotels": 350,
    "activities": 301,
    "tickets": 347,
    "tours": 362,
    "transportation": 366,
    "shopping": 351,
    "restaurant": 352
  },
}

// Travel Tags(Area) ID
const travelTagId = {
  "en": {
    "tokyo": 42,
    "osaka": 43,
    "kyoto": 44,
    "iwate": 404
  },
  "ja": {
    "tokyo": 397,
    "osaka": 396,
    "kyoto": 395
  },
  "zh-hant": {
    "tokyo": 236,
    "osaka": 295,
    "kyoto": 289
  },
  "th": {
    "tokyo": 298,
    "osaka": 293,
    "kyoto": 292
  },
  "vi": {
    "tokyo": 297,
    "osaka": 296,
    "kyoto": 290
  },
  "ko": {
    "tokyo": 237,
    "osaka": 294,
    "kyoto": 291
  },
}

// tJ Article Category Check
const cateHotels = ['accommodation', 'ryokan', 'hotels', 'capsule-hotels', 'airbnb', 'hostels-guest-houses', 'love-hotels', 'shukubo', 'appartments-for-rent'];
const cateActivities = ['things-to-do', 'activities', 'tourist-spots-attractions', 'events', 'flowers-trees', 'nature-scenery', 'mountains', 'parks-gardens', 'onsens-spas', 'animals', 'sports-outdoors', 'castles', 'temples', 'shrines', 'museums-art-galleries', 'theme-parks', 'japan-at-night', 'cruises', 'hair-salons', 'beauty-salons', 'old-japan', 'karaoke', 'cinema', 'skyline-observatories', 'churches', 'meditation', 'exhibitions', 'day-trips', 'workshops', 'factory-tours', 'instagrammable-photo-spots', 'hachiko-statue', 'rainbow-bridge', 'tokyo-tower', 'tokyo-skytree', 'shirakawago-gokayama', 'dotonbori', 'gion', 'imperial-palace', 'robot-restaurant', 'umeda-sky-building', 'sunshine-city', 'roppongi-hills', 'tokyo-metropolitan-government-building', 'kyoto-tower', 'tsutenkaku', 'sekigahara-battlefield', 'yokohama-chinatown', 'tokyo-midtown', 'farm-tomita', 'otaru-canal', 'atomic-bomb-dome', 'shibuya-scramble-crossing', 'kokusai-dori-street', 'world-heritage-sites', 'higashichaya-district', 'festivals-matsuri', 'hinamatsuri', 'tanabata', 'golden-week', 'mikoshi', 'olympics', 'new-year', 'christmas', 'valentine-s-day-white-day', 'setsubun', 'halloween', 'illuminations', 'fireworks', 'hanami-sakura', 'autumn-leaves-momiji', 'japanese-plum', 'wisteria', 'hydrangeas', 'lavender', 'sunflowers', 'ginkgo', 'beaches-seas', 'rivers', 'waterfalls', 'lakes', 'power-spots', 'mt-fuji', 'mt-takao', 'mt-koya', 'mt-aso', 'mt-moiwa', 'ueno-park', 'nara-park', 'yoyogi-park', 'hitachi-seaside-park', 'ashikaga-flower-park', 'shinjuku-gyoen-national-park', 'hamarikyu-gardens', 'inokashira-park', 'kenrokuen-garden', 'osaka-castle-park', 'showa-kinen-park', 'hiroshima-peace-memorial-park', 'korakuen', 'odaiba-seaside-park', 'ritsurin-garden', 'kawachi-wisteria-park', 'hirosaki-park', 'onsen', 'sento', 'rotenburo', 'spas', 'footbath', 'aquariums', 'zoos', 'animal-cafes', 'skiing', 'snowboarding', 'martial-arts', 'sumo', 'walking-hiking', 'camping', 'bicycles', 'horse-racing', 'fishing', 'stadiums', 'scuba-diving', 'rafting', 'snorkeling', 'water-sports', 'osaka-castle', 'himeji-castle', 'shurijo-castle', 'nijo-castle', 'matsumoto-castle', 'nagoya-castle', 'hiroshima-castle', 'kumamoto-castle', 'kanazawa-castle', 'odawara-castle', 'hikone-castle', 'inuyama-castle', 'okayama-castle', 'matsuyama-castle', 'gifu-castle', 'kochi-castle', 'bitchu-matsuyama-castle', 'sankakuji', 'hasedera', 'kinkakuji', 'ginkakuji', 'sensoji-temple-kaminarimon', 'rokkakudou', 'byodoin-temple', 'kiyomizu-dera-temple', 'tenryuji-temple', 'todaiji-temple', 'sanjusangendo', 'ryoanji', 'kodaiji-temple', 'zojoji-temple', 'kotokuin', 'unpenji', 'zenkoji-temple', 'eikando-temple', 'saihoji', 'naritasan-shinshoji-temple', 'daishoin-temple', 'enkoji-temple', 'itsukushima-shrine', 'yasaka-shrine', 'yasukuni-shrine', 'ise-jingu-shrine', 'meiji-jingu-shrine', 'sumiyoshi-taisha', 'kasuga-taisha', 'hakone-shrine', 'fushimi-inari-taisha-shrine', 'ueno-toshogu-shrine', 'nikko-toshogu', 'dazaifu-tenmangu', 'atsuta-shrine', 'enoshima-shrine', 'ferris-wheels', 'universal-studios-japan', 'tokyo-disney-resort', 'tokyo-dome-dome-city', 'fuji-q-highland', 'huis-ten-bosch', 'legoland-discovery-center', 'tokyo-joypolis', 'yomiuri-land', 'reoma-resort', 'kabukicho', 'golden-gai', 'omoide-yokocho', 'experiences', 'indoor-activities', 'outdoor-activities', 'cultural-experiences', 'indoor-activities', 'outdoor-activities', 'cultural-experiences', 'attractions', 'shows', 'cooking-classes'];
const cateTickets = ['tickets', 'museum-gallery-tickets', 'exhibition-tickets'];
const cateTours = ['tours', 'bus-tours', 'local-tours', 'food-tours', 'bar-hopping-tours'];
const cateTransportation = ['transportation', 'buses', 'trains-stations', 'shinkansen', 'subways-metro', 'travel-passes', 'cars-car-rental', 'taxis', 'coin-lockers-luggage-storage', 'accessibility', 'train-tickets', 'bus-tickets'];
const cateShopping = ['shopping', 'shopping-districts-markets', 'konbini', 'beauty-cosmetics', 'brands-stores', 'clothes-fashion', 'supermarkets', 'stationery-toys', 'books-bookstores', 'souvenirs', '100-yen-shops', 'outlet-stores', 'jewelry-accessories', 'duty-free', 'electronics', 'medicine', 'department-stores', 'drugstores-pharmacies', 'second-hand-shops', 'coupons', 'nishiki-market', 'takeshita-dori-street', 'tsukiji-outer-market', 'nakano-broadway', 'ameyoko-market', 'nakamise-shopping-street', 'yokohama-red-brick-warehouse', 'omicho-market', 'tokyo-solamachi', 'kappabashi-street', 'makeup', 'face-masks', 'skincare', 'medicated-cosmetics'];
const cateRestaurant = ['food-drinks', 'restaurant-types', 'sushi', 'sashimi', 'fish-seafood', 'meat', 'ramen', 'noodles-pasta', 'donburi-rice', 'sweets-snacks', 'other-japanese-food', 'japanese-alcohol', 'japanese-green-tea', 'non-alcoholic-drinks', 'dietary-restrictions-preferences', 'restaurants', 'izakaya', 'street-food', 'cafes', 'bars-pubs', 'all-you-can-eat', 'maid-cafes', 'fast-food', 'family-restaurants', 'conveyor-belt-sushi', 'local-cuisine', 'michelin-star-restaurants', 'breakfast', 'lunch', 'dinner', 'themed-cafes', 'octopus-takoyaki', 'unagi', 'fugu', 'crab', 'tuna', 'oysters', 'wagyu', 'kobe-beef', 'matsusaka-beef', 'shabu-shabu', 'yakitori', 'yakiniku', 'sukiyaki', 'tonkatsu', 'karaage', 'steak', 'gyutan', 'hamburger', 'pork', 'horse-meat', 'yakisoba', 'udon', 'soba', 'somen', 'pasta', 'onigiri', 'omurice', 'curry', 'oyakodon', 'gyudon', 'kaisendon', 'unadon', 'tendon', 'mochi', 'pancakes-crepes', 'anko', 'wagashi', 'candy', 'kakigori', 'cake', 'ice-cream', 'fruit', 'senbei', 'chocolate', 'bread', 'pizza', 'sandwiches', 'strawberry', 'pudding', 'potato-chips', 'parfait', 'baumkuchen', 'tofu', 'edamame', 'gyoza', 'tempura', 'miso', 'teppanyaki', 'okonomiyaki', 'bento-ekiben', 'soy-sauce', 'furikake', 'natto', 'oden', 'japanese-hot-pot', 'kaiseki', 'monjayaki', 'teishoku', 'chanko', 'sake', 'whisky', 'shochu', 'beer', 'umeshu', 'cocktails-chuhai', 'matcha', 'sencha', 'hojicha', 'ramune', 'coffee', 'milk', 'vegetarian-vegan', 'halal-food', 'kosher-food', 'organic'];
class TravelContentsView extends React.Component {
  constructor(props) {
    super(props);
    // 初期値設定
    const { locale = "en", currentCateSlug = "things-to-do", currentAreaDepth = "others", position = "h2before" } = this.props;
    this.state = {
      post: [],
      locale: locale,
      currentCateSlug: currentCateSlug,
      currentAreaDepth: currentAreaDepth,
      position: position,
    };
  }

  componentDidMount() {
    // console.log(this.state.currentAreaDepth);
    let travelCategory = "";
    let travelTag = "";

    if (cateHotels.includes(this.state.currentCateSlug)) {
      travelCategory = "hotels";
    } else if (cateActivities.includes(this.state.currentCateSlug)) {
      travelCategory = "activities";
    } else if (cateTickets.includes(this.state.currentCateSlug)) {
      travelCategory = "tickets";
    } else if (cateTours.includes(this.state.currentCateSlug)) {
      travelCategory = "tours";
    } else if (cateTransportation.includes(this.state.currentCateSlug)) {
      travelCategory = "transportation";
    } else if (cateShopping.includes(this.state.currentCateSlug)) {
      travelCategory = "shopping";
    } else if (cateRestaurant.includes(this.state.currentCateSlug)) {
      travelCategory = "restaurant";
    }
    // console.log(`category: ${travelCategory}`);

    // tJ Article Area Category Check
    if (this.state.currentAreaDepth.includes("kanto/tokyo")) {
      travelTag = "tokyo";
    } else if (this.state.currentAreaDepth.includes("kansai/osaka")) {
      travelTag = "osaka";
    } else if (this.state.currentAreaDepth.includes("kansai/kyoto")) {
      travelTag = "kyoto";
    } else if (this.state.currentAreaDepth.includes("tohoku/iwate")) {
      travelTag = "iwate";
    }
    // console.log(`Area: ${travelTag}`);

    let noCorsURL = "https://travel.tsunagujapan.com/";
    let wpEndpoint = "posts?meta_key=loftocean-view-count&order=desc&per_page=3";
    let dataUrl = "";
    let cateId = "";
    let tagId = "";

    if (this.state.locale !== "en"
      && this.state.locale !== "zh-hans"
      && this.state.locale !== "id") {
      cateId = travelCategoryId[this.state.locale][travelCategory];
      dataUrl = `${noCorsURL}${this.state.locale}/wp-json/wp/v2/${wpEndpoint}&categories=${cateId}`;
      tagId = travelTagId[this.state.locale][travelTag];
    } else {
      cateId = travelCategoryId.en[travelCategory];
      dataUrl = `${noCorsURL}wp-json/wp/v2/${wpEndpoint}&categories=${cateId}`;
      tagId = travelTagId.en[travelTag];
    }

    // 該当するTag IDが存在し、且つshoppingカテゴリーではない場合はコンテンツの絞り込み条件に追加する
    if ((typeof tagId !== "undefined") && (travelCategory !== "shopping")) {
      dataUrl += `&tags=${tagId}`;
    }

    // console.log(dataUrl);
    // console.log(tagId);

    axios.get(dataUrl)
      .then(response => {
        this.setState({ post: response.data });
        // console.log(response.data);
      })
      .catch(error => {
        console.log(error);
      });
  }

  renderTravelContents() {
    // console.log(this.state.post);
    if (Array.isArray(this.state.post) && (this.state.post).length) {
      return (
        <LazyLoad height={200} offset={100}>
          <section className={`post_travel ${this.state.position}`}>
            <h3 className="post_travel-heading">{I18n.t("article.travelSite.heading")}</h3>
            <div className="post_travelContents">
              {this.state.post.map((single, index) => {
                const price = single.acf.price_data;
                const rating = single.acf.rating_score;
                return (
                  <div className="post_travelContent" key={index}>
                    <a
                      className="post_travelContent-imageBox"
                      href={single.link + `?utm_source=tsunagujapan&utm_medium=referral&utm_campaign=article_travelSlide&utm_content=slide_${this.state.locale}`}
                      target="_blank"
                    >
                      <img
                        src={single.thumbnails.eaven_small.url}
                        alt={single.title}
                        className="post_travelContent-image"
                        width={243}
                        height={137}
                      />
                    </a>
                    <div className="post_travelContent-detail">
                      <a
                        className="post_travelContent-link"
                        href={single.link + `?utm_source=tsunagujapan&utm_medium=referral&utm_campaign=article_travelSlide&utm_content=slide_${this.state.locale}`}
                        target="_blank"
                      >
                        <h4 className="post_travelContent-title">{single.title}</h4>
                        {price !== "" &&
                          <p className="post_travelContent-price">&yen;&nbsp;{price.toLocaleString()}&nbsp;~</p>
                        }
                        {rating !== "" &&
                          <p className="post_travelContent-rating">
                            <span
                              className="post_travelContent-stars"
                              style={{ "--rating": `${rating}` }}
                              aria-label={`Rating of this content is ${rating} out of 5.`}
                            ></span>
                            <strong>&nbsp;&nbsp;{rating.toFixed(1)}</strong>
                          </p>
                        }
                      </a>
                      <div className="post_travelContent-sponsored">
                        <a
                          href={single.acf.booking_link_1}
                          target="_blank"
                          rel="sponsored"
                        >
                          {single.acf.button_text_1}
                        </a>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </section>
        </LazyLoad>
      );
    } else {
      if (this.state.position == "h2before") {
        return (
          <div className="adsense-h2before travel_noConte">
            <Adsense
              className={"ads_img"}
              style={{ display: 'inline-block', width: '300px', height: '250px' }}
              client={"ca-pub-4177280178292675"}
              slot={"3109749966"}
            />
          </div>
        );
      } else {
        return (
          <div className="adsense-h3before travel_noConte">
            <Adsense
              style={{ display: 'block', textAlign: 'center' }}
              client={"ca-pub-4177280178292675"}
              slot={"2323282870"}
              layout={"in-article"}
              format={"fluid"}
            />
          </div>
        );
      }
    }
  }

  render() {
    return (
      <>
        {this.renderTravelContents()}
      </>
    );
  }
}

export default TravelContentsView;
