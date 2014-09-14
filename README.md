slickdart
=========

slick grid port, not for mobile device

Sort performance is not expected in javascript version

Parameter Description
=======================

* When enable 'selectActiveRow' on row selection model and with CheckboxSelectColumn in first row
  click on first column out side of check box will uncheck other rows if multiple row selected


Example
=========================
* [Live Sample](https://cjkao.github.io/slickdart)
* examples in web/example folder
simple.dart
    import 'dart:html';
    import 'package:slickdart/slick_grid.dart' as grid;
    import 'dart:math' as math;
    
    void main() {
      var g=init();
      g.init();
      print (g.$headerScroller.querySelectorAll('.slick-header-column').length);
    }
    
    grid.SlickGrid init(){
      Element el =querySelector('#grid');
      List column = [
         new grid.Column.fromMap ({'id': "title", 'name': "Title1", 'field': "title", 'sortable': true }),
         new grid.Column.fromMap ({'id': "duration", 'width':120,'name': "percentComplete2", 'field': "percentComplete", 'sortable': true }),
         new grid.Column.fromMap ({'id': "%", 'name': "start3", 'field': "start", 'sortable': true }),
         new grid.Column.fromMap ({'id': "start", 'name': "4finish", 'field': "finish"}),
         new grid.Column.fromMap ({'id': "title2", 'name': "5Title1", 'field': "title", 'sortable': true }),
         new grid.Column.fromMap ({'id': "duration2",'width':120, 'name': "6pppppppplete", 'field': "percentComplete", 'sortable': true }),
         new grid.Column.fromMap ({'id': "%2", 'name': "7start", 'field': "start", 'sortable': true })
      ];
      List data=[];
      for (var i = 0; i < 5000; i++) {
        data.add( {
          'title':  new math.Random().nextInt(100).toString(),
          'duration': new math.Random().nextInt(100).toString(),
          'percentComplete': new math.Random().nextInt(10) * 100,
          'start': "01/01/2009",
          'finish': "01/05/2009",
          'effortDriven': (i % 5 == 0)
        });
      }
      Map opt = {'explicitInitialization': false,
                 'multiColumnSort': false,
                 'frozenColumn': 0,
                 'frozenRow': 1,
      };
      grid.SlickGrid sg= new grid.SlickGrid(el,data,column,opt);
      sg.onSort.subscribe( (e, args) {
        grid.Column col = args['sortCol'];
        data.sort( (dataRow1, dataRow2) {
            var field = col.field;
            var sign = args['sortAsc'] ? 1 : -1;
            dynamic value1 = dataRow1[field], value2 = dataRow2[field];
            var result = (value1 == value2 ? 0 : (value1.compareTo(value2)>0 ? 1 : -1)) * sign;
            if (result != 0) {
              return result;
            }
          return 0;
        });
        sg.invalidate();
        sg.render();
      });
      return sg;
    }
        
simple.html

    <!DOCTYPE html>    
    <html>
      <head>
        <meta charset="utf-8">
        <title>Slickdart</title>
        <link rel="stylesheet" href="slickdart.css">
         <link rel="stylesheet" href="packages/slickdart/slick.grid.css" type="text/css"/>
         <link rel="stylesheet" href="packages/slickdart/slick_default_theme.css" type="text/css"/>
         <link rel="stylesheet" href="simple.css" type="text/css"/>
      </head>
      <body>    
          <div style="width:600px;">
            <div class="grid-header" style="width:100%">
                <label>Santa's TODO list:</label>
            </div>
            <div id="grid" style="width:100%;height:500px;"></div>
          </div>   
        <script type="application/dart" src="simple.dart"></script>
        <script src="packages/browser/dart.js"></script>
      </body>
    </html>

Known constraint
========================
* col-span (not tested) 
* using keyboard navigation on non-editable cell and goes out of viewport will not
  immediate update screen until it on editable area 
TODO
========================

- [-] efficent dynamic row height on frozen column
  - sort column should re-calcule height
  - how about insert row or delete row?
  - low performance on horzontal scrolling
- [x] Frozen column, also editable
- [x] Resize column
- [] Column reorder
- [x] auto tooltip


dynamic height
===============================
limitation: visible row:
when calculate numVisibleRows, when we apply dynamic row height, minimal dynamic row height must >= single row hight
Current design: 
- put '_height' on row object to specify pixel height  
- add {'dynamicHeight': true} option to turn on it  
