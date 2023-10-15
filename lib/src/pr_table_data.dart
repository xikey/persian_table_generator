class PrTableHeaderInfo {
  String name;
  bool isExpanded;

  PrTableHeaderInfo({
    required this.name,
    required this.isExpanded,
  });
}


class PrTableRowInfo {
  final int id;
  final List<String> rowItems;

  PrTableRowInfo({
    required this.id,
    required this.rowItems,
  });
}
