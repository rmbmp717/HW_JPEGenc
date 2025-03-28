// NISHIHARU

/// Function to calculate the bit length of a given s10 value.
fn bit_length(x: s10) -> u8 {
    // Compute absolute value.
    let x_abs: u8 = if x < s10:0 {
        -x as u8
    } else {
         x as u8
    };
    // Return the bit length.
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

#[test]
fn bit_length_test () {
    let bit_length_out1 = bit_length(s10:-12);
    trace!(bit_length_out1);

    let bit_length_out2 = bit_length(s10:12);
    trace!(bit_length_out2);
}

/// Converts an integer between 0 and 15 to a hexadecimal digit (0-9, A-F).
fn to_hex_digit(x: u32) -> u8 {
    if x < u32:10 {
        u8:48 + (x as u8)  // '0' (48) to '9' (57)
    } else {
        u8:55 + (x as u8)  // 'A' (65) to 'F' (70)
    }
}

/// Encodes the run and size values into a two-digit hexadecimal string.
fn encode_run_size(run: u32, size: u32) -> u8[2] {
    [to_hex_digit(run), to_hex_digit(size)]
}

/// Lookup table for JPEG standard DC Luminance Huffman codes (full entries).
/// Returns a tuple (code, length), where 'code' is a 9-bit bit pattern (with valid bits in the lower part)
/// and 'length' is the number of valid bits.
fn lookup_DCLuminanceSizeToCode(index: u8) -> (bits[9], u8) {
    trace!(index);
    match index {
      u8:0x00 => (bits[9]:0b00000110, u8:3),  // Index 0: [1,1,0] → 3 bits (binary: 0b00000110)
      u8:0x01 => (bits[9]:0b00000101, u8:3),  // Index 1: [1,0,1] → 3 bits (binary: 0b00000101)
      u8:0x02 => (bits[9]:0b00000011, u8:3),  // Index 2: [0,1,1] → 3 bits (binary: 0b00000011)
      u8:0x03 => (bits[9]:0b00000010, u8:3),  // Index 3: [0,1,0] → 3 bits (binary: 0b00000010)
      u8:0x04 => (bits[9]:0b00000000, u8:3),  // Index 4: [0,0,0] → 3 bits (binary: 0b00000000)
      u8:0x05 => (bits[9]:0b00000001, u8:3),  // Index 5: [0,0,1] → 3 bits (binary: 0b00000001)
      u8:0x06 => (bits[9]:0b00000100, u8:3),  // Index 6: [1,0,0] → 3 bits (binary: 0b00000100)
      u8:0x07 => (bits[9]:0b00001110, u8:4),  // Index 7: [1,1,1,0] → 4 bits (binary: 0b00001110)
      u8:0x08 => (bits[9]:0b00011110, u8:5),  // Index 8: [1,1,1,1,0] → 5 bits (binary: 0b00011110)
      u8:0x09 => (bits[9]:0b00111110, u8:6),  // Index 9: [1,1,1,1,1,0] → 6 bits (binary: 0b00111110)
      u8:0x0A => (bits[9]:0b01111110, u8:7),  // Index 10: [1,1,1,1,1,1,0] → 7 bits (binary: 0b01111110)
      u8:0x0B => (bits[9]:0b11111110, u8:8),  // Index 11: [1,1,1,1,1,1,1,0] → 8 bits (binary: 0b11111110)
      _       => (bits[9]:0, u8:0),
    }
}

#[test]
fn lookup_DCLuminanceSizeToCode_test() {
    let (code, length): (bits[9], u8) = lookup_DCLuminanceSizeToCode(u8:1);
    trace!(code);
    trace!(length);
    assert_eq(code, bits[9]:0b00000101);
    assert_eq(length, u8:3);
}

/// Lookup table for JPEG standard DC Chrominance Huffman codes.
/// Each tuple is (code, length), where code is a 9-bit bit pattern (with valid bits in the upper portion, padded in lower bits)
/// and length is the number of valid bits.
fn lookup_ChrominanceSizeToCode(index: u8) -> (bits[9], u8) {
    trace!(index);
    match index {
      u8:0x00 => (bits[9]:0b000000001, u8:2), // Index 0: [0,1] → 2 bits, value: 2
      u8:0x01 => (bits[9]:0b000000000, u8:2), // Index 1: [0,0] → 2 bits, value: 0
      u8:0x02 => (bits[9]:0b000000100, u8:3), // Index 2: [1,0,0] → 3 bits, value: 1
      u8:0x03 => (bits[9]:0b000000101, u8:3), // Index 3: [1,0,1] → 3 bits, value: 5
      u8:0x04 => (bits[9]:0b000001100, u8:4), // Index 4: [1,1,0,0] → 4 bits, value: 3
      u8:0x05 => (bits[9]:0b000001101, u8:4), // Index 5: [1,1,0,1] → 4 bits, value: 11
      u8:0x06 => (bits[9]:0b000001110, u8:4), // Index 6: [1,1,1,0] → 4 bits, value: 7
      u8:0x07 => (bits[9]:0b000011110, u8:5), // Index 7: [1,1,1,1,0] → 5 bits, value: 15
      u8:0x08 => (bits[9]:0b000111110, u8:6), // Index 8: [1,1,1,1,1,0] → 6 bits, value: 31
      u8:0x09 => (bits[9]:0b001111110, u8:7), // Index 9: [1,1,1,1,1,1,0] → 7 bits, value: 63
      u8:0x0A => (bits[9]:0b011111110, u8:8), // Index 10: [1,1,1,1,1,1,1,0] → 8 bits, value: 127
      u8:0x0B => (bits[9]:0b011111110, u8:9), // Index 11: [1,1,1,1,1,1,1,1,0] → 9 bits, value: 255
      _       => (bits[9]:0, u8:0),
    }
}

#[test]
fn lookup_ChrominanceSizeToCode_test() {
    let (code, length): (bits[9], u8) = lookup_ChrominanceSizeToCode(u8:3);
    trace!(code);
    trace!(length);
    assert_eq(code, bits[9]:0b000000101);
    assert_eq(length, u8:3);
}

/// Returns the Huffman code for Chrominance based on the provided run/size pair.
fn lookup_huffman_chrom(run_size: u8[2]) -> (bits[16], u8) {
    if run_size[0] == u8:48 && run_size[1] == u8:48 {
        (bits[16]:0b1110, u8:4)  // "00" → EOB
    } else {
        (bits[16]:0b0000, u8:4)  // Temporary encoding result
    }
}

/// Encodes the value by inverting its bits if necessary.
fn encode_value(value: u8) -> bits[8] {
    let bit_0: bits[1] = ((value >> u8:7) & u8:1) as bits[1];
    let bit_1: bits[1] = ((value >> u8:6) & u8:1) as bits[1];
    let bit_2: bits[1] = ((value >> u8:5) & u8:1) as bits[1];
    let bit_3: bits[1] = ((value >> u8:4) & u8:1) as bits[1];
    let bit_4: bits[1] = ((value >> u8:3) & u8:1) as bits[1];
    let bit_5: bits[1] = ((value >> u8:2) & u8:1) as bits[1];
    let bit_6: bits[1] = ((value >> u8:1) & u8:1) as bits[1];
    let bit_7: bits[1] = ((value >> u8:0) & u8:1) as bits[1];

    let bits_value: bits[8] =
        (bit_0 as bits[8] << bits[8]:7) |
        (bit_1 as bits[8] << bits[8]:6) |
        (bit_2 as bits[8] << bits[8]:5) |
        (bit_3 as bits[8] << bits[8]:4) |
        (bit_4 as bits[8] << bits[8]:3) |
        (bit_5 as bits[8] << bits[8]:2) |
        (bit_6 as bits[8] << bits[8]:1) |
        (bit_7 as bits[8]);

    bits_value
}

/// Huffman encoding for the DC component (without loop).
/// Returns a tuple containing (Huffman code, length of Huffman code, additional bits, size of additional bits).
fn encode_dc(dc_value: s10, is_luminance: bool) -> (bits[9], u8, bits[8], u8) {

    let size: u8 = bit_length(dc_value);
    let Code_size = size;
    trace!(dc_value);
    trace!(size);

    let (BoolList, Length): (bits[9], u8) =
        if is_luminance {
            lookup_DCLuminanceSizeToCode(size)
        } else {
            lookup_ChrominanceSizeToCode(size)
        };

    trace!(BoolList);
    trace!(Length);

    let Code_list: bits[8] =
    if dc_value <= s10:0 {
        let bin_value: bits[8] = (-dc_value) as bits[8];
        trace!(bin_value);
        let flipped: bits[8] = !bin_value;
        trace!(flipped);
        flipped
    } else {
        let bin_value: bits[8] = dc_value as bits[8];
        bin_value
    };

    trace!(Code_list);

    (BoolList, Length, Code_list, Code_size)
}

/// Main function for DC Huffman encoding.
fn Huffman_DCenc(dc_in: s10, is_luminance: bool) -> (bits[9], bits[8], u8, u8) {
    trace!(dc_in);
    encode_dc(dc_in, is_luminance) 
}


//----------------------------------------------------------------------
// Test
#[test]
fn test_DCenc() {
    let exp_dc_code = bits[9]:3;
    let exp_dc_code_length = u8:3;
    let exp_dc_code_list = bits[8]:3;
    let exp_dc_code_size = u8:2;
    let (dc_code, dc_code_length, dc_code_list, dc_code_size) = Huffman_DCenc(s10:3, true);

    assert_eq(dc_code, exp_dc_code);
    assert_eq(dc_code_length, exp_dc_code_length);
    assert_eq(dc_code_list, exp_dc_code_list);
    assert_eq(dc_code_size, exp_dc_code_size);
}