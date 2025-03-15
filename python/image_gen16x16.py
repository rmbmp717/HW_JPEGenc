from PIL import Image
import random

# 画像サイズの設定
width, height = 16, 16
img = Image.new('RGB', (width, height))

def randam():
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

def green():
    # 固定色 (red=0, green=122, blue=0) を指定して画像生成
    img = Image.new('RGB', (width, height), (0, 122, 0))

    # BMP形式で保存
    img.save('../image/image_green16x16.bmp')
    print("16x16.bmp を作成しました。")

def blue():
    # 固定色 (red=0, green=122, blue=0) を指定して画像生成
    img = Image.new('RGB', (width, height), (0, 0, 120))

    # BMP形式で保存
    img.save('../image/image_blue16x16.bmp')
    print("16x16.bmp を作成しました。")

if __name__ == "__main__":
    green()
    blue()
