import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';

class TableClassWidget extends StatefulWidget {
  final bool? bIsShowMultiSelect;
  final bool? bIsZebraBg;
  final bool? bIsShowBoarder;
  final Color? boarderColor;
  final TableClass tables;
  final Function(RowClass)? onSelectionChanged;
  final Color? firstZebraColor;
  final Color? secondZebraColor;
  final Color? defaultBackgroundColor;

  const TableClassWidget({
    Key? key,
    this.bIsShowMultiSelect = false,
    this.bIsZebraBg = true,
    this.bIsShowBoarder = true,
    this.boarderColor = AppColors.TABLE_BOARDER_COLOR,
    required this.tables,
    required this.onSelectionChanged,
    this.firstZebraColor = AppColors.TABLE_ROW_BG,
    this.secondZebraColor = AppColors.BASICWHITE,
    this.defaultBackgroundColor = AppColors.BASICWHITE,
  }) : super(key: key);

  @override
  State<TableClassWidget> createState() => _TableClassWidgetState();
}

class _TableClassWidgetState extends State<TableClassWidget> {
  bool _sortAscending = true;
  int columnIndex = 0;

  @override
  Widget build(BuildContext context) {
    // if (widget.tables == null || widget.tables.rows == null) {
    //   return Container();
    // }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Container(
          decoration:
              widget.bIsShowBoarder!
                  ? BoxDecoration(border: Border.all(color: widget.boarderColor!, width: 1.0))
                  : null,
          child: DataTable(
            columns: List.generate(widget.tables.rowHeader.length, (index) {
              return DataColumn(
                label: GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        widget.tables.rowHeader[index].heading!,
                        style:
                            widget.tables.rowHeader[index].textStyle ??
                            AppStyles.columnHeadingStyle,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        child:
                            widget.tables.rowHeader[index].bIsFilterIconOn!
                                ? widget.tables.rowHeader[index].imgWidget ?? const SizedBox()
                                : const SizedBox(),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      if (columnIndex == index) {
                        _sortAscending = !_sortAscending;
                      } else {
                        columnIndex = index;
                        _sortAscending = true;
                      }
                      widget.tables.sortBy(index, _sortAscending);
                    });
                  },
                ),
              );
            }),
            rows: List.generate(widget.tables.rows.length, (index) {
              return DataRow(
                color: WidgetStateColor.resolveWith((states) {
                  return widget.bIsZebraBg!
                      ? index % 2 == 0
                          ? widget.firstZebraColor!
                          : widget.secondZebraColor!
                      : widget.defaultBackgroundColor!;
                }),
                selected: widget.bIsShowMultiSelect! ? widget.tables.rows[index].bIsSelect! : false,
                onSelectChanged:
                    widget.bIsShowMultiSelect!
                        ? (bool? value) {
                          setState(() {
                            for (var element in widget.tables.rows) {
                              if (element == widget.tables.rows[index]) {
                                element.bIsSelect = value;
                                widget.onSelectionChanged!(widget.tables.rows[index]);
                              }
                            }
                          });
                        }
                        : null,
                cells: List.generate(widget.tables.rowHeader.length, (i) {
                  return DataCell(
                    (widget.tables.rows[index].listWidget!.length <= i)
                        ? Container()
                        : widget.tables.rows[index].listWidget![i],
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class ColumnClass {
  final String? heading;
  final TextStyle? textStyle;
  final bool? bIsFilterIconOn;
  bool isAscending = true;
  final Widget? imgWidget;

  ColumnClass({this.heading, this.bIsFilterIconOn, this.imgWidget, this.textStyle});
  void sort(bool sortAscending) {
    isAscending = sortAscending;
  }
}

class RowClass {
  final List<Widget>? listWidget;
  bool? bIsSelect;

  RowClass({this.listWidget = const [], this.bIsSelect = false});
}

class TableClass {
  final List<ColumnClass> rowHeader;
  final List<RowClass> rows;

  TableClass({required this.rowHeader, required this.rows});
  void sortBy(int columnIndex, bool sortAscending) {
    rowHeader[columnIndex].sort(sortAscending);
    rows.sort((a, b) {
      String aStr = '';
      String bStr = '';

      if (a.listWidget != null &&
          columnIndex >= 0 &&
          columnIndex < a.listWidget!.length &&
          a.listWidget![columnIndex] is Text) {
        aStr = (a.listWidget![columnIndex] as Text).data!.toLowerCase();
      }
      if (b.listWidget != null &&
          columnIndex >= 0 &&
          columnIndex < b.listWidget!.length &&
          b.listWidget![columnIndex] is Text) {
        bStr = (b.listWidget![columnIndex] as Text).data!.toLowerCase();
      }
      return aStr.compareTo(bStr) * (sortAscending ? 1 : -1);
    });
  }
}
