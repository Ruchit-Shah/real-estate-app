
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/Routes/app_pages.dart';
import '../../../common_widgets/height.dart';
import '../../../global/AppBar.dart';
import '../../all_products/view/related_products/show_all_videos_for_related_products.dart';
import '../../look_book/view/ProductListScreen.dart';
import '../controller/store_page_controller.dart';

class StorePage extends GetWidget<StorePageController> {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StorePageController(),
      builder: (controller) {
        return Scaffold(
          appBar: appBar(titleName: "Store"),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  boxH10(),
                  menuTabs(
                      title: "Properties",
                      subtitle: "You can see properties over here.",
                      onTap: () {
                        Get.toNamed(Routes.ALL_PRODUCTS_SCREEN);
                      },
                      icon: Image.asset('assets/properties.png', width: 29, height: 29,color: Colors.black,),
                      color:Colors.orange[100]!
                  ),
                  menuTabs(
                      title: "Category",
                      subtitle: "Manage property category from here. ",
                      onTap: () {
                        Get.toNamed(Routes.CATEGORY_SCREEN);
                      },
                      icon:const Icon(Icons.category),
                      color:Colors.purple[100]!
                  ),

                  menuTabs(
                      title: "Related Properties",
                      subtitle: "Add properties related to your video.",
                      onTap: () {
                        Get.to(() => const ShowAllVideosForRelatedProds());
                      },
                      icon: Image.asset('assets/Home_Video-preview.png', width: 24, height: 24,color: Colors.black,),
                      color:Colors.red[100]!
                  ),

                  menuTabs(
                      title: "Enquiry",
                      subtitle: "Manage enquiries here.",
                      onTap: () {

                        Get.to(ProductListScreen());
                      },
                      icon:const Icon(Icons.contact_support),
                      color:Colors.green[100]!
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  menuTabs({String? title,String? subtitle, void Function()? onTap,required Widget icon,required Color color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Get.width * 1,
        height: Get.width * 0.30,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Card(
            color: color,
            surfaceTintColor: color,
            shadowColor: color,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, padding: const EdgeInsets.all(15),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: color,
              ),
              onPressed: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  icon,
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: Text(title!)),
                        Expanded(child: Text(subtitle!,style: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w500),)),
                      ],),
                  ),
                  //Expanded(child: Text(title!)),
                  // const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}