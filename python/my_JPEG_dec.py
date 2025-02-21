#!/usr/bin/env python3
"""
pico baseline JPEG decoder
my_JPEG_dec.py

Copyright (c) 2017 yohhoy
Modified by ChatGPT
"""

import math
import struct
import sys

import ACLuminanceSizeToCode_maker

# --- JPEG Quality と量子化テーブルの設定 ---
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
            new_val = int((q * quality_scale + 50) / 100)
            if new_val < 1:
                new_val = 1
            elif new_val > 255:
                new_val = 255
            new_tbl.append(new_val)
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

# DEFAULT_QT は平坦化された 8x8 マトリックス（1次元リスト）として扱う
DEFAULT_QT = compute_quant_tbl(STD_LUMINANCE_QUANT_TBL, quality_scale)

# Marker symbols (X'FFxx')
MSYM = {'SOF0': 0xC0, 'SOF1': 0xC1, 'SOF2': 0xC2, 'SOF3': 0xC3, 'SOF5': 0xC5,
        'SOF6': 0xC6, 'SOF7': 0xC7, 'JPG': 0xC8, 'SOF9': 0xC9, 'SOF10': 0xCA,
        'SOF11': 0xCB, 'SOF13': 0xCD, 'SOF14': 0xCE, 'SOF15': 0xCF,
        'DHT': 0xC4, 'DAC': 0xCC, 'SOI': 0xD8, 'EOI': 0xD9, 'SOS': 0xDA,
        'DQT': 0xDB, 'DNL': 0xDC, 'DRI': 0xDD, 'DHP': 0xDE, 'EXP': 0xDF, 'COM': 0xFE}
MSYM.update({f'RST{m}': 0xD0 + m for m in range(8)})
MSYM.update({f'APP{n}': 0xE0 + n for n in range(16)})
MSYM.update({f'JPG{n}': 0xF0 + n for n in range(14)})

# --- エンコーダ側と同じ zigzag 順序 ---
zigzagOrder = [0, 1, 8, 16, 9, 2, 3, 10, 17, 24, 32, 25, 18, 11, 4, 5,
               12, 19, 26, 33, 40, 48, 41, 34, 27, 20, 13, 6, 7, 14, 21, 28,
               35, 42, 49, 56, 57, 50, 43, 36, 29, 22, 15, 23, 30, 37, 44, 51,
               58, 59, 52, 45, 38, 31, 39, 46, 53, 60, 61, 54, 47, 55, 62, 63]

# 例外クラスおよび Reader クラス
class NoMoreData(Exception):
    pass

class BrokenByteStuff(Exception):
    def __init__(self, stuff):
        self.stuff = stuff

class Reader():
    def __init__(self, filename):
        self.fs = open(filename, 'rb')
        self.blen = 0
        self.bbuf = 0
    def byte_raw(self, n):
        b = self.fs.read(n)
        if len(b) < n:
            raise NoMoreData()
        return b
    def byte(self, n):
        return int.from_bytes(self.byte_raw(n), 'big')
    def bits(self, n):
        ret = 0
        while n > 0:
            if self.blen == 0:
                b = self.fs.read(1)
                if b == b'\xFF':
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
    def byte_aligned(self):
        return self.blen == 0
    def __enter__(self):
        return self
    def __exit__(self, type, value, traceback):
        self.fs.close()

# HuffmanDecoder とテーブル整形関数
class HuffmanDecoder():
    def __init__(self, hufftbl):
        # hufftbl は (huffval, huffsize, huffcode) のタプル
        self.huffval, self.huffsize, self.huffcode = hufftbl
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
    def value(self, r, n):
        b = r.bits(n)
        if b < (1 << (n - 1)):
            return b - ((1 << n) - 1)
        else:
            return b

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

def build_ac_hufftable(ac_dict):
    table = [[] for _ in range(16)]
    for key, bitlist in ac_dict.items():
        length = len(key)
        try:
            val = int(key, 16)
        except ValueError:
            val = 0
        table[length-1].append(val)
    return decode_hufftable(table)

# DC/ACデコード
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
    if isinstance(rs, str):
        rs = int(rs, 2)
    rrrr, ssss = rs >> 4, rs & 0b1111
    if ssss == 0:
        print('AC ' + ('EOB' if rrrr == 0 else 'ZRL'))
        return (rrrr, 0)
    try:
        val = hdec.value(r, ssss)
    except NoMoreData:
        print("Warning: NoMoreData in hdec.value() - assuming EOB")
        return (0, 0)
    print(f'AC r={rrrr} s={ssss} val={val:+d}')
    return (rrrr, val)

# 逆DCT (LUTを使用)
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
    # DC のデコード
    sq[0] = decode_dccode(r, hdec[0], pred)
    pred = sq[0]
    # AC 成分のデコード（zigzag 順序で格納されていると仮定）
    k = 1
    while k < 64:
        run, val = decode_accode(r, hdec[1])
        if (run, val) == (0, 0):  # EOB
            break
        k += run
        if k >= 64:
            break
        sq[k] = val
        k += 1
    print(f'  Sq={sq[:k]}...')
    # 逆量子化
    for i in range(64):
        sq[i] *= qtbl[i]
    print(f'  Rz={sq[:k]}...')
    # zigzag順序を自然順に戻す
    coeff = [0] * 64
    for i in range(64):
        coeff[zigzagOrder[i]] = sq[i]
    print(f'  Ri=' + str([coeff[i:i + 8] for i in range(0, 64, 8)]))
    # 逆DCT
    block = idct(coeff)
    # レベルシフト
    shift = 1 << (bpp - 1)
    maxval = (1 << bpp) - 1
    for i in range(64):
        block[i] = min(max(0, round(block[i] + shift)), maxval)
    print(f'  I=' + str([block[i:i + 8] for i in range(0, 64, 8)]))
    return (block, pred)

# BitStringReader：テキスト化されたビット列からビットを読み出す
class BitStringReader():
    def __init__(self, bitstr):
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

# 外部テーブルを受け取ってデコードする関数
def decode_final_output_block(bitstr, dc_huff_table, ac_huff_table):
    r = BitStringReader(bitstr)
    bpp = 8
    pred = 0
    # ここでは、すでに (huffval, huffsize, huffcode) のタプルになっているテーブルを利用する
    hdec = [HuffmanDecoder(dc_huff_table), HuffmanDecoder(ac_huff_table)]
    block, new_pred = decode_block8x8(r, hdec, pred, DEFAULT_QT, bpp)
    return block

def main(*args):
    if "--bitstream" in args:
        infile = args[args.index("--bitstream") + 1]
        with open(infile, 'r') as f:
            bitstr = f.read()
        print("----- Final Output Bitstream Decode -----")
        block = decode_final_output_block(bitstr, DEFAULT_DC_HUFFTABLE, DEFAULT_AC_HUFFTABLE)
        print("==========================================================================")
        print("Decoded Y Data (8x8 block):")
        for i in range(8):
            print(" ".join(f"{val:3d}" for val in block[i*8:(i+1)*8]))
    else:
        # --bitstream モード以外の処理は未実装
        print("Non-bitstream mode is not implemented in this version.")

if __name__ == '__main__':
    args = sys.argv[1:]
    if len(args) < 1:
        print('usage: picojdec.py <input.jpg> [<output.ppm>]')
        print('   または: picojdec.py --bitstream <final_output.txt>')
        exit(1)
    main(*args)
