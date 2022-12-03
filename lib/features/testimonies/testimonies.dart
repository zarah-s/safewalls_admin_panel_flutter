import 'package:flutter/material.dart';
import 'package:flutter_demo/common/data/data.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:responsive_table/responsive_table.dart';

class Testimonies extends StatelessWidget {
  const Testimonies(
      {Key? key,
      required this.onView,
      required this.provider,
      required this.onMessage,
      required this.onSuspend,
      required this.testimonies,
      required this.onActivate,
      required this.onDelete})
      : super(key: key);
  final Function onView;
  final Provider provider;
  final List testimonies;
  final Function(List) onMessage;
  final Function(List) onActivate;
  final Function(List) onSuspend;
  final Function(List) onDelete;
  @override
  Widget build(BuildContext context) {
    var short = provider.apiData;

    List newTestimonies = short.testimonies
        .where((element) => element['seen'].toString() == '0')
        .toList();
    List banned = short.testimonies
        .where((element) => element['suspended'] == 'true')
        .toList();
    return DataPage(
      footer: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text("New Testimonies:"),
          ),
          CircleAvatar(
            backgroundColor: primaryColor,
            radius: 15,
            child: Text(newTestimonies.length.toString()),
          ),
          const SizedBox(
            width: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text("Suspended:"),
          ),
          CircleAvatar(
            backgroundColor: primaryColor,
            radius: 15,
            child: Text(banned.length.toString()),
          )
        ],
      ),
      onActivate: (List data) {
        onActivate(data);
      },
      onDelete: (List data) {
        onDelete(data);
      },
      onMessage: (List data) {
        onMessage(data);
      },
      onSuspend: (List data) {
        onSuspend(data);
      },
      provider: provider,
      title: "TESTIMONIES",
      searchKey: 'testifier',
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
          text: "Testifier",
          value: "testifier",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Testimony",
          value: "testimony",
          show: true,
          flex: 2,
          sortable: true,
          // editable: true,
          sourceBuilder: (value, row) {
            // List list = List.from(value);
            // print(value.toString());
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
          sourceBuilder: (id, row) {
            // List list = List.from(value);
            bool isSuspended = provider.apiData.testimonies
                .where(
                  (element) =>
                      element['suspended'] == 'true' &&
                      element['id'].toString() == id.toString(),
                )
                .isNotEmpty;
            return Center(
              child: DropdownButton(
                  value: "Actions",
                  items: [
                    'Actions',
                    'Message',
                    isSuspended ? 'Activate' : 'Suspend',
                    'Delete'
                  ]
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: TextWidget(
                            text: e.toString(),
                          )))
                      .toList(),
                  onChanged: (e) {
                    if (e == "Message") {
                      var userId = provider.apiData.testimonies.singleWhere(
                          (element) =>
                              element['id'].toString() ==
                              id.toString())['userId'];

                      var testifier = [
                        ...provider.apiData.users,
                        ...provider.apiData.pros
                      ].singleWhere(
                        (element) => element['id'] == userId,
                      )['handle'];
                      onMessage([
                        {'testifier': testifier}
                      ]);
                    } else if (e == 'Activate') {
                      onActivate([
                        {'testimony': id}
                      ]);
                    } else if (e == 'Suspend') {
                      onSuspend([
                        {'testimony': id}
                      ]);
                    } else if (e == 'Delete') {
                      onDelete([
                        {'testimony': id}
                      ]);
                    }
                  }),
            );
          },
          editable: true,
          textAlign: TextAlign.center,
        ),
      ],
      data: testimonies.map((e) {
        String testifier =
            [...provider.apiData.users, ...provider.apiData.pros].singleWhere(
          (element) => element['id'] == e['userId'],
          orElse: () => {'handle': ''},
        )['handle'];
        return {
          'date': DateFormat("dd-MM-yyyy").format(DateTime.parse(e['date'])),
          'testifier': testifier,
          'testimony': e['id'],
          'actions': e['id']
        };
      }).toList(),
    );
  }
}
