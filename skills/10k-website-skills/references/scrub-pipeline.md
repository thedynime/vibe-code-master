# Scroll Scrub Pipeline & Quality Standards

Engineering standards for rendering video synchronized to scroll progress.

## 1. Video Loading as Blob
Browsers handle smooth video seeking best when the file is loaded into memory as an object URL / Blob:

```javascript
async function loadVideoBlob(url) {
  const response = await fetch(url);
  const blob = await response.blob();
  return URL.createObjectURL(blob);
}
```

## 2. Linear Interpolation (Lerp) rAF Loop
Never bind `video.currentTime` directly to `window.onscroll`. Use a requestAnimationFrame loop with linear interpolation to eliminate jitter:

```javascript
let targetProgress = 0;
let currentProgress = 0;
const LERP_FACTOR = 0.08; // Smoothness factor (0.05 - 0.12)

function onScroll() {
  const container = document.getElementById('hero-scroll-track');
  const rect = container.getBoundingClientRect();
  const maxScroll = container.offsetHeight - window.innerHeight;
  const progress = Math.max(0, Math.min(1, -rect.top / maxScroll));
  targetProgress = progress;
}

function updateFrame() {
  if (Math.abs(targetProgress - currentProgress) > 0.0005) {
    currentProgress += (targetProgress - currentProgress) * LERP_FACTOR;
    if (video.duration) {
      video.currentTime = currentProgress * video.duration;
    }
  }
  requestAnimationFrame(updateFrame);
}
```

## 3. Caption Band Pacing & Scrims
- Each caption must have a wide plateau where it is 100% visible across multiple scroll flicks.
- Always apply a local backdrop scrim (`background: radial-gradient(ellipse at center, rgba(0,0,0,0.65) 0%, rgba(0,0,0,0) 70%)` or similar) behind text.
- Text shadow: `text-shadow: 0 2px 10px rgba(0,0,0,0.8);`

## 4. Mobile Devices & Reduced Motion Fallback
- Mobile: Detect touch screens (`@media (max-width: 768px)` or `'ontouchstart' in window`) and serve high-resolution static hero image instead of decoding 6-second video continuously.
- Accessibility: Respect `prefers-reduced-motion: reduce`.
