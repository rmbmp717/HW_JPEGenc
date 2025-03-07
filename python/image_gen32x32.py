from PIL import Image
import random

# 画像サイズの設定
width, height = 32, 32
img = Image.new('RGB', (width, height))

# グラデーションの係数計算用
max_factor = (width - 1) + (height - 1)

for y in range(height):
    for x in range(width):
        r = random.randint(0, 255)
        g = random.randint(0, 255)
        b = random.randint(0, 255)
        img.putpixel((x, y), (r, g, b))

# BMP形式で保存
img.save('../image/image32x32.bmp')
print("32x32.bmp を作成しました。")
