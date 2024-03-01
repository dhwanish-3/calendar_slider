import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
export 'package:intl/date_symbol_data_local.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
export 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'full_calendar.dart';
import 'types.dart';

class CalendarSliderController {
  CalendarSliderState? state;

  void bindState(CalendarSliderState state) {
    this.state = state;
  }

  void goToDay(DateTime date) {
    state!.getDate(date);
  }

  void dispose() {
    state = null;
  }
}

class CalendarSlider extends StatefulWidget implements PreferredSizeWidget {
  final CalendarSliderController? controller;

  final DateTime initialDate; // date to be shown initially
  final DateTime firstDate; // the lower limit of the date range
  final DateTime lastDate; // the upper limit of the date range
  final Function
      onDateSelected; // function to be called when a date is selected

  final double selectedTileHeight; // height of the selected date tile
  final double tileHeight; // height of the date tile

  final Color? monthYearTextColor; // color of the month year text
  final Color? backgroundColor; // background color for the entire widget
  final SelectedDayPosition
      selectedDayPosition; // position of the selected day(center, left, right)
  final Color? selectedDateColor; // color of the selected date
  final Color? tileBackgroundColor; // background color of the date tile
  final BoxShadow? tileShadow; // shadow of the date tile
  final Color?
      selectedTileBackgroundColor; // background color of the selected date tile
  final Color?
      disabledTileBackgroundColor; // background color of the selected date tile
  final Color?
      monthYearButtonBackgroundColor; // background color of the month year button on top
  final Color? dateColor; // color of the date on each tile
  final Color?
      calendarEventSelectedColor; // color of the event on the selected date
  final Color? calendarEventColor; // color of the event on the date
  final FullCalendarScroll
      fullCalendarScroll; // scroll direction of the full calendar
  final Widget? fullCalendarBackgroundImage; // logo of the calendar

  final String? locale; // locale of the calendar
  final bool? fullCalendar; // if the full calendar is enabled
  final WeekDay? fullCalendarWeekDay;
  final WeekDay
      weekDay; // format of the week day (long or short)("Monday" or "Mon")
  final List<DateTime>? events; // list of events

  final DateTime? disabledTo;
  final DateTime? disabledFrom;

  CalendarSlider({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.controller,
    this.backgroundColor = Colors.transparent,
    this.tileHeight = 60.0,
    this.selectedTileHeight = 75.0,
    this.dateColor = Colors.black,
    this.selectedDateColor = Colors.black,
    this.tileShadow,
    this.tileBackgroundColor = Colors.white,
    this.selectedTileBackgroundColor = Colors.blue,
    this.disabledTileBackgroundColor = Colors.grey,
    this.monthYearTextColor = Colors.white,
    this.monthYearButtonBackgroundColor = Colors.grey,
    this.calendarEventSelectedColor = Colors.white,
    this.calendarEventColor = Colors.blue,
    this.fullCalendarBackgroundImage,
    this.locale = 'en',
    this.events,
    this.fullCalendar = true,
    this.fullCalendarScroll = FullCalendarScroll.horizontal,
    this.weekDay = WeekDay.short,
    this.fullCalendarWeekDay = WeekDay.short,
    this.selectedDayPosition = SelectedDayPosition.center,
    this.disabledTo,
    this.disabledFrom,
  })  : assert(
          initialDate.difference(firstDate).inDays >= 0,
          'initialDate must be on or after firstDate',
        ),
        assert(
          !initialDate.isAfter(lastDate),
          'initialDate must be on or before lastDate',
        ),
        assert(
          !firstDate.isAfter(lastDate),
          'lastDate must be on or after firstDate',
        ),
        super(key: key);

  @override
  CalendarSliderState createState() => CalendarSliderState();

  @override
  Size get preferredSize => const Size.fromHeight(250.0);
}

class CalendarSliderState extends State<CalendarSlider>
    with TickerProviderStateMixin {
  final ItemScrollController _scrollController = ItemScrollController();

  late double padding;
  late double _initialScrollAlignment;
  late double _scrollAlignment;

  final List<String> _eventDates = [];
  List<DateTime> _dates = [];
  DateTime? _selectedDate;
  int? _daySelectedIndex;

  String get _locale =>
      widget.locale ?? Localizations.localeOf(context).languageCode;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(_locale);
    _initCalendar();
    padding = 25.0;
    if (widget.selectedDayPosition == SelectedDayPosition.center) {
      _initialScrollAlignment = 0.44;
      _scrollAlignment = 0.42;
    } else if (widget.selectedDayPosition == SelectedDayPosition.left) {
      _initialScrollAlignment = 0.01;
      _scrollAlignment = 0.02;
    } else {
      _initialScrollAlignment = 0.83;
      _scrollAlignment = 0.842;
    }

    if (widget.events != null) {
      for (var element in widget.events!) {
        _eventDates.add(element.toString().split(" ").first);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double selectedTileWidth = MediaQuery.of(context).size.width / 6 - 12;
    double tileWidth = MediaQuery.of(context).size.width / 7 - 12;

    Widget dayList() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        padding: const EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: ScrollablePositionedList.builder(
            padding: _dates.length < 5
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width *
                        (5 - _dates.length) /
                        10)
                : const EdgeInsets.symmetric(horizontal: 10),
            initialScrollIndex: _daySelectedIndex ?? 0,
            initialAlignment: _initialScrollAlignment,
            scrollDirection: Axis.horizontal,
            itemScrollController: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: _dates.length,
            itemBuilder: (context, index) {
              DateTime date = _dates[index];
              bool isSelected = _daySelectedIndex == index;

              bool isDisabled = widget.disabledTo != null ? (date.isBefore(widget.disabledTo!)) : false;
              isDisabled = !isDisabled && widget.disabledFrom != null ? (date.isAfter(widget.disabledFrom!)) : isDisabled;

              return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 4.0),
                  child: GestureDetector(
                    onTap: isDisabled ? null : () => _goToActualDay(index),
                    child: Container(
                      height: isSelected
                          ? widget.selectedTileHeight
                          : widget.tileHeight,
                      width: isSelected ? selectedTileWidth : tileWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: isDisabled
                              ? widget.disabledTileBackgroundColor
                              : (isSelected
                                ? widget.selectedTileBackgroundColor
                                : widget.tileBackgroundColor
                              ),
                          boxShadow: [
                            widget.tileShadow ??
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.13),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _eventDates.contains(date.toString().split(" ").first)
                              ? isSelected
                                  ? Icon(
                                      Icons.bookmark,
                                      size: 16,
                                      color: isSelected
                                          ? widget.selectedDateColor
                                          : widget.dateColor!.withOpacity(0.5),
                                    )
                                  : Icon(
                                      Icons.bookmark,
                                      size: 8,
                                      color: isSelected
                                          ? widget.calendarEventColor
                                          : widget.dateColor!.withOpacity(0.5),
                                    )
                              : const SizedBox(
                                  height: 5.0,
                                ),
                          Text(
                            widget.weekDay == WeekDay.long
                                ? DateFormat.EEEE(Locale(_locale).toString())
                                    .format(date)
                                : DateFormat.E(Locale(_locale).toString())
                                    .format(date),
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? widget.selectedDateColor
                                  : widget.dateColor,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            DateFormat("dd").format(date),
                            style: TextStyle(
                                fontSize: isSelected ? 20.0 : 16.0,
                                color: isSelected
                                    ? widget.selectedDateColor
                                    : widget.dateColor,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 190.0,
              color: widget.backgroundColor ?? Colors.transparent,
            ),
          ),
          Positioned(
            top: 50,
            child: Padding(
              padding: EdgeInsets.only(right: padding, left: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    widget.fullCalendar!
                        ? GestureDetector(
                            onTap: () => widget.fullCalendar!
                                ? _showFullCalendar(_locale, widget.weekDay)
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color:
                                        widget.monthYearButtonBackgroundColor,
                                  ),
                                  child: Text(
                                    ('${DateFormat.yMMMM(Locale(_locale).toString()).format(_selectedDate!).split(' ')[0].substring(0, 3)}  ${DateFormat.yMMMM(Locale(_locale).toString()).format(_selectedDate!).split(' ')[1]}'),
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontSize: 18.0,
                                      color: widget.monthYearTextColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: dayList(),
          ),
        ],
      ),
    );
  }

  _generateDates() {
    _dates.clear();

    DateTime first = DateTime.parse(
        "${widget.firstDate.toString().split(" ").first} 00:00:00.000");

    DateTime last = DateTime.parse(
        "${widget.lastDate.toString().split(" ").first} 23:00:00.000");

    DateTime basicDate =
        DateTime.parse("${first.toString().split(" ").first} 12:00:00.000");

    List<DateTime> listDates = List.generate(
        (last.difference(first).inHours / 24).round(),
        (index) => basicDate.add(Duration(days: index)));

    setState(() {
      _dates = listDates;
    });
  }

  _showFullCalendar(String locale, WeekDay weekday) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        double height;
        DateTime? endDate = widget.lastDate;

        if (widget.firstDate.year == endDate.year &&
            widget.firstDate.month == endDate.month) {
          height = ((MediaQuery.of(context).size.width - 2 * padding) / 7) * 5 +
              150.0;
        } else {
          height = (MediaQuery.of(context).size.height - 100.0);
        }
        return SizedBox(
          height: widget.fullCalendarScroll == FullCalendarScroll.vertical
              ? height
              : (MediaQuery.of(context).size.height / 7) * 4.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: const Color(0xFFE0E0E0)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: FullCalendar(
                  startDate: widget.firstDate,
                  endDate: endDate,
                  padding: padding,
                  dateColor: Colors.black,
                  dateSelectedBg: widget.calendarEventColor,
                  dateSelectedColor: widget.calendarEventSelectedColor,
                  events: _eventDates,
                  selectedDate: _selectedDate,
                  fullCalendarDay: widget.fullCalendarWeekDay,
                  calendarScroll: widget.fullCalendarScroll,
                  calendarBackground: widget.fullCalendarBackgroundImage,
                  locale: locale,
                  onDateChange: (value) {
                    getDate(value);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _selectedDay() {
    DateTime getSelected = DateTime.parse(
        "${_selectedDate.toString().split(" ").first} 00:00:00.000");

    _daySelectedIndex = _dates.indexOf(_dates.firstWhere((dayDate) =>
        DateTime.parse("${dayDate.toString().split(" ").first} 00:00:00.000") ==
        getSelected));
  }

  _goToActualDay(int index) {
    _moveToDayIndex(index);
    setState(() {
      _daySelectedIndex = index;
      _selectedDate = _dates[index];
    });
    widget.onDateSelected(_selectedDate);
  }

  void _moveToDayIndex(int index) {
    _scrollController.scrollTo(
      index: index,
      alignment: _scrollAlignment,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void getDate(DateTime value) {
    setState(() {
      _selectedDate = value;
    });
    _selectedDay();
    _goToActualDay(_daySelectedIndex!);
  }

  _initCalendar() {
    if (widget.controller != null &&
        widget.controller is CalendarSliderController) {
      widget.controller!.bindState(this);
    }
    _selectedDate = widget.initialDate;
    _generateDates();
    _selectedDay();
  }
}
