import 'package:flutter/material.dart';

import '../automation_constants.dart';

class ImagePreviewWidget extends StatefulWidget {
  final String url;
  final Function()? onCloseTap;
  final bool isLocal;

  const ImagePreviewWidget(
      {Key? key, required this.url, this.onCloseTap, this.isLocal = false})
      : super(key: key);

  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.IMAGE_PREVIEW,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            right: 0,
            left: 0,
            bottom: 0,
            child: Align(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 2.0,
                // boundaryMargin: const EdgeInsets.all(20.0),
                child: widget.isLocal
                    ? Image.asset(widget.url)
                    : Image.network(
                        widget.url,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: IconButton(
                onPressed: widget.onCloseTap,
                icon: const Icon(Icons.close, color: Colors.white, shadows: [
                  BoxShadow(blurRadius: 6.0),
                ])),
          ),
        ],
      ),
    );
  }
}
