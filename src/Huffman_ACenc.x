// NISHIHARU

const EOB_LUM_EXT: bits[16] = bits[16]:0b1100;    
const EOB_CHM_EXT: bits[16] = bits[16]:0b01;    

// JPEG 標準 AC ルミナンス用 Huffman 符号表
// ACLuminanceSizeToCode 辞書の全エントリに 1 対 1 対応
fn lookup_ACLuminanceSizeToCode(index: u8[2]) -> (bits[16], u8) {
  let index_u8: u8 = (index[0] << u8:4) | index[1];
  trace!(index_u8);
  match index_u8 {
    u8:0x01 => (bits[16]:0b00, u8:2),
    u8:0x02 => (bits[16]:0b01, u8:2),
    u8:0x03 => (bits[16]:0b100, u8:3),
    u8:0x11 => (bits[16]:0b1010, u8:4),
    u8:0x04 => (bits[16]:0b1011, u8:4),
    u8:0x00 => (bits[16]:0b1100, u8:4),
    u8:0x05 => (bits[16]:0b11010, u8:5),
    u8:0x21 => (bits[16]:0b11011, u8:5),
    u8:0x12 => (bits[16]:0b11100, u8:5),
    u8:0x31 => (bits[16]:0b111010, u8:6),
    u8:0x41 => (bits[16]:0b111011, u8:6),
    u8:0x51 => (bits[16]:0b1111000, u8:7),
    u8:0x06 => (bits[16]:0b1111001, u8:7),
    u8:0x13 => (bits[16]:0b1111010, u8:7),
    u8:0x61 => (bits[16]:0b1111011, u8:7),
    u8:0x22 => (bits[16]:0b11111000, u8:8),
    u8:0x71 => (bits[16]:0b11111001, u8:8),
    u8:0x81 => (bits[16]:0b111110100, u8:9),
    u8:0x14 => (bits[16]:0b111110101, u8:9),
    u8:0x32 => (bits[16]:0b111110110, u8:9),
    u8:0x91 => (bits[16]:0b111110111, u8:9),
    u8:0xA1 => (bits[16]:0b111111000, u8:9),
    u8:0x07 => (bits[16]:0b111111001, u8:9),
    u8:0x15 => (bits[16]:0b1111110100, u8:10),
    u8:0xB1 => (bits[16]:0b1111110101, u8:10),
    u8:0x42 => (bits[16]:0b1111110110, u8:10),
    u8:0x23 => (bits[16]:0b1111110111, u8:10),
    u8:0xC1 => (bits[16]:0b1111111000, u8:10),
    u8:0x52 => (bits[16]:0b1111111001, u8:10),
    u8:0xD1 => (bits[16]:0b1111111010, u8:10),
    u8:0xE1 => (bits[16]:0b11111110110, u8:11),
    u8:0x33 => (bits[16]:0b11111110111, u8:11),
    u8:0x16 => (bits[16]:0b11111111000, u8:11),
    u8:0x62 => (bits[16]:0b111111110010, u8:12),
    u8:0xF0 => (bits[16]:0b111111110011, u8:12),
    u8:0x24 => (bits[16]:0b111111110100, u8:12),
    u8:0x72 => (bits[16]:0b111111110101, u8:12),
    u8:0x82 => (bits[16]:0b1111111101100, u8:13),
    u8:0xF1 => (bits[16]:0b1111111101101, u8:13),
    u8:0x25 => (bits[16]:0b11111111011100, u8:14),
    u8:0x43 => (bits[16]:0b11111111011101, u8:14),
    u8:0x34 => (bits[16]:0b11111111011110, u8:14),
    u8:0x53 => (bits[16]:0b11111111011111, u8:14),
    u8:0x92 => (bits[16]:0b11111111100000, u8:14),
    u8:0xA2 => (bits[16]:0b11111111100001, u8:14),
    u8:0xB2 => (bits[16]:0b111111111000100, u8:15),
    u8:0x63 => (bits[16]:0b111111111000101, u8:15),
    u8:0x73 => (bits[16]:0b1111111110001100, u8:16),
    u8:0xC2 => (bits[16]:0b1111111110001101, u8:16),
    u8:0x35 => (bits[16]:0b1111111110001110, u8:16),
    u8:0x44 => (bits[16]:0b1111111110001111, u8:16),
    u8:0x27 => (bits[16]:0b1111111110010000, u8:16),
    u8:0x93 => (bits[16]:0b1111111110010001, u8:16),
    u8:0xA3 => (bits[16]:0b1111111110010010, u8:16),
    u8:0xB3 => (bits[16]:0b1111111110010011, u8:16),
    u8:0x36 => (bits[16]:0b1111111110010100, u8:16),
    u8:0x17 => (bits[16]:0b1111111110010101, u8:16),
    u8:0x54 => (bits[16]:0b1111111110010110, u8:16),
    u8:0x64 => (bits[16]:0b1111111110010111, u8:16),
    u8:0x74 => (bits[16]:0b1111111110011000, u8:16),
    u8:0xC3 => (bits[16]:0b1111111110011001, u8:16),
    u8:0xD2 => (bits[16]:0b1111111110011010, u8:16),
    u8:0xE2 => (bits[16]:0b1111111110011011, u8:16),
    u8:0x08 => (bits[16]:0b1111111110011100, u8:16),
    u8:0x26 => (bits[16]:0b1111111110011101, u8:16),
    u8:0x83 => (bits[16]:0b1111111110011110, u8:16),
    u8:0x09 => (bits[16]:0b1111111110011111, u8:16),
    u8:0x0A => (bits[16]:0b1111111110100000, u8:16),
    u8:0x18 => (bits[16]:0b1111111110100001, u8:16),
    u8:0x19 => (bits[16]:0b1111111110100010, u8:16),
    u8:0x84 => (bits[16]:0b1111111110100011, u8:16),
    u8:0x94 => (bits[16]:0b1111111110100100, u8:16),
    u8:0x45 => (bits[16]:0b1111111110100101, u8:16),
    u8:0x46 => (bits[16]:0b1111111110100110, u8:16),
    u8:0xA4 => (bits[16]:0b1111111110100111, u8:16),
    u8:0xB4 => (bits[16]:0b1111111110101000, u8:16),
    u8:0x56 => (bits[16]:0b1111111110101001, u8:16),
    u8:0xD3 => (bits[16]:0b1111111110101010, u8:16),
    u8:0x55 => (bits[16]:0b1111111110101011, u8:16),
    u8:0x28 => (bits[16]:0b1111111110101100, u8:16),
    u8:0x1A => (bits[16]:0b1111111110101101, u8:16),
    u8:0xF2 => (bits[16]:0b1111111110101110, u8:16),
    u8:0xE3 => (bits[16]:0b1111111110101111, u8:16),
    u8:0xF3 => (bits[16]:0b1111111110110000, u8:16),
    u8:0xC4 => (bits[16]:0b1111111110110001, u8:16),
    u8:0xD4 => (bits[16]:0b1111111110110010, u8:16),
    u8:0xE4 => (bits[16]:0b1111111110110011, u8:16),
    u8:0xF4 => (bits[16]:0b1111111110110100, u8:16),
    u8:0x65 => (bits[16]:0b1111111110110101, u8:16),
    u8:0x75 => (bits[16]:0b1111111110110110, u8:16),
    u8:0x85 => (bits[16]:0b1111111110110111, u8:16),
    u8:0x95 => (bits[16]:0b1111111110111000, u8:16),
    u8:0xA5 => (bits[16]:0b1111111110111001, u8:16),
    u8:0xB5 => (bits[16]:0b1111111110111010, u8:16),
    u8:0xC5 => (bits[16]:0b1111111110111011, u8:16),
    u8:0xD5 => (bits[16]:0b1111111110111100, u8:16),
    u8:0xE5 => (bits[16]:0b1111111110111101, u8:16),
    u8:0xF5 => (bits[16]:0b1111111110111110, u8:16),
    u8:0x66 => (bits[16]:0b1111111110111111, u8:16),
    u8:0x76 => (bits[16]:0b1111111111000000, u8:16),
    u8:0x86 => (bits[16]:0b1111111111000001, u8:16),
    u8:0x96 => (bits[16]:0b1111111111000010, u8:16),
    u8:0xA6 => (bits[16]:0b1111111111000011, u8:16),
    u8:0xB6 => (bits[16]:0b1111111111000100, u8:16),
    u8:0xC6 => (bits[16]:0b1111111111000101, u8:16),
    u8:0xD6 => (bits[16]:0b1111111111000110, u8:16),
    u8:0xE6 => (bits[16]:0b1111111111000111, u8:16),
    u8:0xF6 => (bits[16]:0b1111111111001000, u8:16),
    u8:0x37 => (bits[16]:0b1111111111001001, u8:16),
    u8:0x47 => (bits[16]:0b1111111111001010, u8:16),
    u8:0x57 => (bits[16]:0b1111111111001011, u8:16),
    u8:0x67 => (bits[16]:0b1111111111001100, u8:16),
    u8:0x77 => (bits[16]:0b1111111111001101, u8:16),
    u8:0x87 => (bits[16]:0b1111111111001110, u8:16),
    u8:0x97 => (bits[16]:0b1111111111001111, u8:16),
    u8:0xA7 => (bits[16]:0b1111111111010000, u8:16),
    u8:0xB7 => (bits[16]:0b1111111111010001, u8:16),
    u8:0xC7 => (bits[16]:0b1111111111010010, u8:16),
    u8:0xD7 => (bits[16]:0b1111111111010011, u8:16),
    u8:0xE7 => (bits[16]:0b1111111111010100, u8:16),
    u8:0xF7 => (bits[16]:0b1111111111010101, u8:16),
    u8:0x38 => (bits[16]:0b1111111111010110, u8:16),
    u8:0x48 => (bits[16]:0b1111111111010111, u8:16),
    u8:0x58 => (bits[16]:0b1111111111011000, u8:16),
    u8:0x68 => (bits[16]:0b1111111111011001, u8:16),
    u8:0x78 => (bits[16]:0b1111111111011010, u8:16),
    u8:0x88 => (bits[16]:0b1111111111011011, u8:16),
    u8:0x98 => (bits[16]:0b1111111111011100, u8:16),
    u8:0xA8 => (bits[16]:0b1111111111011101, u8:16),
    u8:0xB8 => (bits[16]:0b1111111111011110, u8:16),
    u8:0xC8 => (bits[16]:0b1111111111011111, u8:16),
    u8:0xD8 => (bits[16]:0b1111111111100000, u8:16),
    u8:0xE8 => (bits[16]:0b1111111111100001, u8:16),
    u8:0xF8 => (bits[16]:0b1111111111100010, u8:16),
    u8:0x29 => (bits[16]:0b1111111111100011, u8:16),
    u8:0x39 => (bits[16]:0b1111111111100100, u8:16),
    u8:0x49 => (bits[16]:0b1111111111100101, u8:16),
    u8:0x59 => (bits[16]:0b1111111111100110, u8:16),
    u8:0x69 => (bits[16]:0b1111111111100111, u8:16),
    u8:0x79 => (bits[16]:0b1111111111101000, u8:16),
    u8:0x89 => (bits[16]:0b1111111111101001, u8:16),
    u8:0x99 => (bits[16]:0b1111111111101010, u8:16),
    u8:0xA9 => (bits[16]:0b1111111111101011, u8:16),
    u8:0xB9 => (bits[16]:0b1111111111101100, u8:16),
    u8:0xC9 => (bits[16]:0b1111111111101101, u8:16),
    u8:0xD9 => (bits[16]:0b1111111111101110, u8:16),
    u8:0xE9 => (bits[16]:0b1111111111101111, u8:16),
    u8:0xF9 => (bits[16]:0b1111111111110000, u8:16),
    u8:0x2A => (bits[16]:0b1111111111110001, u8:16),
    u8:0x3A => (bits[16]:0b1111111111110010, u8:16),
    u8:0x4A => (bits[16]:0b1111111111110011, u8:16),
    u8:0x5A => (bits[16]:0b1111111111110100, u8:16),
    u8:0x6A => (bits[16]:0b1111111111110101, u8:16),
    u8:0x7A => (bits[16]:0b1111111111110110, u8:16),
    u8:0x8A => (bits[16]:0b1111111111110111, u8:16),
    u8:0x9A => (bits[16]:0b1111111111111000, u8:16),
    u8:0xAA => (bits[16]:0b1111111111111001, u8:16),
    u8:0xBA => (bits[16]:0b1111111111111010, u8:16),
    u8:0xCA => (bits[16]:0b1111111111111011, u8:16),
    u8:0xDA => (bits[16]:0b1111111111111100, u8:16),
    u8:0xEA => (bits[16]:0b1111111111111101, u8:16),
    u8:0xFA => (bits[16]:0b1111111111111110, u8:16),
    _ => (bits[16]:0, u8:0),
  }
}

#[test]
fn lookup_ACLuminanceSizeToCode_test() {
  //let run: u4 = u4:0;
  //let value: u8 = u8:11;
  //let size: u32 = bit_length(value);
  //let run_size_str: u8[2] = encode_run_size(run as u32, size);
  let run_size_str1: u8[2] = [u8:0, u8:4];
  trace!(run_size_str1);
  let run_size_str2: u8[2] = [u8:3, u8:8];
  trace!(run_size_str2);

  let (code1, length1): (bits[16], u8) = lookup_ACLuminanceSizeToCode(run_size_str1);
  let (code2, length2): (bits[16], u8) = lookup_ACLuminanceSizeToCode(run_size_str2);

  assert_eq(code1, bits[16]:0b1011);
  assert_eq(length1, u8:4);

  assert_eq(code2, bits[16]:0b1111111111010110);
  assert_eq(length2, u8:16)
}

// JPEG 標準 AC クロミナンス用 Huffman 符号テーブル（全エントリ版）
fn lookup_ACChrominanceToCode(index: u8[2]) -> (bits[16], u8) {
  // 例: [u8:0xA, u8:0x1] は "A1" として 0xA1 となる
  let index_u8: u8 = (index[0] << u8:4) | index[1];
  trace!(index_u8);
  trace!(index_u8);
  match index_u8 {
        u8:0x01 => (bits[16]:0b00, u8:2),
        u8:0x00 => (bits[16]:0b01, u8:2),
        u8:0x02 => (bits[16]:0b100, u8:3),
        u8:0x11 => (bits[16]:0b101, u8:3),
        u8:0x03 => (bits[16]:0b1100, u8:4),
        u8:0x04 => (bits[16]:0b11010, u8:5),
        u8:0x21 => (bits[16]:0b11011, u8:5),
        u8:0x12 => (bits[16]:0b111000, u8:6),
        u8:0x31 => (bits[16]:0b111001, u8:6),
        u8:0x41 => (bits[16]:0b111010, u8:6),
        u8:0x05 => (bits[16]:0b1110110, u8:7),
        u8:0x51 => (bits[16]:0b1110111, u8:7),
        u8:0x13 => (bits[16]:0b1111000, u8:7),
        u8:0x61 => (bits[16]:0b1111001, u8:7),
        u8:0x22 => (bits[16]:0b1111010, u8:7),
        u8:0x06 => (bits[16]:0b11110110, u8:8),
        u8:0x71 => (bits[16]:0b11110111, u8:8),
        u8:0x81 => (bits[16]:0b11111000, u8:8),
        u8:0x91 => (bits[16]:0b11111001, u8:8),
        u8:0x32 => (bits[16]:0b11111010, u8:8),
        u8:0xA1 => (bits[16]:0b111110110, u8:9),
        u8:0xB1 => (bits[16]:0b111110111, u8:9),
        u8:0xF0 => (bits[16]:0b111111000, u8:9),
        u8:0x14 => (bits[16]:0b111111001, u8:9),
        u8:0xC1 => (bits[16]:0b1111110100, u8:10),
        u8:0xD1 => (bits[16]:0b1111110101, u8:10),
        u8:0xE1 => (bits[16]:0b1111110110, u8:10),
        u8:0x23 => (bits[16]:0b1111110111, u8:10),
        u8:0x42 => (bits[16]:0b1111111000, u8:10),
        u8:0x15 => (bits[16]:0b11111110010, u8:11),
        u8:0x52 => (bits[16]:0b11111110011, u8:11),
        u8:0x62 => (bits[16]:0b11111110100, u8:11),
        u8:0x72 => (bits[16]:0b11111110101, u8:11),
        u8:0xF1 => (bits[16]:0b11111110110, u8:11),
        u8:0x33 => (bits[16]:0b11111110111, u8:11),
        u8:0x24 => (bits[16]:0b111111110000, u8:12),
        u8:0x34 => (bits[16]:0b111111110001, u8:12),
        u8:0x43 => (bits[16]:0b111111110010, u8:12),
        u8:0x82 => (bits[16]:0b111111110011, u8:12),
        u8:0x16 => (bits[16]:0b1111111101000, u8:13),
        u8:0x92 => (bits[16]:0b1111111101001, u8:13),
        u8:0x53 => (bits[16]:0b1111111101010, u8:13),
        u8:0x25 => (bits[16]:0b1111111101011, u8:13),
        u8:0xA2 => (bits[16]:0b1111111101100, u8:13),
        u8:0x63 => (bits[16]:0b1111111101101, u8:13),
        u8:0xB2 => (bits[16]:0b1111111101110, u8:13),
        u8:0xC2 => (bits[16]:0b1111111101111, u8:13),
        u8:0x07 => (bits[16]:0b11111111100000, u8:14),
        u8:0x73 => (bits[16]:0b11111111100001, u8:14),
        u8:0xD2 => (bits[16]:0b11111111100010, u8:14),
        u8:0x35 => (bits[16]:0b111111111000110, u8:15),
        u8:0xE2 => (bits[16]:0b111111111000111, u8:15),
        u8:0x44 => (bits[16]:0b111111111001000, u8:15),
        u8:0x83 => (bits[16]:0b1111111110010010, u8:16),
        u8:0x17 => (bits[16]:0b1111111110010011, u8:16),
        u8:0x54 => (bits[16]:0b1111111110010100, u8:16),
        u8:0x93 => (bits[16]:0b1111111110010101, u8:16),
        u8:0x08 => (bits[16]:0b1111111110010110, u8:16),
        u8:0x09 => (bits[16]:0b1111111110010111, u8:16),
        u8:0x0A => (bits[16]:0b1111111110011000, u8:16),
        u8:0x18 => (bits[16]:0b1111111110011001, u8:16),
        u8:0x19 => (bits[16]:0b1111111110011010, u8:16),
        u8:0x26 => (bits[16]:0b1111111110011011, u8:16),
        u8:0x36 => (bits[16]:0b1111111110011100, u8:16),
        u8:0x45 => (bits[16]:0b1111111110011101, u8:16),
        u8:0x1A => (bits[16]:0b1111111110011110, u8:16),
        u8:0x27 => (bits[16]:0b1111111110011111, u8:16),
        u8:0x64 => (bits[16]:0b1111111110100000, u8:16),
        u8:0x74 => (bits[16]:0b1111111110100001, u8:16),
        u8:0x55 => (bits[16]:0b1111111110100010, u8:16),
        u8:0x37 => (bits[16]:0b1111111110100011, u8:16),
        u8:0xF2 => (bits[16]:0b1111111110100100, u8:16),
        u8:0xA3 => (bits[16]:0b1111111110100101, u8:16),
        u8:0xB3 => (bits[16]:0b1111111110100110, u8:16),
        u8:0xC3 => (bits[16]:0b1111111110100111, u8:16),
        u8:0x28 => (bits[16]:0b1111111110101000, u8:16),
        u8:0x29 => (bits[16]:0b1111111110101001, u8:16),
        u8:0xD3 => (bits[16]:0b1111111110101010, u8:16),
        u8:0xE3 => (bits[16]:0b1111111110101011, u8:16),
        u8:0xF3 => (bits[16]:0b1111111110101100, u8:16),
        u8:0x84 => (bits[16]:0b1111111110101101, u8:16),
        u8:0x94 => (bits[16]:0b1111111110101110, u8:16),
        u8:0xA4 => (bits[16]:0b1111111110101111, u8:16),
        u8:0xB4 => (bits[16]:0b1111111110110000, u8:16),
        u8:0xC4 => (bits[16]:0b1111111110110001, u8:16),
        u8:0xD4 => (bits[16]:0b1111111110110010, u8:16),
        u8:0xE4 => (bits[16]:0b1111111110110011, u8:16),
        u8:0xF4 => (bits[16]:0b1111111110110100, u8:16),
        u8:0x65 => (bits[16]:0b1111111110110101, u8:16),
        u8:0x75 => (bits[16]:0b1111111110110110, u8:16),
        u8:0x85 => (bits[16]:0b1111111110110111, u8:16),
        u8:0x95 => (bits[16]:0b1111111110111000, u8:16),
        u8:0xA5 => (bits[16]:0b1111111110111001, u8:16),
        u8:0xB5 => (bits[16]:0b1111111110111010, u8:16),
        u8:0xC5 => (bits[16]:0b1111111110111011, u8:16),
        u8:0xD5 => (bits[16]:0b1111111110111100, u8:16),
        u8:0xE5 => (bits[16]:0b1111111110111101, u8:16),
        u8:0xF5 => (bits[16]:0b1111111110111110, u8:16),
        u8:0x46 => (bits[16]:0b1111111110111111, u8:16),
        u8:0x56 => (bits[16]:0b1111111111000000, u8:16),
        u8:0x66 => (bits[16]:0b1111111111000001, u8:16),
        u8:0x76 => (bits[16]:0b1111111111000010, u8:16),
        u8:0x86 => (bits[16]:0b1111111111000011, u8:16),
        u8:0x96 => (bits[16]:0b1111111111000100, u8:16),
        u8:0xA6 => (bits[16]:0b1111111111000101, u8:16),
        u8:0xB6 => (bits[16]:0b1111111111000110, u8:16),
        u8:0xC6 => (bits[16]:0b1111111111000111, u8:16),
        u8:0xD6 => (bits[16]:0b1111111111001000, u8:16),
        u8:0xE6 => (bits[16]:0b1111111111001001, u8:16),
        u8:0xF6 => (bits[16]:0b1111111111001010, u8:16),
        u8:0x47 => (bits[16]:0b1111111111001011, u8:16),
        u8:0x57 => (bits[16]:0b1111111111001100, u8:16),
        u8:0x67 => (bits[16]:0b1111111111001101, u8:16),
        u8:0x77 => (bits[16]:0b1111111111001110, u8:16),
        u8:0x87 => (bits[16]:0b1111111111001111, u8:16),
        u8:0x97 => (bits[16]:0b1111111111010000, u8:16),
        u8:0xA7 => (bits[16]:0b1111111111010001, u8:16),
        u8:0xB7 => (bits[16]:0b1111111111010010, u8:16),
        u8:0xC7 => (bits[16]:0b1111111111010011, u8:16),
        u8:0xD7 => (bits[16]:0b1111111111010100, u8:16),
        u8:0xE7 => (bits[16]:0b1111111111010101, u8:16),
        u8:0xF7 => (bits[16]:0b1111111111010110, u8:16),
        u8:0x38 => (bits[16]:0b1111111111010111, u8:16),
        u8:0x48 => (bits[16]:0b1111111111011000, u8:16),
        u8:0x58 => (bits[16]:0b1111111111011001, u8:16),
        u8:0x68 => (bits[16]:0b1111111111011010, u8:16),
        u8:0x78 => (bits[16]:0b1111111111011011, u8:16),
        u8:0x88 => (bits[16]:0b1111111111011100, u8:16),
        u8:0x98 => (bits[16]:0b1111111111011101, u8:16),
        u8:0xA8 => (bits[16]:0b1111111111011110, u8:16),
        u8:0xB8 => (bits[16]:0b1111111111011111, u8:16),
        u8:0xC8 => (bits[16]:0b1111111111100000, u8:16),
        u8:0xD8 => (bits[16]:0b1111111111100001, u8:16),
        u8:0xE8 => (bits[16]:0b1111111111100010, u8:16),
        u8:0xF8 => (bits[16]:0b1111111111100011, u8:16),
        u8:0x39 => (bits[16]:0b1111111111100100, u8:16),
        u8:0x49 => (bits[16]:0b1111111111100101, u8:16),
        u8:0x59 => (bits[16]:0b1111111111100110, u8:16),
        u8:0x69 => (bits[16]:0b1111111111100111, u8:16),
        u8:0x79 => (bits[16]:0b1111111111101000, u8:16),
        u8:0x89 => (bits[16]:0b1111111111101001, u8:16),
        u8:0x99 => (bits[16]:0b1111111111101010, u8:16),
        u8:0xA9 => (bits[16]:0b1111111111101011, u8:16),
        u8:0xB9 => (bits[16]:0b1111111111101100, u8:16),
        u8:0xC9 => (bits[16]:0b1111111111101101, u8:16),
        u8:0xD9 => (bits[16]:0b1111111111101110, u8:16),
        u8:0xE9 => (bits[16]:0b1111111111101111, u8:16),
        u8:0xF9 => (bits[16]:0b1111111111110000, u8:16),
        u8:0x2A => (bits[16]:0b1111111111110001, u8:16),
        u8:0x3A => (bits[16]:0b1111111111110010, u8:16),
        u8:0x4A => (bits[16]:0b1111111111110011, u8:16),
        u8:0x5A => (bits[16]:0b1111111111110100, u8:16),
        u8:0x6A => (bits[16]:0b1111111111110101, u8:16),
        u8:0x7A => (bits[16]:0b1111111111110110, u8:16),
        u8:0x8A => (bits[16]:0b1111111111110111, u8:16),
        u8:0x9A => (bits[16]:0b1111111111111000, u8:16),
        u8:0xAA => (bits[16]:0b1111111111111001, u8:16),
        u8:0xBA => (bits[16]:0b1111111111111010, u8:16),
        u8:0xCA => (bits[16]:0b1111111111111011, u8:16),
        u8:0xDA => (bits[16]:0b1111111111111100, u8:16),
        u8:0xEA => (bits[16]:0b1111111111111101, u8:16),
        u8:0xFA => (bits[16]:0b1111111111111110, u8:16),
        _       => (bits[16]:0,               u8:0),
  }
}


#[test]
fn lookup_ACChrominanceToCode_test() {
  //let run: u4 = u4:0;
  //let value: u8 = u8:11;
  //let size: u32 = bit_length(value);
  //let run_size_str: u8[2] = encode_run_size(run as u32, size);
  let run_size_str: u8[2] = [u8:0, u8:4];
  trace!(run_size_str);

  let (code, length): (bits[16], u8) = lookup_ACChrominanceToCode(run_size_str);
  trace!(code);
  trace!(length);
  assert_eq(code, bits[16]:0b11010);
  assert_eq(length, u8:5)
}

fn fn_reverse(row: s10[8]) -> s10[8] {
  [ row[7], row[6], row[5], row[4], row[3], row[2], row[1], row[0] ]
  //[ row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7] ]
}

// 8×8 の u8 行列を平坦化して 64 要素の u8 配列にする関数
fn fn_flatten(matrix: s10[8][8]) -> s10[64] {
  let row0: s10[8] = fn_reverse(matrix[0]);
  let row1: s10[8] = fn_reverse(matrix[1]);
  let row2: s10[8] = fn_reverse(matrix[2]);
  let row3: s10[8] = fn_reverse(matrix[3]);
  let row4: s10[8] = fn_reverse(matrix[4]);
  let row5: s10[8] = fn_reverse(matrix[5]);
  let row6: s10[8] = fn_reverse(matrix[6]);
  let row7: s10[8] = fn_reverse(matrix[7]);

  let flat: s10[64] = row7 ++ row6 ++ row5 ++ row4 ++ row3 ++ row2 ++ row1 ++ row0;   // データ順を逆に
  //let flat: s10[64] = row0 ++ row1 ++ row2 ++ row3 ++ row4 ++ row5 ++ row6 ++ row7;
  flat
}

#[test]
fn test0_fn_flatten() {
  let test_matrix: s10[8][8] = [
    [s10:0,  s10:11, s10:5,  s10:0,  s10:0,  s10:6,  s10:2,  s10:4],
    [s10:4,  s10:4,  s10:3,  s10:2,  s10:4,  s10:2,  s10:2,  s10:56],
    [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:48],
    [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:32],
    [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:24],
    [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:16],
    [s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:8],
    [s10:0,  s10:0,  s10:0,  s10:0,  s10:4,  s10:3,  s10:2,  s10:1]
  ];
  let result: s10[64] = fn_flatten(test_matrix);
  trace!(result);
}

// AC 成分（63 要素）のすべてが 0 かどうか判定する関数
fn fn_is_all_zero(ac: s10[64]) -> bool {
  ac[0]  == s10:0 &&
  ac[1]  == s10:0 &&
  ac[2]  == s10:0 &&
  ac[3]  == s10:0 &&
  ac[4]  == s10:0 &&
  ac[5]  == s10:0 &&
  ac[6]  == s10:0 &&
  ac[7]  == s10:0 &&
  ac[8]  == s10:0 &&
  ac[9]  == s10:0 &&
  ac[10] == s10:0 &&
  ac[11] == s10:0 &&
  ac[12] == s10:0 &&
  ac[13] == s10:0 &&
  ac[14] == s10:0 &&
  ac[15] == s10:0 &&
  ac[16] == s10:0 &&
  ac[17] == s10:0 &&
  ac[18] == s10:0 &&
  ac[19] == s10:0 &&
  ac[20] == s10:0 &&
  ac[21] == s10:0 &&
  ac[22] == s10:0 &&
  ac[23] == s10:0 &&
  ac[24] == s10:0 &&
  ac[25] == s10:0 &&
  ac[26] == s10:0 &&
  ac[27] == s10:0 &&
  ac[28] == s10:0 &&
  ac[29] == s10:0 &&
  ac[30] == s10:0 &&
  ac[31] == s10:0 &&
  ac[32] == s10:0 &&
  ac[33] == s10:0 &&
  ac[34] == s10:0 &&
  ac[35] == s10:0 &&
  ac[36] == s10:0 &&
  ac[37] == s10:0 &&
  ac[38] == s10:0 &&
  ac[39] == s10:0 &&
  ac[40] == s10:0 &&
  ac[41] == s10:0 &&
  ac[42] == s10:0 &&
  ac[43] == s10:0 &&
  ac[44] == s10:0 &&
  ac[45] == s10:0 &&
  ac[46] == s10:0 &&
  ac[47] == s10:0 &&
  ac[48] == s10:0 &&
  ac[49] == s10:0 &&
  ac[50] == s10:0 &&
  ac[51] == s10:0 &&
  ac[52] == s10:0 &&
  ac[53] == s10:0 &&
  ac[54] == s10:0 &&
  ac[55] == s10:0 &&
  ac[56] == s10:0 &&
  ac[57] == s10:0 &&
  ac[58] == s10:0 &&
  ac[59] == s10:0 &&
  ac[60] == s10:0 &&
  ac[61] == s10:0 &&
  ac[62] == s10:0 &&
  ac[63] == s10:0 
}


// AC 成分（63 要素）を取得する関数
fn get_ac(flat: u8[64]) -> u8[63] {
    let ac: u8[63] = [
        flat[1], flat[2], flat[3], flat[4], flat[5], flat[6], flat[7], flat[8],
        flat[9], flat[10], flat[11], flat[12], flat[13], flat[14], flat[15], flat[16],
        flat[17], flat[18], flat[19], flat[20], flat[21], flat[22], flat[23], flat[24],
        flat[25], flat[26], flat[27], flat[28], flat[29], flat[30], flat[31], flat[32],
        flat[33], flat[34], flat[35], flat[36], flat[37], flat[38], flat[39], flat[40],
        flat[41], flat[42], flat[43], flat[44], flat[45], flat[46], flat[47], flat[48],
        flat[49], flat[50], flat[51], flat[52], flat[53], flat[54], flat[55], flat[56],
        flat[57], flat[58], flat[59], flat[60], flat[61], flat[62], flat[63]
    ];
    ac
}

// スタート位置を指定してMatrixを取得する関数
fn get_ac_list(start_index: u8, flat: s10[64]) -> s10[64] {
    // start
    let start_index_1 = if start_index > u8:64 { u8:64 } else { start_index };
    
    //let start_index = u8:0;
    // 64個の要素がすべて0の配列を用意（要素数を正確に63個並べる）
    let zero_array: s10[64] = [
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0
    ];    
  
    // start_index は bits[4] (最大15) なので、u8 に変換してから使う
    let si_u8: u8 = start_index_1 as u8;  // 0 <= si_u8 <= 15
  
    // parametric for 構文
    let result = for (i, accum) in range(bits[8]:0, bits[8]:64) {
      // i を u8 に変換（0..62）
      let idx_u8 = i as u8;
  
      // start_index + i
      let actual_index: u8 = si_u8 + idx_u8;  // 最大 15 + 62 = 77, 範囲外なら下で 0
  
      // update(accum, 書き込み先, 書き込み値)
      let new_accum = update(
        accum,
        idx_u8,
        if actual_index < u8:64 {
          flat[actual_index]
        } else {
          s10:0
        }
      );
  
      new_accum
    }(zero_array);
  
    result
  }
  
// AC 配列 ac のうち、インデックス start 以前に連続する 0 の数をカウントする
fn fn_count_run(ac: s10[63], pre_start: u32, start: u32) -> u8 {
  //trace!(ac);
  //trace!(pre_start);
  //trace!(start);
  //trace!(ac[start]);
  let zero_num = if start == u32:0 {
    // インデックス 0 の場合、先行要素はないので 0 を返す
    u8:0
  } else if ac[start - u32:1] != s10:0 {
    // 直前の要素が 0 でなければ連続 0 はない
    u8:0
  } else if start == u32:1 {
    u8:1
  } else if ac[start - u32:2] != s10:0 {
    u8:1
  } else if start == u32:2 {
    u8:2
  } else if ac[start - u32:3] != s10:0 {
    u8:2
  } else if start == u32:3 {
    u8:3
  } else if ac[start - u32:4] != s10:0 {
    u8:3
  } else if start == u32:4 {
    u8:4
  } else if ac[start - u32:5] != s10:0 {
    u8:4
  } else if start == u32:5 {
    u8:5
  } else if ac[start - u32:6] != s10:0 {
    u8:5
  } else if start == u32:6 {
    u8:6
  } else if ac[start - u32:7] != s10:0 {
    u8:6
  } else if start == u32:7 {
    u8:7
  } else if ac[start - u32:8] != s10:0 {
    u8:7
  } else if start == u32:8 {
    u8:8
  } else if ac[start - u32:9] != s10:0 {
    u8:8
  } else if start == u32:9 {
    u8:9
  } else if ac[start - u32:10] != s10:0 {
    u8:9
  } else if start == u32:10 {
    u8:10
  } else if ac[start - u32:11] != s10:0 {
    u8:10
  } else if start == u32:11 {
    u8:11
  } else if ac[start - u32:12] != s10:0 {
    u8:11
  } else if start == u32:12 {
    u8:12
  } else if ac[start - u32:13] != s10:0 {
    u8:12
  } else if start == u32:13 {
    u8:13
  } else if ac[start - u32:14] != s10:0 {
    u8:13
  } else if start == u32:14 {
    u8:14
  } else if ac[start - u32:15] != s10:0 {
    u8:14
  } else {
    u8:15
  };
  // 最終結果
  let out_num = if zero_num > (start - pre_start) as u8 { (start - pre_start) as u8 } else { zero_num };
  out_num
}

#[test]
fn test0_count_run() {
  let ac_matrix: s10[63] = [ 
      s10:0, s10:0, s10:0, s10:0, s10:7, s10:0, s10:0, s10:0, s10:-1, s10:0,
      s10:5, s10:6, s10:7, s10:8, s10:9, s10:10, s10:11, s10:12, s10:13, s10:14,
      s10:15, s10:16, s10:17, s10:18, s10:19, s10:20, s10:21, s10:22, s10:23, s10:24,
      s10:25, s10:26, s10:27, s10:28, s10:29, s10:30, s10:31, s10:32, s10:33, s10:34,
      s10:35, s10:36, s10:37, s10:38, s10:39, s10:40, s10:41, s10:42, s10:43, s10:44,
      s10:45, s10:46, s10:47, s10:48, s10:49, s10:50, s10:51, s10:52, s10:53, s10:3,
      s10:45, s10:46, s10:47
  ];

    // 各テストケース
    let result0: u8 = fn_count_run(ac_matrix, u32:0, u32:0);
    let result1: u8 = fn_count_run(ac_matrix, u32:2, u32:4);
    let result2: u8 = fn_count_run(ac_matrix, u32:0, u32:3);
    let result3: u8 = fn_count_run(ac_matrix, u32:0, u32:5);
    let result4: u8 = fn_count_run(ac_matrix, u32:0, u32:8);

    trace!(result0);
    trace!(result1);
    trace!(result2);
    trace!(result3);
    trace!(result4);

    // 期待値と比較
    assert_eq(result0, u8:0);
    assert_eq(result1, u8:2);
    assert_eq(result2, u8:3);
    assert_eq(result3, u8:0);
    assert_eq(result4, u8:3);

    // ALL Zero
    let ac_matrix: s10[63] = [
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:23
    ];

    // 各テストケース
    let result5: u8 = fn_count_run(ac_matrix, u32:0, u32:62);

    trace!(result5);

    // 期待値と比較
    // Max = 15 Limit
    assert_eq(result5, u8:15);
}

// AC 配列 ac のうち、インデックス start から連続する 0 の数 + 1 をカウントする
// 最大で15個までカウントし、途中で0以外の値が出たらそこで打ち切る
fn fn_next_pix(ac: s10[64], start: u32) -> u8 {
  let zero_num = if start + u32:1 >= u32:63 {
    u8:0
  } else if ac[start + u32:1] != s10:0 {
    u8:0
  } else if start + u32:2 >= u32:64 {
    u8:1
  } else if ac[start + u32:2] != s10:0 {
    u8:1
  } else if start + u32:3 >= u32:64 {
    u8:2
  } else if ac[start + u32:3] != s10:0 {
    u8:2
  } else if start + u32:4 >= u32:64 {
    u8:3
  } else if ac[start + u32:4] != s10:0 {
    u8:3
  } else if start + u32:5 >= u32:64 {
    u8:4
  } else if ac[start + u32:5] != s10:0 {
    u8:4
  } else if start + u32:6 >= u32:64 {
    u8:5
  } else if ac[start + u32:6] != s10:0 {
    u8:5
  } else if start + u32:7 >= u32:64 {
    u8:6
  } else if ac[start + u32:7] != s10:0 {
    u8:6
  } else if start + u32:8 >= u32:64 {
    u8:7
  } else if ac[start + u32:8] != s10:0 {
    u8:7
  } else if start + u32:9 >= u32:64 {
    u8:8
  } else if ac[start + u32:9] != s10:0 {
    u8:8
  } else if start + u32:10 >= u32:64 {
    u8:9
  } else if ac[start + u32:10] != s10:0 {
    u8:9
  } else if start + u32:11 >= u32:64 {
    u8:10
  } else if ac[start + u32:11] != s10:0 {
    u8:10
  } else if start + u32:12 >= u32:64 {
    u8:11
  } else if ac[start + u32:12] != s10:0 {
    u8:11
  } else if start + u32:13 >= u32:64 {
    u8:12
  } else if ac[start + u32:13] != s10:0 {
    u8:12
  } else if start + u32:14 >= u32:64 {
    u8:13
  } else if ac[start + u32:14] != s10:0 {
    u8:13
  } else if start + u32:15 >= u32:64 {
    u8:14
  } else if ac[start + u32:15] != s10:0 {
    u8:14
  } else {
    u8:15
  };
  if ac[start] != s10:0 {
    u8:0
  } else {
    zero_num + u8:1
  }
}


#[test]
fn test0_next_pix() {
  let ac_matrix: s10[64] = [
      s10:0, s10:0, s10:0, s10:0, s10:7, s10:0, s10:0, s10:0, s10:0, s10:0,
      s10:5, s10:6, s10:7, s10:8, s10:9, s10:10, s10:11, s10:12, s10:13, s10:14,
      s10:15, s10:16, s10:17, s10:18, s10:19, s10:20, s10:21, s10:22, s10:23, s10:24,
      s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
      s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
      s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
      s10:0,  s10:0 , s10:0,  s10:0
  ];

    // 各テストケース
    let result1: u8 = fn_next_pix(ac_matrix, u32:1);
    let result2: u8 = fn_next_pix(ac_matrix, u32:3);
    let result3: u8 = fn_next_pix(ac_matrix, u32:4);
    let result4: u8 = fn_next_pix(ac_matrix, u32:49);

    trace!(result1);
    trace!(result2);
    trace!(result3);
    trace!(result4);

    // 期待値と比較
    assert_eq(result1, u8:3);
    assert_eq(result2, u8:1);
    assert_eq(result3, u8:0);
    assert_eq(result4, u8:15);
}



// ビット数を求める関数
fn bit_length(x: s10) -> u8 {
  // 絶対値を計算
  let x_abs: u8 = if x < s10:0 {
      -x as u8
  } else {
       x as u8
  };
  // Bit長を返す
  if x_abs == u8:0 {
      u8:0
  } else if x_abs >= u8:128 {
      u8:8
  } else if x_abs >= u8:64 {
      u8:7
  } else if x_abs >= u8:32 {
      u8:6
  } else if x_abs >= u8:16 {
      u8:5
  } else if x_abs >= u8:8 {
      u8:4
  } else if x_abs >= u8:4 {
      u8:3
  } else if x_abs >= u8:2 {
      u8:2
  } else {
      u8:1
  }
}

// 0〜15 の整数を 16 進数の文字 (0-9, A-F) に変換
fn to_hex_digit(x: u32) -> u8 {
    if x < u32:10 {
        u8:48 + (x as u8)  // '0' (48) 〜 '9' (57)
    } else {
        u8:55 + (x as u8)  // 'A' (65) 〜 'F' (70)
    }
}

// run_size_str を符号化
fn encode_run_size(run: u32, size: u32) -> u8[2] {
  let run_u8 : u8 = to_hex_digit(run);
  let size_u8: u8 = to_hex_digit(size);
  let run_size : u8[2] = [run_u8, size_u8];
  trace!(run_size);
  run_size
}

#[test]
fn test_encode_run_size() {
  let run: u32 = u32:10;
  let size: u32 = u32:2;
  let result: u8[2] = encode_run_size(run, size);
  // 期待される結果は ['A', '2'] つまり [u8:65, u8:50]
  let expected: u8[2] = [u8:65, u8:50];
  assert_eq(result, expected);
}

// Code生成部分を関数化
fn fn_code_list(value: s16) -> bits[8] {
  if value <= s16:0 {
    let bin_value: bits[8] = (-value) as bits[8];
    let flipped: bits[8] = !bin_value;
    flipped
  } else {
    let bin_value: bits[8] = value as bits[8];
    bin_value
  }
}

#[test]
fn test_fn_code_list() {
  let value = s16:-13;
  let code = fn_code_list(value);
  trace!(code);
  assert_eq(code, bits[8]:0b1111_0010);
}

// ACマトリックスの範囲内取り出し
fn fn_ac_data(start: s10, ac_data: s10[63]) -> s10 {
  let data_out: s10 = if start >= s10:0 && start <= s10:63 { ac_data[start as u8] } else { s10:0 };
  data_out
}

// --------------------------------
// メイン関数
// AC 成分の Huffman 符号化（ループなし）
// Output: code[15:0] + length:u8 + code_list[7:0] + code_size:u8 + run:u8 + next_pix:u8
fn encode_ac(ac_data: s10[64], start_pix: u8, pre_start_pix: u8, is_luminance: bool) -> (bits[16], u8, bits[8], u8, u8, u8) {

    // Debug
    trace!(ac_data);
    trace!(start_pix);
    let start_value: s10 = ac_data[start_pix];
    trace!(start_value);

    // start_pixのデータがゼロであるか？
    let start_pix_data_zero = if ac_data[start_pix] == s10:0 { true } else { false };
    trace!(start_pix_data_zero);

    // 残りがオールゼロの判定
    let ac_remain_data: s10[64] = get_ac_list(start_pix, ac_data);

    // EOB
    if fn_is_all_zero(ac_remain_data) {
      if is_luminance {
        // 直接タプルを返す
        (EOB_LUM_EXT, u8:4, bits[8]:0, u8:0, u8:63, u8:63)
      } else {
        (EOB_CHM_EXT, u8:2, bits[8]:0, u8:0, u8:63, u8:63)
      }
    // Huffman encoding
    } else {
      let value_pix_num = fn_next_pix(ac_data, start_pix as u32);
      trace!(value_pix_num);

      // Huffman encode処理
      let value: s10 = ac_data[start_pix + value_pix_num];
      let run_0: u8 = if value_pix_num > u8:15 { u8:15 } else { value_pix_num  };
      let run = if start_pix_data_zero == false { u8:0 } else { run_0 };
      let size: u8 = bit_length(value);
      //let run_size_str: u8[2] = encode_run_size(run as u32, size);

      trace!(value);
      trace!(run);
      trace!(size);
      let run_size_str: u8[2] = [run as u8, size as u8];
      trace!(run_size_str);

      // Huffman テーブルを参照
      let (Huffman_code_full, Huffman_length): (bits[16], u8) =
          if is_luminance {
              lookup_ACLuminanceSizeToCode(run_size_str)
          } else {
              lookup_ACChrominanceToCode(run_size_str)
          };

      trace!(Huffman_code_full);
      trace!(Huffman_length);    

      // Code_Listの計算
      let Code_list: bits[8] = fn_code_list(value as s16);
      let Code_size = size;
      trace!(Code_list);

      // next_pix
      let next_pix_0 = value_pix_num + u8:1;
      let next_pix_1 = if start_pix_data_zero { next_pix_0  } else { u8:1 };
      let next_pix = if next_pix_1 > u8:16 { u8:16 } else { next_pix_1 };

      (Huffman_code_full, Huffman_length, Code_list, Code_size, run, next_pix)
    }
}

// --------------------------------
// ラッパー関数
// Output: code[15:0] + length:u8 + code_list[7:0] + code_size:u8 + run:u8 + next_pix:u8 + now_pix_data:s10
fn Huffman_ACenc(matrix: s10[8][8], start_pix: u8, pre_start_pix: u8, is_luminance: bool) -> (bits[16], u8, bits[8], u8, u8, u8, s10) {

    // 1次元配列化
    let flat_ac: s10[64] = fn_flatten(matrix);
    let ac_in: s10[64] = get_ac_list(u8:0, flat_ac);

    // debug
    let value = ac_in[start_pix];

    // 通常Huffman encode処理
    let (huff_code, huff_length, code_list, code_size, run, next_pix) 
        = encode_ac(ac_in, start_pix, pre_start_pix, is_luminance);
    // 出力
    (huff_code, huff_length, code_list, code_size, next_pix, run, value)

  }
