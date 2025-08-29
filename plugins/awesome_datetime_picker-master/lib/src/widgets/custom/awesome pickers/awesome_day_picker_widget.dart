import 'package:awesome_datetime_picker/src/models/awesome_date.dart';
import 'package:awesome_datetime_picker/src/theme/item_theme.dart';
import 'package:awesome_datetime_picker/src/utils/awesome_date_utils.dart';
import 'package:awesome_datetime_picker/src/widgets/custom/custom_item_picker_widget.dart';
import 'package:flutter/material.dart';

class AwesomeDayPicker extends StatefulWidget {
  const AwesomeDayPicker({
    super.key,
    required this.selectedDate,
    required this.maxDate,
    required this.minDate,
    required this.onSelectedDayChanged,
    this.theme,
    this.backgroundColor,
    this.fadeEffect,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectorColor,
    this.visibleItemCount,
    this.itemHeight,
    this.itemWidth,
  });
  final AwesomeDate selectedDate;
  final AwesomeDate maxDate;
  final AwesomeDate minDate;
  final Function(int) onSelectedDayChanged;
  final ItemTheme? theme;
  final Color? backgroundColor;
  final Color? selectorColor;
  final bool? fadeEffect;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final int? visibleItemCount;
  final double? itemHeight;
  final double? itemWidth;

  @override
  State<AwesomeDayPicker> createState() => _AwesomeDayPickerState();
}

class _AwesomeDayPickerState extends State<AwesomeDayPicker> {
  @override
  Widget build(BuildContext context) {
    int maxValue = DateUtils.getDaysInMonth(
            widget.selectedDate.year, widget.selectedDate.month),
        minValue = 1;
    if (widget.selectedDate.year == widget.maxDate.year &&
        widget.selectedDate.month == widget.maxDate.month) {
      maxValue = widget.maxDate.day;
    }
    if (widget.selectedDate.year == widget.minDate.year &&
        widget.selectedDate.month == widget.minDate.month) {
      minValue = widget.minDate.day;
    }

    List<String> days = AwesomeDateUtils.getMonthDays(
        widget.selectedDate.year, widget.selectedDate.month);

    return CustomItemPicker(
      items: days,
      initialIndex: days.indexOf(widget.selectedDate.day.toString()),
      maxIndex: maxValue - 1,
      minIndex: minValue - 1,
      onSelectedItemChanged: widget.onSelectedDayChanged,
      theme: widget.theme,
      backgroundColor: widget.backgroundColor,
      fadeEffect: widget.fadeEffect,
      selectedTextStyle: widget.selectedTextStyle,
      unselectedTextStyle: widget.unselectedTextStyle,
      selectorColor: widget.selectorColor,
      visibleItemCount: widget.visibleItemCount,
      itemHeight: widget.itemHeight,
      itemWidth: widget.itemWidth,
    );
  }
}
