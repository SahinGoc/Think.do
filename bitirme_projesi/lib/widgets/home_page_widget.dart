import 'package:bitirme_projesi/services/notifications.dart';
import 'package:bitirme_projesi/services/stream.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePageWidget extends StatefulWidget {
  late String category;
  HomePageWidget(this.category);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState(category);
}

class _HomePageWidgetState extends State<HomePageWidget> {
  String category;

  _HomePageWidgetState(this.category);

  final StreamService streamService = StreamService();
  final NotificationsService notificationsService = NotificationsService();

  late DateTime _currentDate;
  final _monthFormatter = DateFormat('MMM');

  late int currentDay;

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _currentDate = DateTime.now();
    currentDay = _currentDate.day;
    streamService.setFirstDateString();
    streamService.setCurrentCategory(category);
    notificationsService.init(initScheduled: true);
    listenNotifications();
    super.initState();
  }

  void listenNotifications() =>
      notificationsService.onNotifications.stream.listen((value) {
        onClickNotifications(value);
      });

  void onClickNotifications(String? payload) => setState(() {});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => animateToIndex(currentDay));
    return Column(
      children: [
        Row(
          children: [
            Flexible(flex: 1, child: leftArrow()),
            Flexible(
              flex: 12,
              child: SizedBox(
                child: buildCalendar(),
                height: 90,
              ),
            ),
            Flexible(flex: 1, child: rightArrow()),
          ],
        ),
        Expanded(child: streamService.getHomePageStream()),
      ],
    );
  }

  Widget buildCalendar() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 70,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              height: 55.0,
              width: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: index == currentDay - 1
                    ? Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor
                    : Theme.of(context).bottomAppBarColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (index + 1).toString(),
                    style: TextStyle(
                        color: index == currentDay - 1
                            ? Colors.white
                            : Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    //daysNames[index],
                    _monthFormatter.format(_currentDate),
                    style: TextStyle(
                        color: index == currentDay - 1
                            ? Colors.white
                            : Colors.black,
                        fontSize: 8.0,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                currentDay = index + 1;
                DateTime date =
                    DateTime(_currentDate.year, _currentDate.month, currentDay);
                streamService.setDateString(date);
                streamService.setCurrentCategory(widget.category);
              });
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 15.0,
          );
        },
        itemCount: getinDays(),
      ),
    );
  }

  int getinDays() {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    DateTime thisMonth = DateTime(year, month, 0);
    DateTime nextMonth = DateTime(year, month + 1, 0);
    int days = nextMonth.difference(thisMonth).inDays;

    return days;
  }

  void animateToIndex(int index) {
    _controller.animateTo(
      (index - 1) * 75,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  leftArrow() {
    return GestureDetector(
        child: Icon(Icons.keyboard_double_arrow_left),
        onTap: () {
          setState(() {
            DateTime time = DateTime(
                _currentDate.year, _currentDate.month - 1, _currentDate.day);
            _currentDate = time;
          });
        });
  }

  rightArrow() {
    return GestureDetector(
        child: Icon(Icons.keyboard_double_arrow_right),
        onTap: () {
          setState(() {
            DateTime time = DateTime(
                _currentDate.year, _currentDate.month + 1, _currentDate.day);
            _currentDate = time;
          });
        });
  }
}
