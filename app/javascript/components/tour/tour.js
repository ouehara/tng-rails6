import React from "react";
import I18n from "../i18n/i18n";
const tour = ({ title, money, area, duration, details, buttons, image }) => {
  return (
    <>
      <div className="tour-header">
        <a href={details}>
          <img src={image} className="img-responsive" />
        </a>
      </div>
      <div className="tour-body">
        <h3>{title}</h3>
        <div>
          <span>
            {money} {I18n.t("tours.currency")}
          </span>
        </div>
        <div className="sub-details">
          <span className="small area">{area}</span>
          <span className="small"> {duration}</span>
        </div>
      </div>
      <div className="tour-footer">
        <a className="details-btn" href={details}>
          {I18n.t("tours.details")}
        </a>
        {buttons.map(button => {
          if (button.link != "") {
            return (
              <a
                key={button.label}
                href={button.link}
                target="_blank"
                className="external-button"
              >
                <span>{button.btn}</span>
              </a>
            );
          }
        })}
      </div>
    </>
  );
};
export default tour;
