import 'package:drift/drift.dart';
import 'package:rfid/database/database.dart';

class Master_rfid extends Table {
  IntColumn get key_id => integer().autoIncrement()();
  TextColumn get rfid_tag => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get rssi => text().nullable()();
  DateTimeColumn get created_at => dateTime().nullable()();
  DateTimeColumn get updated_at => dateTime().nullable()();
}

class Tag_Running_Rfid extends Table {
  IntColumn get key_id => integer().autoIncrement()();
  TextColumn get rfid_tag => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get rssi => text().nullable()();
  DateTimeColumn get created_at => dateTime().nullable()();
  DateTimeColumn get updated_at => dateTime().nullable()();
}

class TempMasterRfid extends Table {
  IntColumn get key_id => integer().autoIncrement()();
  TextColumn get rfid_tag => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get rssi => text().nullable()();
  DateTimeColumn get created_at => dateTime().nullable()();
  DateTimeColumn get updated_at => dateTime().nullable()();
}

// // This will make drift generate a class called "Category" to represent a row in
// // this table. By default, "Categorie" would have been used because it only
// //strips away the trailing "s" in the table name.
// @DataClassName('Category')
// class Categories extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get description => text()();
// }
abstract class ViewTempMaster extends View {
  TempMasterRfid get master_rfid;

  @override
  Query as() => select([
        master_rfid.key_id,
        master_rfid.rfid_tag,
        master_rfid.status,
        master_rfid.rssi,
      ]).from(master_rfid);
}

abstract class ViewMaster extends View {
  Master_rfid get master_rfid;

  @override
  Query as() => select([
        master_rfid.key_id,
        master_rfid.rfid_tag,
        master_rfid.status,
        master_rfid.rssi,
      ]).from(master_rfid);
}

abstract class ViewDetail extends View {
  Tag_Running_Rfid get tag;

  @override
  Query as() => select([
        tag.key_id,
        tag.rfid_tag,
        tag.status,
        tag.rssi,
      ]).from(tag);
}


// // this annotation tells drift to prepare a database class that uses both of the
// // tables we just defined. We'll see how to use that database class in a moment.
// @DriftDatabase(tables: [Serials,], views: [SerialsView])
// class AppDb extends _$AppDb {
//   AppDb(QueryExecutor e): super(e);
//
//   @override
//   int get schemaVersion => 1;
// }
