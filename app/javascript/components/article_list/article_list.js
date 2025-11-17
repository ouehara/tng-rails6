import React from "react";
import LazyLoad from "react-lazyload";

const ArticleList = ({ link, img, area, date, title, topArticle, count }) => {
  return (
    <article className="article-list-item">
      {topArticle && <div className="article-list-item-ribbon">{count}</div>}
      <a href={link}>
        <div className="article-list-item-imageBox">
          <LazyLoad offset={100} height={200}>
            <img className="article-list-item-image" src={img} />
          </LazyLoad>
        </div>
        <div className="article-list-item-body">
          <div className="article-list-item-body-sub">
            <span class="article-list-item-body-sub-area">{area}</span>
            <span>{date}</span>
          </div>
          <h3 className="truncate-overflow">{title}</h3>
        </div>
      </a>
    </article>
  );
};

export default ArticleList;
