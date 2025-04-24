import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:task_manager/core/constants/app_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/helpers/helper_ui.dart';

import '../../core/managers/general/custom_media_picker_manager.dart';
import '../../route/custom_navigator.dart';
import '../custom_spacers.dart';
import 'custom_carousel_slider.dart';
import 'molecules/custom_video_player.dart';

class MediaView extends StatefulWidget {
  final List<MediaPickerResult> medias;
  final int? index;

  const MediaView({Key? key, required this.medias, this.index}) : super(key: key);

  @override
  MediaViewState createState() => MediaViewState();
}

class MediaViewState extends State<MediaView> {
  late int _current;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    _current = widget.index ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.OFF_WHITE_F4F4F5,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.TOAST_MESSAGE_TEXT_COLOR,
        leading: InkWell(
          onTap: () => CustomNavigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.TOAST_MESSAGE_STYLE),
        ),
      ),
      body: Column(
        children: <Widget>[
          showCarousel(context),
          CustomSpacers.height16,
          if (widget.medias.length > 1) showDotImages(widget.medias),
        ],
      ),
    );
  }

  Widget _displayImage(MediaPickerResult media) {
    if (media.imageBytes != null && media.imageBytes!.isNotEmpty) {
      return Image.memory(media.imageBytes!, fit: BoxFit.contain);
    } else if (media.selectedFile != null) {
      return Image.file(media.selectedFile!, fit: BoxFit.contain);
    } else if (media.networkUrl != null) {
      return CachedNetworkImage(
        imageUrl: media.networkUrl ?? "",
        fit: BoxFit.contain,
        // progressIndicatorBuilder: (context, url, progress) {
        //   return Shimmer.fromColors(
        //       baseColor: Colors.grey[300]!,
        //       highlightColor: Colors.grey[100]!,
        //       child: _placeholder());
        // },
      );
    }
    return HelperUI.emptyContainer();
  }

  Widget showCarousel(BuildContext context) {
    return Container();

    // CustomCarouselSlider.builder(
    //   itemCount: widget.medias.length,
    //   carouselController: _controller,
    //   itemBuilder: (context, index, index2) {
    //     var media = widget.medias[index];
    //     return media.mediaType == CustomMediaType.image
    //         ? InteractiveViewer(
    //           minScale: 0.5,
    //           maxScale: 5.0,
    //           child: _displayImage(media),
    //           // child: ImageView(
    //           //   strIconData: media.selectedFile!=null?media.selectedFile!.path:"",
    //           //   boxFit: BoxFit.contain,
    //           // ),
    //         )
    //         : CustomVideoPlayer(
    //           strURL: media.selectedFile != null ? media.selectedFile!.path : "",
    //           bAutoPlay: true,
    //           bActions: true,
    //           bShowControls: true,
    //           bPickAspectRatio: true,
    //         );
    //   },
    //   options: CarouselOptions(
    //     height: HelperUI.getScreenHeight(context) - 170.h,
    //     enlargeCenterPage: false,
    //     initialPage: widget.index ?? 0,
    //     disableCenter: false,
    //     viewportFraction: 1,
    //     onPageChanged: (index, reason) {
    //       setState(() {
    //         _current = index;
    //       });
    //     },
    //     enableInfiniteScroll: false,
    //   ),
    // );
  }

  Widget showDotImages(List<MediaPickerResult> arrayOfMedias) {
    return Container(
      margin: EdgeInsets.only(right: 24.w),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            arrayOfMedias.asMap().entries.map((entry) {
              return GestureDetector(
                onTap:
                    () => _controller.animateTo(
                      entry.key.toDouble(),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn,
                    ),
                child: Container(
                  width: 5.0,
                  height: 5.0,
                  margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _current == entry.key
                            ? AppColors.APP_THEME
                            : AppColors.ICON_TEXT_ICON_BORDER,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
