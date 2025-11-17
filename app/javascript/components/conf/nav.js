import I18n from "../i18n/i18n";
const baseUrl = I18n.current == "en" ? "/" : "/" + I18n.current + "/";

const items = [
  [
    [
      {
        page_name: I18n.t("savor.hokkaido"),
        id: "g-a_hokkaido",
        url: baseUrl + "area/hokkaido/",
        items: []
      },
      {
        page_name: I18n.t("savor.tohoku"),
        id: "g-a_tohoku",
        url: baseUrl + "area/tohoku/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.aomori"),
            id: "g-a_aomori",
            url: baseUrl + "area/aomori/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.akita"),
            id: "g-a_akita",
            url: baseUrl + "area/akita/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.iwate"),
            id: "g-a_iwate",
            url: baseUrl + "area/iwate/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.miyagi"),
            id: "g-a_miyagi",
            url: baseUrl + "area/miyagi/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.yamagata"),
            id: "g-a_yamagata",
            url: baseUrl + "area/yamagata/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.fukushima"),
            id: "g-a_fukushima",
            url: baseUrl + "area/fukushima/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kanto"),
        id: "g-a_kanto",
        url: baseUrl + "area/kanto/",
        items: [
          {
            page_name: I18n.t("savor.tokyo"),
            id: "g-a_tokyo",
            url: baseUrl + "area/tokyo/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.kanagawa"),
            id: "g-a_kanagawa",
            url: baseUrl + "area/kanagawa/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.saitama"),
            id: "g-a_saitama",
            url: baseUrl + "area/saitama/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.chiba"),
            id: "g-a_chiba",
            url: baseUrl + "area/chiba/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.ibaraki"),
            id: "g-a_ibaraki",
            url: baseUrl + "area/ibaraki/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.tochigi"),
            id: "g-a_tochigi",
            url: baseUrl + "area/tochigi/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.gunma"),
            id: "g-a_gunma",
            url: baseUrl + "area/gunma/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chubu"),
        id: "g-a_chubu",
        url: baseUrl + "area/chubu/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.aichi"),
            id: "g-a_aichi",
            url: baseUrl + "area/aichi/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.yamanashi"),
            id: "g-a_yamanashi",
            url: baseUrl + "area/yamanashi/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.shizuoka"),
            id: "g-a_shizuoka",
            url: baseUrl + "area/shizuoka/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.ishikawa"),
            id: "g-a_Ishikawa",
            url: baseUrl + "area/ishikawa/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.nagano"),
            id: "g-a_nagoya",
            url: baseUrl + "area/nagano/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.gifu"),
            id: "g-a_gifu",
            url: baseUrl + "area/gifu/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.niigata"),
            id: "g-a_niigata",
            url: baseUrl + "area/niigata/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.toyama"),
            id: "g-a_toyama",
            url: baseUrl + "area/toyama/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.fukui"),
            id: "g-a_fukui",
            url: baseUrl + "area/fukui/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kansai"),
        id: "g-a_kansai",
        url: baseUrl + "area/kansai/",
        items: [
          {
            page_name: I18n.t("savor.kyoto_sub.osaka"),
            id: "g-a_osaka",
            url: baseUrl + "area/osaka/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.kyoto"),
            id: "g-a_kyoto",
            url: baseUrl + "area/kyoto/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.nara"),
            id: "g-a_nara",
            url: baseUrl + "area/nara/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.hyogo"),
            id: "g-a_hyogo",
            url: baseUrl + "area/hyogo/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.shiga"),
            id: "g-a_shiga",
            url: baseUrl + "area/shiga/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.mie"),
            id: "g-a_mie",
            url: baseUrl + "area/mie/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.wakayama"),
            id: "g-a_wakayama",
            url: baseUrl + "area/wakayama/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chugoku"),
        id: "g-a_chugoku",
        url: baseUrl + "area/chugoku/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.hiroshima"),
            id: "g-a_hiroshima",
            url: baseUrl + "area/hiroshima/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.tottori"),
            id: "g-a_tottori",
            url: baseUrl + "area/tottori/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.okayama"),
            id: "g-a_okayama",
            url: baseUrl + "area/okayama/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.shimane"),
            id: "g-a_shimane",
            url: baseUrl + "area/shimane/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.yamaguchi"),
            id: "g-a_yamaguchi",
            url: baseUrl + "area/yamaguchi/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.shikoku"),
        id: "g-a_shikoku",
        url: baseUrl + "area/shikoku/",
        items: [
          {
            page_name: I18n.t("savor.shikoku_sub.ehime"),
            id: "g-a_ehime",
            url: baseUrl + "area/ehime/"
          },
          {
            page_name: I18n.t("savor.shikoku_sub.kagawa"),
            id: "g-a_kagawa",
            url: baseUrl + "area/kagawa/"
          },
          {
            page_name: I18n.t("savor.shikoku_sub.tokushima"),
            id: "g-a_tokushima",
            url: baseUrl + "area/tokushima/"
          },
          {
            page_name: I18n.t("savor.shikoku_sub.kochi"),
            id: "g-a_kochi",
            url: baseUrl + "area/kochi/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kyushu"),
        id: "g-a_kyushu",
        url: baseUrl + "area/kyushu/",
        items: [
          {
            page_name: I18n.t("savor.kyushu_sub.fukuoka"),
            id: "g-a_fukuoka",
            url: baseUrl + "area/fukuoka/"
          },
          {
            page_name: I18n.t("savor.kyushu_sub.nagasaki"),
            id: "g_a_nagasaki",
            url: baseUrl + "area/nagasaki/"
          },
          {
            page_name: I18n.t("savor.kyushu_sub.saga"),
            id: "g_a_saga",
            url: baseUrl + "area/saga/"
          },
          {
            page_name: I18n.t("savor.kyushu_sub.kagoshima"),
            id: "g_a_kagoshima",
            url: baseUrl + "area/kagoshima/"
          },
          {
            page_name: I18n.t("savor.kyushu_sub.miyazaki"),
            id: "g_a_miyazaki",
            url: baseUrl + "area/miyazaki/"
          },
          {
            page_name: I18n.t("savor.kyushu_sub.oita"),
            id: "g_a_oita",
            url: baseUrl + "area/oita/"
          },
          {
            page_name: I18n.t("savor.kyushu_sub.kumamoto"),
            id: "g_a_kumamoto",
            url: baseUrl + "area/kumamoto/"
          }
        ]
      },
      {
        page_name: I18n.t("savor.okinawa"),
        id: "g-a_okinawa",
        url: baseUrl + "area/okinawa/",
        items: []
      }
    ]
  ],
  [
    [
      {
        page_name: I18n.t("savor.hokkaido"),
        id: "g-d_hokkaido",
        url: baseUrl + "category/things-to-do/hokkaido/",
        items: []
      }
    ],
    [
      {
        page_name: I18n.t("savor.kanto"),
        id: "g_d_kanto",
        url: baseUrl + "category/things-to-do/kanto/",
        items: [
          {
            page_name: I18n.t("savor.tokyo"),
            id: "g-d_tokyo",
            url: baseUrl + "category/things-to-do/tokyo/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.kanagawa"),
            id: "g-d_kanagawa",
            url: baseUrl + "category/things-to-do/kanagawa/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.chiba"),
            id: "g-d_chiba",
            url: baseUrl + "category/things-to-do/chiba/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.tochigi"),
            id: "g-d_tochigi",
            url: baseUrl + "category/things-to-do/tochigi/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chubu"),
        id: "g-d_chubu",
        url: baseUrl + "category/things-to-do/chubu/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.aichi"),
            id: "g-d_aichi",
            url: baseUrl + "category/things-to-do/aichi/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.ishikawa"),
            id: "g-d_ishikawa",
            url: baseUrl + "category/things-to-do/ishikawa/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.gifu"),
            id: "g-d_gifu",
            url: baseUrl + "category/things-to-do/gifu/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kansai"),
        id: "g-d_kanzsai",
        url: baseUrl + "category/things-to-do/kansai/",
        items: [
          {
            page_name: I18n.t("savor.kyoto_sub.osaka"),
            id: "g-d_osaka",
            url: baseUrl + "category/things-to-do/osaka/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.kyoto"),
            id: "g-d_kyoto",
            url: baseUrl + "category/things-to-do/kyoto/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.hyogo"),
            id: "g-d_hyougo",
            url: baseUrl + "category/things-to-do/hyogo/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chugoku"),
        id: "g-d_chugoku",
        url: baseUrl + "category/things-to-do/chugoku/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.hiroshima"),
            id: "g-d_hirodhima",
            url: baseUrl + "category/things-to-do/hiroshima/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.tottori"),
            id: "g-d_tottori",
            url: baseUrl + "category/things-to-do/tottori/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.okayama"),
            id: "g-d_okayama",
            url: baseUrl + "category/things-to-do/okayama/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.shikoku"),
        id: "g-d_shikoku",
        url: baseUrl + "category/things-to-do/shikoku/",
        items: [
          {
            page_name: I18n.t("savor.shikoku_sub.kagawa"),
            id: "g-d_kagawa",
            url: baseUrl + "category/things-to-do/kagawa/"
          }
        ]
      }
    ]
  ],
  [
    [
      {
        page_name: I18n.t("savor.restaurant_search"),
        id: "g-f_search",
        url: baseUrl + "restaurant/",
        items: []
      },
      {
        page_name: I18n.t("savor.hokkaido"),
        id: "g-f_hokkaido",
        url: baseUrl + "category/food-drink/hokkaido/",
        items: []
      }
    ],
    [
      {
        page_name: I18n.t("savor.kanto"),
        id: "g-f_kanto",
        url: baseUrl + "category/food-drink/kanto/",
        items: [
          {
            page_name: I18n.t("savor.tokyo"),
            id: "g-f_tokyo",
            url: baseUrl + "category/food-drink/tokyo/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.kanagawa"),
            id: "g-f_kanagawa",
            url: baseUrl + "category/food-drink/kanagawa/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.chiba"),
            id: "g-f_chiba",
            url: baseUrl + "category/food-drink/chiba/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.tochigi"),
            id: "g-f_tochigi",
            url: baseUrl + "category/food-drink/tochigi/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chubu"),
        id: "g-f_chubu",
        url: baseUrl + "category/food-drink/chubu/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.aichi"),
            id: "g-f_aichi",
            url: baseUrl + "category/food-drink/aichi/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.ishikawa"),
            id: "g-f_ishikawa",
            url: baseUrl + "category/food-drink/ishikawa/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.gifu"),
            id: "g-f_gifu",
            url: baseUrl + "category/food-drink/gifu/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kansai"),
        id: "g-f_kansai",
        url: baseUrl + "category/food-drink/kansai/",
        items: [
          {
            page_name: I18n.t("savor.kyoto_sub.osaka"),
            id: "g-f_osaka",
            url: baseUrl + "category/food-drink/osaka/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.kyoto"),
            id: "g-f_kyoto",
            url: baseUrl + "category/food-drink/kyoto/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.hyogo"),
            id: "g-f_hyogo",
            url: baseUrl + "category/food-drink/hyogo/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chugoku"),
        id: "g-f_chugoku",
        url: baseUrl + "category/food-drink/chugoku/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.hiroshima"),
            id: "g-f_hiroshima",
            url: baseUrl + "category/food-drink/hiroshima/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.tottori"),
            id: "g-f_tottori",
            url: baseUrl + "category/food-drink/tottori/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.okayama"),
            id: "g-f_okayama",
            url: baseUrl + "category/food-drink/okayama/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.shikoku"),
        id: "g-f_shikoku",
        url: baseUrl + "category/food-drink/shikoku/",
        items: [
          {
            page_name: I18n.t("savor.shikoku_sub.kagawa"),
            id: "g-f_kagawa",
            url: baseUrl + "category/food-drink/kagawa/"
          }
        ]
      }
    ]
  ],
  [
    [
      {
        page_name: I18n.t("savor.hokkaido"),
        id: "g-h_hokkaido",
        url: baseUrl + "category/hotels-ryokan/hokkaido/",
        items: []
      }
    ],
    [
      {
        page_name: I18n.t("savor.kanto"),
        id: "g-h_kanto",
        url: baseUrl + "category/hotels-ryokan/kanto/",
        items: [
          {
            page_name: I18n.t("savor.tokyo"),
            id: "g-h_tokyo",
            url: baseUrl + "category/hotels-ryokan/tokyo/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.tochigi"),
            id: "g-h_tochigi",
            url: baseUrl + "category/hotels-ryokan/tochigi/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chubu"),
        id: "g-h_chubu",
        url: baseUrl + "category/hotels-ryokan/chubu/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.aichi"),
            id: "g-h_aichi",
            url: baseUrl + "category/hotels-ryokan/aichi/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.ishikawa"),
            id: "g-h_ishikawa",
            url: baseUrl + "category/hotels-ryokan/ishikawa/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kansai"),
        id: "g-h_kansai",
        url: baseUrl + "category/hotels-ryokan/kansai/",
        items: [
          {
            page_name: I18n.t("savor.kyoto_sub.osaka"),
            id: "g-h_osaka",
            url: baseUrl + "category/hotels-ryokan/osaka/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.kyoto"),
            id: "g-h_kyoto",
            url: baseUrl + "category/hotels-ryokan/kyoto/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.hyogo"),
            id: "g-h_hyogo",
            url: baseUrl + "category/hotels-ryokan/hyogo/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chugoku"),
        id: "g-h_chugoku",
        url: baseUrl + "category/hotels-ryokan/chugoku/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.hiroshima"),
            id: "g-h_hirosima",
            url: baseUrl + "category/hotels-ryokan/hiroshima/"
          }
        ]
      }
    ]
  ],
  [
    [
      {
        page_name: I18n.t("savor.hokkaido"),
        id: "g-s_hokkaido",
        url: baseUrl + "category/shopping/hokkaido/",
        items: []
      },
      {
        page_name: I18n.t("savor.tohoku"),
        id: "g-s_tohoku",
        url: baseUrl + "category/shopping/tohoku/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.aomori"),
            id: "g-s_aomori",
            url: baseUrl + "category/shopping/aomori/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.iwate"),
            id: "g-s_iwate",
            url: baseUrl + "category/shopping/iwate/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.fukushima"),
            id: "g-s_fukushima",
            url: baseUrl + "category/shopping/fukushima/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kanto"),
        id: "g-s_kanto",
        url: baseUrl + "category/shopping/kanto/",
        items: [
          {
            page_name: I18n.t("savor.tokyo"),
            id: "g-s_tokyo",
            url: baseUrl + "category/shopping/tokyo/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.kanagawa"),
            id: "g-s_kanagawa",
            url: baseUrl + "category/shopping/kanagawa/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.saitama"),
            id: "g-s_saitama",
            url: baseUrl + "category/shopping/saitama/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chubu"),
        id: "g-s_chubu",
        url: baseUrl + "category/shopping/chubu/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.aichi"),
            id: "g-s_aichi",
            url: baseUrl + "category/shopping/aichi/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kansai"),
        id: "g-s_kansai",
        url: baseUrl + "category/shopping/kansai/",
        items: [
          {
            page_name: I18n.t("savor.kyoto_sub.osaka"),
            id: "g-s_osaka",
            url: baseUrl + "category/shopping/osaka/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.kyoto"),
            id: "g-s_kyoto",
            url: baseUrl + "category/shopping/kyoto/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chugoku"),
        id: "g-s_chugoku",
        url: baseUrl + "category/shopping/chugoku/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.tottori"),
            id: "g-s_tottori",
            url: baseUrl + "category/shopping/tottori/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.okayama"),
            id: "g-s_okayama",
            url: baseUrl + "category/shopping/okayama/"
          }
        ]
      }
    ]
  ],
  [
    [
      {
        page_name: I18n.t("savor.kanto"),
        id: "g-t_kanto",
        url: baseUrl + "category/travel-tips/kanto/",
        items: [
          {
            page_name: I18n.t("savor.tokyo"),
            id: "g-t_tokyo",
            url: baseUrl + "category/travel-tips/tokyo/"
          },
          {
            page_name: I18n.t("savor.tokyo_sub.kanagawa"),
            id: "g-t_kanagawa",
            url: baseUrl + "category/travel-tips/kanagawa/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kansai"),
        id: "g-t_kansai",
        url: baseUrl + "category/travel-tips/kansai/",
        items: [
          {
            page_name: I18n.t("savor.kyoto_sub.osaka"),
            id: "g-t_osaka",
            url: baseUrl + "category/travel-tips/osaka/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.kyoto"),
            id: "g-t_kyoto",
            url: baseUrl + "category/travel-tips/kyoto/"
          }
        ]
      }
    ]
  ],
  [
    [
      {
        page_name: I18n.t("savor.tohoku"),
        id: "g-j_tohoku",
        url: baseUrl + "category/japan-in-depth/tohoku/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.akita"),
            id: "g-j_akita",
            url: baseUrl + "category/japan-in-depth/akita/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kanto"),
        id: "g-j_kanto",
        url: baseUrl + "category/japan-in-depth/kanto/",
        items: [
          {
            page_name: I18n.t("savor.tokyo"),
            id: "g-j_tokyo",
            url: baseUrl + "category/japan-in-depth/tokyo/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.chubu"),
        id: "g-j_chubu",
        url: baseUrl + "category/japan-in-depth/chubu/",
        items: [
          {
            page_name: I18n.t("savor.honshu_sub.aichi"),
            id: "g-j_aichi",
            url: baseUrl + "category/japan-in-depth/aichi/"
          },
          {
            page_name: I18n.t("savor.honshu_sub.yamanashi"),
            id: "g-j_yamanashi",
            url: baseUrl + "category/japan-in-depth/yamanashi/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.kansai"),
        id: "g-j_kansai",
        url: baseUrl + "category/japan-in-depth/kansai/",
        items: [
          {
            page_name: I18n.t("savor.kyoto_sub.kyoto"),
            id: "g-j_kyoto",
            url: baseUrl + "category/japan-in-depth/kyoto/"
          },
          {
            page_name: I18n.t("savor.kyoto_sub.shiga"),
            id: "g-j_shiga",
            url: baseUrl + "category/japan-in-depth/shiga/"
          }
        ]
      }
    ],
    [
      {
        page_name: I18n.t("savor.shikoku"),
        id: "g-j_shikoku",
        url: baseUrl + "category/japan-in-depth/shikoku/",
        items: [
          {
            page_name: I18n.t("savor.shikoku_sub.ehime"),
            id: "g-j_ehime",
            url: baseUrl + "category/japan-in-depth/ehime/"
          }
        ]
      }
    ]
  ]
];

const footer = [
  {
    page_name: I18n.t("footer.contact"),
    id: "f_contact",
    // url: baseUrl + "contact/new/",
    url: "https://www.d2cx.co.jp/contact/?lang=en",
    new_tab: true
  },
  {
    page_name: I18n.t("footer.login"),
    id: "f_login",
    url: "/users/sign_in/",
    new_tab: false
  },
  {
    page_name: I18n.t("footer.company"),
    id: "f_company",
    url: "https://www.d2cx.co.jp/",
    new_tab: true
  },
  {
    page_name: I18n.t("partner"),
    id: "f_company",
    url: baseUrl + "partners/",
    new_tab: false
  },
  {
    page_name: I18n.t("footer.privacy"),
    id: "f_privacy",
    url: baseUrl + "privacy/",
    new_tab: false
  },
  {
    page_name: I18n.t("footer.terms"),
    id: "f_terms",
    url: baseUrl + "terms/",
    new_tab: false
  },
  {
    page_name: I18n.t("footer.jobs"),
    id: "f_jobs",
    url: baseUrl + "tsunagu-japan-jobs/",
    new_tab: false
  },
  {
    page_name: I18n.t("footer.dmc"),
    id: "f_dmc",
    url: baseUrl + "tsunagu-japan-travel-dmc/",
    new_tab: false
  }
];

export { footer, items };
