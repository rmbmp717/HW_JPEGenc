from PIL import Image

# 画像サイズの設定
width, height = 64, 64

def image1():
    """
    画像の左半分を緑、右半分を赤に設定して保存
    """
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
    img.save('../image/image_green_red64x64.bmp')
    print("64x64.bmp (green/red) を作成しました。")

def color_bar():
    """
    画像全体にカラーバーを描画して保存する関数
    画像を8分割し、各領域に以下の色を設定：
      - 赤、オレンジ、黄、緑、シアン、青、紫、マゼンタ
    """
    img = Image.new('RGB', (width, height))
    # カラーバーに使用する色のリスト
    colors = [
        (255, 0, 0),     # 赤
        (255, 165, 0),   # オレンジ
        (255, 255, 0),   # 黄
        (0, 255, 0),     # 緑
        (0, 255, 255),   # シアン
        (0, 0, 255),     # 青
        (128, 0, 128),   # 紫
        (255, 0, 255)    # マゼンタ
    ]
    bar_width = width // len(colors)
    for y in range(height):
        for x in range(width):
            color_index = x // bar_width
            # 端数が出た場合は最後の色を使用
            if color_index >= len(colors):
                color_index = len(colors) - 1
            img.putpixel((x, y), colors[color_index])
    img.save('../image/image_color_bar64x64.bmp')
    print("64x64.bmp (color bar) を作成しました。")

if __name__ == "__main__":
    image1()
    color_bar()
