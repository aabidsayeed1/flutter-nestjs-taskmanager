import 'dart:async';
import 'dart:io';

import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/managers/general/media_picker_manager.dart';
import 'package:task_manager/ui/atoms/avatar_alt_text.dart';
import 'package:task_manager/ui/atoms/avatar_icon.dart';
import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatefulWidget {
  const ProfileAvatarWidget({
    Key? key,
    this.isEditable = true,
    this.isRemoteRemovable = true,
    this.source = AvatarSource.Network,
    this.placeholderType = AvatarPlaceholderType.name,
    this.imageURL,
    this.name,
    this.onRemoteRemoved,
    this.onSelected,
  }) : super(key: key);

  final bool isEditable;
  final bool isRemoteRemovable;
  final String? imageURL;
  final String? name;
  final AvatarSource source;
  final AvatarPlaceholderType placeholderType;
  final Function? onRemoteRemoved;
  final Function(File)? onSelected;

  @override
  _ProfileAvatarWidgetState createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  File? _selectedImage;

  final StreamController<File?> _fileSelectionStream = StreamController<File?>();

  @override
  void dispose() {
    _fileSelectionStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      width: 108,
      child: GestureDetector(
        onTapUp: (t) async {
          if (widget.isEditable) {
            MediaPickerResult? result = await MediaPickerManager.selectFile(
              context,
              isFileSelected: _selectedImage != null,
              isRemoteImageRemovable: widget.isRemoteRemovable,
            );

            if (result != null) {
              switch (result.resultType) {
                case MediaPickerResultType.picked:
                  if (widget.onSelected != null) {
                    widget.onSelected!(result.selectedFile!);
                  }
                  _fileSelectionStream.add(result.selectedFile!);

                  break;
                case MediaPickerResultType.removed:
                  _fileSelectionStream.add(null);
                  break;
                case MediaPickerResultType.remoteRemoved:
                  if (widget.onRemoteRemoved != null) {
                    widget.onRemoteRemoved!();
                  } else {
                    throw Exception(
                      "ProfileAvatarWidget: Passed isRemoteRemovable as true but onRemoteRemoved is null",
                    );
                  }
                  break;
                case MediaPickerResultType.cancelled:
                  //  Handle this case.
                  break;
              }
            }
          }
        },
        child: StreamBuilder<File?>(
          stream: _fileSelectionStream.stream,
          builder: (context, snapshot) {
            _selectedImage = snapshot.data;
            return Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child:
                      (widget.placeholderType == AvatarPlaceholderType.name &&
                              (_selectedImage == null && widget.imageURL == null))
                          ? AvatarAltText(name: widget.name ?? "", height: 100, fontSize: 50)
                          : AbsorbPointer(
                            child: AvatarIcon(
                              height: 100,
                              width: 100,
                              imageURL:
                                  _selectedImage != null ? _selectedImage!.path : widget.imageURL,
                              source:
                                  _selectedImage != null ? AvatarSource.File : AvatarSource.Network,
                            ),
                          ),
                ),
                if (widget.isEditable)
                  const Positioned(top: 0, right: 0, child: AbsorbPointer(child: Icon(Icons.edit))),
              ],
            );
          },
        ),
      ),
    );
  }
}
