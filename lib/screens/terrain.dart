import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/utils.dart';

class TerrainPage extends StatefulWidget {
  const TerrainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TerrainPage> createState() => _MyTerrainPage();
}

class _MyTerrainPage extends State<TerrainPage> {
  double rowsNumber = 5;
  var matrix;
  int numberOfIslands = 0;

  initState() {
    createMatrix();
  }

  createMatrix() {
    matrix = createWholeMatrix(rowsNumber.floor());
    numberOfIslands = getNumberOfIsland(matrix);
  }

  List<TableRow> getTable(matrix) {
    var table = matrix.asMap().entries.map<TableRow>((row) {
      int i = row.key;
      return TableRow(
          children: row.value.asMap().entries.map<Widget>((v) {
        int j = v.key;
        return getBlock(i, j, matrix);
      }).toList());
    }).toList();
    return table;
  }

  Widget getBlock(i, j, matrix) {
    return InkWell(
      onTap: () => changeState(i, j),
      child: Container(
        width: 350 / matrix.length,
        height: 350 / matrix.length,
        color: matrix[i][j] == 0 ? Colors.blue : Colors.green,
        alignment: Alignment.center,
        child: Text(matrix[i][j].toString()),
      ),
    );
  }

  changeState(i, j) {
    setState(() {
      matrix[i][j] = matrix[i][j] == 1 ? 0 : 1;
      numberOfIslands = getNumberOfIsland(matrix);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                    child: const Text('Tap on any tile to change state',
                        style: TextStyle(fontSize: 18))),
                const Divider(
                  color: Colors.transparent,
                ),
                matrix == null
                    ? const Placeholder()
                    : Table(
                        border: TableBorder.all(color: Colors.black12),
                        children: getTable(matrix),
                      ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Number Of Islands: $numberOfIslands'),
                ),
                Slider(
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: "$rowsNumber",
                  value: rowsNumber,
                  onChanged: (double value) {
                    setState(() {
                      rowsNumber = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text('Number of Rows: $rowsNumber'),
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() {
                      createMatrix();
                    }),
                    label: Text(
                      'Create Terrain',
                    ),
                    icon: Icon(Icons.create),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
