export default function link_path(path, param) {
  if (typeof path !== "string") {
    throw "path is not a valid parameter";
  }
  for (var i in param) {
    path = path.replace(param[i].key, param[i].value);
  }
  return path;
}
