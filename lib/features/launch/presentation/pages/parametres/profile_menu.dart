// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/dto/inscription_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/formatters/phone_imput_formatter_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileMenu extends StatefulWidget {
  // UserModel user;

  // ProfileMenu({this.user});

  @override
  _ProfileMenuState createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  AppSharedPreferences appSharedPreferences = AppSharedPreferences();
  UserModel me = UserModel();
  bool isLoading;
  InscriptionDto photoDto = InscriptionDto();
  final formKey = GlobalKey<FormState>();
  InscriptionDto inscriptionDto = InscriptionDto();
  GetInfoDto infoDto = GetInfoDto();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomsController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  File _image;
  final _picker = ImagePicker();

  @override
  void initState() {
    isLoading = true;
    _getUserInfo();

    super.initState();
  }

  _getUserInfo() {
    me = UserModel.fromJson(json.decode(UserPreferences().user));
    infoDto.uIdentifiant = me.authKey;
    infoDto.registrationId = "";
    print("current user " + me.toJson().toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddForm(me);
        },
        child: Icon(Icons.edit_rounded),
      ),
      appBar: AppBar(
        toolbarHeight: 150,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    showChoiceDialog(context);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      me.photo.isEmptyOrNull
                          ? "https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png"
                          : me.photo,
                    ),
                    radius: 40.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "${me.nom} ${me.prenoms}",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: White,
                  ),
                ),
                Text(
                  "Fonction : ${me.profilName}",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: White,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh_rounded),
              onPressed: () {
                getUser();
              })
        ],
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              elevation: 1,
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Nom", style: TextStyle(fontSize: 16)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "${me.nom}",
                          style: TextStyle(
                              fontSize: 18,
                              color: GreenLight,
                              fontWeight: FontWeight.bold),
                        )),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: GreenLight, shape: BoxShape.circle),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Prenoms", style: TextStyle(fontSize: 16)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "${me.prenoms}",
                          style: TextStyle(
                              fontSize: 18,
                              color: GreenLight,
                              fontWeight: FontWeight.bold),
                        )),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: GreenLight, shape: BoxShape.circle),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Identifiant", style: TextStyle(fontSize: 16)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "${me.username}",
                          style: TextStyle(
                              fontSize: 18,
                              color: GreenLight,
                              fontWeight: FontWeight.bold),
                        )),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: GreenLight, shape: BoxShape.circle),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Téléphone", style: TextStyle(fontSize: 16)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "${me.telephoneuser ?? "Non defini..."}",
                          style: TextStyle(
                              fontSize: 18,
                              color: GreenLight,
                              fontWeight: FontWeight.bold),
                        )),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: GreenLight, shape: BoxShape.circle),
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Email", style: TextStyle(fontSize: 16)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "${me.email ?? "Non defini..."}",
                          style: TextStyle(
                              fontSize: 16,
                              color: GreenLight,
                              fontWeight: FontWeight.bold),
                        )),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: GreenLight, shape: BoxShape.circle),
                      child: Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Date de naissance",
                        style: TextStyle(fontSize: 16)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "${FunctionUtils.convertFormatDate(me.datenaissance)}",
                          style: TextStyle(
                              fontSize: 16,
                              color: GreenLight,
                              fontWeight: FontWeight.bold),
                        )),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: GreenLight, shape: BoxShape.circle),
                      child: Icon(
                        Icons.date_range_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Adresse", style: TextStyle(fontSize: 16)),
                    subtitle: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          me.adresseuser ?? "Non defini...",
                          style: TextStyle(
                              fontSize: 18,
                              color: GreenLight,
                              fontWeight: FontWeight.bold),
                        )),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: GreenLight, shape: BoxShape.circle),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  //Pick image from galery
  Future _deleteImage() async {
    setState(() {
      photoDto.photo = "0";
      photoDto.uIdentifiant = me.authKey;
      loadProfil();
    });
  }

  Future _openGallery() async {
    PickedFile pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 300,
        maxWidth: 300);

    setState(() {
      _image = File(pickedFile.path);
      photoDto.photo = "${_image.path}";
      photoDto.uIdentifiant = me.authKey;
      loadProfil();
    });
  }

  //Pick image from camera
  Future getImageFromCamera() async {
    PickedFile pickedFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxHeight: 300,
        maxWidth: 300);
    setState(() {
      _image = File(pickedFile.path);
      photoDto.photo = "${_image.path}";
      photoDto.uIdentifiant = me.authKey;
      loadProfil();
    });
  }

  //Envoyer la photo aux serveur
  loadProfil() async {
    print("user changing...");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(allTranslations.text('processing')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation(FunctionUtils.colorFromHex("")), //a changer
                    )
              ],
            ),
          );
        });

    Api api = ApiRepository();
    api.updateProfilPicture(photoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            UserModel information = a.information.user;
            //enregistrement des informations de l'utilisateur dans la session
            UserPreferences().user = json.encode(information.toJson());
            // enregistrement des modules actifs;
            UserPreferences().menus =
                json.encode(a.information.menus.toList().toString());
            print(UserPreferences().user);
            print(UserPreferences().menus);
            print("User profil update succes");
            setState(() {
              me = information;
            });
            Navigator.of(context).pop(null);
            _displaySnackBar(a.message);
            return true;
          } else {
            //l'api a retourne une Erreur
            Navigator.of(context).pop(null);
            _displaySnackBar(a.message);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        _displaySnackBar(allTranslations.text('error_process'));
        return false;
      }
    });
  }

  //Choix de la methode de pick d'image
  Future<void> showChoiceDialog(BuildContext context) async {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 250,
        child: Stack(
          children: <Widget>[
            Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    top: 60.0, bottom: 10.0, left: 10.0, right: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.remove_red_eye_rounded),
                        title: Text(allTranslations.text('detail_photo')),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        onTap: () {
                          Navigator.pop(context, true);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                body: Image.network(
                                  me.photo,
                                  filterQuality: FilterQuality.medium,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                ),
                              );
                            },
                          ));
                        },
                      ),
                      // ListTile(
                      //   leading: Icon(Icons.delete),
                      //   title: Text(allTranslations.text('delete_photo')),
                      //   dense: true,
                      //   visualDensity: VisualDensity.compact,
                      //   onTap: () {
                      //     Navigator.pop(context, true);
                      //     _deleteImage();
                      //   },
                      // ),
                      ListTile(
                        leading: Icon(Icons.photo),
                        title: Text(allTranslations.text('galerie_select')),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        onTap: () {
                          Navigator.pop(context, true);
                          _openGallery();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo),
                        title: Text(allTranslations.text('camera_select')),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        onTap: () {
                          Navigator.pop(context, true);
                          getImageFromCamera();
                        },
                      ),
                    ],
                  ),
                )),
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: GreenLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  allTranslations.text('type_select'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  void showAddForm(UserModel user) {
    if (user != null) {
      setState(() {
        _usernameController.text = user.username;
        _nomController.text = user.nom;
        _prenomsController.text = user.prenoms;
        _emailController.text = user.email;
        _telephoneController.text = user.telephoneuser;
        _birthdayController.text = user.datenaissance;
      });
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // contentPadding: EdgeInsets.all(8),
            scrollable: true,
            content: Stack(
              // fit: StackFit.loose,
              children: <Widget>[
                userForm(context),
              ],
            ),
            actions: [
              TextButton(
                  child: Text(allTranslations.text('cancel')),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                child: Text(allTranslations.text('submit')),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    inscriptionDto.uIdentifiant = me.authKey ?? "";
                    inscriptionDto.username = _usernameController.text ?? "";
                    inscriptionDto.email = _emailController.text ?? "";
                    inscriptionDto.nom = _nomController.text ?? "";
                    inscriptionDto.prenoms = _prenomsController.text ?? "";
                    String tel = (_telephoneController.text).trim();
                    tel = tel.replaceAll("(", "");
                    tel = tel.replaceAll(")", "");
                    tel = tel.replaceAll(" ", "");
                    inscriptionDto.telephone = tel ?? "";
                    inscriptionDto.dateNaissance =
                        _birthdayController.text ?? "";
                    inscriptionDto.adresse =
                        (json.encode(me.adresseuser)).toString();
                    inscriptionDto.registrationId = "";
                    Navigator.pop(context);
                    changeUser();
                    print('Centre modifié');
                  }
                },
              ),
            ],
          );
        });
  }

  Form userForm(BuildContext context) {
    return Form(
        key: this.formKey,
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                    // margin: EdgeInsets.all(10.0),
                    child: Column(
                  children: [
                    TextFormField(
                      controller: _nomController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: Vx.m2,
                        border: OutlineInputBorder(),
                        labelText: allTranslations.text('lastname'),
                        prefixIcon: Icon(
                          Icons.person_rounded,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return allTranslations.text('pls_set_lastname');
                        }
                        return null;
                      },
                    ) /* .py12() */,
                    TextFormField(
                      controller: _prenomsController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: Vx.m2,
                        border: OutlineInputBorder(),
                        labelText: allTranslations.text('firstname'),
                        prefixIcon: Icon(
                          Icons.person_rounded,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return allTranslations.text('pls_set_firstname');
                        }
                        return null;
                      },
                    ).py12(),
                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: Vx.m2,
                        border: OutlineInputBorder(),
                        labelText: allTranslations.text('username'),
                        prefixIcon: Icon(
                          Icons.person_rounded,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return allTranslations.text('pls_set_username');
                        }
                        return null;
                      },
                    ) /* .py12() */,
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: Vx.m2,
                        border: OutlineInputBorder(),
                        labelText: allTranslations.text('email'),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return allTranslations.text('pls_set_email');
                        }
                        return null;
                      },
                    ).py12(),
                    // Formatage du tel
                    TextFormField(
                      controller: _telephoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        PhoneNumberFormatter(),
                        LengthLimitingTextInputFormatter(17),
                      ],
                      decoration: InputDecoration(
                        contentPadding: Vx.m2,
                        border: OutlineInputBorder(),
                        labelText: allTranslations.text('telephone'),
                        // hintText: "Expl: 228 99 88 77 66",
                        hintText: "Expl: (228) 99 88 77 66",
                        prefixIcon: Icon(
                          Icons.phone,
                        ),
                      ),
                      // onChanged: (value) {
                      //   String newText =
                      //       numFormatter(_telephoneController.text);
                      //   setState(() {
                      //     _telephoneController.text = newText;
                      //   });
                      //   debugPrint("\n" + newText);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return allTranslations.text('pls_set_telephone');
                        }
                        return null;
                      },
                    ),
                    // TextFormField(
                    //   controller: _telephoneController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: InputDecoration(
                    //     contentPadding: Vx.m2,
                    //     border: OutlineInputBorder(),
                    //     labelText: allTranslations.text('telephone'),
                    //     hintText: "Expl: 22899887766",
                    //     prefixIcon: Icon(
                    //       Icons.phone,
                    //     ),
                    //   ),
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return allTranslations.text('pls_set_telephone');
                    //     }
                    //     return null;
                    //   },
                    // ),
                  ],
                )),
              ],
            ),
          ),
        ));
  }

  numFormatter(String text) {
    if (text.length >= 1 && text.length <= 3) {
      text = ('(' + text + ') ');
      // if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (text.length <= 8) {
      text = (text + ' ');
      // if (newValue.selection.end >= 4) selectionIndex += 2;
    }
    if (text.length <= 11) {
      text = (text + ' ');
      // if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (text.length <= 14) {
      text = (text + ' ');
      // if (newValue.selection.end >= 9) selectionIndex++;
    }
    if (text.length <= 17) {
      text = (text + ' ');
      // if (newValue.selection.end >= 12) selectionIndex++;
    }
    return text;
  }

  /// envoie des donnees au serveur {
  changeUser() async {
    print("user changing...");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(allTranslations.text('processing')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation(FunctionUtils.colorFromHex("")), //a changer
                    )
              ],
            ),
          );
        });

    Api api = ApiRepository();
    api.updateProfil(inscriptionDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            UserModel information = a.information.user;
            //enregistrement des informations de l'utilisateur dans la session
            UserPreferences().user = json.encode(information.toJson());
            // enregistrement des modules actifs;
            UserPreferences().menus =
                json.encode(a.information.menus.toList().toString());
            print(UserPreferences().user);
            print(UserPreferences().menus);
            setState(() {
              me = information;
              // print("En Widget${me.toJson().toString()}");
            });
            Navigator.of(context).pop(null);
            _displaySnackBar(a.message);
            return true;
          } else {
            //l'api a retourne une Erreur
            Navigator.of(context).pop(null);
            _displaySnackBar(a.message);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        _displaySnackBar(allTranslations.text('error_process'));
        return false;
      }
    });
  }

  getUser() async {
    print("user changing...");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(allTranslations.text('processing')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation(FunctionUtils.colorFromHex("")), //a changer
                    )
              ],
            ),
          );
        });

    Api api = ApiRepository();
    api.getUserInfo(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            UserModel information = a.information.user;
            //enregistrement des informations de l'utilisateur dans la session
            UserPreferences().user = json.encode(information.toJson());
            // enregistrement des modules actifs;
            UserPreferences().menus =
                json.encode(a.information.menus.toList().toString());
            print(UserPreferences().user);
            print(UserPreferences().menus);
            setState(() {
              me = information;
            });
            Navigator.of(context).pop(null);
            // _displaySnackBar(a.message);
            return true;
          } else {
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'),
            type: 0);
        // _displaySnackBar(allTranslations.text('error_process'));
        return false;
      }
    });
  }

  _displaySnackBar(message) {
    if (message == null) {
      message = "Operation en cours";
    }
    Flushbar(
      // title: allTranslations.text(''),
      title: "Information",
      message: message,
      duration: Duration(seconds: 4),
    )..show(context);
  }

// End of class
}
