# Troubleshooting Scroll-Driven Websites

## Symptoms & Fixes

### 1. Video scrub stutters or lags
- **Cause**: GOP size too large (keyframes are spaced every 30-60 frames instead of 1-12 frames).
- **Fix**: Re-encode using `ffmpeg -i input.mp4 -c:v libx264 -g 1 -keyint_min 1 -crf 22 assets/hero-scrub.mp4`.

### 2. Video fails to load or Blob fetch error
- **Cause**: Direct `file://` protocol access blocks fetch requests.
- **Fix**: Run a local HTTP server: `python3 -m http.server 8000` or `npx http-server`.

### 3. Text unreadable over moving video
- **Cause**: Video background brightness changes dramatically across frames.
- **Fix**: Add a local radial or linear gradient scrim behind the text and increase `text-shadow`. Check contrast against the brightest and busiest frames in the band.

### 4. Choppy on mobile devices
- **Cause**: Continuous video seeking stresses mobile hardware decoders and burns battery.
- **Fix**: Use media queries or touch detection to swap the video element with a high-resolution still image on touch devices.
