import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/atoms/custom_checkbox.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class DropDown<T> extends StatefulWidget {
  final List<DropDownModel<T>> modelList;
  final DropDownModel<T> model;
  final bool bIsSearch;
  final bool bIsMultiSelect;
  final String label;
  final ValueChanged<DropDownModel<T>?> callback;
  final String searchHintText;
  final TextStyle? labelTextStyle;
  final TextStyle? searchTextStyle;
  final TextStyle? itemTextStyle;
  final TextStyle? placeHolderTextStyle;
  final bool? bIsDisabled;
  final bool? bIsError;
  final String? errorMessage;
  final TextStyle? errorTextStyle;
  final TextStyle? hintTextStyle;
  final CheckboxType checkboxType;
  final bool? bLabelPositionLeft;
  const DropDown({
    Key? key,
    required this.modelList,
    required this.model,
    required this.callback,
    this.bIsSearch = true,
    this.bIsMultiSelect = false,
    this.label = '',
    this.searchHintText = AppStrings.STRING_HINT_MESSAGE,
    this.itemTextStyle,
    this.labelTextStyle,
    this.searchTextStyle,
    this.placeHolderTextStyle,
    this.bIsDisabled = false,
    this.bIsError = false,
    this.errorMessage,
    this.errorTextStyle,
    this.hintTextStyle,
    this.checkboxType = CheckboxType.Default,
    this.bLabelPositionLeft = false,
  }) : super(key: key);

  @override
  State<DropDown<T>> createState() => _DropDownState<T>();
}

class _DropDownState<T> extends State<DropDown<T>> {
  DropDownModel<T>? labour;
  List<DropDownModel<T>?>? searchModelList;
  bool _isVisible = false;
  late String selecteValue;
  List<String> selectedItems = [];
  final LayerLink _layerLink = LayerLink();
  OverlayState? overlayState;
  OverlayEntry? overlay1;
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    labour = widget.model;
    searchModelList = widget.modelList;
    selecteValue = widget.searchHintText;
  }

  @override
  Widget build(BuildContext context) {
    overlayState = Overlay.of(context);
    return Semantics(
      value: AutomationConstants.DROPDOWN,
      child: Material(
        color: Colors.transparent,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: Stack(
            children: [
              labelWidgte(),
              dropDownItems(),
              widget.bIsError!
                  ? Container(
                    margin: EdgeInsets.only(
                      top:
                          widget.label.isNotEmpty
                              ? AppValues.DROP_DOWN_ITEMS_TOP_MARGIN_SEARCH
                              : AppValues.DROP_DOWN_ITEMS_TOP_MARGIN,
                      left: AppValues.HORIZONTAL_PADDING,
                      right: AppValues.HORIZONTAL_PADDING,
                    ),
                    child: Text(
                      widget.errorMessage!,
                      style: widget.errorTextStyle ?? AppStyles.dropDownErrorTextStyle,
                    ),
                  )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget labelWidgte() {
    return widget.label.isNotEmpty
        ? Container(
          margin: const EdgeInsets.only(
            left: AppValues.HORIZONTAL_PADDING,
            right: AppValues.HORIZONTAL_PADDING,
          ),
          child: Text(widget.label, style: widget.labelTextStyle ?? AppStyles.labelTextStyle),
        )
        : Container();
  }

  Widget dropDownItems() {
    return GestureDetector(
      onTap:
          widget.bIsDisabled!
              ? null
              : () {
                setState(() {
                  _isVisible = !_isVisible;
                  if (searchTextController.text.isNotEmpty) {
                    searchTextController.clear();
                    onSearchTextChanged('');
                  }
                  _showOverlay(context);
                });
              },
      child: Container(
        margin: EdgeInsets.only(
          top: widget.label.isNotEmpty ? AppValues.PADDING_22 : 0,
          left: AppValues.HORIZONTAL_PADDING,
          right: AppValues.HORIZONTAL_PADDING,
        ),
        height: AppValues.DROP_DOWN_PLACEHOLDER_HEIGHT,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppValues.HORIZONTAL_PADDING),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                widget.bIsError!
                    ? AppColors.DROP_DOWN_ERROR_BORADER
                    : widget.bIsDisabled!
                    ? AppColors.DROP_DOWN_DISABLE_BORADER
                    : _isVisible
                    ? AppColors.DROP_DOWN_ACTIVE_BORADER
                    : AppColors.DROP_DOWN_BORADER,
          ),
          borderRadius: BorderRadius.circular(5),
          color: widget.bIsDisabled! ? AppColors.DROP_DOWN_DISABLED_COLOR : AppColors.WHITE,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedItems.isNotEmpty ? selectedItemsValues() : selecteValue,
                style: widget.placeHolderTextStyle ?? AppStyles.dropDownPlaceHolderTextStyle,
              ),
            ),
            _isVisible
                ? Container(
                  margin: const EdgeInsets.only(right: AppValues.PADDING_10),
                  height: AppValues.DROP_DOWN_DOWN_ARROW_HEIGHT,
                  width: AppValues.DROP_DOWN_DOWN_ARROW_WIDTH,
                  child: Image.asset(AppImages.DROP_DOWN_UP_ARROW),
                )
                : Container(
                  margin: const EdgeInsets.only(right: AppValues.PADDING_10),
                  height: AppValues.DROP_DOWN_UP_ARROW_HEIGHT,
                  width: AppValues.DROP_DOWN_UP_ARROW_WIDTH,
                  child: Image.asset(AppImages.DROP_DOWN_DOWN_ARROW),
                ),
          ],
        ),
      ),
    );
  }

  String selectedItemsValues() {
    String localSelectValues = '';
    if (selectedItems.isNotEmpty && selectedItems.length <= 2) {
      localSelectValues = selectedItems.join('; ');
    }
    if (selectedItems.isNotEmpty && selectedItems.length > 2) {
      num remainingCount = (selectedItems.length - 2) > 4 ? 5 : (selectedItems.length - 2);
      // ignore: prefer_interpolation_to_compose_strings
      localSelectValues =
          selectedItems[0] +
          '; ' +
          selectedItems[1] +
          ', ... +' +
          remainingCount.toString() +
          "more";
    }
    return localSelectValues;
  }

  void _showOverlay(BuildContext buildContext) async {
    if (!_isVisible && overlay1 != null) {
      overlay1!.remove();
    } else {
      overlay1 = OverlayEntry(
        builder: (context) {
          return _isVisible
              ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final dropdownWidth = constraints.maxWidth * 0.915;
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: CompositedTransformFollower(
                      link: _layerLink,
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Container(
                          height: AppValues.DROP_DOWN_ITEMS_PARENT_HEIGHT,
                          width: dropdownWidth,
                          margin: EdgeInsets.only(
                            top:
                                widget.label.isNotEmpty
                                    ? AppValues.DROP_DOWN_ITEMS_TOP_MARGIN_SEARCH
                                    : AppValues.DROP_DOWN_ITEMS_TOP_MARGIN,
                            left: AppValues.HORIZONTAL_PADDING,
                            right: AppValues.HORIZONTAL_PADDING,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.DROP_DOWN_BORADER),
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.WHITE,
                          ),
                          child: Column(
                            children: [
                              widget.bIsSearch
                                  ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppValues.PADDING_8,
                                      vertical: AppValues.PADDING_8,
                                    ),
                                    child: TextField(
                                      controller: searchTextController,
                                      style: widget.searchTextStyle ?? AppStyles.searchTextStyle,
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        hintStyle:
                                            widget.hintTextStyle ?? AppStyles.searchTextStyle,
                                        prefixIcon: IconButton(
                                          icon: Image.asset(
                                            AppImages.DROP_DOWN_SEARCH,
                                            width: AppValues.DROP_DOWN_SEARCH_WIDTH,
                                            height: AppValues.DROP_DOWN_SEARCH_HEIGHT,
                                          ),
                                          onPressed: null,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.DROP_DOWN_SEARCH_BORADER_COLOR,
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.DROP_DOWN_SEARCH_BORADER_COLOR,
                                            width: 1.0,
                                          ),
                                        ),
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        onSearchTextChanged(value);
                                      },
                                    ),
                                  )
                                  : Container(),
                              Container(
                                height:
                                    widget.bIsSearch
                                        ? AppValues.DROP_DOWN_ITEMS_CHILD_WITH_SEARCH_HEIGHT
                                        : AppValues.DROP_DOWN_ITEMS_CHILD_HEIGHT,
                                padding: const EdgeInsets.only(
                                  top: AppValues.PADDING_8,
                                  left: AppValues.PADDING_8,
                                  right: AppValues.PADDING_8,
                                ),
                                child: ListView.builder(
                                  itemCount: searchModelList!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (widget.bIsMultiSelect) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          height: AppValues.DROP_DOWN_ITEM_HEIGHT,
                                          color: AppColors.WHITE,
                                          alignment: Alignment.centerLeft,
                                          child: CustomCheckbox(
                                            checkboxType: CheckboxType.Default,
                                            bLabelPositionLeft: widget.bLabelPositionLeft!,
                                            defaultColor:
                                                searchModelList![index]!.bIsSelected!
                                                    ? AppColors.DROP_DOWN_SELECTED_ITEM_BG
                                                    : AppColors.BASICWHITE,
                                            strCheckboxText: searchModelList![index]!.userName!,
                                            bSelected: searchModelList![index]!.bIsSelected!,
                                            selectedValue: (value) {
                                              widget.callback(searchModelList![index]);
                                              setState(() {
                                                if (value == true) {
                                                  selectedItems.add(
                                                    searchModelList![index]!.userName!,
                                                  );
                                                  widget.callback(searchModelList![index]);
                                                  _showOverlay(buildContext);
                                                }
                                                if (value == false) {
                                                  selectedItems.remove(
                                                    searchModelList![index]!.userName!,
                                                  );
                                                  _showOverlay(buildContext);
                                                }
                                                searchModelList![index]!.bIsSelected = value;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          widget.callback(searchModelList![index]);
                                          setState(() {
                                            labour = searchModelList![index];
                                            selecteValue = labour!.userName.toString();
                                            _isVisible = !_isVisible;
                                            _showOverlay(context);
                                          });
                                        },
                                        child: Container(
                                          height:
                                              index == searchModelList!.length - 1
                                                  ? AppValues.DROP_DOWN_LAST_ITEM_HEIGHT
                                                  : AppValues.DROP_DOWN_ITEM_HEIGHT,
                                          color: AppColors.WHITE,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppValues.HORIZONTAL_PADDING,
                                          ),
                                          margin: EdgeInsets.only(
                                            top: index == 0 ? AppValues.PADDING_10 : 0,
                                          ),
                                          child: DefaultTextStyle(
                                            style:
                                                widget.itemTextStyle ??
                                                AppStyles.dropDownItemTextStyle,
                                            child: Text(
                                              searchModelList![index]!.userName.toString(),
                                              style:
                                                  widget.itemTextStyle ??
                                                  AppStyles.dropDownItemTextStyle,
                                              selectionColor: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
              : Container();
        },
      );
      overlayState!.insert(overlay1!);
    }
  }

  void onSearchTextChanged(String enteredKeyword) {
    List<DropDownModel<T>> results = [];
    if (searchTextController.text == '' || searchTextController.text.isEmpty) {
      results = widget.modelList;
    } else {
      results =
          widget.modelList
              .where(
                (user) =>
                    user.userName.toString().toLowerCase().contains(enteredKeyword.toLowerCase()),
              )
              .toList();
    }
    setState(() {
      searchModelList = results;
    });
    _showOverlay(context);
  }
}

class DropDownModel<T> {
  String? userName;
  bool? bIsSelected = false;
  final T? data;
  DropDownModel({this.userName, this.bIsSelected, this.data});
}
