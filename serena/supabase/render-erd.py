"""Render serena/supabase/erd.mmd -> DATABASE_ERD.png (Chrome/Edge headless).

Usage: python serena/supabase/render-erd.py
Needs: Pillow (pip install pillow) + Chrome or Edge installed.
"""
import pathlib
import subprocess
import tempfile

from PIL import Image, ImageChops

HERE = pathlib.Path(__file__).parent
OUT = HERE.parent.parent / "DATABASE_ERD.png"
CHROME = [
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
]

html = (HERE / "erd.html").read_text(encoding="utf-8").replace(
    "__DIAGRAM__", (HERE / "erd.mmd").read_text(encoding="utf-8")
)
page = pathlib.Path(tempfile.gettempdir()) / "erd_render.html"
page.write_text(html, encoding="utf-8")

raw = pathlib.Path(tempfile.gettempdir()) / "erd_raw.png"
browser = next(p for p in CHROME if pathlib.Path(p).exists())
subprocess.run(
    [
        browser, "--headless=new", "--disable-gpu", "--hide-scrollbars", "--no-sandbox",
        "--force-device-scale-factor=2", "--virtual-time-budget=20000",
        "--window-size=1800,1500", f"--screenshot={raw}", page.as_uri(),
    ],
    check=True,
)

im = Image.open(raw).convert("RGB")
bbox = ImageChops.difference(im, Image.new("RGB", im.size, "white")).getbbox()
pad = 40
im.crop((
    max(0, bbox[0] - pad), max(0, bbox[1] - pad),
    min(im.width, bbox[2] + pad), min(im.height, bbox[3] + pad),
)).save(OUT, optimize=True)
print(f"{OUT} ({Image.open(OUT).size[0]}x{Image.open(OUT).size[1]})")
