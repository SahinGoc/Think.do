import 'package:bitirme_projesi/models/todo.dart';
import 'package:bitirme_projesi/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  AuthService authService = AuthService();

  DocumentReference getDocRef() {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('User')
        .doc(authService.getUser()!.uid);
    return docRef;
  }

  void todoAdd(Todo todo) {
    getDocRef()
        .collection('category')
        .doc(todo.category)
        .collection('Todo')
        .doc(todo.createTime)
        .set(todo.toMap());
  }

  void todoDelete(String category, String createTime) {
    getDocRef()
        .collection('category')
        .doc(category)
        .collection('Todo')
        .doc(createTime)
        .delete();
  }

  void todoUpdate(Todo todo) {
    getDocRef()
        .collection('category')
        .doc(todo.category)
        .collection('Todo')
        .doc(todo.createTime)
        .update(todo.toMap());
  }

  void categoryAdd(String category) {
    getDocRef()
        .collection('category')
        .doc(category)
        .set({'categoryName': category});
  }

  void categoryDelete(String category) {
    Future<QuerySnapshot> todos =
    getDocRef().collection('category').doc(category).collection("Todo").get();
    todos.then((value) {
      value.docs.forEach((element) {
        getDocRef().collection('category').doc(category)
            .collection("Todo")
            .doc(element['createTime'])
            .delete()
            .then((value) => print("success"));
      });
    });
    getDocRef().collection('category').doc(category).delete();
  }
}
