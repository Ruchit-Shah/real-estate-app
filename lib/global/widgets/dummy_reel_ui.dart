import 'package:flutter/material.dart';
import '../../common_widgets/height.dart';
import '../app_color.dart';
import '../theme/app_text_style.dart';

Container dummyReelUi() {
  return Container(
    decoration: BoxDecoration(color: AppColor.grey.withOpacity(0.5)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              children: [

                // const ClipRRect(
                //   child: CircleAvatar(
                //     backgroundColor: AppColor.grey,
                //     radius: 16,
                //     child: Icon(
                //       Icons.person,
                //       size: 18,
                //       color: AppColor.white,
                //     ),
                //   ),
                // ),
                // boxH20(),
                // InkWell(
                //   onTap: (){
                //     Get.toNamed(Routes.SEARCH_SCREEN);
                //   },
                //   child: const Icon(
                //       Icons.search,
                //       size: 30,
                //       color: AppColor.white
                //   ),
                // ),
                // boxH20(),
                const Icon(
                  Icons.favorite,
                  size: 30,
                  color: AppColor.white,
                ),
                Text(
                  '',
                  style: AppTextStyle.regular.copyWith(
                    fontSize: 12,
                    color: AppColor.white,
                  ),
                ),
                boxH20(),
                const Icon(
                  Icons.comment_rounded,
                  size: 30,
                  color: AppColor.white,
                ),
                Text(
                  '',
                  style: AppTextStyle.regular.copyWith(
                    fontSize: 12,
                    color: AppColor.white,
                  ),
                ),
                boxH20(),
                const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 30.0,
                ),
                boxH20(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColor.grey,
                radius: 16,
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: AppColor.white,
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: const BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 150,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: const BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_drop_up_outlined,
                size: 25,
                color: Colors.white,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.white),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Text(
                  'Follow',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: AppColor.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      size: 25,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_drop_up_outlined,
                      size: 25,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        boxH10(),
      ],
    ),
  );
}
