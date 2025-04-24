import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class IconRatingCard extends StatefulWidget {
  final int maximumRating;
  final Function(num) onRatingSelected;
  final num rating;

  const IconRatingCard(
      {Key? key,
      required this.onRatingSelected,
      required this.rating,
      this.maximumRating = 5})
      : super(key: key);

  @override
  _IconRatingCard createState() => _IconRatingCard();
}

class _IconRatingCard extends State<IconRatingCard> {
  String ratingStatus = '';

  Widget _buildRatingIcon(int index) {
    Widget? icon;
    if (index < widget.rating) {
      icon = iconView(index + 1, AppColors.ICON_RATING_1);
    } else {
      icon = iconView(index + 1, AppColors.ICON_RATING_2);
    }
    return icon;
  }

  Widget _buildBody() {
    final ratingGrid = Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        widget.maximumRating,
        (index) {
          return GestureDetector(
            child: _buildRatingIcon(index),
            onTap: () {
              widget.onRatingSelected(widget.rating);
            },
          );
        },
      ),
    );

    return ratingGrid;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ICON_RATING_CARD,
      child: Card(
          elevation: 0.0,
          color: AppColors.CARD_BG,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: _buildBody(),
          )),
    );
  }

  Widget iconView(int index, Color iconColor) {
    return Icon(
      Icons.star_rate_rounded,
      color: iconColor,
      size: 16,
    );
  }
}
