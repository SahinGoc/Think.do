class UserData {
  late String uid;
  late String email;
  late String password;

  UserData(String uid, String email){
    this.uid = uid;
    this.email = email;
  }

  UserData.withPassword(String uid, String email, String password){
    this.uid = uid;
    this.email = email;
    this.password = password;
  }

  UserData.withOutInfo();

  UserData.fromMap(Map<String,dynamic> map):
        assert(map["uid"] != null){
    uid = map["uid"];
    email = map["email"];
  }


  Map<String, dynamic> toMap(){
    return {
      "uid" : uid,
      "email" : email,
    };
  }
}