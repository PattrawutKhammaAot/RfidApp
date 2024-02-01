import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ZincDataSource extends DataGridSource {
  ZincDataSource({List<ComboBoxModel>? process}) {
    try {
      for (int i = 0; i < 10; i++) {
        process?.add(ComboBoxModel(
          VALUEMEMBER: "Test Value",
          GROUP: "Test Group",
          IS_ACTIVE: true,
          DESCRIPTION: "Desc",
          COMBOBOX_ID: i,
          ID: i,
        ));
      }

      if (process != null) {
        for (var _item in process) {
          _employees.add(
            DataGridRow(
              cells: [
                DataGridCell<int>(columnName: 'ID', value: _item.ID),
                DataGridCell<String>(
                    columnName: 'batch', value: _item.VALUEMEMBER),
                // DataGridCell<String>(columnName: 't1', value: _item.Thickness1),
                // DataGridCell<String>(columnName: 't2', value: _item.Thickness2),
                // DataGridCell<String>(columnName: 't3', value: _item.Thickness3),
                // DataGridCell<String>(columnName: 't4', value: _item.Thickness4),
                // DataGridCell<String>(columnName: 't6', value: _item.Thickness6),
                // DataGridCell<String>(columnName: 't7', value: _item.Thickness7),
                // DataGridCell<String>(columnName: 't8', value: _item.Thickness8),
                // DataGridCell<String>(columnName: 't9', value: _item.Thickness9),
                // DataGridCell<String>(columnName: 'date', value: _item.DateData),
              ],
            ),
          );
        }
      }
    } catch (e) {}
  }

  List<DataGridRow> _employees = [];

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            alignment: (dataGridCell.columnName == 'id' ||
                    dataGridCell.columnName == 'qty')
                ? Alignment.center
                : Alignment.center,
            child: Text(dataGridCell.value.toString()),
          );
        },
      ).toList(),
    );
  }
}

class ComboBoxModel {
  ComboBoxModel(
      {this.VALUEMEMBER,
      this.GROUP,
      this.IS_ACTIVE,
      this.DESCRIPTION,
      this.COMBOBOX_ID,
      this.ID});
  final int? ID;
  final int? COMBOBOX_ID;
  final String? GROUP;
  final String? VALUEMEMBER;
  final String? DESCRIPTION;
  final bool? IS_ACTIVE;

  List<Object> get props =>
      [ID!, COMBOBOX_ID!, GROUP!, VALUEMEMBER!, IS_ACTIVE!];

  static ComboBoxModel fromJson(dynamic json) {
    return ComboBoxModel(
        COMBOBOX_ID: json['combobox_id'],
        GROUP: json['Group'],
        VALUEMEMBER: json['Value_Member'],
        IS_ACTIVE: json['Is_Active'],
        DESCRIPTION: json['Description']);
  }

  ComboBoxModel.fromMap(Map<String, dynamic> map)
      : GROUP = map['nameGroup'],
        VALUEMEMBER = map['valueMember'],
        IS_ACTIVE = map['IsActive'],
        DESCRIPTION = map['Description'],
        COMBOBOX_ID = map[''],
        ID = map['ID'];
}
