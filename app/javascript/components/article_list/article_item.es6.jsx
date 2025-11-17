import React, { useState, useEffect, useRef } from "react";
import dayjs from "dayjs";
import link_path from "../shared_components/link_path";

const ArticleItem = ({ elements, articlePath, isPc, type, lang = "en" }) => {
  const [imageSrc, setImageSrc] = useState(null);
  const [imageLoaded, setImageLoaded] = useState(false);
  const [imageError, setImageError] = useState(false);
  const imgRef = useRef(null);
  const observerRef = useRef(null);

  // データの存在チェック
  const isValidData = elements && elements.thumb_url && elements.disp_title;

  useEffect(() => {
    if (!isValidData || !imgRef.current) return;

    // Intersection Observer の設定
    const handleIntersection = (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting && !imageSrc) {
          const fullImageUrl = `${elements.thumb_url}&d=400x400`;
          setImageSrc(fullImageUrl);

          // 観察を停止
          if (observerRef.current) {
            observerRef.current.unobserve(entry.target);
          }
        }
      });
    };

    // Observer の作成
    observerRef.current = new IntersectionObserver(handleIntersection, {
      root: null,
      rootMargin: "50px",
      threshold: 0.1
    });

    // 観察開始
    if (imgRef.current) {
      observerRef.current.observe(imgRef.current);
    }

    // クリーンアップ
    return () => {
      if (observerRef.current) {
        observerRef.current.disconnect();
      }
    };
  }, [isValidData, elements.thumb_url, imageSrc]);

  // 日付フォーマット
  const getFormattedDate = () => {
    if (!elements) return "";

    let d = elements.published_at;
    if (elements.schedule && elements.schedule[lang]) {
      d = elements.schedule[lang];
    }
    return dayjs(d).format("MMM DD, YYYY");
  };

  // テキストの切り詰め
  const getText = (str) => {
    if (!str || typeof str === "undefined") return "";
    return str.length > 90 ? str.substr(0, 80) + "..." : str;
  };

  // サブ情報のレンダリング
  const renderArticleListSub = () => {
    if (!elements) return null;

    return elements.prefecture ? (
      <span style={{ display: "flex", justifyContent: "space-between" }}>
        <span className="articleList_area">{elements.prefecture}</span>
        <span className="articleList_date">{getFormattedDate()}</span>
      </span>
    ) : (
      <>
        <span className="articleList_date">{getFormattedDate()}</span>
        <span className="articleList_author">
          {elements.cached_users?.username || ""}
        </span>
      </>
    );
  };

  // 画像エラーハンドリング
  const handleImageError = () => {
    setImageError(true);
    setImageLoaded(false);
  };

  const handleImageLoad = () => {
    setImageLoaded(true);
    setImageError(false);
  };

  // データが無効な場合の処理
  if (!isValidData) {
    return (
      <div className="articleList_item error">
        <p>記事データが読み込めませんでした</p>
      </div>
    );
  }

  // クラス名の決定
  let classes = "articleList_item col-xs-12 col-sm-4";
  if (type === "articleBlock") {
    classes = isPc
      ? "col-sm-4 articleList_item articleBlock_item"
      : "articleList_item swiper-slide";
  }

  return (
    <article className={classes}>
      <a
        href={link_path(articlePath, [
          { key: ":param", value: elements.slug }
        ])}
        id={elements.id}
      >
        <div className="articleList_thumbnail">
          <div
            ref={imgRef}
            className={`lazy-image-container ${imageLoaded ? "loaded" : ""}`}
            style={{
              backgroundColor: "#f0f0f0",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              position: "absolute",
              width: "100%",
              height: "100%",
              top: "50%",
              left: "50%",
              transform: "translate(-50%, -50%)"
            }}
          >
            {imageSrc && !imageError ? (
              <img
                src={imageSrc}
                alt={elements.disp_title}
                onLoad={handleImageLoad}
                onError={handleImageError}
                style={{
                  opacity: imageLoaded ? 1 : 0,
                }}
              />
            ) : imageError ? (
              <div className="image-error">
                <span>Image could not be loaded.</span>
              </div>
            ) : (
              <div className="image-placeholder">
                <span>Loading...</span>
              </div>
            )}
          </div>
        </div>
        <div className="articleList_text">
          <p className="articleList_sub">{renderArticleListSub()}</p>
          <h3 className="articleList_title">
            {getText(elements.disp_title)}
          </h3>
        </div>
      </a>
    </article>
  );
};

export default ArticleItem;
