// グローバルでクリップ数を初期化
import store from "../shared/store";

// ページ読み込み完了時にクリップ数を設定
document.addEventListener('DOMContentLoaded', function() {
  const clipped = store.get("clips") || {};
  const clipCount = Object.keys(clipped).length;
  const navClipNumElement = document.querySelector(".nav_clip_num");

  if (navClipNumElement) {
    navClipNumElement.innerText = clipCount;
  }
});

// Turbo（もしくはTurbolinks）使用時の対応
document.addEventListener('turbo:load', function() {
  const clipped = store.get("clips") || {};
  const clipCount = Object.keys(clipped).length;
  const navClipNumElement = document.querySelector(".nav_clip_num");

  if (navClipNumElement) {
    navClipNumElement.innerText = clipCount;
  }
});
