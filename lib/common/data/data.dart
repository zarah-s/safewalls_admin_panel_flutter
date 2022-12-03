import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/common/actions/general_action_buttons.dart';
import 'package:flutter_demo/common/button/action_button.dart';
import 'package:flutter_demo/common/flushbar/show_flushbar.dart';
import 'package:flutter_demo/common/inputs/search_input.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:responsive_table/responsive_table.dart';

class DataPage extends StatefulWidget {
  const DataPage(
      {Key? key,
      required this.headers,
      required this.data,
      required this.title,
      required this.onActivate,
      required this.onDelete,
      required this.onMessage,
      required this.onSuspend,
      this.searchKey = '',
      this.otherKey = '',
      this.footer,
      this.isReport = false,
      this.showBtns = true,
      required this.provider})
      : super(key: key);
  final List<Map<String, dynamic>> data;
  final List<DatatableHeader> headers;
  final String title;
  final Provider provider;
  final Function(List) onMessage;
  final Function(List) onActivate;
  final Function(List) onSuspend;
  final Function(List) onDelete;
  final String searchKey;
  final String otherKey;
  final bool isReport;
  final Widget? footer;
  final bool showBtns;
  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<DatatableHeader> _headers;

  final List<int> _perPages = [10, 20, 50, 100];
  late int _total;
  int? _currentPerPage = 10;
  List<bool>? _expanded;

  int _currentPage = 1;
  final List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];

  String? _sortColumn;
  final bool _sortAscending = true;
  bool _isLoading = true;
  final bool _showSelect = true;
  var random = Random();

  _initializeData(List<Map<String, dynamic>> sources, {load = true}) async {
    _mockPullData(sources, load);
  }

  _mockPullData(List<Map<String, dynamic>> sources, load) async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = load);
    Future.delayed(const Duration(seconds: 1)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(sources);
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered
          .getRange(
              0,
              _currentPerPage! > sources.length
                  ? sources.length
                  : _currentPerPage!)
          .toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(const Duration(seconds: 0)).then((value) {
      _expanded = List.generate(expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _initializeData(widget.data);
      });
    } else {
      setState(() {
        var searched = widget.data
            .where((field) =>
                field[widget.searchKey]
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                field[widget.otherKey]
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
        _initializeData(searched);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _total = widget.data.length;
    widget.provider.addListener(() {
      _initializeData(widget.data, load: false);
    });
    _headers = widget.headers;

    _initializeData(widget.data);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(20);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 71,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: widget.title,
                  size: 40,
                  fontWeight: FontWeight.w700,
                ),
                if (widget.showBtns)
                  if (widget.isReport)
                    ActionButton(
                      onPress: () {
                        if (_selecteds.isNotEmpty) {
                          widget.onDelete(_selecteds);
                        } else {
                          showFlushbar(widget.provider, "select item", context,
                              success: false);
                        }
                      },
                      color: red,
                      icon: Icons.delete,
                    )
                  else
                    GeneralActionButtons(
                      onActivate: () {
                        if (_selecteds.isNotEmpty) {
                          widget.onActivate(_selecteds);
                        } else {
                          showFlushbar(widget.provider, "select item", context,
                              success: false);
                        }
                      },
                      onDelete: () {
                        if (_selecteds.isNotEmpty) {
                          widget.onDelete(_selecteds);
                        } else {
                          showFlushbar(widget.provider, "select item", context,
                              success: false);
                        }
                      },
                      onMessage: () {
                        if (_selecteds.isNotEmpty) {
                          widget.onMessage(_selecteds);
                        } else {
                          showFlushbar(widget.provider, "select item", context,
                              success: false);
                        }
                      },
                      onSuspend: () {
                        if (_selecteds.isNotEmpty) {
                          widget.onSuspend(_selecteds);
                        } else {
                          showFlushbar(widget.provider, "select item", context,
                              success: false);
                        }
                      },
                    )
              ],
            ),
            const SizedBox(
              height: 54,
            ),
            Align(
              alignment: Alignment.topRight,
              child: SearchInput(onChanged: onSearch),
            ),
            const SizedBox(
              height: 54,
            ),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 700,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  headerDecoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: radius, topRight: radius),
                  ),
                  headerTextStyle: TextStyle(color: getwhiteOpacity(.8)),
                  reponseScreenSizes: const [ScreenSize.xs],
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  showSelect: _showSelect,
                  autoHeight: false,
                  expanded: _expanded,
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
                  onSelect: (value, item) {
                    if (value!) {
                      setState(() => _selecteds.add(item));
                    } else {
                      setState(
                          () => _selecteds.removeAt(_selecteds.indexOf(item)));
                    }
                  },
                  onSelectAll: (value) {
                    if (value!) {
                      setState(() => _selecteds =
                          _source.map((entry) => entry).toList().cast());
                    } else {
                      setState(() => _selecteds.clear());
                    }
                  },
                  footers: _isLoading || _source.isEmpty
                      ? []
                      : [
                          // if(widget.footer == null)
                          // Container()
                          // else widget.footer!
                          widget.footer == null ? Container() : widget.footer!,
                          const SizedBox(
                            width: 100,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Text("Rows per page:"),
                          ),
                          if (_perPages.isNotEmpty)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: DropdownButton<int>(
                                value: _currentPerPage,
                                items: _perPages
                                    .map((e) => DropdownMenuItem<int>(
                                          value: e,
                                          child: Text("$e"),
                                        ))
                                    .toList(),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    _currentPerPage = value;
                                    _currentPage = 1;
                                    _resetData();
                                  });
                                },
                                isExpanded: false,
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                                "$_currentPage - $_currentPerPage of $_total"),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                            ),
                            onPressed: _currentPage == 1
                                ? null
                                : () {
                                    var nextSet =
                                        _currentPage - _currentPerPage!;
                                    setState(() {
                                      _currentPage = nextSet > 1 ? nextSet : 1;
                                      _resetData(start: _currentPage - 1);
                                    });
                                  },
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed:
                                _currentPage + _currentPerPage! - 1 > _total
                                    ? null
                                    : () {
                                        var nextSet =
                                            _currentPage + _currentPerPage!;

                                        setState(() {
                                          _currentPage = nextSet < _total
                                              ? nextSet
                                              : _total - _currentPerPage!;
                                          _resetData(start: nextSet - 1);
                                        });
                                      },
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                          )
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
