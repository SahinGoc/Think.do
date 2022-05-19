import 'package:bitirme_projesi/models/todo.dart';
import 'package:bitirme_projesi/screens/home_page.dart';
import 'package:bitirme_projesi/services/auth.dart';
import 'package:bitirme_projesi/services/notifications.dart';
import 'package:bitirme_projesi/services/todo.dart';
import 'package:bitirme_projesi/widgets/edit_sheet_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreamService {
  TodoService todoService = TodoService();
  AuthService authService = AuthService();
  NotificationsService notificationsService = NotificationsService();

  final _currentDate = DateTime.now();
  final _monthFormatter = DateFormat('MMM');

  late String currentCategory;
  late String dateString;

  late double left;
  late double top;

  void setFirstCurrentCategory() {
    currentCategory = "Anasayfa";
  }

  void setCurrentCategory(String category) {
    currentCategory = category;
  }

  void setFirstDateString() {
    dateString = _monthFormatter.format(_currentDate) +
        ' ' +
        _currentDate.day.toString() +
        ', ' +
        _currentDate.year.toString();
  }

  void setDateString(DateTime date) {
    print(date);
    dateString = _monthFormatter.format(date) +
        ' ' +
        date.day.toString() +
        ', ' +
        date.year.toString();
  }

  void setLeft(double left) {
    this.left = left;
  }

  double getLeft() {
    return left;
  }

  void setTop(double top) {
    this.top = top;
  }

  double getTop() {
    return top;
  }

  CollectionReference getColRef() {
    CollectionReference colRef = FirebaseFirestore.instance
        .collection('User')
        .doc(authService.getUser()!.uid)
        .collection('category');
    return colRef;
  }

  Widget getDrawerStream() {
    return StreamBuilder<QuerySnapshot>(
        stream: getColRef().snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Bazı şeyler yanlış gitti!");
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> listDocument = snapshot.data.docs;
            Widget backgroundLeft() {
              return Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                ),
              );
            }
            Widget backgroundRight() {
              return Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: listDocument.length,
              itemBuilder: (context, index) {
                if (listDocument[index]['categoryName'] != "Anasayfa" &&
                    listDocument[index]['categoryName'] != "Arşiv" &&
                    listDocument[index]['categoryName'] != "Tamamlananlar") {
                  return Dismissible(
                    key: UniqueKey(),
                    background: backgroundLeft(),
                    secondaryBackground: backgroundRight(),
                    child: ListTile(
                      dense: true,
                      title: Row(
                        children: [
                          Text('   '),
                          Icon(Icons.arrow_right,
                              color: Theme.of(context).iconTheme.color),
                          Text(listDocument[index]['categoryName']),
                        ],
                      ),
                      onTap: () {
                        setCurrentCategory(listDocument[index]['categoryName']);
                        Navigator.pushReplacement(
                            (context),
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                    listDocument[index]['categoryName'])));
                      },
                    ),
                    onDismissed: (direction) {
                      Navigator.pushReplacement(
                          (context),
                          MaterialPageRoute(
                              builder: (context) => HomePage("Anasayfa")));
                      todoService.categoryDelete(
                          listDocument[index]['categoryName'].toString());
                    },
                  );
                } else {
                  return Visibility(
                    child: ListTile(),
                    visible: false,
                  );
                }
              },
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget getHomePageStream() {
    var ref = getColRef()
        .doc(currentCategory)
        .collection('Todo')
        .where("date", isEqualTo: dateString)
        .orderBy('time')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: ref,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Yanlış giden bişeyler var!");
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> listDocument = snapshot.data.docs;
            Widget backgroundLeft() {
              return Container(
                color: Colors.lightGreen,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.archive,
                  color: Colors.white,
                ),
              );
            }
            Widget backgroundRight() {
              return Container(
                color: Colors.brown,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              );
            }

            if (listDocument.isEmpty) {
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment(-.2, 0),
                      image: AssetImage('assets/image/empty2.png'),
                      fit: BoxFit.fill),
                ),
              );
            }
            return ListView.builder(
                itemCount: listDocument.length,
                itemBuilder: ((context, index) {
                  bool isAlarm() {
                    DateTime date =
                        DateFormat.yMMMd().parse(listDocument[index]["date"]);

                    String dateS = date.toString().substring(0, 10) +
                        ' ' +
                        listDocument[index]["time"] +
                        ':00';
                    DateTime dateTime =
                        DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateS);

                    if (DateTime.now().compareTo(dateTime) == 1) {
                      return false;
                    } else {
                      return true;
                    }
                  }

                  bool isScheduled() {
                    DateTime date =
                        DateFormat.yMMMd().parse(listDocument[index]["date"]);

                    String dateS = date.toString().substring(0, 10) +
                        ' ' +
                        listDocument[index]["time"] +
                        ':00';
                    DateTime dateTime =
                        DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateS);
                    if(isAlarm()){
                      notificationsService.showScheduledNotifications(
                          title: 'Görevini yerine getirmeyi unutma!',
                          body: listDocument[index]["title"],
                          payload: listDocument[index]["description"],
                          scheduledTime: dateTime);
                      return true;
                    }else{
                      return false;
                    }
                  }

                  if (isScheduled()) {
                    print('alarm kuruldu');
                  }else{
                    print('alarm kurulmadı');
                  }
                  return Dismissible(
                    key: UniqueKey(),
                    background: backgroundLeft(),
                    secondaryBackground: backgroundRight(),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: GestureDetector(
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                          title: Text(listDocument[index]["title"].toString(),
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: Theme.of(context).dividerTheme.color,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  isAlarm()
                                      ? Icon(Icons.access_alarms,
                                          size: 16,
                                          color: Theme.of(context).primaryColor)
                                      : Icon(Icons.alarm_off,
                                          size: 16,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    listDocument[index]['time'],
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(listDocument[index]['description']),
                              )
                            ],
                          ),
                          onLongPress: () {
                            showMenu(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              context: context,
                              position: RelativeRect.fromLTRB(getLeft(),
                                  getTop(), getLeft() + 1, getTop() + 10),
                              items: <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: TextButton(
                                    child: Text(
                                      "KALDIR",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      todoService.todoDelete(
                                          listDocument[index]["category"],
                                          listDocument[index]["createTime"]);
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                              elevation: 8.0,
                            );
                          },
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  Todo todo = Todo(
                                      listDocument[index]["title"],
                                      listDocument[index]["description"],
                                      listDocument[index]["category"],
                                      listDocument[index]["date"],
                                      listDocument[index]["time"],
                                      listDocument[index]["rememberTime"],
                                      listDocument[index]["createTime"],
                                      listDocument[index]["complete"],
                                      listDocument[index]["archive"]);
                                  return EditSheetWidget(todo);
                                });
                          },
                        ),
                        onTapDown: (TapDownDetails details) {
                          setLeft(details.globalPosition.dx);
                          setTop(details.globalPosition.dy);
                        },
                      ),
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        Todo todo = new Todo(
                            listDocument[index]["title"],
                            listDocument[index]["description"],
                            "Arşiv",
                            listDocument[index]["date"],
                            listDocument[index]["time"],
                            listDocument[index]["rememberTime"],
                            listDocument[index]["createTime"],
                            '',
                            listDocument[index]["category"]);
                        todoService.todoAdd(todo);
                        todoService.todoDelete(listDocument[index]["category"],
                            listDocument[index]["createTime"]);
                      } else {
                        Todo todo = new Todo(
                            listDocument[index]["title"],
                            listDocument[index]["description"],
                            "Tamamlananlar",
                            listDocument[index]["date"],
                            listDocument[index]["time"],
                            listDocument[index]["rememberTime"],
                            listDocument[index]["createTime"],
                            listDocument[index]["category"],
                            '');
                        todoService.todoAdd(todo);
                        todoService.todoDelete(listDocument[index]["category"],
                            listDocument[index]["createTime"]);
                      }
                    },
                  );
                }));
          }
          return CircularProgressIndicator();
        });
  }

  Widget getArchiveStream() {
    var ref = getColRef()
        .doc("Arşiv")
        .collection("Todo")
        .orderBy('date')
        .orderBy('time');
    return StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Bazı şeyler yanlış gitti!");
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> listDocument = snapshot.data.docs;
            Widget backgroundLeft() {
              return Container(
                color: Colors.deepPurple,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.unarchive,
                  color: Colors.white,
                ),
              );
            }
            Widget backgroundRight() {
              return Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              );
            }

            return ListView.builder(
              itemCount: listDocument.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: backgroundLeft(),
                  secondaryBackground: backgroundRight(),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                      title: Text(listDocument[index]["title"].toString(),
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Theme.of(context).dividerTheme.color,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.alarm_off,
                                  size: 16,
                                  color: Theme.of(context).iconTheme.color),
                              SizedBox(
                                width: 3,
                              ),
                              Text(listDocument[index]['time'],
                                  style: TextStyle(fontSize: 10)),
                              SizedBox(width: 5),
                              Text(listDocument[index]['date'],
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Text(listDocument[index]['description']),
                          )
                        ],
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      Todo todo = new Todo(
                          listDocument[index]["title"],
                          listDocument[index]["description"],
                          listDocument[index]["archive"],
                          listDocument[index]["date"],
                          listDocument[index]["time"],
                          listDocument[index]["rememberTime"],
                          listDocument[index]["createTime"],
                          '',
                          '');
                      todoService.todoAdd(todo);
                      todoService.todoDelete(listDocument[index]["category"],
                          listDocument[index]["createTime"]);
                    } else {
                      todoService.todoDelete(listDocument[index]["category"],
                          listDocument[index]["createTime"]);
                    }
                  },
                );
              },
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget getCompleteStream() {
    var ref = getColRef()
        .doc("Tamamlananlar")
        .collection("Todo")
        .orderBy('date')
        .orderBy('time');
    return StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Bazı şeyler yanlış gitti!");
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> listDocument = snapshot.data.docs;
            Widget backgroundLeft() {
              return Container(
                color: Colors.grey,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
              );
            }
            Widget backgroundRight() {
              return Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              );
            }

            return ListView.builder(
              itemCount: listDocument.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: backgroundLeft(),
                  secondaryBackground: backgroundRight(),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                      title: Text(listDocument[index]["title"].toString(),
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Theme.of(context).dividerTheme.color,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.alarm_off,
                                  size: 16,
                                  color: Theme.of(context).iconTheme.color),
                              SizedBox(
                                width: 3,
                              ),
                              Text(listDocument[index]['time'],
                                  style: TextStyle(fontSize: 10)),
                              SizedBox(width: 5),
                              Text(listDocument[index]['date'],
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Text(listDocument[index]['description']),
                          )
                        ],
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      Todo todo = new Todo(
                          listDocument[index]["title"],
                          listDocument[index]["description"],
                          listDocument[index]["complete"],
                          listDocument[index]["date"],
                          listDocument[index]["time"],
                          listDocument[index]["rememberTime"],
                          listDocument[index]["createTime"],
                          '',
                          '');
                      todoService.todoAdd(todo);
                      todoService.todoDelete(listDocument[index]["category"],
                          listDocument[index]["createTime"]);
                    } else {
                      todoService.todoDelete(listDocument[index]["category"],
                          listDocument[index]["createTime"]);
                    }
                  },
                );
              },
            );
          }
          return CircularProgressIndicator();
        });
  }
}
