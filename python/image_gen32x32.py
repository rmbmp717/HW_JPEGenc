import math
from PIL import Image

# 画像サイズの設定
width, height = 32, 32
img = Image.new('RGB', (width, height))

# 波の設定
wave_frequency = 2  # 波の回数
amplitude = 127  # 波の振幅（0-255の範囲に収めるため）
offset = 128  # 波の中央位置（グレースケール範囲の中央値）

for y in range(height):
    for x in range(width):
        # 斜め方向のサイン波を計算（x + y を入力にする）
        factor = math.sin(((x + y) / (width + height)) * wave_frequency * math.pi)  # -1 ～ 1 の範囲
        gray = int(amplitude * factor + offset)  # 0～255 に変換
        
        color = (gray, gray, gray)
        img.putpixel((x, y), color)

# BMP形式で保存
img.save('../image/image_diagonal_wave32x32.bmp')
print("32x32 斜めに波打つグラデーション BMP を作成しました。")
