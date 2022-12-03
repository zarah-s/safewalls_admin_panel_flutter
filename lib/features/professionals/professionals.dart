import 'package:flutter/material.dart';
import 'package:flutter_demo/common/data/data.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:responsive_table/responsive_table.dart';

class Professionals extends StatelessWidget {
  const Professionals(
      {Key? key,
      required this.onView,
      required this.provider,
      required this.onMessage,
      required this.onSuspend,
      required this.onActivate})
      : super(key: key);
  final Function onView;
  final Provider provider;
  final Function(List) onMessage;
  final Function(List) onActivate;
  final Function(List) onSuspend;
  @override
  Widget build(BuildContext context) {
    var short = provider.apiData;

    List newUsers = short.pros
        .where((element) => element['seen'].toString() == '0')
        .toList();
    var banned = [...short.users, ...short.pros]
        .map((e) {
          var ban = short.banned.firstWhere(
            (yo) => yo['userId'] == e['id'],
            orElse: () => null,
          );
          return {...e, 'banned': ban};
        })
        .where((element) => element['banned'] != null)
        .where((chi) => chi['profession'] != null)
        .toList();

    return DataPage(
      footer: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text("New Professionals:"),
          ),
          CircleAvatar(
            backgroundColor: primaryColor,
            radius: 15,
            child: Text(newUsers.length.toString()),
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
      onDelete: (_) {},
      onMessage: (List data) {
        onMessage(data);
      },
      onSuspend: (List data) {
        onSuspend(data);
      },
      provider: provider,
      title: "PROFESSIONALS",
      headers: [
        DatatableHeader(
          text: "User name",
          value: "userName",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Name",
          value: "name",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Location",
          value: "location",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "See all",
          value: "seeAll",
          show: true,
          flex: 2,
          sortable: true,
          // editable: true,
          sourceBuilder: (id, row) {
            // List list = List.from(value);
            // print(row);
            return GestureDetector(
              onTap: () {
                onView(id);
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
            // print(id);
            // List list = List.from(value);
            bool isSuspended = provider.apiData.banned
                .where(
                  (element) => element['userId'] == id,
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
                      onMessage([
                        {'seeAll': id}
                      ]);
                    } else if (e == 'Activate') {
                      onActivate([
                        {'seeAll': id}
                      ]);
                    } else if (e == 'Suspend') {
                      onSuspend([
                        {'seeAll': id}
                      ]);
                    }
                  }),
            );
          },
          editable: true,
          textAlign: TextAlign.center,
        ),
      ],
      data: provider.apiData.pros
          .where((element) =>
              element['id'].toString().toLowerCase() != "safewalls")
          .map((e) {
        return {
          'userName': e['handle'],
          'name': e['userName'],
          'location': e['country'],
          'seeAll': e['id'],
          'actions': e['id']
        };
      }).toList(),
      searchKey: 'userName',
      otherKey: 'location',
    );
  }
}
