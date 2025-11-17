let _cb = null;
const store = {
  get: (key) => {
    const item = localStorage.getItem(key);
    try {
      return JSON.parse(item);
    } catch (e) {
      return {};
    }
  },

  set: (key, value) => {
    const res = localStorage.setItem(key, JSON.stringify(value));
    if (typeof _cb == "function") {
      _cb();
    }
    return res;
  },
  watch: (cb) => {
    _cb = cb;
  },
};
export default store;
