// Copy install command to clipboard
const cmd = document.getElementById("install-cmd-text");
const copyBtn = document.getElementById("copy-cmd-btn");
copyBtn?.addEventListener("click", async () => {
  try {
    await navigator.clipboard.writeText(cmd.textContent.trim());
    const orig = copyBtn.textContent;
    copyBtn.textContent = "✓ Copied";
    copyBtn.classList.add("copied");
    setTimeout(() => {
      copyBtn.textContent = orig;
      copyBtn.classList.remove("copied");
    }, 1600);
  } catch {
    copyBtn.textContent = "Copy failed";
  }
});

// Lazy-load install.ps1 source into the <details> when first opened
const details = document.querySelector(".install-source");
const sourceEl = document.getElementById("install-source-code");
let loaded = false;
details?.addEventListener("toggle", async () => {
  if (!details.open || loaded) return;
  loaded = true;
  try {
    const res = await fetch("./install.ps1");
    sourceEl.textContent = await res.text();
  } catch {
    sourceEl.textContent =
      "# Failed to load install.ps1 — view directly at\n" +
      "# https://github.com/kompound-ca/cs-website/blob/main/install/install.ps1";
  }
});
