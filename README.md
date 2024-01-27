**CalendarSllider widget with a lot of customization**

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
![](https://github.com/sud0su/calendar_agenda/blob/main/assets/selectedDayCenter.png?raw=true) | ![](https://github.com/sud0su/calendar_agenda/blob/main/assets/selectedDayLeft.png?raw=true) | ![](https://github.com/sud0su/calendar_agenda/blob/main/assets/selectedDayRight.png?raw=true)

 FullCalendarScroll.vertical         |  FullCalendarScroll.horizontal
:-------------------------:|:-------------------------:
![](https://github.com/sud0su/calendar_agenda/blob/main/assets/FullCalendarScrollVertical.png?raw=true) | ![](https://github.com/sud0su/calendar_agenda/blob/main/assets/FullCalendarScrollHorizontal.png?raw=true)


### Demo

![](https://github.com/sud0su/calendar_agenda/blob/main/assets/demo.gif?raw=true)

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
| initialDate  | DateTime  | True  | |
| firstDate  |  DateTime | True  | |
| lastDate  | DateTime  | True  | |
| onDateSelected  | Funtion  | False  | |
| backgroundColor  | Color?  | False  | |
| selectedDayLogo  | ImageProvider\<Object>?  | False  | |
| controller  | CalendarAgendaController?  | False  | |
| selectedDateColor  | Color?  | False  | Colors.black |
| dateColor  | Color?  | False  | Colors.white |
| calendarBackground  | Color?  | False  |Colors.white |
| calendarEventSelectedColor  | Color?  | False  | Colors.white |
| calendarEventColor  | Color?  | False  | Colors.blue |
| locale  | String?  | False  | 'en' |
| leading  | Widget?  | False  | |
| appbar  | bool  | False  | False |
| events  | List\<DateTime>?  | False  | |
| fullCalendar  | bool  | False  | True |
| fullCalendarScroll  | FullCalendarScroll  | False  |FullCalendarScroll.vertical |
| fullCalendarDay  | WeekDay  | False  | WeekDay.short |
| weekDay  | WeekDay  | False  | WeekDay.short |
| selectedDayPosition  | SelectedDayPosition  | False  | SelectedDayPosition.left |

---



## Thank you
Special thanks goes to all contributors to this package. Make sure to check them out.<br />

<a href="https://github.com/dhwanish-3/calendar_slider/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=dhwanish-3/calendar_slider" />
</a>
