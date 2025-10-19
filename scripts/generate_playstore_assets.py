from PIL import Image, ImageDraw, ImageFont
import os

OUT_DIR = 'release/playstore'
ICON_SRC = 'assets/icon/app_icon.png'

os.makedirs(OUT_DIR, exist_ok=True)

# Load source icon
icon = Image.open(ICON_SRC).convert('RGBA')

# 1) 512x512 icon without alpha (white background)
icon_512 = icon.resize((512, 512), Image.LANCZOS)
bg = Image.new('RGB', (512, 512), (255,255,255))
bg.paste(icon_512, mask=icon_512.split()[3])
icon_512_path = os.path.join(OUT_DIR, 'icon_512.png')
bg.save(icon_512_path, optimize=True)
print('Saved', icon_512_path)

# 2) Feature graphic 1024x500
FG_W, FG_H = 1024, 500
fg = Image.new('RGB', (FG_W, FG_H), (40, 20, 90))  # dark gradient base
# create gradient
for y in range(FG_H):
    f = y / (FG_H - 1)
    r = int(116 + (255-116) * f)
    g = int(90 + (80-90) * f)
    b = int(255 + (120-255) * f)
    for x in range(FG_W):
        fg.putpixel((x, y), (r, g, b))

# Paste icon to the left
icon_fg = icon.resize((380, 380), Image.LANCZOS)
icon_x = 64
icon_y = (FG_H - 380)//2
fg.paste(icon_fg, (icon_x, icon_y), mask=icon_fg.split()[3])

# Add app title text to the right
draw = ImageDraw.Draw(fg)
try:
    font = ImageFont.truetype('Arial.ttf', 64)
except:
    font = ImageFont.load_default()

text = 'Mensagens Prontas'
text_x = icon_x + 380 + 40
text_y = FG_H//2 - 40
# draw shadow
draw.text((text_x+2, text_y+2), text, font=font, fill=(0,0,0))
# draw text
draw.text((text_x, text_y), text, font=font, fill=(255,255,255))

fg_path = os.path.join(OUT_DIR, 'feature_graphic.png')
fg.save(fg_path, optimize=True)
print('Saved', fg_path)
