import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

// These imports are used to open the database
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../blocs/scanrfid/models/ScanRfidCodeModel.dart';
import '../blocs/scanrfid/models/importRfidCodeModel.dart';
import '../screens/reportpage/model/import_txt.dart';
import 'table.dart';

part 'database.g.dart';

// @DriftDatabase(
//   // relative import for the drift file. Drift also supports `package:`
//   // imports
//   include: {'tables.drift'},
// )
// class AppDb extends _$AppDb {
//   AppDb() : super(_openConnection());
//
//   @override
//   int get schemaVersion => 1;
// }

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(
    tables: [Master_rfid, Tag_Running_Rfid], views: [ViewDetail, ViewMaster])
class AppDb extends _$AppDb {
  // AppDb(super.e);

  // we tell the database where to store the data with this constructor
  AppDb() : super(_openConnection());

  // AppDb(QueryExecutor e): super(e);
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
      beforeOpen: (details) async {
        // // your existing beforeOpen callback, enable foreign keys, etc.
        // if (kDebugMode) {
        //   // This check pulls in a fair amount of code that's not needed
        //   // anywhere else, so we recommend only doing it in debug builds.
        //   await validateDatabaseSchema();
        // }
      },
    );
  }

  //#region ************************** MASTER *******************************

  Future<List<Master_rfidData>> serach_master(String s) async {
    if (s.isEmpty) {
      return (select(masterRfid)).get();
    } else {
      return (select(masterRfid)..where((tbl) => tbl.rfid_tag.like('%$s%')))
          .get();
    }
  }

  // import master
  Future<bool> importMasterWithTxt(List<ImportRfidCodeModel> model) async {
    try {
      if (model.isNotEmpty) {
        await delete(masterRfid).go();
        for (var item in model) {
          await into(masterRfid).insert(Master_rfidCompanion(
            rfid_tag: Value(item.rfidTag),
            status: Value(null),
            created_at: Value(DateTime.now()),
            updated_at: Value(DateTime.now()),
          ));
        }
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      print("$e$s");
      return false;
    }
  }

  Future<bool> editMaster(Master_rfidData model) async {
    try {
      var result = await (select(masterRfid)
            ..where((tbl) => tbl.key_id.equals(model.key_id)))
          .get();
      final Master_rfidData? entries = result.isNotEmpty ? result.first : null;

      if (entries != null) {
        await update(masterRfid).replace(Master_rfidCompanion(
          key_id: Value(model.key_id),
          rfid_tag: Value(model.rfid_tag),
          status: Value(entries.status),
          created_at: Value(entries.created_at),
          updated_at: Value(DateTime.now()),
        ));
        return true;
      }
      return false;
    } catch (e, s) {
      print("$e$s");
      return false;
    }
  }

  Future<bool> scanImportMaster(ImportRfidCodeModel model) async {
    try {
      var result = await (select(masterRfid)
            ..where((tbl) => tbl.rfid_tag.equals(model.rfidTag!.trim())))
          .get();
      final Master_rfidData? entries = result.isNotEmpty ? result.first : null;

      print("Test: $entries");
      if (entries == null) {
        await into(masterRfid).insert(Master_rfidCompanion(
          rfid_tag: Value(model.rfidTag),
          status: Value(null),
          created_at: Value(DateTime.now()),
          updated_at: Value(null),
        ));
        return true;
      }
      return false;
    } catch (e, s) {
      print("$e$s");
      return false;
    }
  }

  Future<bool> deleteMaster(int s) async {
    // Execute the query to check if the entry exists
    var query =
        await (select(masterRfid)..where((tbl) => tbl.key_id.equals(s))).get();
    print("query: $query");

    final Master_rfidData? entries = query.isNotEmpty ? query.first : null;

    // Check if the result is not empty
    if (entries != null) {
      // If not empty, proceed to delete
      return (delete(masterRfid)..where((tbl) => tbl.key_id.equals(s)))
          .go()
          .then((value) => value == 1); // Returns true if one row is affected
    } else {
      print("Empty");
      // If empty, return false indicating no deletion happened
      return Future.value(false);
    }
  }

  Future<void> updateMaster() async {
    try {
      var tag_running = await (select(tagRunningRfid)
            ..where((filter) => filter.status.equals("Found")))
          .get();

      if (tag_running.isNotEmpty) {
        for (var item in tag_running) {
          // Assuming `masterRfid` has a method `update` and a `status` field to update.
          // Also assuming `item.rfid_tag` is the correct way to access the RFID tag of the item.
          await (update(masterRfid)
                ..where((t) => t.rfid_tag.equals(item.rfid_tag!)))
              .write(
            Master_rfidCompanion(
              updated_at: Value(DateTime.now()),
              status: Value("Found"), // Example field to update
            ),
          );
        }
      }
    } catch (e, s) {
      print("$e$s");
    }
  }

  Future<List<Master_rfidData>> getMasterAll() async {
    await updateMaster();
    return await (select(masterRfid)).get();
  }

  //#region ************************** SUB_MATER *******************************
  Future<bool> scan_Rfid_Code(ScanRfidCodeModel req) async {
    try {
      var resultRunning = await (select(tagRunningRfid)
            ..where((tbl) => tbl.rfid_tag.equals(req.rfidNumber!.trim())))
          .get();

      final Tag_Running_RfidData? dto =
          resultRunning.isNotEmpty ? resultRunning.first : null;

      if (dto != null) {
        if (dto.status == "Not Found" && req.statusRunning == "Found") {
          await update(tagRunningRfid).replace(Tag_Running_RfidCompanion(
            key_id: Value(dto.key_id),
            rfid_tag: Value(req.rfidNumber),
            status: Value(req.statusRunning),
            rssi: Value(req.rssi),
            created_at: Value(dto.created_at),
            updated_at: Value(DateTime.now()),
          ));
          return true;
        } else if (dto.status == "Found" && req.statusRunning == "Found") {
          await update(tagRunningRfid).replace(Tag_Running_RfidCompanion(
            key_id: Value(dto.key_id),
            rssi: Value(req.rssi),
            updated_at: Value(DateTime.now()),
          ));
          return true;
        }
      } else {
        await into(tagRunningRfid).insert(Tag_Running_RfidCompanion(
          rfid_tag: Value(req.rfidNumber),
          status: Value(req.statusRunning),
          rssi: Value(req.rssi),
          created_at: Value(DateTime.now()),
          updated_at: Value(DateTime.now()),
        ));
        return true;
      }
      return false;
    } catch (e, s) {
      print("$e$s");
      return false;
    }
  }

  Future<List<Tag_Running_RfidData>> search_tag_rfid(String s) async {
    if (s.isEmpty) {
      return (select(tagRunningRfid)).get();
    } else {
      return (select(tagRunningRfid)..where((tbl) => tbl.rfid_tag.like('%$s%')))
          .get();
    }
  }

  Future<bool> deleteRunningRfid(int id) async {
    return (delete(tagRunningRfid)..where((tbl) => tbl.key_id.equals(id)))
        .go()
        .then((value) => value == 1);
  }

  //#region ************************** REPORT *******************************
  Future<int> totalMaster() async {
    // สร้าง query ที่นับจำนวนแถวทั้งหมดในตาราง masterRfid
    var query = selectOnly(masterRfid)
      ..addColumns([
        masterRfid.key_id.count()
      ]); // ใช้ id หรือคอลัมน์อื่นๆ ในตารางเพื่อนับ
    var result = await query.getSingle();
    return result.read(masterRfid.key_id.count()) ?? 0;
  }

  Future<int> totalFilter(String s) async {
    print(s);
    try {
      return (select(tagRunningRfid)..where((tbl) => tbl.status.equals(s)))
          .get()
          .then((value) => value.length);
    } catch (e, s) {
      print("$e$s");
      throw Exception();
    }
  }

//#endregion *********************************************************//
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
