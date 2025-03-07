from PIL import Image
import random

# 画像サイズの設定
width, height = 16, 16
img = Image.new('RGB', (width, height))

# 各ピクセルに対してランダムなRGB値を設定
for y in range(height):
    for x in range(width):
        r = random.randint(0, 255)
        g = random.randint(0, 255)
        b = random.randint(0, 255)
        img.putpixel((x, y), (r, g, b))

# BMP形式で保存
img.save('../image/image16x16.bmp')
print("16x16.bmp を作成しました。")
