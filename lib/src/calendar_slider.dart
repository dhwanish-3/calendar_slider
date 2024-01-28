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

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function onDateSelected;

  final double selectedTileHeight;
  late final double? selectedTileWidth;
  final double tileHeight;
  late final double? tileWidth;

  final Color? backgroundColor;
  final SelectedDayPosition selectedDayPosition;
  final Color? selectedDateColor;
  final Color? selectedBackgroundColor;
  final Color? monthYearButtonColor;
  final Color? dateColor;
  final Color? calendarBackground;
  final Color? calendarEventSelectedColor;
  final Color? calendarEventColor;
  final FullCalendarScroll fullCalendarScroll;
  final Widget? calendarLogo;
  final ImageProvider<Object>? selectedDayLogo;

  final String? locale;
  final bool? fullCalendar;
  final WeekDay? fullCalendarDay;
  final double? padding;
  final Widget? leading;
  final WeekDay weekDay;
  final bool appbar;
  final double leftMargin;
  final List<DateTime>? events;

  CalendarSlider({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.selectedTileHeight = 75.0,
    this.tileHeight = 60.0,
    this.backgroundColor,
    this.selectedDayLogo,
    this.controller,
    this.selectedDateColor = Colors.black,
    this.selectedBackgroundColor = Colors.blue,
    this.monthYearButtonColor = Colors.grey,
    this.dateColor = Colors.white,
    this.calendarBackground = Colors.white,
    this.calendarEventSelectedColor = Colors.white,
    this.calendarEventColor = Colors.blue,
    this.calendarLogo,
    this.locale = 'en',
    this.padding,
    this.leading,
    this.appbar = false,
    this.events,
    this.fullCalendar = true,
    this.leftMargin = 0,
    this.fullCalendarScroll = FullCalendarScroll.vertical,
    this.fullCalendarDay = WeekDay.short,
    this.weekDay = WeekDay.short,
    this.selectedDayPosition = SelectedDayPosition.left,
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

  late Color backgroundColor;
  late double padding;
  late Widget leading;
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
    padding = widget.padding ?? 25.0;
    leading = widget.leading ?? Container();
    _scrollAlignment = widget.leftMargin / 440;

    if (widget.events != null) {
      for (var element in widget.events!) {
        _eventDates.add(element.toString().split(" ").first);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    backgroundColor = widget.backgroundColor ?? Theme.of(context).primaryColor;
    widget.selectedTileWidth = MediaQuery.of(context).size.width / 6 - 12;
    widget.tileWidth = MediaQuery.of(context).size.width / 7 - 12;

    Widget dayList() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: widget.appbar ? 125 : 100,
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
            // initialAlignment: _scrollAlignment,
            initialAlignment:
                widget.selectedDayPosition == SelectedDayPosition.center
                    ? 84 / 200
                    : _scrollAlignment,
            scrollDirection: Axis.horizontal,
            reverse: widget.selectedDayPosition == SelectedDayPosition.left
                ? false
                : true,
            itemScrollController: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: _dates.length,
            itemBuilder: (context, index) {
              DateTime date = _dates[index];
              bool isSelected = _daySelectedIndex == index;

              return Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () => _goToActualDay(index),
                      child: Container(
                        height: isSelected
                            ? widget.selectedTileHeight
                            : widget.tileHeight,
                        width: isSelected
                            ? widget.selectedTileWidth
                            : widget.tileWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: isSelected
                              ? widget.selectedBackgroundColor
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.13),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _eventDates
                                    .contains(date.toString().split(" ").first)
                                ? isSelected
                                    ? Icon(
                                        Icons.bookmark,
                                        size: 16,
                                        color: isSelected
                                            ? widget.selectedDateColor
                                            : widget.dateColor!
                                                .withOpacity(0.5),
                                      )
                                    : Icon(
                                        Icons.bookmark,
                                        size: 8,
                                        color: isSelected
                                            ? widget.calendarEventColor
                                            : widget.dateColor!
                                                .withOpacity(0.5),
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
                ),
              );
            }),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: widget.appbar ? 210 : 150.0,
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 190.0,
              color: backgroundColor,
            ),
          ),
          Positioned(
            top: widget.appbar ? 50.0 : 20.0,
            child: Padding(
              padding: EdgeInsets.only(right: padding, left: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // leading,
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
                                  width: 100.0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: widget.monthYearButtonColor,
                                  ),
                                  child: Text(
                                    ('${DateFormat.yMMMM(Locale(_locale).toString()).format(_selectedDate!).split(' ')[0].substring(0, 3).toUpperCase()} ${DateFormat.yMMMM(Locale(_locale).toString()).format(_selectedDate!).split(' ')[1]}'),
                                    style: const TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontSize: 18.0,
                                      color: Colors.white,
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

    widget.selectedDayPosition == SelectedDayPosition.left
        ? listDates.sort((b, a) => b.compareTo(a))
        : listDates.sort((b, a) => a.compareTo(b));

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
                  fullCalendarDay: widget.fullCalendarDay,
                  calendarScroll: widget.fullCalendarScroll,
                  calendarBackground: widget.calendarLogo,
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
      alignment: widget.selectedDayPosition == SelectedDayPosition.center
          ? 0.42
          : _scrollAlignment,
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
