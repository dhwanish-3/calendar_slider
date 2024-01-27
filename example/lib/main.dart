import 'dart:math';

import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example for Calendar Slider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final CalendarSliderController _calendarSliderControllerAppBar =
      CalendarSliderController();
  final CalendarSliderController _calendarSliderControllerNotAppBar =
      CalendarSliderController();

  late DateTime _selectedDateAppBBar;
  late DateTime _selectedDateNotAppBBar;

  Random random = Random();

  @override
  void initState() {
    super.initState();
    _selectedDateAppBBar = DateTime.now();
    _selectedDateNotAppBBar = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarSlider(
        controller: _calendarSliderControllerAppBar,
        appbar: true,
        selectedDayPosition: SelectedDayPosition.right,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        weekDay: WeekDay.long,
        fullCalendarScroll: FullCalendarScroll.horizontal,
        fullCalendarDay: WeekDay.long,
        selectedDateColor: Colors.green.shade900,
        dateColor: Colors.white,
        locale: 'en',
        initialDate: DateTime.now(),
        calendarEventColor: Colors.green,
        firstDate: DateTime.now().subtract(const Duration(days: 140)),
        lastDate: DateTime.now().add(const Duration(days: 60)),
        events: List.generate(
            100,
            (index) => DateTime.now()
                .subtract(Duration(days: index * random.nextInt(5)))),
        onDateSelected: (date) {
          setState(() {
            _selectedDateAppBBar = date;
          });
        },
        calendarLogo: Image.network(
          'https://www.kindpng.com/picc/m/355-3557482_flutter-logo-png-transparent-png.png',
          scale: 5.0,
        ),
        selectedDayLogo: const NetworkImage(
          'https://www.kindpng.com/picc/m/355-3557482_flutter-logo-png-transparent-png.png',
          scale: 15.0,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _calendarSliderControllerAppBar.goToDay(DateTime.now());
              },
              child: const Text("Today, appbar = true"),
            ),
            Text('Selected date is $_selectedDateAppBBar'),
            const SizedBox(
              height: 20.0,
            ),
            CalendarSlider(
              controller: _calendarSliderControllerNotAppBar,
              leading: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text(
                  "Slider anda hari ini adalah sebagai berikut",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // fullCalendar: false,
              locale: 'en',
              weekDay: WeekDay.long,
              fullCalendarDay: WeekDay.short,
              selectedDateColor: Colors.blue.shade900,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 140)),
              lastDate: DateTime.now().add(const Duration(days: 4)),
              events: List.generate(
                  100,
                  (index) => DateTime.now()
                      .subtract(Duration(days: index * random.nextInt(5)))),
              onDateSelected: (date) {
                setState(() {
                  _selectedDateNotAppBBar = date;
                });
              },
              calendarLogo: Image.network(
                'https://www.kindpng.com/picc/m/355-3557482_flutter-logo-png-transparent-png.png',
                scale: 5.0,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _calendarSliderControllerNotAppBar.goToDay(DateTime.now());
              },
              child: const Text("Today, appbar = false (default value)"),
            ),
            Text('Selected date is $_selectedDateNotAppBBar'),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
