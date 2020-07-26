import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  LogIn({Key key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

showloading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              Text("Loding ... "),
              CircularProgressIndicator()
            ],
          ),
        );
      });
}

showdialogall(context, String mytitle, String mycontent) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(mytitle),
          content: Text(mycontent),
          actions: <Widget>[
            FlatButton(
              child: Text("done"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

class _LogInState extends State<LogIn> {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // Start Form Controller

  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmpassword = new TextEditingController();
  GlobalKey<FormState> formstatesignin = new GlobalKey<FormState>();
  GlobalKey<FormState> formstatesignup = new GlobalKey<FormState>();

  savePref(String username, String email , String id ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("id", id);
    preferences.setString("username", username);
    preferences.setString("email", email);
    print(preferences.getString("username"));
    print(preferences.getString("email"));
    print(preferences.getString("id"));
  }

  String validglobal(String val) {
    if (val.isEmpty) {
      return "field can't empty";
    }
  }

  String validusername(String val) {
    if (val.trim().isEmpty) {
      return "لا يمكن ان يكون اسم المستخدم فارغ ";
    }
    if (val.trim().length < 4) {
      return "لا يمكن ان يكون اسم المستخدم اقل من 4 احرف ";
    }
    if (val.trim().length > 20) {
      return "لا يمكن ان يكون اسم المستخدم اكبر من 20 احرف ";
    }
  }

  String validpassword(String val) {
    if (val.trim().isEmpty) {
      return "لا يمكن ان تكون كلمة المرور فارغة ";
    }
    if (val.trim().length < 4) {
      return "لا يمكن ان تكون كلمة المرور اقل من 4 احرف";
    }
    if (val.trim().length > 20) {
      return "لا يمكن ان تكون كلمة المرور اكبر من 20 حرف";
    }
  }

  String validconfirmpassword(String val) {
    if (val != password.text) {
      return "كلمة المرور غير متطابقة";
    }
  }

  String validemail(String val) {
    if (val.trim().isEmpty) {
      return " لا يمكن ان يكون البريد الالكتوني فارغ ";
    }
    if (val.trim().length < 4) {
      return " لا يمكن ان يكون البريد الالكتروني اقل من 4 احرف  ";
    }
    if (val.trim().length > 20) {
      return "لا يمكن ان يكون البريد الالكتروني اكبر من 20 حرف  ";
    }
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(val)) {
      return " عنوان البريد غير صحيح يجب ان يكون على سبيل المثال مثل (example@gmail.com)";
    }
  }

  signin() async {
    var formdata = formstatesignin.currentState;
    if (formdata.validate()) {
      formdata.save();

      showloading(context);
      var data = {"email": email.text, "password": password.text};
      var url = "http://10.0.2.2:8080/mobtech/login.php";
      var response = await http.post(url, body: data);
      var responsebody = jsonDecode(response.body);
      if (responsebody['status'] == "success") {
        savePref(responsebody['username'], responsebody['email'] , responsebody['id']);
        Navigator.of(context).pushNamed("homepage");
      } else {
        print("login faild");
        showdialogall(context, "خطأ", "البريد الالكتروني او كلمة المرور خاطئة");
      }
    } else {
      print("not valid");
    }
  }

  signup() async {
    var formdata = formstatesignup.currentState;
    if (formdata.validate()) {
      formdata.save();
      showloading(context);
      var data = {
        "email": email.text,
        "password": password.text,
        'username': username.text
      };
      var url = "http://10.0.2.2:8080/mobtech/signup.php";
      var response = await http.post(url, body: data);
      var responsebody = jsonDecode(response.body);
      if (responsebody['status'] == "success") {
 
        print("yes success");
        Navigator.of(context).pushNamed("homepage");
      } else {
        print(responsebody['status']);
        Navigator.of(context).pop();
        showdialogall(context, "خطأ", " البريد الالكتروني موجود سابقا ");
      }
    } else {
      print("not valid");
    }
  }

  TapGestureRecognizer _changesign;
  bool showsignin = true;

  @override
  void initState() {
    _changesign = new TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showsignin = !showsignin;
          print(showsignin);
        });
      };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(height: double.infinity, width: double.infinity),
            buildPositionedtop(mdw),
            buildPositionedBottom(mdw),
            Container(
                height: 1000,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Container(
                              margin: EdgeInsets.only(top: 30),
                              child: Text(
                                showsignin ? "تسجيل الدخول " : "انشاء حساب",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: showsignin ? 22 : 25),
                              ))),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      buildContaineraAvatar(mdw),
                      showsignin
                          ? buildFormBoxSignIn(mdw)
                          : buildFormBoxSignUp(mdw),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: <Widget>[
                              showsignin
                                  ? InkWell(
                                      onTap: () {},
                                      child: Text(
                                        "  ? هل نسيت كلمة المرور",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ))
                                  : SizedBox(),
                              SizedBox(height: showsignin ? 24 : 5),
                              RaisedButton(
                                color:
                                    showsignin ? Colors.blue : Colors.grey[700],
                                elevation: 10,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                onPressed: showsignin ? signin : signup,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      showsignin
                                          ? "تسجيل الدخول"
                                          : "انشاء حساب",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 4),
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Cairo'),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: showsignin
                                                  ? "في حال ليس لديك حساب يمكنك "
                                                  : "اذا كان لديك حساب يمكنك"),
                                          TextSpan(
                                              recognizer: _changesign,
                                              text: showsignin
                                                  ? " انشاء حساب من هنا  "
                                                  : " تسجيل الدخول من هنا  ",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w700))
                                        ]),
                                  )),
                              SizedBox(
                                height: 10,
                              ),

                              showsignin ?
                              Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                      ),
                                      Expanded(
                                        child: RaisedButton(
                                          padding: EdgeInsets.all(10),
                                          color: Colors.red[400],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              // Image.asset("images/iconsocial/g.png" , width: 25 , height: 25,) ,
                                              Text(
                                                " Sign In Google ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                      ),
                                      Expanded(
                                        child: RaisedButton(
                                          padding: EdgeInsets.all(10),
                                          color: Colors.blue[800],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              // Image.asset("images/iconsocial/f.png" , width: 25 , height: 25,) ,
                                              Text(
                                                " Sign In facebook ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                      ),
                                    ],
                                  ))
                          :
                          Text("")

                            ],
                          )),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Center buildFormBoxSignIn(double mdw) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        margin: EdgeInsets.only(top: 40),
        height: 250,
        width: mdw / 1.2,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black,
              spreadRadius: .1,
              blurRadius: 1,
              offset: Offset(1, 1))
        ]),
        child: Form(
            autovalidate: true,
            key: formstatesignin,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Start Text Username
                    Text(
                      "البريد الالكتروني",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل البريد الالكتروني", false, email, validemail),
                    // End Text username
                    SizedBox(
                      height: 10,
                    ),
                    // Start Text password
                    Text("كلمة المرور",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل كلمة المرور", true, password, validpassword),
                    // End Text username
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Center buildFormBoxSignUp(double mdw) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOutBack,
        margin: EdgeInsets.only(top: 20),
        height: 403,
        width: mdw / 1.2,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black,
              spreadRadius: .1,
              blurRadius: 1,
              offset: Offset(1, 1))
        ]),
        child: Form(
            key: formstatesignup,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Start Text Username
                    Text(
                      "اسم المستخدم",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل اسم المستخدم", false, username, validusername),
                    // End Text username
                    SizedBox(
                      height: 10,
                    ),
                    // Start Text password
                    Text("كلمة المرور",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل كلمة المرور", true, password, validpassword),
                    // Start Text password CONFIRM
                    Text(" تاكيد كلمة المرور ",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll("تاكيد كلمة المرور", true,
                        confirmpassword, validconfirmpassword),
                    // Start Text EMAIL
                    Text("البريد الالكتروني",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll("ادخل البريد الالكتروني هنا ", false,
                        email, validemail),
                    // End Text username
                  ],
                ),
              ),
            )),
      ),
    );
  }

  TextFormField buildTextFormFieldAll(String myhinttext, bool pass,
      TextEditingController myController, myvalid) {
    return TextFormField(
      controller: myController,
      obscureText: pass,
      validator: myvalid,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          hintText: myhinttext,
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[500], style: BorderStyle.solid, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue, style: BorderStyle.solid, width: 1))),
    );
  }

  AnimatedContainer buildContaineraAvatar(double mdw) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: showsignin ? Colors.yellow : Colors.grey[700],
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 0.1)
          ]),
      child: InkWell(
        onTap: () {
          setState(() {
            showsignin = !showsignin;
          });
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 25,
                right: 25,
                child:
                    Icon(Icons.person_outline, size: 50, color: Colors.white)),
            Positioned(
                top: 35,
                left: 60,
                child: Icon(Icons.arrow_back, size: 30, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Positioned buildPositionedtop(double mdw) {
    return Positioned(
        child: Transform.scale(
      scale: 1.3,
      child: Transform.translate(
        offset: Offset(0, -mdw / 1.7),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mdw),
                color: showsignin ? Colors.grey[800] : Colors.blue)),
      ),
    ));
  }

  Positioned buildPositionedBottom(double mdw) {
    return Positioned(
        top: 300,
        right: mdw / 1.5,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mdw),
                color: showsignin
                    ? Colors.blue[800].withOpacity(0.2)
                    : Colors.grey[800].withOpacity(0.3))));
  }
}
