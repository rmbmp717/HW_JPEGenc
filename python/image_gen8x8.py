from PIL import Image

# 画像サイズの設定
width, height = 8, 8
img = Image.new('RGB', (width, height), (180, 0, 0))  # 全体を赤(180,0,0)で初期化

# BMP形式で保存
img.save('../image/image_red8x8.bmp')
print("赤 (180,0,0) の 8x16 BMP を作成しました。")