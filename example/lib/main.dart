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
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final CalendarSliderController _firstController = CalendarSliderController();
  final CalendarSliderController _secondController = CalendarSliderController();

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
        controller: _firstController,
        selectedDayPosition: SelectedDayPosition.center,
        fullCalendarScroll: FullCalendarScroll.vertical,
        backgroundColor: Colors.lightBlue,
        fullCalendarWeekDay: WeekDay.short,
        selectedTileBackgroundColor: Colors.white,
        monthYearButtonBackgroundColor: Colors.white,
        monthYearTextColor: Colors.black,
        tileBackgroundColor: Colors.lightBlue,
        selectedDateColor: Colors.black,
        dateColor: Colors.white,
        tileShadow: BoxShadow(
          color: Colors.black.withOpacity(1),
        ),
        locale: 'en',
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 100)),
        lastDate: DateTime.now().add(const Duration(days: 100)),
        onDateSelected: (date) {
          setState(() {
            _selectedDateAppBBar = date;
          });
        },
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _firstController.goToDay(DateTime.now());
              },
              child: const Text("Go to today"),
            ),
            Text('Selected date is $_selectedDateAppBBar'),
            const SizedBox(
              height: 20.0,
            ),
            CalendarSlider(
              controller: _secondController,
              selectedDayPosition: SelectedDayPosition.right,
              locale: 'en',
              selectedDateColor: Colors.black,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 140)),
              lastDate: DateTime.now().add(const Duration(days: 400)),
              events: List.generate(
                  100,
                  (index) => DateTime.now()
                      .subtract(Duration(days: index * random.nextInt(5)))),
              onDateSelected: (date) {
                setState(() {
                  _selectedDateNotAppBBar = date;
                });
              },
              fullCalendarBackgroundImage: Image.network(
                'https://www.kindpng.com/picc/m/355-3557482_flutter-logo-png-transparent-png.png',
                scale: 5.0,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _secondController.goToDay(DateTime.now());
              },
              child: const Text("Go to today"),
            ),
            Text('Selected date is $_selectedDateNotAppBBar'),
          ],
        ),
      ),
    );
  }
}
