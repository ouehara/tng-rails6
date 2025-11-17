import React, { useEffect } from "react";

const OtomoWidgetView = props => {
  const { otomoId = "" } = props;
  useEffect(() => {
    const script = document.createElement("script");
    script.src =
      "https://widgets.bokun.io/assets/javascripts/apps/build/BokunWidgetsLoader.js?bookingChannelUUID=49cdf9d5-c2f0-4b57-81d7-c02c02778d9e";
    script.async = true;
    document.body.appendChild(script);
  }, []);
  return (
    <>
      <div
        className="bokunWidget"
        data-src={
          "https://widgets.bokun.io/online-sales/49cdf9d5-c2f0-4b57-81d7-c02c02778d9e/experience/" +
          otomoId
        }
      ></div>
      <noscript>Please enable javascript in your browser to book</noscript>
    </>
  );
};
export default OtomoWidgetView;
