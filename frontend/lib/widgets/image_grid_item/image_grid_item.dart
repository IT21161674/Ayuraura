import 'dart:io';
import 'package:flutter/material.dart';
import '../../pages/image_color_page/image_color_page.dart';

class ImageGridItem extends StatelessWidget {
  final String? path;
  final String? asset;
  final File? file;
  final int? index;

  const ImageGridItem({
    Key? key,
    this.path,
    this.asset,
    this.file,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (asset != null && path != null)
            Image.asset(
              "assets/$asset/$path",
              fit: BoxFit.contain,
            )
          else if (file != null)
            Image.file(
              file!,
              fit: BoxFit.contain,
            )
          else
            Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey[400],
                size: 32,
              ),
            ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (asset != null && path != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageColorPage(
                        path: "assets/$asset/$path",
                        asset: asset,
                      ),
                    ),
                  );
                } else if (file != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageColorPage(
                        file: file,
                        index: index,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
