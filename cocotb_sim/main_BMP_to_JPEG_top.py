"""
NISHIHARU
JPEG HW Encoder Test
"""
import sys, os
import cocotb
import random
import numpy
from PIL import Image
from bitstring import BitArray, BitStream
from cocotb.triggers import Timer, RisingEdge

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cocotb_sim/')))
import sub_test_JPEGenc

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cocotb_sim/')))
import sub_test_JPEG_write

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../python/')))
import my_JPEG_dec

async def generate_clock(dut, period=10):
    """Generate a clock on dut.clock with the given period in ns."""
    while True:
        dut.clock.value = 0
        await Timer(period // 2, units="ns")
        dut.clock.value = 1
        await Timer(period // 2, units="ns")

@cocotb.test()
async def main_JPEGenc_top(dut):

    # Input / Output File name 
    #srcFileName = "./image/image_grad32x32.bmp"
    #srcFileName = "./image/image16x32.bmp"
    #srcFileName = "./image/image64x64.bmp"
    #srcFileName = "./image/image_diagonal_wave32x32.bmp"
    #srcFileName = "./image/image8x16.bmp"
    srcFileName = "./image/lena.bmp"
    #srcFileName = "./image/image_color_bar64x64.bmp"
    #srcFileName = "./image/P1000264_512.bmp"
    #srcFileName = "./image/P1000264_2048.bmp"

    # Outpu File name
    outputJPEGFileName = "./image/output.jpg"

    print("srcFileName:", srcFileName)
    print("outputJPEGFileName:", outputJPEGFileName)

    numpy.set_printoptions(threshold=numpy.inf)
    srcImage = Image.open(srcFileName)
    srcImageWidth, srcImageHeight = srcImage.size
    print('srcImageWidth = %d srcImageHeight = %d' % (srcImageWidth, srcImageHeight))
    print('srcImage info:\n', srcImage)
    srcImageMatrix = numpy.asarray(srcImage)

    imageWidth = srcImageWidth
    imageHeight = srcImageHeight
    # add width and height to %8==0
    if (srcImageWidth % 8 != 0):
        imageWidth = srcImageWidth // 8 * 8 + 8
    if (srcImageHeight % 8 != 0):
        imageHeight = srcImageHeight // 8 * 8 + 8

    print('added to: ', imageWidth, imageHeight)

    # copy data from srcImageMatrix to addedImageMatrix
    addedImageMatrix = numpy.zeros((imageHeight, imageWidth, 3), dtype=numpy.uint8)
    for y in range(srcImageHeight):
        for x in range(srcImageWidth):
            addedImageMatrix[y][x] = srcImageMatrix[y][x]

    # blockSum
    blockSum = imageWidth // 8 * imageHeight // 8
    print('blockSum = ', blockSum)

    # 各チャネルのマトリックスを表示
    #print("R matrix:")
    #print(addedImageMatrix[:, :, 0])
    #print("G matrix:")
    #print(addedImageMatrix[:, :, 1])
    #print("B matrix:")
    #print(addedImageMatrix[:, :, 2])

    # split y u v
    yImage,uImage,vImage = Image.fromarray(addedImageMatrix).convert('YCbCr').split()

    yImageMatrix = numpy.asarray(yImage).astype(int)
    uImageMatrix = numpy.asarray(uImage).astype(int)
    vImageMatrix = numpy.asarray(vImage).astype(int)


    yImageMatrix = yImageMatrix - 127
    uImageMatrix = uImageMatrix - 127
    vImageMatrix = vImageMatrix - 127

    print('yImageMatrix:\n', yImageMatrix)
    print('uImageMatrix:\n', uImageMatrix)
    print('vImageMatrix:\n', vImageMatrix)

    print("==========================================================================")
    # Start clock generation (if not already spawned by testbench)
    cocotb.start_soon(generate_clock(dut, period=10))
    
    # initialize
    dut.reset_n.value = 0  
    dut.Red.value = 0
    dut.Green.value = 0
    dut.Blue.value = 0
    dut.input_1pix_enable.value = 0
    dut.input_enable.value = 0

    dut.dct_enable.value = 0
    dut.dct_end_enable.value = 0
    dut.zigzag_input_enable.value = 0
    dut.Huffman_start.value = 0

    for _ in range(10):
        await RisingEdge(dut.clock)
    dut.reset_n.value = 1      

    # wait
    for _ in range(20):
        await RisingEdge(dut.clock)

    sosBitStream = BitStream()

    blockNum = 0
    for y in range(0, imageHeight, 8):
        for x in range(0, imageWidth, 8):
            # Input Image
            input_matrix_r = addedImageMatrix[y:y + 8, x:x + 8, 0].astype(int).tolist()
            input_matrix_g = addedImageMatrix[y:y + 8, x:x + 8, 1].astype(int).tolist()
            input_matrix_b = addedImageMatrix[y:y + 8, x:x + 8, 2].astype(int).tolist()

            # 赤チャネル: 255、他は0
            #input_matrix_r = [[255 for j in range(8)] for i in range(8)]
            #input_matrix_g = [[0 for j in range(8)] for i in range(8)]
            #input_matrix_b = [[0 for j in range(8)] for i in range(8)]

            #print("R =", input_matrix_r)
            #print("G =", input_matrix_g)
            #print("B =", input_matrix_b)

            # start
            final_Y_output, final_Cb_output, final_Cr_output = await sub_test_JPEGenc.sub_test_JPEGenc(dut, input_matrix_r, input_matrix_g, input_matrix_b)

            #formatted_output = '_'.join([final_Y_output[i:i+8] for i in range(0, len(final_Y_output), 8)])
            formatted_output = final_Y_output
            #print("final Y output : ", formatted_output)
            #formatted_output = '_'.join([final_Cb_output[i:i+8] for i in range(0, len(final_Cb_output), 8)])
            formatted_output = final_Cb_output
            #print("final Cb output : ", formatted_output)
            #formatted_output = '_'.join([final_Cr_output[i:i+8] for i in range(0, len(final_Cr_output), 8)])
            formatted_output = final_Cr_output
            #print("final Cr output : ", formatted_output)

            sosBitStream.append(BitArray(bin=final_Y_output))
            sosBitStream.append(BitArray(bin=final_Cb_output))
            sosBitStream.append(BitArray(bin=final_Cr_output))

            #print("Total Bits:", len(final_Y_output + final_Cb_output + final_Cr_output))
            #print("Compression Rate:", 100*len((final_Y_output + final_Cb_output + final_Cr_output))/(512*3), "%")

            blockNum = blockNum + 1
            print("blockNum = ", blockNum)

    bit_stream_str = sosBitStream.bin
    print(bit_stream_str)

    print("==========================================================================")
    print("Main test End")

    print("==========================================================================")
    print("JPEG File Write")
    
    await sub_test_JPEG_write.file_write(dut, outputJPEGFileName, srcImageHeight, srcImageWidth, sosBitStream)

    file_size = os.path.getsize(srcFileName)
    print(f"{srcFileName} のサイズは {file_size} バイトです。")
    output_file_size = os.path.getsize(outputJPEGFileName)
    print(f"JPEG変換後のサイズは {output_file_size} バイトです。")
    completed_ratio = output_file_size / file_size * 100
    print(f"圧縮後のデータサイズは元画像の {completed_ratio} %です。")

    print("JPEG File Write End.")

