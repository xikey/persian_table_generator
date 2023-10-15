import 'package:flutter/material.dart';
import 'package:flutter_persian_table/src/pr_table_data.dart';



class FlutterPersianTable extends StatefulWidget {
  const FlutterPersianTable({
    Key? key,
    required this.columnHeaders,
    required this.tableHeight,
    required this.tableData,
  }) : super(key: key);

  final List<PrTableHeaderInfo> columnHeaders;
  final List<PrTableRowInfo> tableData;
  final double tableHeight;

  @override
  _FlutterPersianTableState createState() => _FlutterPersianTableState();
}

class _FlutterPersianTableState extends State<FlutterPersianTable> {
  static const int itemsPerPage = 50;
  int currentPage = 0;

  List<int> expandedColumnIndex = [];

  @override
  void initState() {
    super.initState();
    initializeExpandedColumnIndex();
  }

  void initializeExpandedColumnIndex() {
    if (widget.columnHeaders.isNotEmpty) {
      for (int i = 0; i < widget.columnHeaders.length; i++) {
        final item = widget.columnHeaders[i];
        if (item.isExpanded) {
          expandedColumnIndex.add(i);
        }
      }
    }
  }

  List<PrTableRowInfo> getVisibleRows() {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return widget.tableData.sublist(startIndex, endIndex);
  }

  int getTotalPages() {
    return (widget.tableData.length / itemsPerPage).ceil();
  }

  void goToNextPage() {
    setState(() {
      currentPage = currentPage < getTotalPages() - 1 ? currentPage + 1 : currentPage;
    });
  }

  void goToPreviousPage() {
    setState(() {
      currentPage = currentPage > 0 ? currentPage - 1 : currentPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleRows = getVisibleRows();
    final totalPages = getTotalPages();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: widget.tableHeight,
        child: Column(
          children: [
            Container(
              height: 60, // Header height
              color: const Color(0xff362f4b), // Header background color
              child: Row(
                children: List.generate(widget.columnHeaders.length, (index) {
                  final headerInfo = widget.columnHeaders[index];
                  return Expanded(
                    flex: headerInfo.isExpanded ? 2 : 1,
                    child: Container(
                      height: double.infinity,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        headerInfo.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: visibleRows.isEmpty
                  ? const Center(
                child: Text("اطلاعاتی جهت نمایش وجود ندارد"),
              )
                  : ListView.builder(
                itemCount: visibleRows.length,
                itemBuilder: (context, eachRowIndex) {
                  final eachRowItem = visibleRows[eachRowIndex];
                  return Row(
                    children: List.generate(
                      eachRowItem.rowItems.length,
                          (index) {
                        final cellInfo = eachRowItem.rowItems[index];
                        return Expanded(
                          flex: expandedColumnIndex.contains(index) ? 2 : 1,
                          child: Container(
                            height: 60,
                            color: eachRowIndex.isOdd
                                ? Colors.white
                                : Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: Text(
                              cellInfo,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 60, // Footer height
              color: const Color(0xff362f4b), // Footer background color
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: goToPreviousPage,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Item ${currentPage * itemsPerPage + 1} - ${(currentPage + 1) * itemsPerPage} of ${widget.tableData.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: goToNextPage,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

