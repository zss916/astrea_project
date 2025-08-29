import 'package:awesome_datetime_picker/src/data/format.dart';
import 'package:awesome_datetime_picker/src/data/picker_type.dart';
import 'package:awesome_datetime_picker/src/models/awesome_time.dart';
import 'package:awesome_datetime_picker/src/theme/awesome_time_picker_theme.dart';
import 'package:awesome_datetime_picker/src/utils/awesome_time_utils.dart';
import 'package:awesome_datetime_picker/src/utils/validation_utils.dart';
import 'package:awesome_datetime_picker/src/widgets/custom/awesome%20pickers/awesome_am_pm_picker_widget.dart';
import 'package:awesome_datetime_picker/src/widgets/custom/awesome%20pickers/awesome_hour_picker_widget.dart';
import 'package:awesome_datetime_picker/src/widgets/custom/awesome%20pickers/awesome_minute_picker_widget.dart';
import 'package:flutter/material.dart';

class AwesomeTimePicker extends StatefulWidget {
  AwesomeTimePicker(
      {super.key,
      this.minTime,
      this.maxTime,
      this.initialTime,
      this.timeFormat = AwesomeTimeFormat.Hm,
      this.theme,
      this.onChanged,
      this.backgroundColor,
      this.fadeEffect,
      this.selectedTextStyle,
      this.unselectedTextStyle,
      this.selectorColor,
      this.visibleItemCount,
      this.itemHeight,
      this.itemWidth,
      this.isToday})
      : assert(
          ValidationUtils.isValidTimeRange(minTime: minTime, maxTime: maxTime),
          'minTime must be before maxTime',
        ),
        assert(
          ValidationUtils.isValidInitialTime(
              time: initialTime, minTime: minTime, maxTime: maxTime),
          'initialTime must be within minTime and maxTime range',
        );

  /// The minimum selectable time for the time picker (default 00:00).
  final AwesomeTime? minTime;

  /// The maximum selectable time for the time picker (default 23:59).
  final AwesomeTime? maxTime;

  /// The initial time displayed when the picker is first shown (default current time).
  final AwesomeTime? initialTime;

  /// The format of the time to be displayed in the picker (default [AwesomeTimeFormat.Hm]).
  final AwesomeTimeFormat timeFormat;

  /// The theme for customizing the appearance of the time picker (hour, minute themes).
  final AwesomeTimePickerTheme? theme;

  /// A callback function that is triggered when the selected time changes.
  final ValueChanged<AwesomeTime>? onChanged;

  /// The background color of the time picker.
  /// This value is overridden by the value passed in the theme's backgroundColor property.
  final Color? backgroundColor;

  /// The color of the selector (highlight) used in the time picker.
  final Color? selectorColor;

  /// A flag to indicate whether to apply a fade effect on the edges of the time picker (default true).
  final bool? fadeEffect;

  /// The text style for the selected time (customize font, size, color, etc.).
  /// This value is overridden by the value passed in the theme's selectedTextStyle property.
  final TextStyle? selectedTextStyle;

  /// The text style for the unselected times (customize font, size, color, etc.).
  /// This value is overridden by the value passed in the theme's unselectedTextStyle property.
  final TextStyle? unselectedTextStyle;

  /// The number of visible items in the time picker at once.
  final int? visibleItemCount;

  /// The height of each item in the time picker.
  /// This value is overridden by the value passed in the theme's height property.
  final double? itemHeight;

  /// The width of each item in the time picker.
  /// This value is overridden by the value passed in the theme's width property.
  final double? itemWidth;

  final bool? isToday;

  @override
  State<AwesomeTimePicker> createState() => _AwesomeTimePickerState();
}

class _AwesomeTimePickerState extends State<AwesomeTimePicker> {
  late AwesomeTime selectedTime;
  late AwesomeTime minTime;
  late AwesomeTime maxTime;
  late AwesomeTime initialTime;

  late String selectedAmPm;

  @override
  void initState() {
    minTime = widget.minTime ?? AwesomeTime(hour: 00, minute: 00);
    /*if (widget.isToday == true) {
      maxTime = AwesomeTime(
          hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    } else {
      maxTime = widget.maxTime ?? AwesomeTime(hour: 23, minute: 59);
    }*/
    maxTime = widget.maxTime ?? AwesomeTime(hour: 23, minute: 59);

    /*if (widget.isToday == true) {
      initialTime = AwesomeTime(
          hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    } else {
      initialTime = widget.initialTime ??
          AwesomeTime(
              hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    }*/

    initialTime = widget.initialTime ??
        AwesomeTime(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);

    selectedTime = initialTime;

    selectedAmPm = AwesomeTimeUtils.getAmPm(selectedTime.hour);
    super.initState();
  }

  /*@override
  void didUpdateWidget(covariant AwesomeTimePicker oldWidget) {
    if (widget.isToday == true) {
      maxTime = AwesomeTime(
          hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    } else {
      maxTime = widget.maxTime ?? AwesomeTime(hour: 23, minute: 59);
    }

    if (widget.isToday == true) {
      initialTime = AwesomeTime(
          hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    } else {
      initialTime = widget.initialTime ??
          AwesomeTime(
              hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    }

    super.didUpdateWidget(oldWidget);
  }
*/
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.timeFormat.value.length, (index) {
        if (widget.timeFormat.value[index] == PickerType.hour_12) {
          return AwesomeHourPicker(
            key: ValueKey(selectedAmPm == AwesomeTimeUtils.amPm[0]
                ? "hour_picker 1"
                : "hour_picker 2"),
            selectedTime: selectedTime,
            maxTime: maxTime,
            minTime: minTime,
            selectedAmPm: selectedAmPm,
            theme: widget.theme?.minuteTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedHourChanged: (index) {
              selectedTime = AwesomeTime(
                  hour: AwesomeTimeUtils.convertTo24HourFormat(
                      index == 0 ? 12 : index, selectedAmPm),
                  minute: selectedTime.minute);

              DateTime nativeSelectedTime =
                  DateTime(2025, 1, 1, selectedTime.hour, selectedTime.minute);
              if (nativeSelectedTime.isBefore(
                  DateTime(2025, 1, 1, minTime.hour, minTime.minute))) {
                selectedTime = minTime;
              } else if (nativeSelectedTime.isAfter(
                  DateTime(2025, 1, 1, maxTime.hour, maxTime.minute))) {
                selectedTime = maxTime;
              }
              setState(() {});

              widget.onChanged?.call(selectedTime);
            },
          );
        } else if (widget.timeFormat.value[index] == PickerType.hour_24) {
          return AwesomeHourPicker(
            selectedTime: selectedTime,
            maxTime: maxTime,
            minTime: minTime,
            selectedAmPm: null,
            theme: widget.theme?.hourTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedHourChanged: (index) {
              selectedTime =
                  AwesomeTime(hour: index, minute: selectedTime.minute);

              DateTime nativeSelectedTime =
                  DateTime(2025, 1, 1, selectedTime.hour, selectedTime.minute);
              if (nativeSelectedTime.isBefore(
                  DateTime(2025, 1, 1, minTime.hour, minTime.minute))) {
                selectedTime = minTime;
              } else if (nativeSelectedTime.isAfter(
                  DateTime(2025, 1, 1, maxTime.hour, maxTime.minute))) {
                selectedTime = maxTime;
              }
              setState(() {});

              widget.onChanged?.call(selectedTime);
            },
          );
        } else if (widget.timeFormat.value[index] == PickerType.minute) {
          return AwesomeMinutePicker(
            key: ValueKey(selectedTime.hour == minTime.hour
                ? "minute_picker 1"
                : selectedTime.hour == maxTime.hour
                    ? "minute_picker 2"
                    : "minute_picker 3"),
            selectedTime: selectedTime,
            maxTime: maxTime,
            minTime: minTime,
            theme: widget.theme?.minuteTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedMinuteChanged: (index) {
              selectedTime =
                  AwesomeTime(hour: selectedTime.hour, minute: index);

              DateTime nativeSelectedTime =
                  DateTime(2025, 1, 1, selectedTime.hour, selectedTime.minute);
              if (nativeSelectedTime.isBefore(
                  DateTime(2025, 1, 1, minTime.hour, minTime.minute))) {
                selectedTime = minTime;
              } else if (nativeSelectedTime.isAfter(
                  DateTime(2025, 1, 1, maxTime.hour, maxTime.minute))) {
                selectedTime = maxTime;
              }
              setState(() {});

              widget.onChanged?.call(selectedTime);
            },
          );
        } else if (widget.timeFormat.value[index] == PickerType.am_pm) {
          return AwesomeAmPmPicker(
            selectedAmPm: selectedAmPm,
            theme: widget.theme?.minuteTheme,
            backgroundColor: widget.backgroundColor,
            selectorColor: widget.selectorColor,
            fadeEffect: widget.fadeEffect,
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            visibleItemCount: widget.visibleItemCount,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            onSelectedAmPmChanged: (index) {
              selectedAmPm = AwesomeTimeUtils.amPm[index];
              selectedTime.hour =
                  AwesomeTimeUtils.toggleAmPm(selectedTime.hour);
              setState(() {});

              widget.onChanged?.call(selectedTime);
            },
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
