import 'package:flutter/material.dart';
import 'package:flutter_demo/common/data/data.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:responsive_table/responsive_table.dart';

class ProVerification extends StatelessWidget {
  const ProVerification({
    Key? key,
    required this.onView,
    required this.provider,
    required this.onRetract,
    required this.onAccept,
  }) : super(key: key);
  final Function(String) onView;
  final Provider provider;

  final Function(String) onRetract;
  final Function(String) onAccept;
  @override
  Widget build(BuildContext context) {
    // List newTestimonies = short.promotes
    //     .where((element) => element['seen'].toString() == '0')
    //     .toList();
    // List banned = short.promotes
    //     .where((element) => element['suspended'] == 'true')
    //     .toList();
    return DataPage(
      // footer: Row(
      //   children: [
      //     Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 15),
      //       child: const Text("New Testimonies:"),
      //     ),
      //     CircleAvatar(
      //       backgroundColor: primaryColor,
      //       radius: 15,
      //       child: Text(newTestimonies.length.toString()),
      //     ),
      //     SizedBox(
      //       width: 30,
      //     ),
      //     Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 15),
      //       child: const Text("Suspended:"),
      //     ),
      //     CircleAvatar(
      //       backgroundColor: primaryColor,
      //       radius: 15,
      //       child: Text(banned.length.toString()),
      //     )
      //   ],
      // ),
      onActivate: (List data) {
        // onActivate(data);
      },
      onDelete: (List data) {
        // onDelete(data);
      },
      onMessage: (List data) {
        // onMessage(data);
      },
      onSuspend: (List data) {
        // onSuspend(data);
      },
      showBtns: false,
      provider: provider,
      title: "Verification Requests",
      searchKey: 'pro',
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
          text: "Professional",
          value: "pro",
          show: true,
          flex: 2,
          sortable: true,
          editable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "View",
          value: "view",
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
            bool isVerified = provider.apiData.pros
                .where(
                  (element) =>
                      element['certified'] == 'true' &&
                      element['id'].toString() == id.toString(),
                )
                .isNotEmpty;
            return Center(
              child: DropdownButton(
                  value: "Actions",
                  items: [
                    'Actions',
                    isVerified ? 'Retract' : 'Accept',
                  ]
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: TextWidget(
                            text: e.toString(),
                          )))
                      .toList(),
                  onChanged: (e) {
                    if (e == 'Accept') {
                      onAccept(id);
                    } else if (e == 'Retract') {
                      onRetract(id);
                    }
                  }),
            );
          },
          editable: true,
          textAlign: TextAlign.center,
        ),
      ],
      data: provider.apiData.verificationRequest.map((e) {
        // var proId = provider.apiData.verificationRequest
        //     .singleWhere((element) => element['proId'] == e['proId'])['posterId'];
        String pro = provider.apiData.pros.singleWhere(
          (element) => element['id'] == e['proId'],
          orElse: () => {'handle': ''},
        )['handle'];
        return {
          'date': e['created_at'],
          'pro': pro,
          'view': e['proId'],
          'actions': e['proId']
        };
      }).toList(),
    );
  }
}
