import 'dart:html';
import 'package:slickdart/src/slick_custom.dart';
import 'package:slickdart/slick.dart';

Map<int, Map<String, String>> hash = {};
Map<String, String> getMeta(int row) {
  var rdata = csv.data[row];
 // print("HI");
  if (rdata['gss_code'] == filterStr) {
    //build column style hash
    hash[row] = {'UNITID': 'bold', 'school_id': 'bold'};

    return {"cssClasses": "highlight"};
  } else
    return {}; // {"cssClasses":'highlight'};
}

main() {
  registerElem();
  HttpRequest.getString('gss1983_Code-small.csv').then((data) {
//  HttpRequest.getString('gss1983_Code.csv').then((data) {
    csv = new CsvAdapter(data);
    var cols = getColDefs(csv.columns);
    cols[1]
      ..width = 20
      ..name = 'id';
    csv.columns[0]
      ..width = 14
      ..name = 'id';
    Map opt = {
      'multiColumnSort': true,
      'editable': false,
    };
    gw0 = document.querySelector("$GRID_TAG.second");
    gw0.init(new MetaList(csv.data, getMeta), cols, option: opt);
    gw0.grid.setSelectionModel(new CellSelectionModel(opt));
    gw0.grid.setCellCssStyles("fixed", {
      3: {'year': 'blur'}
    });
    gw0.grid.setCellCssStyles('bold_test', hash);
    gw0.grid.onSort.subscribe((EventData e, dynamic parm) {
      hash.clear();
      gw0.grid.invalidate();
    });
  });
  querySelector('.inputgs').onKeyUp.listen((_) {
    filterStr = (_.target as InputElement).value;
    hash.clear();
    gw0.grid.invalidate();
  });
}

JGrid gw0;
CsvAdapter csv;
String filterStr;

List<Column> getColDefs(List<Column> cols) {
  List<Column> newCols = cols.map((col) => new Column.fromColumn(col)..sortable = true).toList();
  CheckboxSelectColumn checkboxCol = new CheckboxSelectColumn({'cssClass': "slick-cell-checkboxsel"});
  newCols.insert(0, checkboxCol.getColumnDefinition());
  return newCols;
}
