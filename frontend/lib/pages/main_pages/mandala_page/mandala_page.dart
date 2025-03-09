import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/main_provider.dart';
import '../../../widgets/image_menu_item/image_menu_item.dart';
import '../../image_list_page/image_grid_list_page.dart';



class MandalaPage extends StatefulWidget {
  const MandalaPage({Key? key}) : super(key: key);

  @override
  State<MandalaPage> createState() => _MandalaPageState();
}

class _MandalaPageState extends State<MandalaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ImageMenuItem(
            title: "Simple",
            imageList: context.read<MainProvider>().simpleList,
            asset: "simple",
            navigatePage: ImageGridListPage(dataList: context.read<MainProvider>().simpleList, asset: "simple",),
          ),
          ImageMenuItem(
            title: "Medium",
            imageList: context.read<MainProvider>().mediumList,
            asset: "medium",
            navigatePage: ImageGridListPage(dataList: context.read<MainProvider>().mediumList, asset: "medium",),
          ),
          ImageMenuItem(
            title: "Complex",
            imageList: context.read<MainProvider>().complexList,
            asset: "complex",
            navigatePage: ImageGridListPage(dataList: context.read<MainProvider>().complexList, asset: "complex",),
          )
        ],
      ),
    );
  }

}
