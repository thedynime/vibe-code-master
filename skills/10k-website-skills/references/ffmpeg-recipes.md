# FFmpeg Recipes for Scroll-Driven Websites

Commands for video encoding, frame extraction, and segment concatenation optimized for scroll scrubbing.

## 1. Re-encode Video for Smooth Scroll Scrubbing
Live scrubbing requires frequent keyframes (low GOP size) so browsers seek instantly without stuttering or decoding lag:

```bash
# Keyframe every frame (intra-frame / highest scrub performance)
ffmpeg -i input.mp4 -c:v libx264 -preset slow -crf 22 -g 1 -keyint_min 1 -pix_fmt yuv420p -an assets/hero-scrub.mp4

# Balanced keyframe every 12 frames (smaller file size, smooth on modern laptops)
ffmpeg -i input.mp4 -c:v libx264 -preset medium -crf 23 -g 12 -keyint_min 12 -pix_fmt yuv420p -an assets/hero-scrub.mp4
```

## 2. Extract First, Middle, and Final Frames
```bash
# First frame (start image / poster)
ffmpeg -ss 00:00:00 -i input.mp4 -vframes 1 -q:v 2 assets/hero-start.png

# Final frame (composed rest state / chaining start frame)
ffmpeg -sseof -1 -i input.mp4 -update 1 -q:v 2 assets/hero-final.png

# Specific timestamp (e.g. 3.0 seconds)
ffmpeg -ss 00:00:03 -i input.mp4 -vframes 1 -q:v 2 assets/frame-mid.png
```

## 3. Join Multiple Segments (Chained Journey)
```bash
# Concatenate multiple segments into one continuous scrub video
cat << 'EOF' > segments.txt
file 'segment1.mp4'
file 'segment2.mp4'
file 'segment3.mp4'
EOF

ffmpeg -f concat -safe 0 -i segments.txt -c:v libx264 -preset medium -crf 22 -g 12 -an assets/hero-chained.mp4
```

## 4. Web Image Compression
```bash
# Optimize stills for web delivery (max width 1920, web-friendly quality)
ffmpeg -i raw-image.png -vf "scale='min(1920,iw)':-1" -q:v 3 assets/supporting-1.webp
```
