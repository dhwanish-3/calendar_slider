**CalendarSlider widget with a lot of customization**

<p align="left">
<a href="https://github.com/dhwanish-3/calendar_slider"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

# Getting Started

1. Depend on it
Add it to your package's pubspec.yaml file
```yaml
dependencies:
  flutter:
    sdk: flutter
  calendar_slider: version
```
2. Install it
Install packages from the command line
```sh
flutter pub get calendar_slider
```
3. Import it
Import it to your project
```dart
import 'package:calendar_slider/calendar_slider.dart';
```

 SelectedDayPosition.center         |  SelectedDayPosition.Left      | SelectedDayPosition.Right
:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/dhwanish-3/calendar_slider/main/assets/position_centre.png) | ![](https://raw.githubusercontent.com/dhwanish-3/calendar_slider/main/assets/position_left.png) | ![](https://raw.githubusercontent.com/dhwanish-3/calendar_slider/main/assets/position_right.png)

 FullCalendarScroll.vertical         |  FullCalendarScroll.horizontal
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/dhwanish-3/calendar_slider/main/assets/full_calendar_vertical.jpg) | ![](https://raw.githubusercontent.com/dhwanish-3/calendar_slider/main/assets/full_calendar_horizontal.jpg)


### Demo

![Demo](https://raw.githubusercontent.com/dhwanish-3/calendar_slider/main/assets/demo.gif)

# How to use?

Use the **CalendarAgenda** Widget
```dart
CalendarAgenda(
  initialDate: DateTime.now(),
  firstDate: DateTime.now().subtract(Duration(days: 140)),
  lastDate: DateTime.now().add(Duration(days: 4)),
  onDateSelected: (date) {
                    print(date);
                  },
)
```

# Props

| Props  | Types  | Required  | defaultValues  |
| ------------ | ------------ | ------------ |  ------------ |
| initialDate  | DateTime  | True  |
| firstDate  |  DateTime | True  |
| lastDate  | DateTime  | True  |
| onDateSelected  | Funtion  | False  |
| controller  | CalendarAgendaController?  | False  |
| backgroundColor  | Color?  | False  | Colors.transparent |
| tileHeight  | double?  | False  | 60.0 |
| selectedTileHeight  | double?  | False  | 75.0 |
| dateColor  | Color?  | False  | Colors.black |
| selectedDateColor  | Color?  | False  | Colors.black |
| tileShadow | BoxShadow? | False | BoxShadow(color: Colors.black.withOpacity(0.13),spreadRadius: 1,blurRadius: 2,offset: const Offset(0, 2),), |
| tileBackgroundColor  | Color?  | False  | Colors.white |
| selectedTileBackgroundColor  | Color?  | False  | Colors.blue |
| monthYearTextColor  | Color?  | False  | Colors.black |
| monthYearButtonBackgroundColor  | Color?  | False  | Colors.grey |
| calendarEventSelectedColor  | Color?  | False  | Colors.white |
| calendarEventColor  | Color?  | False  | Colors.blue |
| fullCalendarBackgroundImage | DecorationImage? | False | null |
| locale  | String?  | False  | 'en' |
| events  | List\<DateTime>?  | False  | [] |
| fullCalendar  | bool  | False  | True |
| fullCalendarScroll  | FullCalendarScroll  | False  |FullCalendarScroll.horizontal |
| weekDay  | WeekDay  | False  | WeekDay.short |
| fullCalendarWeekDay  | WeekDay  | False  | WeekDay.short |
| selectedDayPosition  | SelectedDayPosition  | False  | SelectedDayPosition.center |

---



## Thank you
Special thanks goes to all contributors to this package. Make sure to check them out.<br />

<a href="https://github.com/dhwanish-3/calendar_slider/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=dhwanish-3/calendar_slider" />
</a>
