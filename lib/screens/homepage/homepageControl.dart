import 'package:flutter/material.dart';
import 'package:rfid/config/appConstants.dart';
import 'package:rfid/screens/reportpage/reportScreen.dart';
import 'package:rfid/screens/scan/scanScreen.dart';
import 'package:rfid/screens/scan/tableViewScan.dart';

class HomePageControl extends StatefulWidget {
  const HomePageControl({super.key});

  @override
  State<HomePageControl> createState() => _HomePageControlState();
}

class _HomePageControlState extends State<HomePageControl> {
  List<tempRfidItemList> sendValue = [];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ScanScreen(
        onChange: (value) {
          setState(() {
            sendValue = value;
          });
        },
        receiveValue: sendValue,
      ),
      ReportScreen(
        receiveValue: sendValue,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text(
          'RFID APP',
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Import',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[700],
        onTap: _onItemTapped,
      ),
    );
  }
}
