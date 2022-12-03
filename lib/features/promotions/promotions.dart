import 'package:flutter/material.dart';
import 'package:flutter_demo/common/data/data.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:responsive_table/responsive_table.dart';

class Promotions extends StatelessWidget {
  const Promotions(
      {Key? key,
      required this.onView,
      required this.provider,
      required this.onMessage,
      required this.onSuspend,
      required this.onActivate,
      required this.onDelete})
      : super(key: key);
  final Function(String) onView;
  final Provider provider;
  final Function(List) onMessage;
  final Function(List) onActivate;
  final Function(List) onSuspend;
  final Function(List) onDelete;
  @override
  Widget build(BuildContext context) {
    var short = provider.apiData;

    List newTestimonies = short.promotes
        .where((element) => element['seen'].toString() == '0')
        .toList();
    List banned = short.promotes
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
      title: "Promotions",
      searchKey: 'promoter',
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
          text: "Promoter",
          value: "promoter",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Post",
          value: "post",
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
            bool isSuspended = provider.apiData.promotes
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
                      var postId = provider.apiData.promotes.singleWhere(
                          (element) =>
                              element['id'].toString() ==
                              id.toString())['postId'];
                      var userId = provider.apiData.posts.singleWhere(
                          (element) => element['id'] == postId)['posterId'];
                      var promoter = [
                        ...provider.apiData.users,
                        ...provider.apiData.pros
                      ].singleWhere(
                        (element) => element['id'] == userId,
                      )['handle'];
                      onMessage([
                        {'promoter': promoter}
                      ]);
                    } else if (e == 'Activate') {
                      onActivate([
                        {'post': id}
                      ]);
                    } else if (e == 'Suspend') {
                      onSuspend([
                        {'post': id}
                      ]);
                    } else if (e == 'Delete') {
                      onDelete([
                        {'post': id}
                      ]);
                    }
                  }),
            );
          },
          editable: true,
          textAlign: TextAlign.center,
        ),
      ],
      data: provider.apiData.promotes.map((e) {
        var promoterId = provider.apiData.posts
            .singleWhere((element) => element['id'] == e['postId'])['posterId'];
        String promoter =
            [...provider.apiData.users, ...provider.apiData.pros].singleWhere(
          (element) => element['id'] == promoterId,
          orElse: () => {'handle': ''},
        )['handle'];
        return {
          'date': e['date'],
          'promoter': promoter,
          'post': e['id'],
          'actions': e['id']
        };
      }).toList(),
    );
  }
}
