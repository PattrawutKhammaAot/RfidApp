import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rfid/config/appData.dart';
import 'package:rfid/main.dart';

import '../../app.dart';
import '../../nativefunction/nativeFunction.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  dynamic currentPower;
  dynamic currentLength;
  dynamic isScanHeader;
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
    SDK_Function.init().then((e) {
      SDK_Function.getPower().then((value) {
        if (value != 'Error' && value != null) {
          currentPower = value;
        } else {
          AppData.getPower().then((value) {
            if (value != null && value != '') {
              currentPower = value;
            }
          });
        }

        setState(() {});
      });
      SDK_Function.getLengthASCII().then((value) {
        currentLength = value;
        setState(() {});
      });
      SDK_Function.checkScanner().then((value) {
        isScanHeader = value;
        setState(() {});
      });

      _initPackageInfo().then((value) {
        _packageInfo = value;
      });
      AppData.setPopupInfo("page_settings");
    });

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
              onTap: () => modalSelectLang(currentPower),
              controller: TextEditingController(
                  text:
                      "${appLocalizations.txt_current_lang} : ${appLocalizations.current_lang}"),
              readOnly: true,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () => modalSelectLang(currentPower),
                      icon: Icon(Icons.language)),
                  labelText: appLocalizations.txt_select_lang_title,
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            currentPower != "Error" && currentPower != null
                ? TextFormField(
                    onTap: () => modalPickerNumber(currentPower),
                    controller: TextEditingController(
                        text: "${appLocalizations.txt_power} : $currentPower"),
                    readOnly: true,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () => modalPickerNumber(currentPower),
                            icon: Icon(Icons.settings_applications)),
                        hintText:
                            "${appLocalizations.txt_power} : ${currentPower.toString()}",
                        labelText: appLocalizations.btn_set_power,
                        border: OutlineInputBorder()),
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onTap: () => modalPickerNumberLength(currentLength),
              controller: TextEditingController(
                  text:
                      "${appLocalizations.txt_length_ASCII} : $currentLength ${appLocalizations.txt_unit}"),
              readOnly: true,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () => modalPickerNumberLength(currentLength),
                      icon: Icon(Icons.settings)),
                  hintText: "Length ${currentPower.toString()} digits",
                  labelText: appLocalizations.btn_set_length_ASCII,
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: TextEditingController(
                  text:
                      "${appLocalizations.txt_scanner} ${isScanHeader != null ? isScanHeader ? appLocalizations.status_scanner_on : appLocalizations.status_scanner_off : appLocalizations.no_data}"),
              readOnly: true,
              decoration: InputDecoration(
                  suffixIcon: isScanHeader != null
                      ? Switch(
                          value: isScanHeader,
                          onChanged: (value) async {
                            isScanHeader = value;
                            setState(() {});
                            if (isScanHeader) {
                              await SDK_Function.openScanner();
                            } else {
                              await SDK_Function.closeScanner();
                            }
                          })
                      : Icon(Icons.error),
                  labelText: appLocalizations.btn_swtich_scanner,
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: TextEditingController(
                  text: "Version : ${_packageInfo.version}"),
              readOnly: true,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.mobile_friendly),
                  labelText: "Version App",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void modalSelectLang(dynamic power) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10, width: double.infinity),
              Center(
                  child: Text(
                appLocalizations.txt_select_lang_title,
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                "${appLocalizations.txt_current_lang} : ${appLocalizations.current_lang}",
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    ListTile(
                      title: Text('English'),
                      onTap: () async {
                        AppView.of(context)?.setLocale(Locale('en'));
                        await AppData.setLocale('en');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('ภาษาไทย'),
                      onTap: () async {
                        AppView.of(context)?.setLocale(Locale('th'));
                        await AppData.setLocale('th');
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
              Center(
                  child: Text(
                appLocalizations.txt_select_power,
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                "${appLocalizations.txt_current_power} : $power",
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
                      title: Text(
                          '${appLocalizations.txt_length_power} : ${numbers[index]}'),
                      onTap: () async {
                        var result =
                            await SDK_Function.setPower(numbers[index]);
                        await AppData.setPower(numbers[index].toString());
                        currentPower = numbers[index];
                        setState(() {});
                        if (result == "Error") {
                          EasyLoading.show(
                              status: appLocalizations.txt_Initializing);
                          await SDK_Function.setPower(numbers[index]);
                          await Future.delayed(Duration(seconds: 3));
                          EasyLoading.showSuccess(
                              appLocalizations.txt_Initialized);
                        } else {
                          EasyLoading.showSuccess(
                              "${appLocalizations.txt_set_power_success} ${numbers[index]}");
                        }

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
              Center(
                  child: Text(
                appLocalizations.txt_select_digits,
                style: TextStyle(fontSize: 20),
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                "${appLocalizations.txt_current_digits} : $length",
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
                      title: Text(
                          '${appLocalizations.txt_digits} : ${numbers[index]}'),
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
