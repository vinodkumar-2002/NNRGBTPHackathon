sap.ui.define(["sap/m/MessageToast"], function (MessageToast) {
  "use strict";

  return {
    SetAlumni: function (oBindingContext, aSelectedContexts) {
      aSelectedContexts.forEach((element) => {
        //MessageToast.show(element.sPath);
        var oData = jQuery
          .ajax({
            type: "PATCH",
            contentType: "application/json",
            url: "/odata/v4/student-db" + element.sPath,
            data: JSON.stringify({ is_alumni: true }),
          })
          .then(element.requestRefresh());
      });
    },
  };
});
