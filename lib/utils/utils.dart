import 'dart:math';

createWholeMatrix(int dimention) {
  int row = dimention;
  int col = dimention;

  var matrix = List.generate(
    row,
    (i) => List.generate(col, (i) => getRandomIO()),
  );

  printMatrix(matrix);
  return matrix;
}

getRandomIO() {
  var rnd = Random();
  return rnd.nextInt(2);
}

void printMatrix(var matrix) {
  print('matrix:');
  for (var row in matrix) {
    String sRow = '';
    for (var v in row) {
      String s = v == 1 ? "\x1B[32m1\x1B[0m" : "\x1B[36m0\x1B[0m";
      sRow = sRow + s;
    }
    print(sRow);
  }
}

int getNumberOfIsland(var matrix) {
  int numberOfIslands = 0;

  var booleanMatrix = List.generate(
    matrix.length,
    (i) => List.generate(matrix.length, (i) => 0),
  );
  for (int j = 0; j < matrix.length; j++) {
    for (int i = 0; i < matrix[j].length; i++) {
      if (matrix[j][i] == 1 && booleanMatrix[j][i] == 0) {
        //new island
        numberOfIslands++;
        booleanMatrix = setIslandInTrue(i, j, booleanMatrix, matrix);
      }
    }
  }
  print('number of islands: ' + numberOfIslands.toString());
  return numberOfIslands;
}

setIslandInTrue(i, j, matrix, orgMatrix) {
  matrix[j][i] = 1;
  if (i + 1 < matrix.length &&
      matrix[j][i + 1] != 1 &&
      orgMatrix[j][i + 1] == 1) {
    matrix = setIslandInTrue(i + 1, j, matrix, orgMatrix);
  }
  if (i - 1 >= 0 && matrix[j][i - 1] != 1 && orgMatrix[j][i - 1] == 1) {
    matrix = setIslandInTrue(i - 1, j, matrix, orgMatrix);
  }
  if (j + 1 < matrix[i].length &&
      matrix[j + 1][i] != 1 &&
      orgMatrix[j + 1][i] == 1) {
    matrix = setIslandInTrue(i, j + 1, matrix, orgMatrix);
  }
  if (j - 1 >= 0 && matrix[j - 1][i] != 1 && orgMatrix[j - 1][i] == 1) {
    matrix = setIslandInTrue(i, j - 1, matrix, orgMatrix);
  }
  return matrix;
}
