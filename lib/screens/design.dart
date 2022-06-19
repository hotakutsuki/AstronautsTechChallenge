import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Design extends StatefulWidget {
  const Design({Key? key}) : super(key: key);

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {
  List<String> _chips = [];
  List<bool> _selectedChips = [];

  initState() {
    _chips = [
      'All',
      'Happy hours',
      'Drinks',
      'Beer',
      'cocktails',
      'Wine',
      'Extras'
    ];
    _selectedChips = List.generate(_chips.length, (i) => i == 1);
  }

  Widget appBarButtons(icon, [color]) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(0, 3),
              color: Colors.black54,
            )
          ]),
      child: IconButton(
          onPressed: () => {},
          icon: Icon(
            icon,
            color: color ?? Colors.grey,
          )),
    );
  }

  Widget opChip(text, i) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ChoiceChip(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          labelPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          elevation: 5,
          backgroundColor: Colors.white,
          selectedColor: Colors.orange,
          label: Text(text),
          selected: _selectedChips[i],
          onSelected: (v) {
            setState(() {
              _selectedChips[i] = v;
            });
          }),
    );
  }

  getGiphyData(query) async {
    var uQuery = "&q=%22a$query%22";
    var endpoint = "https://api.giphy.com/v1/gifs/search?";
    var apikey = "&api_key=0Nmt3jP2pZpCz02XOgJJoLC0kyHxqDO0";
    var url = endpoint + uQuery + apikey;
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    }
  }

  List<Widget> getImagesAsWidgets(Map<dynamic, dynamic> myData) {
    var widgets = myData['data'].map<Widget>((imageObj) => Column(
          children: [
            Divider(color: Colors.transparent),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                height: 150,
                color: const Color.fromARGB(10, 0, 0, 0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.more_horiz),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 105,
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: FadeInImage(
                                width: 150,
                                height: 85,
                                fit: BoxFit.cover,
                                image: NetworkImage(imageObj['images']
                                        ['downsized']['url']
                                    .toString()),
                                placeholder: const AssetImage(
                                    'assets/images/placeholder.png'),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 55,
                                child: appBarButtons(
                                    CupertinoIcons.suit_heart_fill,
                                    Colors.orange)),
                          ]),
                        ),
                        SizedBox(
                          width: 180,
                          child: Text(
                            imageObj['title'],
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
    return widgets.toList().sublist(0, 4);
  }

  List<Widget> getImagesOfTheme(theme) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(theme,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          appBarButtons(Icons.delete_outline, Colors.black87)
        ],
      ),
      FutureBuilder(
          future: getGiphyData(theme),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<dynamic, dynamic> mydata = snapshot.data as Map;
              return Column(
                children: getImagesAsWidgets(mydata),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })
    ];
  }

  List<Widget> getSelectedChipsQuery() {
    List<Widget> result = [];
    _selectedChips.asMap().entries.map((e) {
      int i = e.key;
      if (e.value) {
        result.addAll(getImagesOfTheme(_chips[i]));
      }
    }).toList();
    if (result.isEmpty) {
      return [const Center(
        child: Text('Select one chip'),
      )];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          appBarButtons(CupertinoIcons.bell),
          appBarButtons(Icons.settings)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(CupertinoIcons.home, color: Colors.grey)),
          BottomNavigationBarItem(
              label: 'Calendar',
              icon: Icon(CupertinoIcons.calendar, color: Colors.grey)),
          BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(CupertinoIcons.search, color: Colors.grey)),
          BottomNavigationBarItem(
              label: 'Favorites',
              icon: Icon(CupertinoIcons.heart, color: Colors.grey)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Favorites',
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                appBarButtons(Icons.add, Colors.black87)
              ],
            ),
            Container(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _chips.asMap().entries.map<Widget>((c) {
                  return opChip(c.value, c.key);
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView(
                children: getSelectedChipsQuery(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
