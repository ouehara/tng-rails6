import React from "react";
export default class ContextMenu extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      visible: false
    };
  }

  componentDidMount() {
    this.contextRef.addEventListener(
      "contextmenu",
      this._handleContextMenu.bind(this)
    );
    document.addEventListener("click", this._handleClick.bind(this));
    document.addEventListener("scroll", this._handleScroll.bind(this));
  }

  componentWillUnmount() {
    this.contextRef.removeEventListener("contextmenu", this._handleContextMenu);
    document.removeEventListener("click", this._handleClick);
    document.removeEventListener("scroll", this._handleScroll);
  }

  _handleContextMenu(event) {
    event.preventDefault();

    this.setState({ visible: true }, () => {
      if (typeof this.props.openCb != "undefined") {
        this.props.openCb();
      }
    });

    const clickX = event.clientX;
    const clickY = event.clientY;
    const screenW = window.innerWidth;
    const screenH = window.innerHeight;
    const rootW = this.root.offsetWidth;
    const rootH = this.root.offsetHeight;

    const right = screenW - clickX > rootW;
    const left = !right;
    const top = screenH - clickY > rootH;
    const bottom = !top;

    if (right) {
      this.root.style.left = `${clickX + 5}px`;
    }

    if (left) {
      this.root.style.left = `${clickX - rootW - 5}px`;
    }

    if (top) {
      this.root.style.top = `${clickY + 5}px`;
    }

    if (bottom) {
      this.root.style.top = `${clickY - rootH - 5}px`;
    }
  }

  _handleClick(event) {
    const { visible } = this.state;
    if (this.contextRef === null) {
      return;
    }
    const wasOutside = !this.contextRef.contains(event.target);
    if (wasOutside && visible)
      this.setState({ visible: false }, () => {
        if (typeof this.props.closeCb != "undefined") this.props.closeCb();
      });
  }

  _handleScroll() {
    const { visible } = this.state;

    if (visible)
      this.setState({ visible: false }, () => {
        if (typeof this.props.closeCb != "undefined") this.props.closeCb();
      });
  }

  render() {
    const { visible } = this.state;
    let { width, height } = this.props.defaultValues;
    width = width == "auto" ? "0" : width;
    height = height == "auto" ? "0" : height;
    return (
      <div
        className="context-menu"
        ref={ref => {
          this.contextRef = ref;
        }}
      >
        {(visible || null) && (
          <div
            ref={ref => {
              this.root = ref;
            }}
            className="contextMenu"
          >
            <div className="contextMenu--option">
              <div className="input-group">
                <span className="input-group-addon" id="basic-addon1">
                  width
                </span>
                <input
                  type="number"
                  className="form-control"
                  placeholder="0"
                  aria-describedby="basic-addon1"
                  value={width}
                  onChange={this.props.inputChange.bind(this, "width")}
                />
              </div>
            </div>
            {/*
          <div className="contextMenu--option">
            <div className="input-group">
              <span className="input-group-addon" id="basic-addon1">height</span>
              <input type="number" className="form-control" placeholder="0" aria-describedby="basic-addon1" value={height} onChange={this.props.inputChange.bind(this, "height")} />
            </div>
          </div>*/}
          </div>
        )}
        {this.props.children}
      </div>
    );
  }
}
