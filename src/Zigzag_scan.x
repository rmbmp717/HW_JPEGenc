// NISHIHARU

/// 8×8 の行列を 1 次元（64 要素）の配列に平坦化（行優先）する関数。
fn flatten_matrix(matrix: s10[8][8]) -> s10[64] {
  [
    matrix[0][0], matrix[0][1], matrix[0][2], matrix[0][3], matrix[0][4], matrix[0][5], matrix[0][6], matrix[0][7],
    matrix[1][0], matrix[1][1], matrix[1][2], matrix[1][3], matrix[1][4], matrix[1][5], matrix[1][6], matrix[1][7],
    matrix[2][0], matrix[2][1], matrix[2][2], matrix[2][3], matrix[2][4], matrix[2][5], matrix[2][6], matrix[2][7],
    matrix[3][0], matrix[3][1], matrix[3][2], matrix[3][3], matrix[3][4], matrix[3][5], matrix[3][6], matrix[3][7],
    matrix[4][0], matrix[4][1], matrix[4][2], matrix[4][3], matrix[4][4], matrix[4][5], matrix[4][6], matrix[4][7],
    matrix[5][0], matrix[5][1], matrix[5][2], matrix[5][3], matrix[5][4], matrix[5][5], matrix[5][6], matrix[5][7],
    matrix[6][0], matrix[6][1], matrix[6][2], matrix[6][3], matrix[6][4], matrix[6][5], matrix[6][6], matrix[6][7],
    matrix[7][0], matrix[7][1], matrix[7][2], matrix[7][3], matrix[7][4], matrix[7][5], matrix[7][6], matrix[7][7]
  ]
}

const ZERO64: s10[64] = [
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
  s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0, s10:0,
];

/// 平坦化した配列を zigzag 順に並び替える関数。
fn Zigzag_reorder(matrix: s10[8][8], is_enable: bool) -> s10[64] {
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
  let matrix: s10[8][8] = [
    [ s10:1,  s10:2,  s10:3,  s10:4,  s10:5,  s10:6,  s10:7,  s10:8 ],
    [ s10:9,  s10:10, s10:11, s10:12, s10:13, s10:14, s10:15, s10:16 ],
    [ s10:17, s10:18, s10:19, s10:20, s10:21, s10:22, s10:23, s10:24 ],
    [ s10:25, s10:26, s10:27, s10:28, s10:29, s10:30, s10:31, s10:32 ],
    [ s10:33, s10:34, s10:35, s10:36, s10:37, s10:38, s10:39, s10:40 ],
    [ s10:41, s10:42, s10:43, s10:44, s10:45, s10:46, s10:47, s10:48 ],
    [ s10:49, s10:50, s10:51, s10:52, s10:53, s10:54, s10:55, s10:56 ],
    [ s10:57, s10:58, s10:59, s10:60, s10:61, s10:62, s10:63, s10:64 ]
  ];
  let result = Zigzag_reorder(matrix, true);
  //trace!(result);

  // 期待される結果（実行結果は以下の通り）
  let expected: s10[64] = [
    s10:1,  s10:2,  s10:9,  s10:17, s10:10, s10:3,  s10:4,  s10:11,
    s10:18, s10:25, s10:33, s10:26, s10:19, s10:12, s10:5,  s10:6,
    s10:13, s10:20, s10:27, s10:34, s10:41, s10:49, s10:42, s10:35,
    s10:28, s10:21, s10:14, s10:7,  s10:8,  s10:15, s10:22, s10:29,
    s10:36, s10:43, s10:50, s10:57, s10:58, s10:51, s10:44, s10:37,
    s10:30, s10:23, s10:16, s10:24, s10:31, s10:38, s10:45, s10:52,
    s10:59, s10:60, s10:53, s10:46, s10:39, s10:32, s10:40, s10:47,
    s10:54, s10:61, s10:62, s10:55, s10:48, s10:56, s10:63, s10:64
  ];

  // 結果が期待値と一致することを検証する
  assert_eq(result, expected);
}

#[test]
fn test1_zigzag_reorder() {
  let matrix: s10[8][8] = [
    [ s10:1,  s10:2,  s10:3,  s10:4,  s10:5,  s10:6,  s10:7,  s10:8 ],
    [ s10:9,  s10:10, s10:11, s10:12, s10:13, s10:14, s10:15, s10:16 ],
    [ s10:17, s10:18, s10:19, s10:20, s10:21, s10:22, s10:23, s10:24 ],
    [ s10:25, s10:26, s10:27, s10:28, s10:29, s10:30, s10:31, s10:32 ],
    [ s10:33, s10:34, s10:35, s10:36, s10:37, s10:38, s10:39, s10:40 ],
    [ s10:41, s10:42, s10:43, s10:44, s10:45, s10:46, s10:47, s10:48 ],
    [ s10:49, s10:50, s10:51, s10:52, s10:53, s10:54, s10:55, s10:56 ],
    [ s10:57, s10:58, s10:59, s10:60, s10:61, s10:62, s10:63, s10:64 ]
  ];
  let result = Zigzag_reorder(matrix, false);
  //trace!(result);

  // 期待される結果（実行結果は以下の通り）
  let expected: s10[64] = [
    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,
    s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0,  s10:0
  ];

  // 結果が期待値と一致することを検証する
  assert_eq(result, expected);
}