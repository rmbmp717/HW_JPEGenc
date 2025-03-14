"""
NISHIHARU
JPEG HW Encoder Data Write to File
"""
import cocotb
import random
import numpy
import logging
from bitstring import BitArray, BitStream
from cocotb.triggers import First, Timer, RisingEdge, FallingEdge
from cocotb.utils import get_sim_time

import sys, os

std_luminance_quant_tbl = numpy.array(
[ 16,  11,  10,  16,  24,  40,  51,  61,
  12,  12,  14,  19,  26,  58,  60,  55,
  14,  13,  16,  24,  40,  57,  69,  56,
  14,  17,  22,  29,  51,  87,  80,  62,
  18,  22,  37,  56,  68, 109, 103,  77,
  24,  35,  55,  64,  81, 104, 113,  92,
  49,  64,  78,  87, 103, 121, 120, 101,
  72,  92,  95,  98, 112, 100, 103,  99],dtype=int)
std_luminance_quant_tbl = std_luminance_quant_tbl.reshape([8,8])

std_chrominance_quant_tbl = numpy.array(
[ 17,  18,  24,  47,  99,  99,  99,  99,
  18,  21,  26,  66,  99,  99,  99,  99,
  24,  26,  56,  99,  99,  99,  99,  99,
  47,  66,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99,
  99,  99,  99,  99,  99,  99,  99,  99],dtype=int)
std_chrominance_quant_tbl = std_chrominance_quant_tbl.reshape([8,8])

#hexToBytes('F0') = 1111 1111 0000 0000(bytes)
def hexToBytes(hexStr):
    num = len(hexStr)//2
    ret = numpy.zeros([num],dtype=int)
    for i in range(num):
        ret[i] = int(hexStr[2*i:2*i+2],16)

    ret = ret.tolist()
    ret = bytes(ret)
    return ret

async def file_write(dut, outputJPEGFileName, srcImageHeight, srcImageWidth, sosBitStream):

    #sosBitStream.append(BitArray(bin="00100100100111100110111101010111100011111100001101001010011110111110001010101"))

    #print(type(sosBitStream))
    #print(sosBitStream)

    quality = 25    # Quantize.x と合わせること！
    print("quality = ", quality)

    # ==============================================================
    if(quality <= 0):
        quality = 1
    if(quality > 100):
        quality = 100
    if(quality < 50):
        qualityScale = 5000 / quality
    else:
        qualityScale = 200 - quality * 2

    luminanceQuantTbl = numpy.array(numpy.floor((std_luminance_quant_tbl * qualityScale + 50) / 100))
    luminanceQuantTbl[luminanceQuantTbl == 0] = 1
    luminanceQuantTbl[luminanceQuantTbl > 255] = 255
    luminanceQuantTbl = luminanceQuantTbl.reshape([8, 8]).astype(int)
    #print('luminanceQuantTbl:\n', luminanceQuantTbl)
    chrominanceQuantTbl = numpy.array(numpy.floor((std_chrominance_quant_tbl * qualityScale + 50) / 100))
    chrominanceQuantTbl[chrominanceQuantTbl == 0] = 1
    chrominanceQuantTbl[chrominanceQuantTbl > 255] = 255
    chrominanceQuantTbl = chrominanceQuantTbl.reshape([8, 8]).astype(int)
    #print('chrominanceQuantTbl:\n', chrominanceQuantTbl)

    # ==============================================================
    jpegFile = open(outputJPEGFileName, 'wb+')
    # write jpeg header
    jpegFile.write(hexToBytes('FFD8FFE000104A46494600010100000100010000'))
    # write y Quantization Table
    jpegFile.write(hexToBytes('FFDB004300'))
    luminanceQuantTbl = luminanceQuantTbl.reshape([64])
    jpegFile.write(bytes(luminanceQuantTbl.tolist()))
    # write u/v Quantization Table
    jpegFile.write(hexToBytes('FFDB004301'))
    chrominanceQuantTbl = chrominanceQuantTbl.reshape([64])
    jpegFile.write(bytes(chrominanceQuantTbl.tolist()))
    # write height and width
    jpegFile.write(hexToBytes('FFC0001108'))
    hHex = hex(srcImageHeight)[2:]
    while len(hHex) != 4:
        hHex = '0' + hHex

    jpegFile.write(hexToBytes(hHex))

    wHex = hex(srcImageWidth)[2:]
    while len(wHex) != 4:
        wHex = '0' + wHex

    jpegFile.write(hexToBytes(wHex))

    # 03    01 11 00    02 11 01    03 11 01
    # 1：1	01 11 00	02 11 01	03 11 01
    # 1：2	01 21 00	02 11 01	03 11 01
    # 1：4	01 22 00	02 11 01	03 11 01
    # write Subsamp
    jpegFile.write(hexToBytes('03011100021101031101'))

    #write huffman table
    jpegFile.write(hexToBytes('FFC401A20000000701010101010000000000000000040503020601000708090A0B0100020203010101010100000000000000010002030405060708090A0B1000020103030204020607030402060273010203110400052112314151061361227181143291A10715B14223C152D1E1331662F0247282F12543345392A2B26373C235442793A3B33617546474C3D2E2082683090A181984944546A4B456D355281AF2E3F3C4D4E4F465758595A5B5C5D5E5F566768696A6B6C6D6E6F637475767778797A7B7C7D7E7F738485868788898A8B8C8D8E8F82939495969798999A9B9C9D9E9F92A3A4A5A6A7A8A9AAABACADAEAFA110002020102030505040506040803036D0100021103042112314105511361220671819132A1B1F014C1D1E1234215526272F1332434438216925325A263B2C20773D235E2448317549308090A18192636451A2764745537F2A3B3C32829D3E3F38494A4B4C4D4E4F465758595A5B5C5D5E5F5465666768696A6B6C6D6E6F6475767778797A7B7C7D7E7F738485868788898A8B8C8D8E8F839495969798999A9B9C9D9E9F92A3A4A5A6A7A8A9AAABACADAEAFA'))
    # SOS Start of Scan
    # yDC yAC uDC uAC vDC vAC
    sosLength = sosBitStream.__len__()
    filledNum = 8 - sosLength % 8
    if(filledNum!=0):
        sosBitStream.append(numpy.ones([filledNum]).tolist())

    jpegFile.write(bytes([255, 218, 0, 12, 3, 1, 0, 2, 17, 3, 17, 0, 63, 0])) # FF DA 00 0C 03 01 00 02 11 03 11 00 3F 00

    # write encoded data
    sosBytes = sosBitStream.bytes
    for i in range(len(sosBytes)):
        jpegFile.write(bytes([sosBytes[i]]))
        if(sosBytes[i]==255):
            jpegFile.write(bytes([0])) # FF to FF 00
    
    # write end symbol
    jpegFile.write(bytes([255,217])) # FF D9
    jpegFile.close()
    