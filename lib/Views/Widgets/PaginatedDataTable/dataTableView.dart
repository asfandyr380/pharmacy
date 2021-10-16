import 'package:flutter/material.dart';
import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataSource.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/helperClass.dart';
import 'package:velocity_x/velocity_x.dart';

class ResponsiveTableView extends StatelessWidget {
  final List<DataColumn> columns;
  final dynamic dataSource;
  final Function? sort;
  final bool sortAscending;
  final int? sortColumnIndex;
  const ResponsiveTableView({
    required this.columns,
    required this.dataSource,
    this.sort,
    required this.sortAscending,
    this.sortColumnIndex,
  });

  @override
  Widget build(BuildContext context) {
    return VxResponsive(
      xlarge: TableViewLarge(
        columns: columns,
        dataSource: dataSource,
        sort: sort,
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
      ),
      large: TableViewLarge(
        columns: columns,
        dataSource: dataSource,
        sort: sort,
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
      ),
      small: TableViewSmall(
        columns: columns,
        dataSource: dataSource,
        sort: sort,
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
      ),
      medium: TableViewLarge(
        columns: columns,
        dataSource: dataSource,
        sort: sort,
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
      ),
      xsmall: TableViewSmall(
        columns: columns,
        dataSource: dataSource,
        sort: sort,
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
      ),
      fallback: Text('No View Specified'),
    );
  }
}

class TableViewLarge extends StatelessWidget {
  final List<DataColumn> columns;
  final dynamic dataSource;

  final Function? sort;
  final bool sortAscending;
  final int? sortColumnIndex;
  const TableViewLarge({
    required this.columns,
    required this.dataSource,
    this.sort,
    required this.sortAscending,
    this.sortColumnIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.percentHeight * 85,
      width: context.percentWidth * 80,
      child: PaginatedDataTable2Demo(
        columns: columns,
        dataSource: dataSource,
        sort: sort,
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
      ),
    );
  }
}

class TableViewSmall extends StatelessWidget {
  final List<DataColumn> columns;
  final dynamic dataSource;

  final Function? sort;
  final bool sortAscending;
  final int? sortColumnIndex;
  const TableViewSmall({
    required this.columns,
    required this.dataSource,
    this.sort,
    required this.sortAscending,
    this.sortColumnIndex,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.percentHeight * 85,
      width: context.percentWidth * 90,
      child: PaginatedDataTable2Demo(
        columns: columns,
        dataSource: dataSource,
        sort: sort,
        sortAscending: sortAscending,
        sortColumnIndex: sortColumnIndex,
      ),
    );
  }
}

class PaginatedDataTable2Demo extends StatefulWidget {
  final List<DataColumn> columns;
  final dynamic dataSource;
  final Function? sort;
  final bool sortAscending;
  final int? sortColumnIndex;
  const PaginatedDataTable2Demo({
    required this.columns,
    required this.dataSource,
    this.sort,
    required this.sortAscending,
    this.sortColumnIndex,
  });

  @override
  _PaginatedDataTable2DemoState createState() =>
      _PaginatedDataTable2DemoState();
}

class _PaginatedDataTable2DemoState extends State<PaginatedDataTable2Demo> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _initialized = false;
  PaginatorController? _controller;
  DataSource _dataSource = locator<DataSource>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _controller = PaginatorController();
      _dataSource = widget.dataSource;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    // _dataSource.dispose();
    super.dispose();
  }

  List<DataColumn> get _columns => widget.columns;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      PaginatedDataTable2(
        showCheckboxColumn: false,
        horizontalMargin: 10,
        columnSpacing: 0,
        wrapInCard: false,
        rowsPerPage: _rowsPerPage,
        autoRowsToHeight: getCurrentRouteOption(context) == autoRows,
        minWidth: 800,
        fit: FlexFit.tight,
        border: TableBorder(
            top: BorderSide(color: Vx.black),
            bottom: BorderSide(color: Colors.grey[300]!),
            left: BorderSide(color: Colors.grey[300]!),
            right: BorderSide(color: Colors.grey[300]!),
            verticalInside: BorderSide(color: Colors.grey[300]!),
            horizontalInside: BorderSide(color: Colors.grey, width: 1)),
        onRowsPerPageChanged: (value) {
          _rowsPerPage = value!;
          print(_rowsPerPage);
        },
        initialFirstRowIndex: 0,
        onPageChanged: (rowIndex) {
          print(rowIndex / _rowsPerPage);
        },
        sortColumnIndex: widget.sortColumnIndex,
        sortAscending: widget.sortAscending,
        controller:
            getCurrentRouteOption(context) == custPager ? _controller : null,
        hidePaginator: getCurrentRouteOption(context) == custPager,
        columns: _columns,
        empty: Center(
            child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[200],
                child: Text('No data'))),
        source: getCurrentRouteOption(context) == noData
            ? DataSource.empty(context)
            : _dataSource,
      ),
      if (getCurrentRouteOption(context) == custPager)
        Positioned(bottom: 16, child: _CustomPager(_controller!))
    ]);
  }
}

class _PageNumber extends StatefulWidget {
  const _PageNumber({
    required PaginatorController controller,
  }) : _controller = controller;

  final PaginatorController _controller;

  @override
  _PageNumberState createState() => _PageNumberState();
}

class _PageNumberState extends State<_PageNumber> {
  @override
  void initState() {
    super.initState();
    widget._controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget._controller.isAttached
        ? 'Page: ${1 + ((widget._controller.currentRowIndex + 1) / widget._controller.rowsPerPage).floor()} of '
            '${(widget._controller.rowCount / widget._controller.rowsPerPage).ceil()}'
        : 'Page: x of y');
  }
}

class _CustomPager extends StatefulWidget {
  const _CustomPager(this.controller);

  final PaginatorController controller;

  @override
  _CustomPagerState createState() => _CustomPagerState();
}

class _CustomPagerState extends State<_CustomPager> {
  static const List<int> _availableSizes = [3, 5, 10, 20];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
          data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(subtitle1: TextStyle(color: Colors.white))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => widget.controller.goToFirstPage(),
                  icon: Icon(Icons.skip_previous)),
              IconButton(
                  onPressed: () => widget.controller.goToPreviousPage(),
                  icon: Icon(Icons.chevron_left_sharp)),
              DropdownButton<int>(
                  onChanged: (v) => widget.controller.setRowsPerPage(v!),
                  value: _availableSizes.contains(widget.controller.rowsPerPage)
                      ? widget.controller.rowsPerPage
                      : _availableSizes[0],
                  dropdownColor: Colors.grey[800],
                  items: _availableSizes
                      .map((s) => DropdownMenuItem<int>(
                            child: Text(s.toString()),
                            value: s,
                          ))
                      .toList()),
              IconButton(
                  onPressed: () => widget.controller.goToNextPage(),
                  icon: Icon(Icons.chevron_right_sharp)),
              IconButton(
                  onPressed: () => widget.controller.goToLastPage(),
                  icon: Icon(Icons.skip_next))
            ],
          )),
      width: 220,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 4,
            offset: Offset(4, 8),
          ),
        ],
      ),
    );
  }
}
