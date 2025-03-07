from PIL import Image

# 画像サイズの設定
width, height = 64, 64
img = Image.new('RGB', (width, height))

for y in range(height):
    for x in range(width):
        # 画像の左半分なら緑、右半分なら赤に設定
        if x < width // 2:
            color = (0, 255, 0)  # 緑
        else:
            color = (255, 0, 0)  # 赤
        img.putpixel((x, y), color)

# BMP形式で保存
img.save('../image/image64x64.bmp')
print("64x64.bmp を作成しました。")
