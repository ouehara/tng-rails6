import React from "react";
export default class HistoryList extends React.Component {
  constructor(props) {
    super(props);
    this.state = { versions: [] };
  }
  componentWillMount() {
    $.ajax({
      url: " /article/" + this.props.id + "/versions.json",
      type: "GET",
      processData: false,
      contentType: false
    }).done(result => {
      this.setState({ versions: result });
    });
  }
  formatDate(date) {
    let d = new Date(date);
    var options = {
      year: "numeric",
      month: "short",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit"
    };
    return <span>{d.toLocaleDateString("en-US", options)}</span>;
  }
  openEvent(id) {}
  render() {
    return (
      <ul>
        <li>
          {" "}
          <h4> History </h4>{" "}
        </li>
        {this.state.versions.map((version, i) => {
          return (
            <li key={i} onClick={this.openEvent.bind(this, version.id)}>
              {version.event + " "}on {this.formatDate(version.created_at)}
            </li>
          );
        })}
      </ul>
    );
  }
}
