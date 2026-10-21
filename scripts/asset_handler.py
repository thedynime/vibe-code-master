#!/usr/bin/env python3
"""
Antigravity Universal Asset Handler & Inspector
Enables instant, seamless inspection and visual conversion of SVGs, WebP, HEIC, AVIF, TIFF, PSD, and other local assets.
"""

import sys
import os
import subprocess
from pathlib import Path

def handle_svg(file_path: Path):
    print(f"[SVG Detected] {file_path}")
    content = file_path.read_text(encoding='utf-8', errors='ignore')
    print(f"File Size: {len(content)} bytes")
    # Quick analysis of viewBox / width / height
    import re
    viewbox = re.search(r'viewBox="([^"]+)"', content)
    width = re.search(r'width="([^"]+)"', content)
    height = re.search(r'height="([^"]+)"', content)
    if viewbox: print(f"viewBox: {viewbox.group(1)}")
    if width: print(f"width: {width.group(1)}")
    if height: print(f"height: {height.group(1)}")
    
    # Generate high-res PNG preview using macOS native qlmanage
    tmp_out = Path("/tmp/antigravity_previews")
    tmp_out.mkdir(parents=True, exist_ok=True)
    out_cmd = subprocess.run(
        ["qlmanage", "-t", "-s", "1024", "-o", str(tmp_out), str(file_path)],
        capture_output=True, text=True
    )
    png_preview = tmp_out / f"{file_path.name}.png"
    if png_preview.exists():
        print(f"Generated Visual Preview: {png_preview}")
    return png_preview if png_preview.exists() else None

def handle_raster(file_path: Path):
    try:
        from PIL import Image
        with Image.open(file_path) as img:
            print(f"[Image Format: {img.format}] {file_path}")
            print(f"Dimensions: {img.size[0]}x{img.size[1]} | Mode: {img.mode}")
            
            # If format is WebP or other non-standard, save a PNG preview
            tmp_out = Path("/tmp/antigravity_previews")
            tmp_out.mkdir(parents=True, exist_ok=True)
            png_preview = tmp_out / f"{file_path.stem}_converted.png"
            img.save(png_preview, format="PNG")
            print(f"Converted Preview: {png_preview}")
            return png_preview
    except Exception as e:
        print(f"Pillow inspect error: {e}, falling back to qlmanage...")
        tmp_out = Path("/tmp/antigravity_previews")
        tmp_out.mkdir(parents=True, exist_ok=True)
        subprocess.run(["qlmanage", "-t", "-s", "1024", "-o", str(tmp_out), str(file_path)], capture_output=True)
        png_preview = tmp_out / f"{file_path.name}.png"
        if png_preview.exists():
            print(f"Generated Visual Preview: {png_preview}")
            return png_preview
    return None

def process_path(target: str):
    p = Path(target).expanduser().resolve()
    if not p.exists():
        print(f"Error: Path does not exist: {p}")
        return
        
    if p.is_dir():
        print(f"Scanning directory: {p}")
        extensions = {'.svg', '.webp', '.png', '.jpg', '.jpeg', '.gif', '.heic', '.avif', '.tiff', '.bmp', '.ico'}
        found = [f for f in p.rglob('*') if f.suffix.lower() in extensions]
        print(f"Found {len(found)} media asset(s):")
        for f in found:
            print(f" - {f.name} ({f.suffix.lower()}) -> {f}")
        return

    ext = p.suffix.lower()
    if ext == '.svg':
        handle_svg(p)
    else:
        handle_raster(p)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python3 asset_handler.py <file_or_directory_path>")
        sys.exit(1)
    process_path(sys.argv[1])
