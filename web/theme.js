"use strict";
try {
  const theme = localStorage.getItem("theme-v1:" + location.pathname);
  if (["default", "art-crafts", "dark"].includes(theme)) document.documentElement.dataset.theme = theme;
} catch {}
