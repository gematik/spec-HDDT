// Description: Dynamically load giscus comment system
// Since IG-Publisher prohibits inline <script> tags, we need to load giscus dynamically
(function () {
  var me = document.currentScript;
  if (!me) return;

  // optional: skip on utility pages
  var p = (location.pathname || "").toLowerCase();
  if (p.endsWith("/qa.html") || p.endsWith("/toc.html")) return;

  var real = document.createElement("script");
  real.src = "https://giscus.app/client.js";
  real.async = true;
  real.crossOrigin = "anonymous";

  // copy all data-* attributes so config is preserved
  for (var i = 0; i < me.attributes.length; i++) {
    var a = me.attributes[i];
    if (a.name && a.name.indexOf("data-") === 0) {
      real.setAttribute(a.name, a.value);
    }
  }

  // insert right after the loader
  me.parentNode && me.parentNode.insertBefore(real, me.nextSibling);
})();