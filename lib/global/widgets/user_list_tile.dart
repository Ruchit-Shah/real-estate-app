import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/height.dart';
import '../app_color.dart';
import '../services/api_shorts_string.dart';
import '../theme/app_text_style.dart';

userListTile({data,void Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 60,width: 60,
            decoration:const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.grey
            ),
            margin: const EdgeInsets.only(right: 15),
            child: data["profile_image"] == null || data["profile_image"].toString().isEmpty?
            const Icon(Icons.person)
                :ClipOval(child: CachedNetworkImage(imageUrl: APIShortsString.profileImageBaseUrl+data["profile_image"] ,
            fit: BoxFit.cover,)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data["full_name"].toString(),
                  style:AppTextStyle.bold.copyWith(fontSize: 18),
                ),
                boxH02(),
                Text(
                  data["username"].toString(),
                  style:AppTextStyle.regular.copyWith(fontSize: 14),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
