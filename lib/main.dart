import 'package:flutter/material.dart';
import 'package:test/screens/design.dart';
import 'package:test/screens/terrain.dart';
import 'package:test/widgets/RaisedGradientButton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Astronauts test',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // home: const Design(),
      home: const MyHomePage(title: 'Terrain Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            children: [
              SizedBox(
                width: 200,
                child: RaisedGradientButton(
                  child: const Text(
                    'Terrain',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const TerrainPage(title: 'Terrain')),
                  ),
                  gradient:
                      const LinearGradient(colors: [Colors.green, Colors.blue]),
                  key: const Key('terrain'),
                ),
              ),
              const Divider(height: 20, color: Colors.transparent),
              SizedBox(
                width: 200,
                child: RaisedGradientButton(
                  child: const Text(
                    'Design',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Design()),
                  ),
                  gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.redAccent]),
                  key: const Key('terrain'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
