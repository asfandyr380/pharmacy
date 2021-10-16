import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RestorableDessertSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  @override
  Set<int> createDefaultValue() => _dessertSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _dessertSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _dessertSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _dessertSelections = value;
  }

  @override
  Object toPrimitives() => _dessertSelections.toList();
}

class DataSource extends DataTableSource {
  DataSource.empty(this.context) {
    data = [];
  }
  DataSource({this.context, this.data, this.getCell}) {
    data = data;
    getCell = getCell;
  }

  final BuildContext? context;
  late List<dynamic>? data;
  late Function(dynamic)? getCell;
  void sort<T>(Comparable<T> Function(dynamic d) getField, bool ascending) {
    data!.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    final format = NumberFormat.decimalPercentPattern(
      locale: 'en',
      decimalDigits: 0,
    );
    assert(index >= 0);
    if (index >= data!.length) throw 'index > _desserts.length';
    final dessert = data![index];

    List<DataCell> datacell = getCell!(dessert) as List<DataCell>;

    return DataRow.byIndex(index: index, cells: datacell);
  }

  @override
  int get rowCount => data!.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
