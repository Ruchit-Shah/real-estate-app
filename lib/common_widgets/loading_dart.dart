import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:real_estate_app/global/app_color.dart';

import '../view/property_screens/properties_controllers/post_property_controller.dart';


void uploadProject(BuildContext context, String message) {
  controller.isUploading.value = true; // Set uploading to true

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Fluttertoast.showToast(msg: "Project will continue uploading in background.");
          return true; // Allow dialog to close
        },
        child: AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 20,
                  width: 20,
                  child: GFLoader(
                    size: 40,
                    loaderColorOne: Colors.purple,
                    loaderColorTwo: Colors.red,
                    loaderColorThree: Colors.yellow.shade700,
                    type: GFLoaderType.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


void showHomLoading(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 20,
                width: 20,
                child:   GFLoader(
                    size: 40,
                    loaderColorOne:   Colors.purple,
                    loaderColorTwo:Colors.red,
                    loaderColorThree:  Colors.yellow.shade700,
                    type: GFLoaderType.circle),
              ),
            ),

            //   SizedBox(width: 30),
            // Expanded(
            //   child: Text(
            //     message,
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
          ],
        ),
      );
    },
  );
}
// void showVideoUploadDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircularProgressIndicator(
//             color: Theme.of(context).primaryColor, // or use Colors.blue, etc.
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             "This property includes a video.\nUploading may take more time.\nPlease wait...",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     ),
//   );
// }
final PostPropertyController controller = Get.find();
void showVideoUploadDialog(BuildContext context) {
  controller.isUploading.value = true; // Mark uploading started

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(msg: "Project is uploading in background.");
        return true; // allow closing
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.cloud_upload_rounded,
                color: Theme.of(context).primaryColor,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              strokeWidth: 3.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Posting...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "This property includes a video.\nUpload may take a little longer.\nPlease wait patiently.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget commonButton({
  required String text,
  required VoidCallback onPressed,
  Color buttonColor = AppColor.primaryThemeColor,
  double height = 50.0,
  double width = double.infinity,
  TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),

})
{
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle,
      ),
    ),
  );
}

Widget customIconButton({
  required IconData icon,
  required VoidCallback onTap,
   double? iconSize,
   double? borderRadius,
  Color buttonColor = AppColor.black,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius??20),
        color: Colors.white.withOpacity(0.7),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding:  EdgeInsets.all(10.0),
        child: Icon(icon,size: iconSize ?? 18,color: buttonColor,),

      ),
    ),
  );
}