#!/usr/bin/env python3
"""
pico baseline JPEG decoder
my_JPEG_dec.py

Copyright (c) 2017 yohhoy
"""

import math
import struct
import sys

import ACLuminanceSizeToCode_maker

# --- 新規追加：JPEG Quality と量子化テーブルの設定 ---

QUALITY = 25  # JPEG Quality

if QUALITY < 50:
    quality_scale = 5000 / QUALITY
else:
    quality_scale = 200 - QUALITY * 2

def compute_quant_tbl(std_tbl, quality_scale):
    """標準輝度量子化テーブル std_tbl を quality_scale でスケーリングし、1次元リストに変換する"""
    new_tbl = []
    for row in std_tbl:
        for q in row:
            # 標準では (q * quality_scale + 50) / 100 の値を使用
            new_val = int((q * quality_scale + 50) / 100)
            # 値を 1〜255 の範囲にクランプ
            if new_val < 1:
                new_val = 1
            elif new_val > 255:
                new_val = 255
            new_tbl.append(new_val)
    #print("new_tbl=", new_tbl)
    return new_tbl

STD_LUMINANCE_QUANT_TBL = [
    [16, 11, 10, 16, 24, 40, 51, 61],
    [12, 12, 14, 19, 26, 58, 60, 55],
    [14, 13, 16, 24, 40, 57, 69, 56],
    [14, 17, 22, 29, 51, 87, 80, 62],
    [18, 22, 37, 56, 68, 109, 103, 77],
    [24, 35, 55, 64, 81, 104, 113, 92],
    [49, 64, 78, 87, 103, 121, 120, 101],
    [72, 92, 95, 98, 112, 100, 103, 99]
]

# DEFAULT_QT は平坦化された 8x8 マトリックス（1次元リスト）として扱います
DEFAULT_QT = compute_quant_tbl(STD_LUMINANCE_QUANT_TBL, quality_scale)

# Marker symbols (X'FFxx')
MSYM = {'SOF0': 0xC0, 'SOF1': 0xC1, 'SOF2': 0xC2, 'SOF3': 0xC3, 'SOF5': 0xC5,
        'SOF6': 0xC6, 'SOF7': 0xC7, 'JPG': 0xC8, 'SOF9': 0xC9, 'SOF10': 0xCA,
        'SOF11': 0xCB, 'SOF13': 0xCD, 'SOF14': 0xCE, 'SOF15': 0xCF,
        'DHT': 0xC4, 'DAC': 0xCC, 'SOI': 0xD8, 'EOI': 0xD9, 'SOS': 0xDA,
        'DQT': 0xDB, 'DNL': 0xDC, 'DRI': 0xDD, 'DHP': 0xDE, 'EXP': 0xDF, 'COM': 0xFE}
MSYM.update({f'RST{m}': 0xD0 + m for m in range(8)})   # RST0..RST7
MSYM.update({f'APP{n}': 0xE0 + n for n in range(16)})  # APP0..APP15
MSYM.update({f'JPG{n}': 0xF0 + n for n in range(14)})  # JPG0..JPG13

# Zig-zag sequence
ZZ = [0,  1,  5,  6,  14, 15, 27, 28,
      2,  4,  7,  13, 16, 26, 29, 42,
      3,  8,  12, 17, 25, 30, 41, 43,
      9,  11, 18, 24, 31, 40, 44, 53,
      10, 19, 23, 32, 39, 45, 52, 54,
      20, 22, 33, 38, 46, 51, 55, 60,
      21, 34, 37, 47, 50, 56, 59, 61,
      35, 36, 48, 49, 57, 58, 62, 63]


class NoMoreData(Exception):
    pass

class BrokenByteStuff(Exception):
    def __init__(self, stuff):
        self.stuff = stuff

# byte/bit stream reader (従来のファイルから読む Reader)
class Reader():
    def __init__(self, filename):
        self.fs = open(filename, 'rb')
        self.blen = 0
        self.bbuf = 0
    # read n-bytes (as byte type)
    def byte_raw(self, n):
        b = self.fs.read(n)
        if len(b) < n:
            raise NoMoreData()
        return b
    # read n-bytes
    def byte(self, n):
        return int.from_bytes(self.byte_raw(n), 'big')
    # read n-bits
    def bits(self, n):
        ret = 0
        while 0 < n:
            if self.blen == 0:
                b = self.fs.read(1)
                if b == b'\xFF':
                    # X'FF00' -> 0xff(256)
                    stuff = self.fs.read(1)
                    if stuff != b'\x00':
                        raise BrokenByteStuff(stuff)
                self.bbuf = int.from_bytes(b, 'big')
                self.blen = 8
            m = min(n, self.blen)
            lb = (self.bbuf >> (self.blen - m)) & ((1 << m) - 1)
            ret = (ret << m) | lb
            self.blen -= m
            n -= m
        return ret
    # byte aligned?
    def byte_aligned(self):
        return self.blen == 0
    def __enter__(self):
        return self
    def __exit__(self, type, value, traceback):
        self.fs.close()


# --- 以下、HuffmanDecoder や各パース関数は変更なし ---

class HuffmanDecoder():
    def __init__(self, hufftbl):
        self.huffval, self.huffsize, self.huffcode = hufftbl
    # decode Huffman code
    def code(self, r):
        code, sz = 0, 0
        for i, n in enumerate(self.huffsize):
            if sz < n:
                m, sz = n - sz, n
                code = (code << m) | r.bits(m)
            if self.huffcode[i] == code:
                print(f'Huffman: {code:0{sz}b} -> {self.huffval[i]}')
                return self.huffval[i]
        assert False, "broken Huffman code"
    # decode one value
    def value(self, r, n):
        b = r.bits(n)
        if b < (1 << (n - 1)):
            return b - ((1 << n) - 1)  # neg. value
        else:
            return b  # pos. value

def build_ac_hufftable(ac_dict):
    """
    ac_dict は、キーが文字列（例："01"）で、その文字数がコード長を表し、
    値はビットリスト（AC Huffman コードに対応する値）とします。
    
    この関数は、各コード長毎のリスト（全16エントリ）を作成し、
    decode_hufftable() を用いて Huffman テーブル (huffval, huffsize, huffcode) を生成します。
    """
    # 16エントリのリストを初期化（コード長 1～16 に対応）
    table = [[] for _ in range(16)]
    for key, bitlist in ac_dict.items():
        length = len(key)  # キーの文字数＝コード長
        try:
            # キーを16進数として整数に変換（Huffmanテーブルの値として使用）
            val = int(key, 16)
        except ValueError:
            val = 0
        # コード長は1～16なので、インデックスは length-1
        table[length-1].append(val)
    return decode_hufftable(table)

def decode_hufftable(v):
    huffval = []
    huffsize = []
    for i, w in enumerate(v):
        huffval.extend(w)
        huffsize += [i + 1] * len(w)
    huffsize += [0]

    huffcode = [0] * len(huffval)
    si = huffsize[0]
    code = 0
    k = 0
    while True:
        while True:
            huffcode[k] = code
            k += 1
            code += 1
            if huffsize[k] != si:
                break
        if huffsize[k] == 0:
            break
        while True:
            code <<= 1
            si += 1
            if huffsize[k] == si:
                break
    return (huffval, huffsize, huffcode)

# ACLuminanceSizeToCode_maker からAC Huffmanテーブル用の辞書をインポートして利用
DEFAULT_AC_HUFFTABLE = build_ac_hufftable(ACLuminanceSizeToCode_maker.ACLuminanceSizeToCode)

def decode_dccode(r, hdec, pred):
    ssss = hdec.code(r)
    if ssss == 0:
        print(f'DC diff=0 pred={pred:+d}')
        return pred
    assert ssss <= 15, "DC magnitude category <= 15"
    diff = hdec.value(r, ssss)
    print(f'DC s={ssss} diff={diff:+d} pred={pred:+d}')
    return diff + pred

def decode_accode(r, hdec):
    try:
        rs = hdec.code(r)
    except (IndexError, NoMoreData):
        print("Warning: NoMoreData/IndexError in HuffmanDecoder.code() - assuming EOB")
        return (0, 0)
    rrrr, ssss = rs >> 4, rs & 0b1111
    if ssss == 0:
        print('AC ' + ('EOB' if rrrr == 0 else 'ZRL'))
        return (rrrr, 0)  # EOB/ZRL
    try:
        val = hdec.value(r, ssss)
    except NoMoreData:
        print("Warning: NoMoreData in hdec.value() - assuming EOB")
        return (0, 0)
    print(f'AC r={rrrr} s={ssss} val={val:+d}')
    return (rrrr, val)

def idct_lut(coeff):
    COS_LUT = [[math.cos((2 * xy + 1) * uv * math.pi / 16) for uv in range(8)] for xy in range(8)]
    INVSQRT2 = 1 / math.sqrt(2)
    block = [0] * 64
    for i in range(64):
        y, x = i // 8, i % 8
        s = 0
        for j in range(64):
            v, u = j // 8, j % 8
            cu = INVSQRT2 if u == 0 else 1
            cv = INVSQRT2 if v == 0 else 1
            s += cu * cv * coeff[j] * COS_LUT[x][u] * COS_LUT[y][v]
        block[i] = s / 4
    return block

idct = idct_lut

def decode_block8x8(r, hdec, pred, qtbl, bpp):
    sq = [0] * 64
    # decode DC coefficient
    sq[0] = decode_dccode(r, hdec[0], pred)
    pred = sq[0]
    # decode AC coefficients (in Zig-Zag order)
    k = 1
    while k < 64:
        run, val = decode_accode(r, hdec[1])
        if (run, val) == (0, 0):  # EOB
            break
        k += run
        # もし run を加えた結果、k が 64 以上ならブロックは満杯なのでループ終了
        if k >= 64:
            break
        sq[k] = val
        k += 1
    print(f'  Sq={sq[:k]}...')
    # dequantize
    for i in range(64):
        sq[i] *= qtbl[i]
    print(f'  Rz={sq[:k]}...')
    # reorder Zig-Zag to coding order
    coeff = [0] * 64
    for i in range(64):
        coeff[ZZ[i]] = sq[i]
    print(f'  Ri=' + str([coeff[i:i + 8] for i in range(0, 64, 8)]))
    # inverse DCT
    block = idct(coeff)
    # level shift
    shift = 1 << (bpp - 1)
    maxval = (1 << bpp) - 1
    for i in range(64):
        block[i] = min(max(0, round(block[i] + shift)), maxval)
    print(f'  I=' + str([block[i:i + 8] for i in range(0, 64, 8)]))
    return (block, pred)

# （以下、parse_stream など従来の JPEG 解析用関数は省略・・・）
# ※ここでは元コードの内容をそのまま利用します

# --- 以下、新規追加：final_output のビット列を直接デコードするための処理 ---

# BitStringReader: テキスト中の "101010..." を元に、bits(n) を返すクラス
class BitStringReader():
    def __init__(self, bitstr):
        # 空白や改行を除去
        self.bitstr = "".join(bitstr.split())
        self.pos = 0
    def bits(self, n):
        if self.pos + n > len(self.bitstr):
            raise NoMoreData()
        bits_chunk = self.bitstr[self.pos:self.pos+n]
        self.pos += n
        return int(bits_chunk, 2)
    def byte_aligned(self):
        return self.pos % 8 == 0

# 以下、簡易なデコード処理を行うためのデフォルトパラメータ（※実際はエンコーダ側と同一のテーブルを設定する必要があります）
# ここでは、1ブロック（8x8）の DC/AC 部分をデコードする例を示します。

# ダミーの DC Huffman テーブル (例：JPEG 標準テーブルの一部を簡略化)
DEFAULT_DC_HUFFTABLE = decode_hufftable([
    [],           # 1ビット長：なし
    [0, 1, 2],    # 2ビット長のコード（例）
    [3, 4],       # 3ビット長
    [5, 6, 7, 8], # 4ビット長
    [9, 10, 11],  # 5ビット長
    [], [], [], [], [], [], [], [], [], [], []
])

def decode_final_output_block(bitstr):
    """
    エンコーダ側で生成された final_output のビット列から
    1ブロック（8x8）のデコードを行う例
    """
    r = BitStringReader(bitstr)
    bpp = 8
    pred = 0
    hdec = [HuffmanDecoder(DEFAULT_DC_HUFFTABLE), HuffmanDecoder(DEFAULT_AC_HUFFTABLE)]
    # 1ブロック分のデコードを実施
    block, new_pred = decode_block8x8(r, hdec, pred, DEFAULT_QT, bpp)
    return block

def write_ppm(image, outfile):
    width, height = image['F']['size']
    recimg = image['I']

    nc = len(image['C'])
    if nc == 1:
        print(f'Y size={width}x{height}')
    elif nc == 3:
        ds_h = image['C'][0]['H'] // image['C'][1]['H']
        ds_v = image['C'][0]['V'] // image['C'][1]['V']
        print(f'YCbCr size={width}x{height} chroma={ds_h}x{ds_v}')
    else:
        assert False, "unknown color space"

    with open(outfile, 'wb') as f:
        f.write(f'P6\n{width} {height}\n255\n'.encode('ascii'))
        for y in range(height):
            for x in range(width):
                luma = recimg[0][y * width + x]
                if nc == 3:
                    offset = (y // ds_v) * (width // ds_h) + (x // ds_h)
                    cb = recimg[1][offset]
                    cr = recimg[2][offset]
                else:
                    cb = cr = 128
                r_val, g_val, b_val = to_rgb(luma, cb, cr)
                f.write(struct.pack('3B', r_val, g_val, b_val))

def to_rgb(y, cb, cr):
    cb -= 128
    cr -= 128
    r_val = min(max(0, round(y               + 1.402  * cr)), 255)
    g_val = min(max(0, round(y - 0.3441 * cb - 0.7141 * cr)), 255)
    b_val = min(max(0, round(y + 1.772  * cb              )), 255)
    return (r_val, g_val, b_val)

def parse_stream(r):
    MARKER = {v: k for k, v in MSYM.items()}
    try:
        image = None
        while True:
            b = r.byte(1)
            if b != 0xFF:
                continue
            b = r.byte(1)
            if b == 0x00:
                continue
            m = MARKER.get(b, None)
            if m == 'SOI':
                print(f'{m}')
                image = {'QT': [None] * 4,
                         'HT': [None] * 8,
                         'RI': 0}
            elif m == 'EOI':
                print(f'{m}')
                return image
            elif m[:3] == 'SOF':
                n = b - MSYM['SOF0']
                parse_SOFn(r, n, image)
                assert n == 0, "support only SOF0/Baseline DCT"
            elif m == 'DQT':
                parse_DQT(r, image)
            elif m == 'DHT':
                parse_DHT(r, image)
            elif m == 'DAC':
                assert False, "Arithmetic coding is not supported"
            elif m == 'DRI':
                parse_DRI(r, image)
            elif m == 'SOS':
                scan = parse_SOS(r, image)
                decode_scan(r, image, scan)
            elif m[:3] == 'APP':
                n = b - MSYM['APP0']
                parse_APPn(r, n)
            else:
                print(f'(ignore {m})')
    except NoMoreData:
        pass

# 以下、parse_SOFn, parse_SOS, parse_DQT, parse_DHT, parse_DRI, parse_APPn, decode_scan などの関数は
# もともとのコードの内容と同じです。省略・・・

# --- メイン処理 ---
def main(*args):
    #print("DEFAULT_QT=", DEFAULT_QT)
    # コマンドライン引数に "--bitstream" がある場合は、final_output のビット列としてデコードを実施
    if "--bitstream" in args:
        # 例: python my_JPEG_dec.py --bitstream final_output.txt
        infile = args[args.index("--bitstream") + 1]
        with open(infile, 'r') as f:
            bitstr = f.read()
        print("----- Final Output Bitstream Decode -----")
        block = decode_final_output_block(bitstr)
        print("==========================================================================")
        print("Decoded Y Data (8x8 block):")
        for i in range(8):
            print(" ".join(f"{val:3d}" for val in block[i*8:(i+1)*8]))
    else:
        # 従来の JPEG bytestream をパースして PPM へ変換
        infile = args[0]
        outfile = args[1] if len(args) >= 2 else None
        with Reader(infile) as r:
            image = parse_stream(r)
            if outfile:
                write_ppm(image, outfile)

if __name__ == '__main__':
    args = sys.argv[1:]
    if len(args) < 1:
        print('usage: picojdec.py <input.jpg> [<output.ppm>]')
        print('   または: picojdec.py --bitstream <final_output.txt>')
        exit(1)
    main(*args)
