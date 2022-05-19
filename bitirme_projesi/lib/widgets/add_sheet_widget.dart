import 'package:bitirme_projesi/models/todo.dart';
import 'package:bitirme_projesi/services/auth.dart';
import 'package:bitirme_projesi/services/stream.dart';
import 'package:bitirme_projesi/services/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SheetWidget extends StatefulWidget {
  const SheetWidget({Key? key}) : super(key: key);

  @override
  State<SheetWidget> createState() => _SheetWidgetState();
}

class _SheetWidgetState extends State<SheetWidget> {
  TodoService todoService = TodoService();
  AuthService authService = AuthService();
  StreamService streamService = StreamService();

  TextEditingController titleController = TextEditingController();
  TextEditingController dscrptnController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController newCategoryController = TextEditingController();

  String? selectedMenuItem = null;

  late bool isEnable;
  @override
  void initState() {
    titleController.text = '';
    dscrptnController.text = '';
    categoryController.text = '';
    dateController.text = '';
    timeController.text = '';
    newCategoryController.text = '';
    isEnable = true;
    super.initState();
  }

  void dispose() {
    titleController.dispose();
    dscrptnController.dispose();
    categoryController.dispose();
    dateController.dispose();
    timeController.dispose();
    newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildSheet();
  }

  buildSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).bottomSheetTheme.modalBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0))),
              child: Container(
                padding: EdgeInsets.all(20),
                child: ListView(
                  controller: scrollController,
                  children: todoAdd(),
                ),
              ),
            ),
            Positioned(
              top: -30,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                child: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  if (titleController.text != '' &&
                      categoryController.text != '' &&
                      dateController.text != '' &&
                      timeController.text != '') {
                    Todo todo = new Todo(
                        titleController.text,
                        dscrptnController.text,
                        categoryController.text,
                        dateController.text,
                        timeController.text,
                        'deneme',
                        DateTime.now().toString(),
                        '',
                        '');
                    todoService.todoAdd(todo);
                    buildFieldClean();
                  } else {
                    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Gerekli alanları doldurunuz...",
                          style: TextStyle(fontSize: 16),),
                    ));*/
                  }
                },
              ),
            )
          ],
        );
      },
    );
  }

  List<Widget> todoAdd() {
    return [
      SizedBox(
        height: 20,
      ),
      buildTitleField(),
      SizedBox(
        height: 10,
      ),
      buildDscrptnField(),
      SizedBox(
        height: 10,
      ),
      buildCategoryField(),
      SizedBox(
        height: 30,
      ),
      buildDateField(),
      SizedBox(
        height: 30,
      ),
      buildTimeField(),
      //buildRememberField(),
    ];
  }

  buildFieldClean() {
    titleController.text = '';
    dscrptnController.text = '';
    dateController.text = '';
    timeController.text = '';
    Navigator.pop(context);
  }

  buildTitleField() {
    return TextFormField(
      maxLength: 30,
      controller: titleController,
      decoration: InputDecoration(
          labelText: 'Başlık *',
          labelStyle: TextStyle(color: Theme.of(context).iconTheme.color!),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).iconTheme.color!)),
          contentPadding: EdgeInsets.all(10)),
    );
  }

  buildDscrptnField() {
    return TextFormField(
      maxLength: 160,
      minLines: 1,
      maxLines: 5,
      controller: dscrptnController,
      decoration: InputDecoration(
          labelText: 'İçerik',
          labelStyle: TextStyle(color: Theme.of(context).iconTheme.color!),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).iconTheme.color!)),
          contentPadding: EdgeInsets.all(10)),
    );
  }

  buildDateField() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            enabled: false,
            controller: dateController,
            decoration: InputDecoration(
                labelText: 'Tarih *',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(color: Theme.of(context).iconTheme.color!),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Theme.of(context).iconTheme.color!)),
                contentPadding: EdgeInsets.all(10)),
          ),
        ),
        Flexible(
          child: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              setState(() {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 730)))
                    .then((value) {
                  dateController.text = DateFormat.yMMMd().format(value!);
                });
              });
            },
          ),
        )
      ],
    );
  }

  buildTimeField() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            enabled: false,
            controller: timeController,
            decoration: InputDecoration(
                labelText: 'Saat *',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(color: Theme.of(context).iconTheme.color!),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Theme.of(context).iconTheme.color!)),
                contentPadding: EdgeInsets.all(10)),
          ),
        ),
        Flexible(
          child: IconButton(
            icon: Icon(Icons.timer),
            onPressed: () {
              setState(() {
                showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!);
                    }).then((value) {
                  timeController.text = value!.format(context);
                });
              });
            },
          ),
        )
      ],
    );
  }

  buildRememberField() {
    return Container();
  }

  buildCategoryField() {
    return StreamBuilder<QuerySnapshot>(
        stream: streamService.getColRef().snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) return CircularProgressIndicator();
          if(snapshot.hasData){
            List<DocumentSnapshot> list = snapshot.data.docs;
            if (list.isNotEmpty) {
              return Container(
                padding: EdgeInsets.only(bottom: 16.0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: new DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: 'Kategori *',
                            hintText: 'Seçiniz',
                            hintStyle: TextStyle(color: Theme.of(context).hintColor),
                            labelStyle: TextStyle(color: Theme.of(context).iconTheme.color!),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Theme.of(context).iconTheme.color!)),
                            contentPadding: EdgeInsets.all(10)),
                        value: selectedMenuItem,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == "Arşiv" ||
                                newValue == "Tamamlananlar")  {
                              categoryController.text = '';
                            } else {
                              selectedMenuItem = newValue.toString();
                              categoryController.text = selectedMenuItem!;
                            }
                          });
                        },
                        items: list.map<DropdownMenuItem<String>>(
                                (DocumentSnapshot document) {
                              if (document['categoryName'] == "Arşiv" ||
                                  document['categoryName'] == "Tamamlananlar") {
                                isEnable = false;
                              }else{
                                isEnable = true;
                              }
                              return DropdownMenuItem<String>(
                                  value: document['categoryName'],
                                  child: Text(
                                    document['categoryName'],
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        color: isEnable ? Theme.of(context).iconTheme.color : Colors.grey,
                                        decoration: isEnable
                                            ? TextDecoration.none
                                            : TextDecoration.lineThrough),
                                  ));
                            }).toList(),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            Text(
                              "Yeni Kategori",
                              style: TextStyle(color: Theme.of(context).iconTheme.color, fontSize: 12),
                            )
                          ],
                        ),
                        onPressed: () {
                          addCategory();
                        },
                      ),
                      flex: 2,
                    )
                  ],
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
          return CircularProgressIndicator();
        });
  }

  addCategory() {
    var alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      titleTextStyle: TextStyle(fontSize: 16),
      //title: Text("Yeni Kategori Ekle"),
      content: addCategoryFeild(),
      actions: [addCategoryButton()],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  addCategoryFeild() {
    return TextField(
      decoration: InputDecoration(
          labelText: "Yeni Kategori",
          labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          contentPadding: EdgeInsets.all(10)),
      controller: newCategoryController,
    );
  }

  addCategoryButton() {
    return TextButton(
      child: Text(
        "Tamam",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        todoService.categoryAdd(newCategoryController.text);
        Navigator.pop(context);
      },
    );
  }
}
