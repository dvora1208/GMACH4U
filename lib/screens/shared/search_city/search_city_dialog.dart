import 'package:flutter/material.dart';
import 'package:gmach1/utils/location_helper.dart';

class SearchCityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SearchList();
}

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();

  List<City> _cities;
  String _searchText = "";

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _cities = LocationHelper().cities;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<ChildItem> items = _buildSearchList();
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      appBar: buildBar(context),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return items[index];
        },
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      ),
    );
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _cities == null
          ? <ChildItem>[]
          : _cities
          .map((city) => ChildItem(city, _cities.indexOf(city), _cities))
          .toList();
    } else {
      List<City> _searchList = List();
      for (int i = 0; i < _cities.length; i++) {
        City city = _cities.elementAt(i);
        if (city.name.toLowerCase().contains(_searchText.toLowerCase()) ||
            city.englishName
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
          _searchList.add(city);
        }
      }
      return _searchList
          .map((city) => ChildItem(city, _cities.indexOf(city), _cities))
          .toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // status bar color
      brightness: Brightness.light,
      // status bar brightness
//      backgroundColor: Colors.white,
      title: TextField(
        controller: _searchQuery,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixStyle: null,
            hintText: "Type a city's name",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18)),
      ),
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      actions: <Widget>[
        if (_searchText.isNotEmpty)
          IconButton(
            icon: Icon(Icons.close),
            tooltip: "delete",
            onPressed: () {
              setState(() {
                _searchQuery.text = "";
              });
            },
          ),
      ],
    );
  }
}

class ChildItem extends StatelessWidget {
  final City city;
  final int id;
  final List<City> cities;

  ChildItem(this.city, this.id, this.cities);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.white,
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "${city == null ? '' :  city.englishName}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context, cities[id]);
              },
            ),
          ),
        ],
      ),
    );
  }
}