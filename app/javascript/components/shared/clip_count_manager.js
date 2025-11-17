/**
 * クリップ数管理のためのユーティリティクラス
 */
import store from "./store";

class ClipCountManager {
  static updateNavClipCount() {
    const clipped = store.get("clips") || {};
    const clipCount = Object.keys(clipped).length;
    const navClipNumElement = document.querySelector(".nav_clip_num");

    if (navClipNumElement) {
      navClipNumElement.innerText = clipCount;
    }

    return clipCount;
  }

  static initializeClipCount() {
    // ページ読み込み時の初期化
    document.addEventListener('DOMContentLoaded', () => {
      this.updateNavClipCount();
    });

    // React コンポーネントからも呼び出し可能
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => {
        this.updateNavClipCount();
      });
    } else {
      this.updateNavClipCount();
    }
  }

  static addClip(postId, postData) {
    const clipped = store.get("clips") || {};
    clipped[postId] = postData;
    store.set("clips", clipped);

    return this.updateNavClipCount();
  }

  static removeClip(postId) {
    const clipped = store.get("clips") || {};
    delete clipped[postId];
    store.set("clips", clipped);

    return this.updateNavClipCount();
  }
}

export default ClipCountManager;
