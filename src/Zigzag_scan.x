// NISHIHARU

/// 8×8 の行列を 1 次元（64 要素）の配列に平坦化（行優先）する関数。
fn flatten_matrix(matrix: u8[8][8]) -> u8[64] {
  [
    matrix[0][0], matrix[0][1], matrix[0][2], matrix[0][3],
    matrix[0][4], matrix[0][5], matrix[0][6], matrix[0][7],
    matrix[1][0], matrix[1][1], matrix[1][2], matrix[1][3],
    matrix[1][4], matrix[1][5], matrix[1][6], matrix[1][7],
    matrix[2][0], matrix[2][1], matrix[2][2], matrix[2][3],
    matrix[2][4], matrix[2][5], matrix[2][6], matrix[2][7],
    matrix[3][0], matrix[3][1], matrix[3][2], matrix[3][3],
    matrix[3][4], matrix[3][5], matrix[3][6], matrix[3][7],
    matrix[4][0], matrix[4][1], matrix[4][2], matrix[4][3],
    matrix[4][4], matrix[4][5], matrix[4][6], matrix[4][7],
    matrix[5][0], matrix[5][1], matrix[5][2], matrix[5][3],
    matrix[5][4], matrix[5][5], matrix[5][6], matrix[5][7],
    matrix[6][0], matrix[6][1], matrix[6][2], matrix[6][3],
    matrix[6][4], matrix[6][5], matrix[6][6], matrix[6][7],
    matrix[7][0], matrix[7][1], matrix[7][2], matrix[7][3],
    matrix[7][4], matrix[7][5], matrix[7][6], matrix[7][7]
  ]
}

const ZERO64: u8[64] = [
  u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
  u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
  u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
  u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
  u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
  u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
  u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
  u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0, u8:0,
];

/// 平坦化した配列を zigzag 順に並び替える関数。
fn Zigzag_reorder(matrix: u8[8][8], is_enable: bool) -> u8[64] {
  if is_enable  {
    let flat = flatten_matrix(matrix);
    [
      flat[0],
      flat[1],
      flat[8],
      flat[16],
      flat[9],
      flat[2],
      flat[3],
      flat[10],
      flat[17],
      flat[24],
      flat[32],
      flat[25],
      flat[18],
      flat[11],
      flat[4],
      flat[5],
      flat[12],
      flat[19],
      flat[26],
      flat[33],
      flat[40],
      flat[48],
      flat[41],
      flat[34],
      flat[27],
      flat[20],
      flat[13],
      flat[6],
      flat[7],
      flat[14],
      flat[21],
      flat[28],
      flat[35],
      flat[42],
      flat[49],
      flat[56],
      flat[57],
      flat[50],
      flat[43],
      flat[36],
      flat[29],
      flat[22],
      flat[15],
      flat[23],
      flat[30],
      flat[37],
      flat[44],
      flat[51],
      flat[58],
      flat[59],
      flat[52],
      flat[45],
      flat[38],
      flat[31],
      flat[39],
      flat[46],
      flat[53],
      flat[60],
      flat[61],
      flat[54],
      flat[47],
      flat[55],
      flat[62],
      flat[63]
    ]
  } else {
    ZERO64
  }
}

#[test]
fn test0_zigzag_reorder() {
  let matrix: u8[8][8] = [
    [ u8:1,  u8:2,  u8:3,  u8:4,  u8:5,  u8:6,  u8:7,  u8:8 ],
    [ u8:9,  u8:10, u8:11, u8:12, u8:13, u8:14, u8:15, u8:16 ],
    [ u8:17, u8:18, u8:19, u8:20, u8:21, u8:22, u8:23, u8:24 ],
    [ u8:25, u8:26, u8:27, u8:28, u8:29, u8:30, u8:31, u8:32 ],
    [ u8:33, u8:34, u8:35, u8:36, u8:37, u8:38, u8:39, u8:40 ],
    [ u8:41, u8:42, u8:43, u8:44, u8:45, u8:46, u8:47, u8:48 ],
    [ u8:49, u8:50, u8:51, u8:52, u8:53, u8:54, u8:55, u8:56 ],
    [ u8:57, u8:58, u8:59, u8:60, u8:61, u8:62, u8:63, u8:64 ]
  ];
  let result = Zigzag_reorder(matrix, true);
  //trace!(result);

  // 期待される結果（実行結果は以下の通り）
  let expected: u8[64] = [
    u8:1,  u8:2,  u8:9,  u8:17, u8:10, u8:3,  u8:4,  u8:11,
    u8:18, u8:25, u8:33, u8:26, u8:19, u8:12, u8:5,  u8:6,
    u8:13, u8:20, u8:27, u8:34, u8:41, u8:49, u8:42, u8:35,
    u8:28, u8:21, u8:14, u8:7,  u8:8,  u8:15, u8:22, u8:29,
    u8:36, u8:43, u8:50, u8:57, u8:58, u8:51, u8:44, u8:37,
    u8:30, u8:23, u8:16, u8:24, u8:31, u8:38, u8:45, u8:52,
    u8:59, u8:60, u8:53, u8:46, u8:39, u8:32, u8:40, u8:47,
    u8:54, u8:61, u8:62, u8:55, u8:48, u8:56, u8:63, u8:64
  ];

  // 結果が期待値と一致することを検証する
  assert_eq(result, expected);
}

#[test]
fn test1_zigzag_reorder() {
  let matrix: u8[8][8] = [
    [ u8:1,  u8:2,  u8:3,  u8:4,  u8:5,  u8:6,  u8:7,  u8:8 ],
    [ u8:9,  u8:10, u8:11, u8:12, u8:13, u8:14, u8:15, u8:16 ],
    [ u8:17, u8:18, u8:19, u8:20, u8:21, u8:22, u8:23, u8:24 ],
    [ u8:25, u8:26, u8:27, u8:28, u8:29, u8:30, u8:31, u8:32 ],
    [ u8:33, u8:34, u8:35, u8:36, u8:37, u8:38, u8:39, u8:40 ],
    [ u8:41, u8:42, u8:43, u8:44, u8:45, u8:46, u8:47, u8:48 ],
    [ u8:49, u8:50, u8:51, u8:52, u8:53, u8:54, u8:55, u8:56 ],
    [ u8:57, u8:58, u8:59, u8:60, u8:61, u8:62, u8:63, u8:64 ]
  ];
  let result = Zigzag_reorder(matrix, false);
  //trace!(result);

  // 期待される結果（実行結果は以下の通り）
  let expected: u8[64] = [
    u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,
    u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,
    u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,
    u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,
    u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,
    u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,
    u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,
    u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0,  u8:0
  ];

  // 結果が期待値と一致することを検証する
  assert_eq(result, expected);
}
