// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $Master_rfidTable extends Master_rfid
    with TableInfo<$Master_rfidTable, Master_rfidData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $Master_rfidTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _key_idMeta = const VerificationMeta('key_id');
  @override
  late final GeneratedColumn<int> key_id = GeneratedColumn<int>(
      'key_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _rfid_tagMeta =
      const VerificationMeta('rfid_tag');
  @override
  late final GeneratedColumn<String> rfid_tag = GeneratedColumn<String>(
      'rfid_tag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rssiMeta = const VerificationMeta('rssi');
  @override
  late final GeneratedColumn<String> rssi = GeneratedColumn<String>(
      'rssi', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _created_atMeta =
      const VerificationMeta('created_at');
  @override
  late final GeneratedColumn<DateTime> created_at = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updated_atMeta =
      const VerificationMeta('updated_at');
  @override
  late final GeneratedColumn<DateTime> updated_at = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [key_id, rfid_tag, status, rssi, created_at, updated_at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'master_rfid';
  @override
  VerificationContext validateIntegrity(Insertable<Master_rfidData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key_id')) {
      context.handle(_key_idMeta,
          key_id.isAcceptableOrUnknown(data['key_id']!, _key_idMeta));
    }
    if (data.containsKey('rfid_tag')) {
      context.handle(_rfid_tagMeta,
          rfid_tag.isAcceptableOrUnknown(data['rfid_tag']!, _rfid_tagMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('rssi')) {
      context.handle(
          _rssiMeta, rssi.isAcceptableOrUnknown(data['rssi']!, _rssiMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at']!, _created_atMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
          _updated_atMeta,
          updated_at.isAcceptableOrUnknown(
              data['updated_at']!, _updated_atMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key_id};
  @override
  Master_rfidData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Master_rfidData(
      key_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key_id'])!,
      rfid_tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rfid_tag']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      rssi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rssi']),
      created_at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updated_at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $Master_rfidTable createAlias(String alias) {
    return $Master_rfidTable(attachedDatabase, alias);
  }
}

class Master_rfidData extends DataClass implements Insertable<Master_rfidData> {
  final int key_id;
  final String? rfid_tag;
  final String? status;
  final String? rssi;
  final DateTime? created_at;
  final DateTime? updated_at;
  const Master_rfidData(
      {required this.key_id,
      this.rfid_tag,
      this.status,
      this.rssi,
      this.created_at,
      this.updated_at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key_id'] = Variable<int>(key_id);
    if (!nullToAbsent || rfid_tag != null) {
      map['rfid_tag'] = Variable<String>(rfid_tag);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || rssi != null) {
      map['rssi'] = Variable<String>(rssi);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || updated_at != null) {
      map['updated_at'] = Variable<DateTime>(updated_at);
    }
    return map;
  }

  Master_rfidCompanion toCompanion(bool nullToAbsent) {
    return Master_rfidCompanion(
      key_id: Value(key_id),
      rfid_tag: rfid_tag == null && nullToAbsent
          ? const Value.absent()
          : Value(rfid_tag),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      rssi: rssi == null && nullToAbsent ? const Value.absent() : Value(rssi),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      updated_at: updated_at == null && nullToAbsent
          ? const Value.absent()
          : Value(updated_at),
    );
  }

  factory Master_rfidData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Master_rfidData(
      key_id: serializer.fromJson<int>(json['key_id']),
      rfid_tag: serializer.fromJson<String?>(json['rfid_tag']),
      status: serializer.fromJson<String?>(json['status']),
      rssi: serializer.fromJson<String?>(json['rssi']),
      created_at: serializer.fromJson<DateTime?>(json['created_at']),
      updated_at: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key_id': serializer.toJson<int>(key_id),
      'rfid_tag': serializer.toJson<String?>(rfid_tag),
      'status': serializer.toJson<String?>(status),
      'rssi': serializer.toJson<String?>(rssi),
      'created_at': serializer.toJson<DateTime?>(created_at),
      'updated_at': serializer.toJson<DateTime?>(updated_at),
    };
  }

  Master_rfidData copyWith(
          {int? key_id,
          Value<String?> rfid_tag = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> rssi = const Value.absent(),
          Value<DateTime?> created_at = const Value.absent(),
          Value<DateTime?> updated_at = const Value.absent()}) =>
      Master_rfidData(
        key_id: key_id ?? this.key_id,
        rfid_tag: rfid_tag.present ? rfid_tag.value : this.rfid_tag,
        status: status.present ? status.value : this.status,
        rssi: rssi.present ? rssi.value : this.rssi,
        created_at: created_at.present ? created_at.value : this.created_at,
        updated_at: updated_at.present ? updated_at.value : this.updated_at,
      );
  Master_rfidData copyWithCompanion(Master_rfidCompanion data) {
    return Master_rfidData(
      key_id: data.key_id.present ? data.key_id.value : this.key_id,
      rfid_tag: data.rfid_tag.present ? data.rfid_tag.value : this.rfid_tag,
      status: data.status.present ? data.status.value : this.status,
      rssi: data.rssi.present ? data.rssi.value : this.rssi,
      created_at:
          data.created_at.present ? data.created_at.value : this.created_at,
      updated_at:
          data.updated_at.present ? data.updated_at.value : this.updated_at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Master_rfidData(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi, ')
          ..write('created_at: $created_at, ')
          ..write('updated_at: $updated_at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key_id, rfid_tag, status, rssi, created_at, updated_at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Master_rfidData &&
          other.key_id == this.key_id &&
          other.rfid_tag == this.rfid_tag &&
          other.status == this.status &&
          other.rssi == this.rssi &&
          other.created_at == this.created_at &&
          other.updated_at == this.updated_at);
}

class Master_rfidCompanion extends UpdateCompanion<Master_rfidData> {
  final Value<int> key_id;
  final Value<String?> rfid_tag;
  final Value<String?> status;
  final Value<String?> rssi;
  final Value<DateTime?> created_at;
  final Value<DateTime?> updated_at;
  const Master_rfidCompanion({
    this.key_id = const Value.absent(),
    this.rfid_tag = const Value.absent(),
    this.status = const Value.absent(),
    this.rssi = const Value.absent(),
    this.created_at = const Value.absent(),
    this.updated_at = const Value.absent(),
  });
  Master_rfidCompanion.insert({
    this.key_id = const Value.absent(),
    this.rfid_tag = const Value.absent(),
    this.status = const Value.absent(),
    this.rssi = const Value.absent(),
    this.created_at = const Value.absent(),
    this.updated_at = const Value.absent(),
  });
  static Insertable<Master_rfidData> custom({
    Expression<int>? key_id,
    Expression<String>? rfid_tag,
    Expression<String>? status,
    Expression<String>? rssi,
    Expression<DateTime>? created_at,
    Expression<DateTime>? updated_at,
  }) {
    return RawValuesInsertable({
      if (key_id != null) 'key_id': key_id,
      if (rfid_tag != null) 'rfid_tag': rfid_tag,
      if (status != null) 'status': status,
      if (rssi != null) 'rssi': rssi,
      if (created_at != null) 'created_at': created_at,
      if (updated_at != null) 'updated_at': updated_at,
    });
  }

  Master_rfidCompanion copyWith(
      {Value<int>? key_id,
      Value<String?>? rfid_tag,
      Value<String?>? status,
      Value<String?>? rssi,
      Value<DateTime?>? created_at,
      Value<DateTime?>? updated_at}) {
    return Master_rfidCompanion(
      key_id: key_id ?? this.key_id,
      rfid_tag: rfid_tag ?? this.rfid_tag,
      status: status ?? this.status,
      rssi: rssi ?? this.rssi,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key_id.present) {
      map['key_id'] = Variable<int>(key_id.value);
    }
    if (rfid_tag.present) {
      map['rfid_tag'] = Variable<String>(rfid_tag.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rssi.present) {
      map['rssi'] = Variable<String>(rssi.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (updated_at.present) {
      map['updated_at'] = Variable<DateTime>(updated_at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('Master_rfidCompanion(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi, ')
          ..write('created_at: $created_at, ')
          ..write('updated_at: $updated_at')
          ..write(')'))
        .toString();
  }
}

class $Tag_Running_RfidTable extends Tag_Running_Rfid
    with TableInfo<$Tag_Running_RfidTable, Tag_Running_RfidData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $Tag_Running_RfidTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _key_idMeta = const VerificationMeta('key_id');
  @override
  late final GeneratedColumn<int> key_id = GeneratedColumn<int>(
      'key_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _rfid_tagMeta =
      const VerificationMeta('rfid_tag');
  @override
  late final GeneratedColumn<String> rfid_tag = GeneratedColumn<String>(
      'rfid_tag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rssiMeta = const VerificationMeta('rssi');
  @override
  late final GeneratedColumn<String> rssi = GeneratedColumn<String>(
      'rssi', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _created_atMeta =
      const VerificationMeta('created_at');
  @override
  late final GeneratedColumn<DateTime> created_at = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updated_atMeta =
      const VerificationMeta('updated_at');
  @override
  late final GeneratedColumn<DateTime> updated_at = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [key_id, rfid_tag, status, rssi, created_at, updated_at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_running_rfid';
  @override
  VerificationContext validateIntegrity(
      Insertable<Tag_Running_RfidData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key_id')) {
      context.handle(_key_idMeta,
          key_id.isAcceptableOrUnknown(data['key_id']!, _key_idMeta));
    }
    if (data.containsKey('rfid_tag')) {
      context.handle(_rfid_tagMeta,
          rfid_tag.isAcceptableOrUnknown(data['rfid_tag']!, _rfid_tagMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('rssi')) {
      context.handle(
          _rssiMeta, rssi.isAcceptableOrUnknown(data['rssi']!, _rssiMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at']!, _created_atMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
          _updated_atMeta,
          updated_at.isAcceptableOrUnknown(
              data['updated_at']!, _updated_atMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key_id};
  @override
  Tag_Running_RfidData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag_Running_RfidData(
      key_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key_id'])!,
      rfid_tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rfid_tag']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      rssi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rssi']),
      created_at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updated_at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $Tag_Running_RfidTable createAlias(String alias) {
    return $Tag_Running_RfidTable(attachedDatabase, alias);
  }
}

class Tag_Running_RfidData extends DataClass
    implements Insertable<Tag_Running_RfidData> {
  final int key_id;
  final String? rfid_tag;
  final String? status;
  final String? rssi;
  final DateTime? created_at;
  final DateTime? updated_at;
  const Tag_Running_RfidData(
      {required this.key_id,
      this.rfid_tag,
      this.status,
      this.rssi,
      this.created_at,
      this.updated_at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key_id'] = Variable<int>(key_id);
    if (!nullToAbsent || rfid_tag != null) {
      map['rfid_tag'] = Variable<String>(rfid_tag);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || rssi != null) {
      map['rssi'] = Variable<String>(rssi);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || updated_at != null) {
      map['updated_at'] = Variable<DateTime>(updated_at);
    }
    return map;
  }

  Tag_Running_RfidCompanion toCompanion(bool nullToAbsent) {
    return Tag_Running_RfidCompanion(
      key_id: Value(key_id),
      rfid_tag: rfid_tag == null && nullToAbsent
          ? const Value.absent()
          : Value(rfid_tag),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      rssi: rssi == null && nullToAbsent ? const Value.absent() : Value(rssi),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      updated_at: updated_at == null && nullToAbsent
          ? const Value.absent()
          : Value(updated_at),
    );
  }

  factory Tag_Running_RfidData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag_Running_RfidData(
      key_id: serializer.fromJson<int>(json['key_id']),
      rfid_tag: serializer.fromJson<String?>(json['rfid_tag']),
      status: serializer.fromJson<String?>(json['status']),
      rssi: serializer.fromJson<String?>(json['rssi']),
      created_at: serializer.fromJson<DateTime?>(json['created_at']),
      updated_at: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key_id': serializer.toJson<int>(key_id),
      'rfid_tag': serializer.toJson<String?>(rfid_tag),
      'status': serializer.toJson<String?>(status),
      'rssi': serializer.toJson<String?>(rssi),
      'created_at': serializer.toJson<DateTime?>(created_at),
      'updated_at': serializer.toJson<DateTime?>(updated_at),
    };
  }

  Tag_Running_RfidData copyWith(
          {int? key_id,
          Value<String?> rfid_tag = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> rssi = const Value.absent(),
          Value<DateTime?> created_at = const Value.absent(),
          Value<DateTime?> updated_at = const Value.absent()}) =>
      Tag_Running_RfidData(
        key_id: key_id ?? this.key_id,
        rfid_tag: rfid_tag.present ? rfid_tag.value : this.rfid_tag,
        status: status.present ? status.value : this.status,
        rssi: rssi.present ? rssi.value : this.rssi,
        created_at: created_at.present ? created_at.value : this.created_at,
        updated_at: updated_at.present ? updated_at.value : this.updated_at,
      );
  Tag_Running_RfidData copyWithCompanion(Tag_Running_RfidCompanion data) {
    return Tag_Running_RfidData(
      key_id: data.key_id.present ? data.key_id.value : this.key_id,
      rfid_tag: data.rfid_tag.present ? data.rfid_tag.value : this.rfid_tag,
      status: data.status.present ? data.status.value : this.status,
      rssi: data.rssi.present ? data.rssi.value : this.rssi,
      created_at:
          data.created_at.present ? data.created_at.value : this.created_at,
      updated_at:
          data.updated_at.present ? data.updated_at.value : this.updated_at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag_Running_RfidData(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi, ')
          ..write('created_at: $created_at, ')
          ..write('updated_at: $updated_at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key_id, rfid_tag, status, rssi, created_at, updated_at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag_Running_RfidData &&
          other.key_id == this.key_id &&
          other.rfid_tag == this.rfid_tag &&
          other.status == this.status &&
          other.rssi == this.rssi &&
          other.created_at == this.created_at &&
          other.updated_at == this.updated_at);
}

class Tag_Running_RfidCompanion extends UpdateCompanion<Tag_Running_RfidData> {
  final Value<int> key_id;
  final Value<String?> rfid_tag;
  final Value<String?> status;
  final Value<String?> rssi;
  final Value<DateTime?> created_at;
  final Value<DateTime?> updated_at;
  const Tag_Running_RfidCompanion({
    this.key_id = const Value.absent(),
    this.rfid_tag = const Value.absent(),
    this.status = const Value.absent(),
    this.rssi = const Value.absent(),
    this.created_at = const Value.absent(),
    this.updated_at = const Value.absent(),
  });
  Tag_Running_RfidCompanion.insert({
    this.key_id = const Value.absent(),
    this.rfid_tag = const Value.absent(),
    this.status = const Value.absent(),
    this.rssi = const Value.absent(),
    this.created_at = const Value.absent(),
    this.updated_at = const Value.absent(),
  });
  static Insertable<Tag_Running_RfidData> custom({
    Expression<int>? key_id,
    Expression<String>? rfid_tag,
    Expression<String>? status,
    Expression<String>? rssi,
    Expression<DateTime>? created_at,
    Expression<DateTime>? updated_at,
  }) {
    return RawValuesInsertable({
      if (key_id != null) 'key_id': key_id,
      if (rfid_tag != null) 'rfid_tag': rfid_tag,
      if (status != null) 'status': status,
      if (rssi != null) 'rssi': rssi,
      if (created_at != null) 'created_at': created_at,
      if (updated_at != null) 'updated_at': updated_at,
    });
  }

  Tag_Running_RfidCompanion copyWith(
      {Value<int>? key_id,
      Value<String?>? rfid_tag,
      Value<String?>? status,
      Value<String?>? rssi,
      Value<DateTime?>? created_at,
      Value<DateTime?>? updated_at}) {
    return Tag_Running_RfidCompanion(
      key_id: key_id ?? this.key_id,
      rfid_tag: rfid_tag ?? this.rfid_tag,
      status: status ?? this.status,
      rssi: rssi ?? this.rssi,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key_id.present) {
      map['key_id'] = Variable<int>(key_id.value);
    }
    if (rfid_tag.present) {
      map['rfid_tag'] = Variable<String>(rfid_tag.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rssi.present) {
      map['rssi'] = Variable<String>(rssi.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (updated_at.present) {
      map['updated_at'] = Variable<DateTime>(updated_at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('Tag_Running_RfidCompanion(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi, ')
          ..write('created_at: $created_at, ')
          ..write('updated_at: $updated_at')
          ..write(')'))
        .toString();
  }
}

class $TempMasterRfidTable extends TempMasterRfid
    with TableInfo<$TempMasterRfidTable, TempMasterRfidData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TempMasterRfidTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _key_idMeta = const VerificationMeta('key_id');
  @override
  late final GeneratedColumn<int> key_id = GeneratedColumn<int>(
      'key_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _rfid_tagMeta =
      const VerificationMeta('rfid_tag');
  @override
  late final GeneratedColumn<String> rfid_tag = GeneratedColumn<String>(
      'rfid_tag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rssiMeta = const VerificationMeta('rssi');
  @override
  late final GeneratedColumn<String> rssi = GeneratedColumn<String>(
      'rssi', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _created_atMeta =
      const VerificationMeta('created_at');
  @override
  late final GeneratedColumn<DateTime> created_at = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updated_atMeta =
      const VerificationMeta('updated_at');
  @override
  late final GeneratedColumn<DateTime> updated_at = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [key_id, rfid_tag, status, rssi, created_at, updated_at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temp_master_rfid';
  @override
  VerificationContext validateIntegrity(Insertable<TempMasterRfidData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key_id')) {
      context.handle(_key_idMeta,
          key_id.isAcceptableOrUnknown(data['key_id']!, _key_idMeta));
    }
    if (data.containsKey('rfid_tag')) {
      context.handle(_rfid_tagMeta,
          rfid_tag.isAcceptableOrUnknown(data['rfid_tag']!, _rfid_tagMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('rssi')) {
      context.handle(
          _rssiMeta, rssi.isAcceptableOrUnknown(data['rssi']!, _rssiMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _created_atMeta,
          created_at.isAcceptableOrUnknown(
              data['created_at']!, _created_atMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
          _updated_atMeta,
          updated_at.isAcceptableOrUnknown(
              data['updated_at']!, _updated_atMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key_id};
  @override
  TempMasterRfidData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TempMasterRfidData(
      key_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key_id'])!,
      rfid_tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rfid_tag']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      rssi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rssi']),
      created_at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updated_at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $TempMasterRfidTable createAlias(String alias) {
    return $TempMasterRfidTable(attachedDatabase, alias);
  }
}

class TempMasterRfidData extends DataClass
    implements Insertable<TempMasterRfidData> {
  final int key_id;
  final String? rfid_tag;
  final String? status;
  final String? rssi;
  final DateTime? created_at;
  final DateTime? updated_at;
  const TempMasterRfidData(
      {required this.key_id,
      this.rfid_tag,
      this.status,
      this.rssi,
      this.created_at,
      this.updated_at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key_id'] = Variable<int>(key_id);
    if (!nullToAbsent || rfid_tag != null) {
      map['rfid_tag'] = Variable<String>(rfid_tag);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || rssi != null) {
      map['rssi'] = Variable<String>(rssi);
    }
    if (!nullToAbsent || created_at != null) {
      map['created_at'] = Variable<DateTime>(created_at);
    }
    if (!nullToAbsent || updated_at != null) {
      map['updated_at'] = Variable<DateTime>(updated_at);
    }
    return map;
  }

  TempMasterRfidCompanion toCompanion(bool nullToAbsent) {
    return TempMasterRfidCompanion(
      key_id: Value(key_id),
      rfid_tag: rfid_tag == null && nullToAbsent
          ? const Value.absent()
          : Value(rfid_tag),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      rssi: rssi == null && nullToAbsent ? const Value.absent() : Value(rssi),
      created_at: created_at == null && nullToAbsent
          ? const Value.absent()
          : Value(created_at),
      updated_at: updated_at == null && nullToAbsent
          ? const Value.absent()
          : Value(updated_at),
    );
  }

  factory TempMasterRfidData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TempMasterRfidData(
      key_id: serializer.fromJson<int>(json['key_id']),
      rfid_tag: serializer.fromJson<String?>(json['rfid_tag']),
      status: serializer.fromJson<String?>(json['status']),
      rssi: serializer.fromJson<String?>(json['rssi']),
      created_at: serializer.fromJson<DateTime?>(json['created_at']),
      updated_at: serializer.fromJson<DateTime?>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key_id': serializer.toJson<int>(key_id),
      'rfid_tag': serializer.toJson<String?>(rfid_tag),
      'status': serializer.toJson<String?>(status),
      'rssi': serializer.toJson<String?>(rssi),
      'created_at': serializer.toJson<DateTime?>(created_at),
      'updated_at': serializer.toJson<DateTime?>(updated_at),
    };
  }

  TempMasterRfidData copyWith(
          {int? key_id,
          Value<String?> rfid_tag = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> rssi = const Value.absent(),
          Value<DateTime?> created_at = const Value.absent(),
          Value<DateTime?> updated_at = const Value.absent()}) =>
      TempMasterRfidData(
        key_id: key_id ?? this.key_id,
        rfid_tag: rfid_tag.present ? rfid_tag.value : this.rfid_tag,
        status: status.present ? status.value : this.status,
        rssi: rssi.present ? rssi.value : this.rssi,
        created_at: created_at.present ? created_at.value : this.created_at,
        updated_at: updated_at.present ? updated_at.value : this.updated_at,
      );
  TempMasterRfidData copyWithCompanion(TempMasterRfidCompanion data) {
    return TempMasterRfidData(
      key_id: data.key_id.present ? data.key_id.value : this.key_id,
      rfid_tag: data.rfid_tag.present ? data.rfid_tag.value : this.rfid_tag,
      status: data.status.present ? data.status.value : this.status,
      rssi: data.rssi.present ? data.rssi.value : this.rssi,
      created_at:
          data.created_at.present ? data.created_at.value : this.created_at,
      updated_at:
          data.updated_at.present ? data.updated_at.value : this.updated_at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TempMasterRfidData(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi, ')
          ..write('created_at: $created_at, ')
          ..write('updated_at: $updated_at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key_id, rfid_tag, status, rssi, created_at, updated_at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TempMasterRfidData &&
          other.key_id == this.key_id &&
          other.rfid_tag == this.rfid_tag &&
          other.status == this.status &&
          other.rssi == this.rssi &&
          other.created_at == this.created_at &&
          other.updated_at == this.updated_at);
}

class TempMasterRfidCompanion extends UpdateCompanion<TempMasterRfidData> {
  final Value<int> key_id;
  final Value<String?> rfid_tag;
  final Value<String?> status;
  final Value<String?> rssi;
  final Value<DateTime?> created_at;
  final Value<DateTime?> updated_at;
  const TempMasterRfidCompanion({
    this.key_id = const Value.absent(),
    this.rfid_tag = const Value.absent(),
    this.status = const Value.absent(),
    this.rssi = const Value.absent(),
    this.created_at = const Value.absent(),
    this.updated_at = const Value.absent(),
  });
  TempMasterRfidCompanion.insert({
    this.key_id = const Value.absent(),
    this.rfid_tag = const Value.absent(),
    this.status = const Value.absent(),
    this.rssi = const Value.absent(),
    this.created_at = const Value.absent(),
    this.updated_at = const Value.absent(),
  });
  static Insertable<TempMasterRfidData> custom({
    Expression<int>? key_id,
    Expression<String>? rfid_tag,
    Expression<String>? status,
    Expression<String>? rssi,
    Expression<DateTime>? created_at,
    Expression<DateTime>? updated_at,
  }) {
    return RawValuesInsertable({
      if (key_id != null) 'key_id': key_id,
      if (rfid_tag != null) 'rfid_tag': rfid_tag,
      if (status != null) 'status': status,
      if (rssi != null) 'rssi': rssi,
      if (created_at != null) 'created_at': created_at,
      if (updated_at != null) 'updated_at': updated_at,
    });
  }

  TempMasterRfidCompanion copyWith(
      {Value<int>? key_id,
      Value<String?>? rfid_tag,
      Value<String?>? status,
      Value<String?>? rssi,
      Value<DateTime?>? created_at,
      Value<DateTime?>? updated_at}) {
    return TempMasterRfidCompanion(
      key_id: key_id ?? this.key_id,
      rfid_tag: rfid_tag ?? this.rfid_tag,
      status: status ?? this.status,
      rssi: rssi ?? this.rssi,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key_id.present) {
      map['key_id'] = Variable<int>(key_id.value);
    }
    if (rfid_tag.present) {
      map['rfid_tag'] = Variable<String>(rfid_tag.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rssi.present) {
      map['rssi'] = Variable<String>(rssi.value);
    }
    if (created_at.present) {
      map['created_at'] = Variable<DateTime>(created_at.value);
    }
    if (updated_at.present) {
      map['updated_at'] = Variable<DateTime>(updated_at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TempMasterRfidCompanion(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi, ')
          ..write('created_at: $created_at, ')
          ..write('updated_at: $updated_at')
          ..write(')'))
        .toString();
  }
}

class ViewDetailData extends DataClass {
  final int key_id;
  final String? rfid_tag;
  final String? status;
  final String? rssi;
  const ViewDetailData(
      {required this.key_id, this.rfid_tag, this.status, this.rssi});
  factory ViewDetailData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ViewDetailData(
      key_id: serializer.fromJson<int>(json['key_id']),
      rfid_tag: serializer.fromJson<String?>(json['rfid_tag']),
      status: serializer.fromJson<String?>(json['status']),
      rssi: serializer.fromJson<String?>(json['rssi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key_id': serializer.toJson<int>(key_id),
      'rfid_tag': serializer.toJson<String?>(rfid_tag),
      'status': serializer.toJson<String?>(status),
      'rssi': serializer.toJson<String?>(rssi),
    };
  }

  ViewDetailData copyWith(
          {int? key_id,
          Value<String?> rfid_tag = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> rssi = const Value.absent()}) =>
      ViewDetailData(
        key_id: key_id ?? this.key_id,
        rfid_tag: rfid_tag.present ? rfid_tag.value : this.rfid_tag,
        status: status.present ? status.value : this.status,
        rssi: rssi.present ? rssi.value : this.rssi,
      );
  @override
  String toString() {
    return (StringBuffer('ViewDetailData(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key_id, rfid_tag, status, rssi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ViewDetailData &&
          other.key_id == this.key_id &&
          other.rfid_tag == this.rfid_tag &&
          other.status == this.status &&
          other.rssi == this.rssi);
}

class $ViewDetailView extends ViewInfo<$ViewDetailView, ViewDetailData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$AppDb attachedDatabase;
  $ViewDetailView(this.attachedDatabase, [this._alias]);
  $Tag_Running_RfidTable get tag =>
      attachedDatabase.tagRunningRfid.createAlias('t0');
  @override
  List<GeneratedColumn> get $columns => [key_id, rfid_tag, status, rssi];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'view_detail';
  @override
  Map<SqlDialect, String>? get createViewStatements => null;
  @override
  $ViewDetailView get asDslTable => this;
  @override
  ViewDetailData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ViewDetailData(
      key_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key_id'])!,
      rfid_tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rfid_tag']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      rssi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rssi']),
    );
  }

  late final GeneratedColumn<int> key_id = GeneratedColumn<int>(
      'key_id', aliasedName, false,
      generatedAs: GeneratedAs(tag.key_id, false), type: DriftSqlType.int);
  late final GeneratedColumn<String> rfid_tag = GeneratedColumn<String>(
      'rfid_tag', aliasedName, true,
      generatedAs: GeneratedAs(tag.rfid_tag, false), type: DriftSqlType.string);
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      generatedAs: GeneratedAs(tag.status, false), type: DriftSqlType.string);
  late final GeneratedColumn<String> rssi = GeneratedColumn<String>(
      'rssi', aliasedName, true,
      generatedAs: GeneratedAs(tag.rssi, false), type: DriftSqlType.string);
  @override
  $ViewDetailView createAlias(String alias) {
    return $ViewDetailView(attachedDatabase, alias);
  }

  @override
  Query? get query => (attachedDatabase.selectOnly(tag)..addColumns($columns));
  @override
  Set<String> get readTables => const {'tag_running_rfid'};
}

class ViewMasterData extends DataClass {
  final int key_id;
  final String? rfid_tag;
  final String? status;
  final String? rssi;
  const ViewMasterData(
      {required this.key_id, this.rfid_tag, this.status, this.rssi});
  factory ViewMasterData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ViewMasterData(
      key_id: serializer.fromJson<int>(json['key_id']),
      rfid_tag: serializer.fromJson<String?>(json['rfid_tag']),
      status: serializer.fromJson<String?>(json['status']),
      rssi: serializer.fromJson<String?>(json['rssi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key_id': serializer.toJson<int>(key_id),
      'rfid_tag': serializer.toJson<String?>(rfid_tag),
      'status': serializer.toJson<String?>(status),
      'rssi': serializer.toJson<String?>(rssi),
    };
  }

  ViewMasterData copyWith(
          {int? key_id,
          Value<String?> rfid_tag = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> rssi = const Value.absent()}) =>
      ViewMasterData(
        key_id: key_id ?? this.key_id,
        rfid_tag: rfid_tag.present ? rfid_tag.value : this.rfid_tag,
        status: status.present ? status.value : this.status,
        rssi: rssi.present ? rssi.value : this.rssi,
      );
  @override
  String toString() {
    return (StringBuffer('ViewMasterData(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key_id, rfid_tag, status, rssi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ViewMasterData &&
          other.key_id == this.key_id &&
          other.rfid_tag == this.rfid_tag &&
          other.status == this.status &&
          other.rssi == this.rssi);
}

class $ViewMasterView extends ViewInfo<$ViewMasterView, ViewMasterData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$AppDb attachedDatabase;
  $ViewMasterView(this.attachedDatabase, [this._alias]);
  $Master_rfidTable get master_rfid =>
      attachedDatabase.masterRfid.createAlias('t0');
  @override
  List<GeneratedColumn> get $columns => [key_id, rfid_tag, status, rssi];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'view_master';
  @override
  Map<SqlDialect, String>? get createViewStatements => null;
  @override
  $ViewMasterView get asDslTable => this;
  @override
  ViewMasterData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ViewMasterData(
      key_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key_id'])!,
      rfid_tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rfid_tag']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      rssi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rssi']),
    );
  }

  late final GeneratedColumn<int> key_id = GeneratedColumn<int>(
      'key_id', aliasedName, false,
      generatedAs: GeneratedAs(master_rfid.key_id, false),
      type: DriftSqlType.int);
  late final GeneratedColumn<String> rfid_tag = GeneratedColumn<String>(
      'rfid_tag', aliasedName, true,
      generatedAs: GeneratedAs(master_rfid.rfid_tag, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      generatedAs: GeneratedAs(master_rfid.status, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<String> rssi = GeneratedColumn<String>(
      'rssi', aliasedName, true,
      generatedAs: GeneratedAs(master_rfid.rssi, false),
      type: DriftSqlType.string);
  @override
  $ViewMasterView createAlias(String alias) {
    return $ViewMasterView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(master_rfid)..addColumns($columns));
  @override
  Set<String> get readTables => const {'master_rfid'};
}

class ViewTempMasterData extends DataClass {
  final int key_id;
  final String? rfid_tag;
  final String? status;
  final String? rssi;
  const ViewTempMasterData(
      {required this.key_id, this.rfid_tag, this.status, this.rssi});
  factory ViewTempMasterData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ViewTempMasterData(
      key_id: serializer.fromJson<int>(json['key_id']),
      rfid_tag: serializer.fromJson<String?>(json['rfid_tag']),
      status: serializer.fromJson<String?>(json['status']),
      rssi: serializer.fromJson<String?>(json['rssi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key_id': serializer.toJson<int>(key_id),
      'rfid_tag': serializer.toJson<String?>(rfid_tag),
      'status': serializer.toJson<String?>(status),
      'rssi': serializer.toJson<String?>(rssi),
    };
  }

  ViewTempMasterData copyWith(
          {int? key_id,
          Value<String?> rfid_tag = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> rssi = const Value.absent()}) =>
      ViewTempMasterData(
        key_id: key_id ?? this.key_id,
        rfid_tag: rfid_tag.present ? rfid_tag.value : this.rfid_tag,
        status: status.present ? status.value : this.status,
        rssi: rssi.present ? rssi.value : this.rssi,
      );
  @override
  String toString() {
    return (StringBuffer('ViewTempMasterData(')
          ..write('key_id: $key_id, ')
          ..write('rfid_tag: $rfid_tag, ')
          ..write('status: $status, ')
          ..write('rssi: $rssi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key_id, rfid_tag, status, rssi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ViewTempMasterData &&
          other.key_id == this.key_id &&
          other.rfid_tag == this.rfid_tag &&
          other.status == this.status &&
          other.rssi == this.rssi);
}

class $ViewTempMasterView
    extends ViewInfo<$ViewTempMasterView, ViewTempMasterData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$AppDb attachedDatabase;
  $ViewTempMasterView(this.attachedDatabase, [this._alias]);
  $TempMasterRfidTable get master_rfid =>
      attachedDatabase.tempMasterRfid.createAlias('t0');
  @override
  List<GeneratedColumn> get $columns => [key_id, rfid_tag, status, rssi];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'view_temp_master';
  @override
  Map<SqlDialect, String>? get createViewStatements => null;
  @override
  $ViewTempMasterView get asDslTable => this;
  @override
  ViewTempMasterData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ViewTempMasterData(
      key_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key_id'])!,
      rfid_tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rfid_tag']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      rssi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rssi']),
    );
  }

  late final GeneratedColumn<int> key_id = GeneratedColumn<int>(
      'key_id', aliasedName, false,
      generatedAs: GeneratedAs(master_rfid.key_id, false),
      type: DriftSqlType.int);
  late final GeneratedColumn<String> rfid_tag = GeneratedColumn<String>(
      'rfid_tag', aliasedName, true,
      generatedAs: GeneratedAs(master_rfid.rfid_tag, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      generatedAs: GeneratedAs(master_rfid.status, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<String> rssi = GeneratedColumn<String>(
      'rssi', aliasedName, true,
      generatedAs: GeneratedAs(master_rfid.rssi, false),
      type: DriftSqlType.string);
  @override
  $ViewTempMasterView createAlias(String alias) {
    return $ViewTempMasterView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(master_rfid)..addColumns($columns));
  @override
  Set<String> get readTables => const {'temp_master_rfid'};
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $Master_rfidTable masterRfid = $Master_rfidTable(this);
  late final $Tag_Running_RfidTable tagRunningRfid =
      $Tag_Running_RfidTable(this);
  late final $TempMasterRfidTable tempMasterRfid = $TempMasterRfidTable(this);
  late final $ViewDetailView viewDetail = $ViewDetailView(this);
  late final $ViewMasterView viewMaster = $ViewMasterView(this);
  late final $ViewTempMasterView viewTempMaster = $ViewTempMasterView(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        masterRfid,
        tagRunningRfid,
        tempMasterRfid,
        viewDetail,
        viewMaster,
        viewTempMaster
      ];
}

typedef $$Master_rfidTableCreateCompanionBuilder = Master_rfidCompanion
    Function({
  Value<int> key_id,
  Value<String?> rfid_tag,
  Value<String?> status,
  Value<String?> rssi,
  Value<DateTime?> created_at,
  Value<DateTime?> updated_at,
});
typedef $$Master_rfidTableUpdateCompanionBuilder = Master_rfidCompanion
    Function({
  Value<int> key_id,
  Value<String?> rfid_tag,
  Value<String?> status,
  Value<String?> rssi,
  Value<DateTime?> created_at,
  Value<DateTime?> updated_at,
});

class $$Master_rfidTableFilterComposer
    extends FilterComposer<_$AppDb, $Master_rfidTable> {
  $$Master_rfidTableFilterComposer(super.$state);
  ColumnFilters<int> get key_id => $state.composableBuilder(
      column: $state.table.key_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rfid_tag => $state.composableBuilder(
      column: $state.table.rfid_tag,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rssi => $state.composableBuilder(
      column: $state.table.rssi,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get created_at => $state.composableBuilder(
      column: $state.table.created_at,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updated_at => $state.composableBuilder(
      column: $state.table.updated_at,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$Master_rfidTableOrderingComposer
    extends OrderingComposer<_$AppDb, $Master_rfidTable> {
  $$Master_rfidTableOrderingComposer(super.$state);
  ColumnOrderings<int> get key_id => $state.composableBuilder(
      column: $state.table.key_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rfid_tag => $state.composableBuilder(
      column: $state.table.rfid_tag,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rssi => $state.composableBuilder(
      column: $state.table.rssi,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get created_at => $state.composableBuilder(
      column: $state.table.created_at,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updated_at => $state.composableBuilder(
      column: $state.table.updated_at,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$Master_rfidTableTableManager extends RootTableManager<
    _$AppDb,
    $Master_rfidTable,
    Master_rfidData,
    $$Master_rfidTableFilterComposer,
    $$Master_rfidTableOrderingComposer,
    $$Master_rfidTableCreateCompanionBuilder,
    $$Master_rfidTableUpdateCompanionBuilder,
    (
      Master_rfidData,
      BaseReferences<_$AppDb, $Master_rfidTable, Master_rfidData>
    ),
    Master_rfidData,
    PrefetchHooks Function()> {
  $$Master_rfidTableTableManager(_$AppDb db, $Master_rfidTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$Master_rfidTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$Master_rfidTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> key_id = const Value.absent(),
            Value<String?> rfid_tag = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> rssi = const Value.absent(),
            Value<DateTime?> created_at = const Value.absent(),
            Value<DateTime?> updated_at = const Value.absent(),
          }) =>
              Master_rfidCompanion(
            key_id: key_id,
            rfid_tag: rfid_tag,
            status: status,
            rssi: rssi,
            created_at: created_at,
            updated_at: updated_at,
          ),
          createCompanionCallback: ({
            Value<int> key_id = const Value.absent(),
            Value<String?> rfid_tag = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> rssi = const Value.absent(),
            Value<DateTime?> created_at = const Value.absent(),
            Value<DateTime?> updated_at = const Value.absent(),
          }) =>
              Master_rfidCompanion.insert(
            key_id: key_id,
            rfid_tag: rfid_tag,
            status: status,
            rssi: rssi,
            created_at: created_at,
            updated_at: updated_at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$Master_rfidTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $Master_rfidTable,
    Master_rfidData,
    $$Master_rfidTableFilterComposer,
    $$Master_rfidTableOrderingComposer,
    $$Master_rfidTableCreateCompanionBuilder,
    $$Master_rfidTableUpdateCompanionBuilder,
    (
      Master_rfidData,
      BaseReferences<_$AppDb, $Master_rfidTable, Master_rfidData>
    ),
    Master_rfidData,
    PrefetchHooks Function()>;
typedef $$Tag_Running_RfidTableCreateCompanionBuilder
    = Tag_Running_RfidCompanion Function({
  Value<int> key_id,
  Value<String?> rfid_tag,
  Value<String?> status,
  Value<String?> rssi,
  Value<DateTime?> created_at,
  Value<DateTime?> updated_at,
});
typedef $$Tag_Running_RfidTableUpdateCompanionBuilder
    = Tag_Running_RfidCompanion Function({
  Value<int> key_id,
  Value<String?> rfid_tag,
  Value<String?> status,
  Value<String?> rssi,
  Value<DateTime?> created_at,
  Value<DateTime?> updated_at,
});

class $$Tag_Running_RfidTableFilterComposer
    extends FilterComposer<_$AppDb, $Tag_Running_RfidTable> {
  $$Tag_Running_RfidTableFilterComposer(super.$state);
  ColumnFilters<int> get key_id => $state.composableBuilder(
      column: $state.table.key_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rfid_tag => $state.composableBuilder(
      column: $state.table.rfid_tag,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rssi => $state.composableBuilder(
      column: $state.table.rssi,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get created_at => $state.composableBuilder(
      column: $state.table.created_at,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updated_at => $state.composableBuilder(
      column: $state.table.updated_at,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$Tag_Running_RfidTableOrderingComposer
    extends OrderingComposer<_$AppDb, $Tag_Running_RfidTable> {
  $$Tag_Running_RfidTableOrderingComposer(super.$state);
  ColumnOrderings<int> get key_id => $state.composableBuilder(
      column: $state.table.key_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rfid_tag => $state.composableBuilder(
      column: $state.table.rfid_tag,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rssi => $state.composableBuilder(
      column: $state.table.rssi,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get created_at => $state.composableBuilder(
      column: $state.table.created_at,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updated_at => $state.composableBuilder(
      column: $state.table.updated_at,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$Tag_Running_RfidTableTableManager extends RootTableManager<
    _$AppDb,
    $Tag_Running_RfidTable,
    Tag_Running_RfidData,
    $$Tag_Running_RfidTableFilterComposer,
    $$Tag_Running_RfidTableOrderingComposer,
    $$Tag_Running_RfidTableCreateCompanionBuilder,
    $$Tag_Running_RfidTableUpdateCompanionBuilder,
    (
      Tag_Running_RfidData,
      BaseReferences<_$AppDb, $Tag_Running_RfidTable, Tag_Running_RfidData>
    ),
    Tag_Running_RfidData,
    PrefetchHooks Function()> {
  $$Tag_Running_RfidTableTableManager(_$AppDb db, $Tag_Running_RfidTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$Tag_Running_RfidTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$Tag_Running_RfidTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> key_id = const Value.absent(),
            Value<String?> rfid_tag = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> rssi = const Value.absent(),
            Value<DateTime?> created_at = const Value.absent(),
            Value<DateTime?> updated_at = const Value.absent(),
          }) =>
              Tag_Running_RfidCompanion(
            key_id: key_id,
            rfid_tag: rfid_tag,
            status: status,
            rssi: rssi,
            created_at: created_at,
            updated_at: updated_at,
          ),
          createCompanionCallback: ({
            Value<int> key_id = const Value.absent(),
            Value<String?> rfid_tag = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> rssi = const Value.absent(),
            Value<DateTime?> created_at = const Value.absent(),
            Value<DateTime?> updated_at = const Value.absent(),
          }) =>
              Tag_Running_RfidCompanion.insert(
            key_id: key_id,
            rfid_tag: rfid_tag,
            status: status,
            rssi: rssi,
            created_at: created_at,
            updated_at: updated_at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$Tag_Running_RfidTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $Tag_Running_RfidTable,
    Tag_Running_RfidData,
    $$Tag_Running_RfidTableFilterComposer,
    $$Tag_Running_RfidTableOrderingComposer,
    $$Tag_Running_RfidTableCreateCompanionBuilder,
    $$Tag_Running_RfidTableUpdateCompanionBuilder,
    (
      Tag_Running_RfidData,
      BaseReferences<_$AppDb, $Tag_Running_RfidTable, Tag_Running_RfidData>
    ),
    Tag_Running_RfidData,
    PrefetchHooks Function()>;
typedef $$TempMasterRfidTableCreateCompanionBuilder = TempMasterRfidCompanion
    Function({
  Value<int> key_id,
  Value<String?> rfid_tag,
  Value<String?> status,
  Value<String?> rssi,
  Value<DateTime?> created_at,
  Value<DateTime?> updated_at,
});
typedef $$TempMasterRfidTableUpdateCompanionBuilder = TempMasterRfidCompanion
    Function({
  Value<int> key_id,
  Value<String?> rfid_tag,
  Value<String?> status,
  Value<String?> rssi,
  Value<DateTime?> created_at,
  Value<DateTime?> updated_at,
});

class $$TempMasterRfidTableFilterComposer
    extends FilterComposer<_$AppDb, $TempMasterRfidTable> {
  $$TempMasterRfidTableFilterComposer(super.$state);
  ColumnFilters<int> get key_id => $state.composableBuilder(
      column: $state.table.key_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rfid_tag => $state.composableBuilder(
      column: $state.table.rfid_tag,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rssi => $state.composableBuilder(
      column: $state.table.rssi,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get created_at => $state.composableBuilder(
      column: $state.table.created_at,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updated_at => $state.composableBuilder(
      column: $state.table.updated_at,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TempMasterRfidTableOrderingComposer
    extends OrderingComposer<_$AppDb, $TempMasterRfidTable> {
  $$TempMasterRfidTableOrderingComposer(super.$state);
  ColumnOrderings<int> get key_id => $state.composableBuilder(
      column: $state.table.key_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rfid_tag => $state.composableBuilder(
      column: $state.table.rfid_tag,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rssi => $state.composableBuilder(
      column: $state.table.rssi,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get created_at => $state.composableBuilder(
      column: $state.table.created_at,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updated_at => $state.composableBuilder(
      column: $state.table.updated_at,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$TempMasterRfidTableTableManager extends RootTableManager<
    _$AppDb,
    $TempMasterRfidTable,
    TempMasterRfidData,
    $$TempMasterRfidTableFilterComposer,
    $$TempMasterRfidTableOrderingComposer,
    $$TempMasterRfidTableCreateCompanionBuilder,
    $$TempMasterRfidTableUpdateCompanionBuilder,
    (
      TempMasterRfidData,
      BaseReferences<_$AppDb, $TempMasterRfidTable, TempMasterRfidData>
    ),
    TempMasterRfidData,
    PrefetchHooks Function()> {
  $$TempMasterRfidTableTableManager(_$AppDb db, $TempMasterRfidTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TempMasterRfidTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TempMasterRfidTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> key_id = const Value.absent(),
            Value<String?> rfid_tag = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> rssi = const Value.absent(),
            Value<DateTime?> created_at = const Value.absent(),
            Value<DateTime?> updated_at = const Value.absent(),
          }) =>
              TempMasterRfidCompanion(
            key_id: key_id,
            rfid_tag: rfid_tag,
            status: status,
            rssi: rssi,
            created_at: created_at,
            updated_at: updated_at,
          ),
          createCompanionCallback: ({
            Value<int> key_id = const Value.absent(),
            Value<String?> rfid_tag = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> rssi = const Value.absent(),
            Value<DateTime?> created_at = const Value.absent(),
            Value<DateTime?> updated_at = const Value.absent(),
          }) =>
              TempMasterRfidCompanion.insert(
            key_id: key_id,
            rfid_tag: rfid_tag,
            status: status,
            rssi: rssi,
            created_at: created_at,
            updated_at: updated_at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TempMasterRfidTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $TempMasterRfidTable,
    TempMasterRfidData,
    $$TempMasterRfidTableFilterComposer,
    $$TempMasterRfidTableOrderingComposer,
    $$TempMasterRfidTableCreateCompanionBuilder,
    $$TempMasterRfidTableUpdateCompanionBuilder,
    (
      TempMasterRfidData,
      BaseReferences<_$AppDb, $TempMasterRfidTable, TempMasterRfidData>
    ),
    TempMasterRfidData,
    PrefetchHooks Function()>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$Master_rfidTableTableManager get masterRfid =>
      $$Master_rfidTableTableManager(_db, _db.masterRfid);
  $$Tag_Running_RfidTableTableManager get tagRunningRfid =>
      $$Tag_Running_RfidTableTableManager(_db, _db.tagRunningRfid);
  $$TempMasterRfidTableTableManager get tempMasterRfid =>
      $$TempMasterRfidTableTableManager(_db, _db.tempMasterRfid);
}
