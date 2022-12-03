// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/appbar/appbar_widget.dart';
import 'package:flutter_demo/common/button/linear_btn.dart';
import 'package:flutter_demo/common/data/list_menu_items.dart';
import 'package:flutter_demo/common/flushbar/show_flushbar.dart';
import 'package:flutter_demo/common/inputs/custom_input.dart';
import 'package:flutter_demo/common/loader/loader.dart';
import 'package:flutter_demo/common/post/post.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/features/auth/login.dart';
import 'package:flutter_demo/features/avatars/add_avatar.dart';
import 'package:flutter_demo/features/avatars/avatars.dart';
import 'package:flutter_demo/features/dashboard/stats.dart';
import 'package:flutter_demo/features/policy/policy.dart';
import 'package:flutter_demo/features/pro_verification/pro_verification.dart';
import 'package:flutter_demo/features/professionals/pro_view.dart';
import 'package:flutter_demo/features/professionals/professionals.dart';
import 'package:flutter_demo/features/promotions/promotions.dart';
import 'package:flutter_demo/features/reports/reports.dart';
import 'package:flutter_demo/features/testimonies/testimonies.dart';
import 'package:flutter_demo/features/users/user_view.dart';
import 'package:flutter_demo/features/users/users.dart';
import 'package:flutter_demo/features/walls/create_wall.dart';
import 'package:flutter_demo/features/walls/edit_wall.dart';
import 'package:flutter_demo/features/walls/walls.dart';
import 'package:flutter_demo/models/data_model.dart';
import 'package:flutter_demo/services/api.dart';
import 'package:flutter_demo/services/post_request.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/services/stream.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:flutter_demo/utils/styles.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Provider());
    final themeStorage = GetStorage();
    themeStorage.writeIfNull("loggedIn", false);
    return SimpleBuilder(builder: (context) {
      bool loggedIn = themeStorage.read("loggedIn") ?? false;
      // print(loggedIn);
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: lightBackground,
            textTheme: GoogleFonts.openSansTextTheme()),
        title: 'Safewalls',
        home: loggedIn ? const HomePage() : const Login(),
      );
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var date = Jiffy().format("d MMM yyyy hh mm a");
  Provider provider = Get.find();
  StreamSocket streamSocket = StreamSocket();
  final _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidateMode;
  bool isLoading = false;
  String oldPassword = '';
  String newPassword = '';
  String message = '';
  Dio dio = Dio();
  Future<void> getData() async {
    try {
      var uri = '$api/adminData';
      final res = await dio.get(uri);
      final data = res.data;
      DataModel dataModel = DataModel.fromJson(data);
      streamSocket.addResponse(dataModel);
      provider.saveApiData(dataModel);
    } catch (e) {
      showFlushbar(provider, "Network interrupted", context, success: false);
    }
  }

  PageController page = PageController();
  int currentPageIndex = 0;
  late RouteType route;
  late dynamic _id;
  void navigateTo(RouteType type) {
    setState(() {
      route = type;
    });
  }

  void back() {
    setState(() {
      route = RouteType.none;
      _id = null;
    });
  }

  showMessageDialog(List data) {
    if (data.isEmpty) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (context, StateSetter setState) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                text: "Send Message",
                fontWeight: FontWeight.w600,
                size: 18,
                color: getblackOpacity(.5),
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel_outlined,
                  color: getblackOpacity(.5),
                ),
              )
            ],
          ),
          content: SizedBox(
            width: 350,
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    onChange: (String value) {
                      setState(() {
                        message = value;
                      });
                    },
                    shouldBreak: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field required";
                      } else {
                        return null;
                      }
                    },
                    label: "Message...",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LinearButton(
                    text: isLoading ? "Sending..." : "Send",
                    onTap: () {
                      if (!isLoading) {
                        setState(() {
                          isLoading = true;
                        });
                        sendMessage(data);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> deleteWall(Map data) async {
    // showFlushbar(provider, "Loading...", context, static: true);
    var res = await ApiRequest(data: {'data': data}, route: 'deleteWall')
        .postRequest();

    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "Successful", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(provider, res['msg'], context, success: false);
    }
  }

  Future<void> suspendFeature(List data, String table) async {
    showFlushbar(provider, "Loading...", context, static: true);
    var res = await ApiRequest(
            data: {'id': data, 'table': table}, route: 'suspendFeature')
        .postRequest();

    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "Successful", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(provider, res['msg'], context, success: false);
    }
  }

  Future<void> proVerify(String id, String certified) async {
    showFlushbar(provider, "Loading...", context, static: true);
    var res = await ApiRequest(
            data: {'id': id, 'certified': certified}, route: 'proVerification')
        .postRequest();

    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "Successful", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(provider, res['msg'], context, success: false);
    }
  }

  Future<void> deleteFeature(List data, String table) async {
    showFlushbar(provider, "Loading...", context, static: true);
    var res = await ApiRequest(
            data: {'ids': data, 'table': table}, route: 'deleteFeature')
        .postRequest();

    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "Successful", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(provider, res['msg'], context, success: false);
    }
  }

  Future<void> activateFeature(List data, String table) async {
    showFlushbar(provider, "Loading...", context, static: true);
    var res = await ApiRequest(
            data: {'id': data, 'table': table}, route: 'activateFeature')
        .postRequest();

    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "Successful", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(provider, res['msg'], context, success: false);
    }
  }

  Future<void> sendMessage(List data) async {
    _formKey.currentState!.save();

    setState(() {
      _autoValidateMode = AutovalidateMode.always;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });

    var res = await ApiRequest(data: {
      'to': data.map((e) => e['seeAll']).toList(),
      'msg': message,
      'date': date
    }, route: 'adminMessage')
        .postRequest();
    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "message delivered", context);
    } else {
      showFlushbar(provider, res['msg'], context, success: false);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> activateUsers(List data) async {
    showFlushbar(provider, "Loading...", context, static: true);
    var res = await ApiRequest(
            data: {'id': data.map((e) => e['seeAll']).toList()},
            route: 'activateAccount')
        .postRequest();

    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "Successful", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(provider, res['msg'], context, success: false);
    }
  }

  Future<void> suspendAccount(List data) async {
    showFlushbar(provider, "Loading...", context, static: true);
    var res = await ApiRequest(
            data: {'id': data.map((e) => e['seeAll']).toList()},
            route: 'suspendAccount')
        .postRequest();

    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "Successful", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(provider, res['msg'], context, success: false);
    }
  }

  Future<void> savePassword() async {
    _formKey.currentState!.save();

    setState(() {
      _autoValidateMode = AutovalidateMode.always;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });

    var res = await ApiRequest(data: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    }, route: 'adminChangePassword')
        .postRequest();
    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(provider, "Password saved", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(provider, res['msg'], context, success: false);
    }
    setState(() {
      isLoading = false;
    });
  }

  showPasswordDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (context, StateSetter setState) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                text: "Change password",
                fontWeight: FontWeight.w600,
                size: 18,
                color: getblackOpacity(.5),
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel_outlined,
                  color: getblackOpacity(.5),
                ),
              )
            ],
          ),
          content: SizedBox(
            width: 350,
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    onChange: (String value) {
                      setState(() {
                        oldPassword = value;
                      });
                    },
                    shouldBreak: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field required";
                      } else {
                        return null;
                      }
                    },
                    label: "Old Password",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputField(
                    onChange: (String value) {
                      setState(() {
                        newPassword = value;
                      });
                    },
                    shouldBreak: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field required";
                      } else {
                        return null;
                      }
                    },
                    label: "New password",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LinearButton(
                    text: isLoading ? "Saving..." : "Save Password",
                    onTap: () {
                      if (!isLoading) {
                        setState(() {
                          isLoading = true;
                        });
                        savePassword();
                        // sendMessage(data);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    route = RouteType.none;
    _autoValidateMode = AutovalidateMode.disabled;
    Timer.periodic(const Duration(seconds: 3), (timer) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Provider>(
      builder: (provider) {
        return Scaffold(
          backgroundColor: lightBackground,
          appBar: customAppbar(context, provider, showPasswordDialog),
          body: StreamBuilder<DataModel>(
              stream: streamSocket.getResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SideMenu(
                        // Page controller to manage a PageView
                        controller: page,
                        // Will shows on top of all items, it can be a logo or a Title text
                        title: const SizedBox(height: 20),

                        style: customSideMenuStyle(),
                        items: Items(
                            provider: provider,
                            page: page,
                            pageIndex: currentPageIndex,
                            onTap: (int e) {
                              back();
                              setState(() {
                                currentPageIndex = e;
                              });
                            }).getList(),
                      ),
                      Expanded(
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: page,
                          children: [
                            Stats(provider: provider),
                            route == RouteType.none
                                ? Users(
                                    onSuspend: (List data) {
                                      suspendAccount(data);
                                    },
                                    onActivate: (List data) {
                                      activateUsers(data);
                                    },
                                    onMessage: (List data) {
                                      // print(data);
                                      showMessageDialog(data);
                                    },
                                    onView: (String id) {
                                      _id = id;
                                      navigateTo(RouteType.userView);
                                    },
                                    provider: provider,
                                  )
                                : UserView(
                                    onActivate: (data) {
                                      activateUsers(data);
                                    },
                                    onMessage: (data) {
                                      showMessageDialog(data);
                                    },
                                    onSuspend: (data) {
                                      suspendAccount(data);
                                    },
                                    id: _id,
                                    provider: provider,
                                    onPressBack: () {
                                      back();
                                    },
                                  ),
                            route == RouteType.none
                                ? Professionals(
                                    onSuspend: (List data) {
                                      suspendAccount(data);
                                    },
                                    onActivate: (List data) {
                                      activateUsers(data);
                                    },
                                    onMessage: (List data) {
                                      showMessageDialog(data);
                                    },
                                    onView: (String id) {
                                      _id = id;
                                      navigateTo(RouteType.professionalView);
                                    },
                                    provider: provider,
                                  )
                                : ProView(
                                    onActivate: (data) {
                                      activateUsers(data);
                                    },
                                    onMessage: (data) {
                                      showMessageDialog(data);
                                    },
                                    onSuspend: (data) {
                                      suspendAccount(data);
                                    },
                                    id: _id,
                                    provider: provider,
                                    onPressBack: () {
                                      back();
                                    },
                                  ),
                            route == RouteType.none
                                ? Walls(
                                    onActivate: (data) {
                                      activateFeature([data], 'walls');
                                    },
                                    onSuspend: (data) {
                                      suspendFeature([data], 'walls');
                                    },
                                    onDelete: (Map data) {
                                      // showFlushbar(
                                      //     provider, "message", context);
                                      deleteWall(data);
                                    },
                                    walls: provider.apiData.walls,
                                    provider: provider,
                                    onCreate: () {
                                      _id = '';

                                      navigateTo(RouteType.newWall);
                                    },
                                    onPressWall: (String id) {
                                      _id = id;

                                      navigateTo(RouteType.editWall);
                                    },
                                  )
                                : route == RouteType.newWall
                                    ? CreateWall(
                                        // id: _id,
                                        provider: provider,
                                        onPressBack: () {
                                          back();
                                        },
                                      )
                                    : EditWall(
                                        onActivate: (data) {
                                          activateFeature([data], 'walls');
                                        },
                                        onSuspend: (data) {
                                          suspendFeature([data], 'walls');
                                        },
                                        onDelete: (Map data) {
                                          // showFlushbar(
                                          //     provider, "message", context);
                                          deleteWall(data);
                                        },
                                        provider: provider,
                                        id: _id,
                                        onPressBack: () {
                                          back();
                                        },
                                      ),
                            route == RouteType.none
                                ? Avatars(
                                    avatars: provider.apiData.avatars,
                                    provider: provider,
                                    onCreate: () {
                                      _id = 'id';

                                      navigateTo(RouteType.newAvatar);
                                    })
                                : AddAvatar(
                                    onPressBack: () {
                                      back();
                                    },
                                    provider: provider,
                                  ),
                            route == RouteType.none
                                ? Reports(
                                    onDelete: (data, table) {
                                      List newData = table == "posts"
                                          ? []
                                          : data
                                              .map(
                                                (e) => e['report'].toString(),
                                              )
                                              .toList();
                                      deleteFeature(
                                        table == 'reports' ? newData : data,
                                        table,
                                      );
                                    },
                                    onActivate: (data, isAccount) {
                                      if (isAccount) {
                                        activateUsers(data);
                                      } else {
                                        activateFeature(data, 'posts');
                                      }
                                    },
                                    onMessage: (List data) {
                                      showMessageDialog(data);
                                    },
                                    onSuspend: (data, isAccount) {
                                      if (isAccount) {
                                        suspendAccount(data);
                                      } else {
                                        suspendFeature(data, 'posts');
                                      }
                                      // suspendFeature(data, 'posts');
                                    },
                                    provider: provider,
                                    onView: (String id) {
                                      _id = id;
                                      navigateTo(RouteType.viewReport);
                                    })
                                : route == RouteType.viewReport
                                    ? Post(
                                        isReport: true,
                                        user: int.tryParse(
                                                  _id,
                                                ).runtimeType ==
                                                int
                                            ? [
                                                ...provider.apiData.users,
                                                ...provider.apiData.pros
                                              ].singleWhere((element) =>
                                                element['id'].toString() ==
                                                provider.apiData.reports
                                                    .singleWhere((rep) =>
                                                        rep['id'].toString() ==
                                                        _id)['reporter'])
                                            : [
                                                ...provider.apiData.users,
                                                ...provider.apiData.pros
                                              ].singleWhere((element) {
                                                return element['id']
                                                        .toString() ==
                                                    provider.apiData.posts
                                                        .singleWhere(
                                                            (post) =>
                                                                post['id']
                                                                    .toString() ==
                                                                _id,
                                                            orElse: () =>
                                                                {})['posterId'];
                                              }, orElse: () => {}),
                                        id: _id,
                                        content: [
                                          ...provider.apiData.reports,
                                          ...provider.apiData.posts
                                        ]
                                                .where((element) =>
                                                    element['id'].toString() ==
                                                    _id)
                                                .map((e) {
                                                  return e['content'] ??
                                                      e['report'];
                                                })
                                                .toList()
                                                .isEmpty
                                            ? 'Deleted'
                                            : [
                                                ...provider.apiData.reports,
                                                ...provider.apiData.posts
                                              ]
                                                .where((element) =>
                                                    element['id'].toString() ==
                                                    _id)
                                                .map((e) {
                                                return e['content'] ??
                                                    e['report'];
                                              }).toList()[0],
                                        // user: ,
                                        onActivate: (_) {},
                                        onDelete: (_) {},
                                        onMessage: (_) {},
                                        onSuspend: (_) {},
                                        onPressBack: () {
                                          back();
                                        },
                                        title: "Reports",
                                      )
                                    : Container(),
                            Policy(
                              provider: provider,
                            ),
                            route == RouteType.none
                                ? Testimonies(
                                    testimonies: provider.apiData.testimonies,
                                    onDelete: (List data) {
                                      List newData = data
                                          .map(
                                            (e) => e['testimony'].toString(),
                                          )
                                          .toList();
                                      deleteFeature(newData, 'testimonies');
                                    },
                                    onSuspend: (List data) {
                                      List newData = data
                                          .map(
                                            (e) => e['testimony'].toString(),
                                          )
                                          .toList();

                                      // print(data);
                                      suspendFeature(newData, 'testimonies');
                                    },
                                    onActivate: (List data) {
                                      List newData = data
                                          .map(
                                            (e) => e['testimony'].toString(),
                                          )
                                          .toList();
                                      activateFeature(newData, 'testimonies');
                                    },
                                    onMessage: (List data) {
                                      // print(data);
                                      List userIds = [
                                        ...provider.apiData.users,
                                        ...provider.apiData.pros
                                      ]
                                          .map((e) {
                                            var userHandle = data.where(
                                                (element) =>
                                                    element['testifier'] ==
                                                    e['handle']);
                                            return {
                                              'seeAll': e['id'],
                                              'filter': userHandle.isEmpty
                                            };
                                            // if (!userHandle.isEmpty) {
                                            //   return {'seeAll': e['id']};
                                            // }
                                          })
                                          .toList()
                                          .where(
                                              (element) => !element['filter'])
                                          .toList();
                                      // print(userIds);
                                      showMessageDialog(userIds);
                                    },
                                    provider: provider,
                                    onView: (String id) {
                                      _id = id;
                                      navigateTo(RouteType.viewTestimony);
                                    },
                                  )
                                : route == RouteType.viewTestimony
                                    ? Post(
                                        onDelete: (data) {
                                          deleteFeature(data, 'testimonies');
                                        },
                                        onMessage: (data) {
                                          showMessageDialog(data);
                                        },
                                        onSuspend: (data) {
                                          suspendFeature(data, 'testimonies');
                                        },
                                        id: _id,
                                        onActivate: (List data) {
                                          activateFeature(data, 'testimonies');
                                        },
                                        content: provider.apiData.testimonies
                                            .singleWhere((element) =>
                                                element['id'].toString() ==
                                                _id)['content'],
                                        date: provider.apiData.testimonies
                                            .singleWhere((element) =>
                                                element['id'].toString() ==
                                                _id)['date'],
                                        user: [
                                          ...provider.apiData.users,
                                          ...provider.apiData.pros
                                        ].singleWhere((element) =>
                                            element['id'].toString() ==
                                            provider.apiData.testimonies
                                                .singleWhere((element) =>
                                                    element['id'].toString() ==
                                                    _id)['userId']),
                                        onPressBack: () {
                                          back();
                                        },
                                        title: "Testimonies",
                                      )
                                    : Container(),
                            route == RouteType.none
                                ? Promotions(
                                    onDelete: (List data) {
                                      List newData = data
                                          .map(
                                            (e) => e['post'].toString(),
                                          )
                                          .toList();
                                      deleteFeature(newData, 'promotes');
                                    },
                                    onSuspend: (List data) {
                                      List newData = data
                                          .map(
                                            (e) => e['post'].toString(),
                                          )
                                          .toList();

                                      // print(data);
                                      suspendFeature(newData, 'promotes');
                                    },
                                    onActivate: (List data) {
                                      List newData = data
                                          .map(
                                            (e) => e['post'].toString(),
                                          )
                                          .toList();
                                      activateFeature(newData, 'promotes');
                                    },
                                    onMessage: (List data) {
                                      // print(data);
                                      List userIds = [
                                        ...provider.apiData.users,
                                        ...provider.apiData.pros
                                      ]
                                          .map((e) {
                                            var userHandle = data.where(
                                                (element) =>
                                                    element['promoter'] ==
                                                    e['handle']);
                                            return {
                                              'seeAll': e['id'],
                                              'filter': userHandle.isEmpty
                                            };
                                            // if (!userHandle.isEmpty) {
                                            //   return {'seeAll': e['id']};
                                            // }
                                          })
                                          .toList()
                                          .where(
                                              (element) => !element['filter'])
                                          .toList();
                                      // print(userIds);
                                      showMessageDialog(userIds);
                                    },
                                    provider: provider,
                                    onView: (String id) {
                                      _id = id;
                                      navigateTo(RouteType.viewPromotions);
                                    },
                                  )
                                : route == RouteType.viewPromotions
                                    ? Post(
                                        onDelete: (data) {
                                          deleteFeature(data, 'promotes');
                                        },
                                        onMessage: (data) {
                                          showMessageDialog(data);
                                        },
                                        onSuspend: (data) {
                                          suspendFeature(data, 'promotes');
                                        },
                                        id: _id,
                                        onActivate: (List data) {
                                          activateFeature(data, 'promotes');
                                        },
                                        content: provider.apiData.posts
                                                .singleWhere((element) =>
                                                    element['id'].toString() ==
                                                    provider.apiData.promotes
                                                        .singleWhere((prom) =>
                                                            prom['id']
                                                                .toString() ==
                                                            _id)['postId'])[
                                            'content'],
                                        // date: DateTime.now().toString(),
                                        user: [
                                          ...provider.apiData.users,
                                          ...provider.apiData.pros
                                        ].singleWhere((element) =>
                                            element['id'].toString() ==
                                            provider.apiData.posts.singleWhere(
                                                (post) =>
                                                    post['id'].toString() ==
                                                    provider.apiData.promotes
                                                            .singleWhere((prom) =>
                                                                prom['id']
                                                                    .toString() ==
                                                                _id)[
                                                        'postId'])['posterId']),
                                        onPressBack: () {
                                          back();
                                        },
                                        title: "Promotions",
                                      )
                                    : Container(),
                            ProVerification(
                              onView: (_) {},
                              provider: provider,
                              onRetract: (id) {
                                proVerify(id, '0');
                              },
                              onAccept: (id) {
                                proVerify(id, '1');
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Loader();
                }
              }),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    streamSocket.dispose();
  }
}

enum RouteType {
  none,
  userView,
  professionalView,
  newWall,
  editWall,
  newAvatar,
  viewReport,
  viewTestimony,
  viewPromotions
}
