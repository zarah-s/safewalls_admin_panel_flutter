import 'package:flutter/material.dart';
import 'package:flutter_demo/common/data/data.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:responsive_table/responsive_table.dart';

class Reports extends StatelessWidget {
  const Reports({
    Key? key,
    required this.onView,
    required this.provider,
    required this.onMessage,
    required this.onSuspend,
    required this.onActivate,
    required this.onDelete,
  }) : super(key: key);
  final Function onView;
  final Provider provider;
  final Function(List) onMessage;
  final Function(List, bool) onActivate;
  final Function(List, bool) onSuspend;
  final Function(List, String) onDelete;
  @override
  Widget build(BuildContext context) {
    var short = provider.apiData;

    List newReports = short.reports
        .where((element) => element['seen'].toString() == '0')
        .toList();
    return DataPage(
      footer: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text("New Reports:"),
          ),
          CircleAvatar(
            backgroundColor: primaryColor,
            radius: 15,
            child: Text(newReports.length.toString()),
          ),
        ],
      ),
      isReport: true,
      onActivate: (List data) {
        onActivate(data, false);
      },
      onDelete: (List data) {
        onDelete(data, 'reports');
      },
      onMessage: (List data) {
        onMessage(data);
      },
      onSuspend: (List data) {
        onSuspend(data, false);
      },
      provider: provider,
      title: "REPORTS",
      searchKey: 'reporter',
      headers: [
        DatatableHeader(
          text: "Date",
          value: "date",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Reporter",
          value: "reporter",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Reporting",
          value: "reporting",
          show: true,
          flex: 2,
          sortable: true,
          // editable: true,
          sourceBuilder: (value, row) {
            // bool isPost
            // List list = List.from(value);
            if (value['isPost']) {
              return GestureDetector(
                onTap: () {
                  onView(value['reporting']);
                },
                child: Icon(
                  Icons.link,
                  color: lightBlue,
                ),
              );
            } else {
              var user = [
                ...provider.apiData.users,
                ...provider.apiData.pros
              ].singleWhere((element) => element['id'] == value['reporting']);
              return TextWidget(
                text: user['handle'],
                centralized: true,
              );
            }
          },
          textAlign: TextAlign.center,
        ),
        // DatatableHeader(
        //   text: "Post Reported",
        //   value: "postReported",
        //   show: true,
        //   flex: 2,
        //   sortable: true,
        //   editable: true,
        //   textAlign: TextAlign.center,
        // ),
        DatatableHeader(
          text: "Report",
          value: "report",
          show: true,
          flex: 2,
          sortable: true,
          // editable: true,

          sourceBuilder: (value, row) {
            // List list = List.from(value);
            return GestureDetector(
              onTap: () {
                onView(value.toString());
              },
              child: Icon(
                Icons.link,
                color: lightBlue,
              ),
            );
          },
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Actions",
          value: "actions",
          show: true,
          flex: 2,
          // sortable: true,
          sourceBuilder: (value, row) {
            // List list = List.from(value);
            if (value['isPost']) {
              var post = provider.apiData.posts.singleWhere(
                (element) => element['id'] == value['reporting'],
                orElse: () => null,
              );
              bool isSuspended = post == null
                  ? false
                  : post['suspended'] == 'true'
                      ? true
                      : false;
              return Center(
                child: DropdownButton(
                    value: "Actions",
                    items: [
                      'Actions',
                      'Message Reporter',
                      'Message post owner',
                      post == null
                          ? 'Post Deleted'
                          : isSuspended
                              ? 'Activate Post'
                              : 'Suspend Post',
                      'Delete Post',
                      'Delete Report'
                    ]
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: TextWidget(
                              text: e.toString(),
                            )))
                        .toList(),
                    onChanged: (e) {
                      if (e == 'Message Reporter') {
                        onMessage([
                          {'seeAll': value['reporter']}
                        ]);
                      } else if (e == 'Message post owner') {
                        var post = provider.apiData.posts.singleWhere(
                            (element) => element['id'] == value['reporting']);
                        onMessage([
                          {'seeAll': post['posterId']}
                        ]);
                      } else if (e == 'Activate Post') {
                        onActivate([value['reporting'].toString()], false);
                      } else if (e == 'Suspend Post') {
                        onSuspend([value['reporting'].toString()], false);
                      } else if (e == 'Delete Post') {
                        onDelete([value['reporting']], 'posts');
                      } else if (e == 'Delete Report') {
                        onDelete([
                          {'report': value['id'].toString()}
                        ], 'reports');
                      }
                    }),
              );
            } else {
              bool isSuspended = provider.apiData.banned
                  .where(
                    (element) => element['userId'] == value['reporting'],
                  )
                  .isNotEmpty;
              return Center(
                child: DropdownButton(
                    value: "Actions",
                    items: [
                      'Actions',
                      'Message Reported',
                      'Message Reporter',
                      isSuspended ? 'Activate Reported' : 'Suspend Reported',
                      'Delete Report'
                    ]
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: TextWidget(
                              text: e.toString(),
                            )))
                        .toList(),
                    onChanged: (e) {
                      if (e == 'Message Reported') {
                        onMessage([
                          {'seeAll': value['reporting']}
                        ]);
                      } else if (e == 'Message Reporter') {
                        onMessage([
                          {'seeAll': value['reporter']}
                        ]);
                      } else if (e == 'Activate Reported') {
                        onActivate([
                          {'seeAll': value['reporting'].toString()}
                        ], true);
                      } else if (e == 'Suspend Reported') {
                        onSuspend([
                          {'seeAll': value['reporting'].toString()}
                        ], true);
                      }
                    }),
              );
            }
          },
          editable: true,
          textAlign: TextAlign.center,
        ),
      ],
      data: provider.apiData.reports.map((e) {
        var reporter = [...provider.apiData.users, ...provider.apiData.pros]
            .singleWhere((element) => element['id'] == e['reporter']);
        return {
          'date': DateFormat("dd-MM-yyyy").format(DateTime.parse(e['date'])),
          'reporter': reporter['handle'],
          'reporting': {
            'reporting': e['reporting'],
            'isPost': e['post'] == '1' ? true : false
          },
          'report': e['id'],
          // 'seeAll': e['id'],
          'actions': {
            'reporting': e['reporting'],
            'isPost': e['post'] == '1' ? true : false,
            ...e
          }
        };
      }).toList(),
    );
  }
}
