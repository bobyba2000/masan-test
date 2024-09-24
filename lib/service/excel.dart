import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:web_test/model/result/model.dart';
import 'package:web_test/ui/admin/widget/result.dart';

class ExcelService {
  Future<void> createExcel(List<ResultModel> res) async {
    final excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet() ?? '', 'Report');

    final sheet = excel['Report'];
    CellStyle cellTitleStyle = CellStyle(
      backgroundColorHex: ExcelColor.blue50,
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    String printDuration(Duration duration) {
      String negativeSign = duration.isNegative ? '-' : '';
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.abs());
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
      return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
    }

    for (var i = 0; i < DataColName.values.length; i++) {
      final title = DataColName.values[i].name.toUpperCase();
      var cell = sheet.cell(
        CellIndex.indexByColumnRow(
          columnIndex: i,
          rowIndex: 0,
        ),
      );
      cell.value = TextCellValue(title);
      cell.cellStyle = cellTitleStyle;
    }
    for (var j = 0; j < res.length; j++) {
      final data = res[j];
      for (var i = 0; i < DataColName.values.length; i++) {
        final col = DataColName.values[i];
        CellStyle cellStyle = CellStyle();
        CellValue? value;
        switch (col) {
          case DataColName.id:
            value = IntCellValue(j + 1);
            break;
          case DataColName.username:
            value = TextCellValue(data.username);
            break;
          case DataColName.result:
            value = IntCellValue(data.point);
            break;
          case DataColName.time:
            final duration = Duration(seconds: data.time.toInt());
            value = TextCellValue(printDuration(duration));
            break;
        }
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(
            columnIndex: i,
            rowIndex: j + 1,
          ),
        );
        cell.value = value;
        cell.cellStyle = cellStyle;
      }
    }

    excel.save(fileName: 'Report-${DateFormat('yyyyMMddhhmm').format(DateTime.now())}.xlsx');
  }
}
