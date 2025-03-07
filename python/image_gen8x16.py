from PIL import Image
import random

# 画像サイズの設定
width, height = 16, 8
img = Image.new('RGB', (width, height))

for y in range(height):
    for x in range(width):
        # 画像の左半分なら緑、右半分なら赤に設定
        '''
        if x < width // 2:
            color = (0, 255, 0)  # 緑
        else:
            color = (255, 0, 0)  # 赤
        img.putpixel((x, y), color)
        '''
        # 補間係数を計算（左端が0、右端が1）
        factor = x / (width - 1)
        # 0～255 のグレースケール値に変換
        gray = int(255 * factor)
        color = (gray, gray, gray)
        img.putpixel((x, y), color)

# BMP形式で保存
img.save('../image/image8x16.bmp')
print("8x16.bmp を作成しました。")
