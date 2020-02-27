//= require all.js
//= require govwifi-shared-frontend.js

window.addEventListener("DOMContentLoaded", () => {
  window.GOVUKFrontend.initAll();
  window.GovWifi.cookies.checkCookiePolicy();
});
