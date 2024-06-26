import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../nativefunction/nativeFunction.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  dynamic currentPower;
  dynamic currentLength;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  @override
  void initState() {
    SDK_Function.getPower().then((value) {
      print(value);
      currentPower = value;
      setState(() {});
    });
    SDK_Function.getLengthASCII().then((value) {
      currentLength = value;
      setState(() {});
    });
    _initPackageInfo().then((value) {
      _packageInfo = value;
    });

    // TODO: implement initState
    super.initState();
  }

  Future _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onTap: () => modalPickerNumber(currentPower),
              controller: TextEditingController(text: "Power : $currentPower"),
              readOnly: true,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () => modalPickerNumber(currentPower),
                      icon: Icon(Icons.settings_applications)),
                  hintText: "Power : ${currentPower.toString()}",
                  labelText: "Set Power",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onTap: () => modalPickerNumberLength(currentLength),
              controller:
                  TextEditingController(text: "Power : $currentLength digits"),
              readOnly: true,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () => modalPickerNumberLength(currentLength),
                      icon: Icon(Icons.settings)),
                  hintText: "Length : ${currentPower.toString()} digits",
                  labelText: "Set Length ASCII",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onTap: () => modalPickerNumberLength(currentLength),
              controller: TextEditingController(
                  text: "Version : ${_packageInfo.version}"),
              readOnly: true,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.mobile_friendly),
                  labelText: "Version App",
                  border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  void modalPickerNumber(dynamic power) {
    // Mock data
    List<int> numbers = List<int>.generate(33, (i) => i + 1);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10, width: double.infinity),
              const Center(
                  child: Text(
                "Select Power",
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                "Current Power : $power",
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: numbers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Power : ${numbers[index]}'),
                      onTap: () async {
                        var result =
                            await SDK_Function.setPower(numbers[index]);
                        currentPower = numbers[index];
                        setState(() {});
                        EasyLoading.showSuccess(result);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void modalPickerNumberLength(dynamic length) {
    // Mock data
    List<int> numbers = List<int>.generate(33, (i) => i + 1);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10, width: double.infinity),
              const Center(
                  child: Text(
                "Select length",
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                "Current length : $length",
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: numbers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('length : ${numbers[index]}'),
                      onTap: () async {
                        var result =
                            await SDK_Function.setLengthASCII(numbers[index]);
                        currentLength = numbers[index];
                        setState(() {});
                        EasyLoading.showSuccess(result);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
