"use strict";
// Runs before the page draws (not deferred): applies the SETTINGS Theme this page
// last saw, so a returning visitor doesn't see the default flash while settings load.
// app.js sets the real theme and saves it under the same key. Not inline, so a
// strict CSP (pro) allows it.
try {
  const theme = localStorage.getItem("theme-v1:" + location.pathname);
  if (theme === "default" || theme === "art-crafts") document.documentElement.dataset.theme = theme;
} catch {}
