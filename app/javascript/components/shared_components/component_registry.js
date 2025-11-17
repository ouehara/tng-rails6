export default class ComponentRegistry {
  constructor() {
    this.componentList = {};
  }
  register(comp) {
    Object.assign(this.componentList, comp);
  }

  getComponentByName(name) {
    if (this.componentList[name]) {
      return this.componentList[name];
    }
    throw "Component " + name + " is not in Registry";
  }
}
