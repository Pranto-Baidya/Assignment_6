import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled3/ui/utils/asset_Path.dart';

class screenBackground extends StatelessWidget {
  const screenBackground({super.key, required this.child});

  final Widget child;


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return  Stack(
        children: [
          SvgPicture.asset(assetPaths.backgroundSVG,
            fit: BoxFit.cover,
            height: screenSize.height,
            width:  screenSize.width,
          ),
          child
        ],
      );
  }
}
