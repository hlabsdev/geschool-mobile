import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class DetailCenter extends StatefulWidget {
  UserModel me;
  DetailCenter({this.me});
  @override
  _DetailCenterState createState() => _DetailCenterState();
}

const kExpandedHeight = 300.0;

class _DetailCenterState extends State<DetailCenter> {
  List<CentreModel> information = [];
  GetInfoDto infoDto = GetInfoDto();
  bool isLoading;
  bool error = false;
  bool isAdmin = false;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Centre"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 20.0),
            icon: Icon(
              Icons.refresh_rounded,
              size: 30.0,
            ),
            onPressed: () {
              getInfos();
            },
          ),
        ],
      ),
      body: RefreshableWidget(
        error: error,
        information: information,
        isLoading: isLoading,
        noDataText: Text("Information du centre non disponible"),
        onRefresh: getInfos,
        child: ListView(
          children: List.generate(
              information.length,
              (i) => ExpansionTile(
                    title: Text(information[i].denominationCenter ??
                        allTranslations.text('not_defined')),
                    children: [
                      Card(
                        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                        elevation: 1,
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              subtitle: Center(
                                  child: Text("Logo",
                                      style: TextStyle(fontSize: 16))),
                              title: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  information[i].lienlogo ??
                                      "https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png",
                                ),
                                radius: 40.0,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Dénomination",
                                  style: TextStyle(fontSize: 16)),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    information[i].denominationCenter ??
                                        allTranslations.text('not_defined'),
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
                                  Icons.settings_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Nom court",
                                  style: TextStyle(fontSize: 16)),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    information[i].nomcourt ??
                                        allTranslations.text('not_defined'),
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
                                  Icons.settings_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Region",
                                  style: TextStyle(fontSize: 16)),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    information[i].region ??
                                        allTranslations.text('not_defined'),
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
                                  Icons.location_city,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Prefecture",
                                  style: TextStyle(fontSize: 16)),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    information[i].prefecture ??
                                        allTranslations.text('not_defined'),
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
                                  Icons.my_location_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Localité",
                                  style: TextStyle(fontSize: 16)),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    information[i].localiteCenter ??
                                        allTranslations.text('not_defined'),
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
                            Divider(),
                            ListTile(
                              title:
                                  Text("Email", style: TextStyle(fontSize: 16)),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    information[i].emailcentre ??
                                        allTranslations.text('not_defined'),
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
                              title: Text("Téléphone",
                                  style: TextStyle(fontSize: 16)),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    information[i].telephonecentre ??
                                        allTranslations.text('not_defined'),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  )),
        ),
      ),
    );
  }

  void loading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  void checkAdmin(int value) {
    setState(() {
      isAdmin = value == 1 ? true : false;
    });
  }

  // ignore: missing_return
  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getCentre(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            if (widget.me.idcenters.contains("1")) {
              information = a.information;
            } else {
              information.clear();
              for (var cent in a.information) {
                for (var item in widget.me.idcenters) {
                  if (cent.idCenter.toString() == item &&
                      !information.contains(cent)) {
                    information.add(cent);
                  }
                }
              }
            }
            loading(false);
            return true;
          } else {
            // Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message);
            return false;
          }
        });
      } else if (value.isLeft()) {
        setState(() {
          error = true;
        });
        loading(false);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
      }
    }, onError: (error) {
      loading(false);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

/* End */
}
