
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/common_widgets/loading_dart.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/CustomBottomNavBar.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_controller.dart';
import 'package:real_estate_app/view/dashboard/bottom_navbar_screens/profile_screen/profile_screen.dart';
import 'package:real_estate_app/view/dashboard/view/BottomNavbar.dart';
import 'package:real_estate_app/view/dashboard/view/Provider/BotProvider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';


class Onboarding_Screen extends StatefulWidget {
  final String isfrom ;

  const Onboarding_Screen({Key? key, required this.isfrom}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Onboarding_Screen> {
  ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BotProvider>(context, listen: false).initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BotProvider>(
      builder: (context, botProvider, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    customIconButton(
                      icon: Icons.arrow_back,
                      onTap: () {

                        setState(() {
                          // botProvider.controller.isBuyerSelected.value = true;
                          botProvider.bottomBarController.selectedBottomIndex.value = 0;
                        });

                        if(widget.isfrom=="bottom"){
                          Navigator.pop(context);
                        }
                        // Get.offAll(() => const BottomNavbar());
                      },
                    ),
                    boxW15(),
                    customIconButton(
                      icon: Icons.star_border,
                      onTap: () {

                      },
                    ),
                  ],
                ),
                const Text(
                  "Houzza AI",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),




                GestureDetector(
                  onTap: () {
                     Get.to(ProfileScreen());
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor:
                    AppColor.white.withOpacity(0.8),
                    child: profileController.profileImage.isNotEmpty
                        ? CircleAvatar(
                      radius: 18,
                      backgroundImage: CachedNetworkImageProvider(
                        profileController.profileImage.value,
                      ),
                    ):
                    ClipOval(
                      child: Image.asset(

                        'assets/image_rent/profile.png',
                        width: 18,
                        height: 18,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              botProvider.messages.isEmpty
                  ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 15, left: 8.0, right: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/NewThemChangesAssets/botHouse.png"),
                        boxH15(),
                        Text(
                          "Hello, ${Get.find<ProfileController>().name.value}",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                        boxH05(),
                        const Text(
                          "Type or say anything",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25.0),
                        Wrap(
                          children: botProvider.search_controller.propertyFrom
                              .map((propertyType) => PropertyType(propertyType))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 15, left: 8.0, right: 8.0),
                    child: Column(
                      children: botProvider.messages.map((message) {
                        if (message is String) {
                          final bool isUserMessage = message.startsWith("You:");
                          return Column(
                            crossAxisAlignment:
                            isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: isUserMessage ? 160.0 : 160.0,
                                    padding: const EdgeInsets.all(6.0),
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: isUserMessage
                                          ? Colors.white.withOpacity(0.2)
                                          : Colors.white.withOpacity(0.2),
                                      border: Border.all(
                                        color: isUserMessage ? Colors.grey[300]! : Colors.grey[300]!,
                                      ),
                                      borderRadius: isUserMessage
                                          ? const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      )
                                          : const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: isUserMessage
                                        ? Text(
                                      message.substring(message.indexOf(":") + 2),
                                    )
                                        : TyperAnimatedTextKit(
                                      speed: const Duration(milliseconds: 60),
                                      isRepeatingAnimation: false,
                                      text: [message.substring(message.indexOf(":") + 2)],
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                            ],
                          );
                        } else if (message is Widget) {
                          return message;
                        } else {
                          return Container();
                        }
                      }).toList(),
                    ),
                  ),
                ),
              ),
              botProvider.isSpeechListening
                  ? const Expanded(
                child: Column(
                  children: [
                    RippleAnimation(
                      child: Icon(Icons.mic_none_sharp, size: 45),
                      color: Colors.deepOrange,
                      delay: Duration(milliseconds: 500),
                      repeat: true,
                      minRadius: 25,
                      maxRadius: 40,
                      ripplesCount: 6,
                      duration: Duration(milliseconds: 6 * 300),
                    ),
                    Text('listening...'),
                  ],
                ),
              )
                  : Container(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * .01,
                  horizontal: botProvider.openTextField ? 0 : MediaQuery.of(context).size.width * .025,
                ),
                child: Row(
                  children: [
                    // Expanded(
                    //   child: botProvider.openTextField
                    //       ? Container(
                    //     height: 150,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(25),
                    //       color: Colors.white.withOpacity(0.7),
                    //       border: Border.all(
                    //         color: Colors.grey.shade200,
                    //         width: 1,
                    //       ),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 17.0),
                    //       child: Column(
                    //         children: [
                    //           Expanded(
                    //             child: TextField(
                    //               controller: botProvider.txtController,
                    //               keyboardType: TextInputType.multiline,
                    //               maxLines: null,
                    //               decoration: InputDecoration(
                    //                 hintText: botProvider.isSpeechListening
                    //                     ? botProvider.lastWords
                    //                     : botProvider.speechEnabled
                    //                     ? 'Tap the microphone to start speaking...'
                    //                     : 'Speech not available',
                    //                 hintStyle: const TextStyle(color: Colors.grey),
                    //                 border: InputBorder.none,
                    //               ),
                    //               onChanged: (text) {
                    //                 botProvider.handleTextInput(text);
                    //               },
                    //               minLines: 1,
                    //               maxLength: 70,
                    //               onSubmitted: (String value) {
                    //                 String message = botProvider.txtController.text.trim();
                    //                 if (message.isNotEmpty) {
                    //                   if (botProvider.isSpeechListening) {
                    //                     botProvider.stopListening();
                    //                     botProvider.ttsService.stop();
                    //                   }
                    //                   botProvider.sendMessage(message);
                    //                   botProvider.txtController.clear();
                    //                 }
                    //               },
                    //             ),
                    //           ),
                    //           Row(
                    //             children: [
                    //               Container(
                    //                 decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(20),
                    //                   color: AppColor.secondaryThemeColor,
                    //                 ),
                    //                 child: IconButton(
                    //                   onPressed: () {
                    //                     print("isListening ${botProvider.isListening}");
                    //                     if (botProvider.isSpeechListening) {
                    //                       botProvider.stopListening();
                    //                       botProvider.ttsService.stop();
                    //                     } else {
                    //                       botProvider.ttsService.stop();
                    //                       botProvider.startListening();
                    //                     }
                    //                   },
                    //                   icon: Icon(
                    //                     botProvider.isSpeechListening ? Icons.mic : Icons.mic_off,
                    //                     color: AppColor.black,
                    //                     size: 26,
                    //                   ),
                    //                 ),
                    //               ),
                    //               boxW05(),
                    //               Container(
                    //                 decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(20),
                    //                   color: AppColor.primaryThemeColor,
                    //                 ),
                    //                 child: IconButton(
                    //                   onPressed: () {
                    //                     if (botProvider.area.isEmpty) {
                    //                       botProvider.sendBotMessage(
                    //                           'Please enter area in which you are searching property.');
                    //                     } else {
                    //                       botProvider.pickImage(context);
                    //                     }
                    //                   },
                    //                   icon: const Icon(
                    //                     Icons.camera_alt_rounded,
                    //                     color: Colors.white,
                    //                     size: 26,
                    //                   ),
                    //                 ),
                    //               ),
                    //               const Spacer(),
                    //               MaterialButton(
                    //                 onPressed: () {
                    //                   String message = botProvider.txtController.text.trim();
                    //                   if (botProvider.isSpeechListening) {
                    //                     botProvider.stopListening();
                    //                     botProvider.ttsService.stop();
                    //                   }
                    //                   if (message.isNotEmpty) {
                    //                     botProvider.sendMessage(message);
                    //                     botProvider.txtController.clear();
                    //                   }
                    //                 },
                    //                 minWidth: 0,
                    //                 padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                    //                 shape: const CircleBorder(),
                    //                 color: AppColor.app_background,
                    //                 child: const Icon(
                    //                   Icons.send,
                    //                   color: AppColor.primaryThemeColor,
                    //                   size: 28,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   )
                    //       : GestureDetector(
                    //     onTap: () {
                    //       print("object");
                    //       botProvider.toggleTextField();
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(25),
                    //         color: Colors.white.withOpacity(0.7),
                    //         border: Border.all(
                    //           color: Colors.grey.shade200,
                    //           width: 1,
                    //         ),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    //         child: Row(
                    //           children: [
                    //             const Icon(Icons.search, color: Colors.black87, size: 25),
                    //             boxW15(),
                    //             const Text("Ask", style: TextStyle(color: Colors.grey, fontSize: 18)),
                    //             const Spacer(),
                    //             Row(
                    //               children: [
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(20),
                    //                     color: AppColor.secondaryThemeColor,
                    //                   ),
                    //                   child: IconButton(
                    //                     onPressed: () {},
                    //                     icon: const Icon(Icons.mic, color: AppColor.black, size: 26),
                    //                   ),
                    //                 ),
                    //                 boxW05(),
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(20),
                    //                     color: AppColor.primaryThemeColor,
                    //                   ),
                    //                   child: IconButton(
                    //                     onPressed: () {},
                    //                     icon: const Icon(
                    //                       Icons.camera_alt_rounded,
                    //                       color: Colors.white,
                    //                       size: 26,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child:
                   //   botProvider.openTextField ?
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.7),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 17.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: botProvider.txtController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: botProvider.isSpeechListening
                                        ? botProvider.lastWords
                                        : botProvider.speechEnabled
                                        ? 'Tap the microphone to start speaking...'
                                        : 'Speech not available',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) {
                                    botProvider.handleTextInput(text);
                                  },
                                  minLines: 1,
                                  maxLength: 70,
                                  onSubmitted: (String value) {
                                    String message = botProvider.txtController.text.trim();
                                    if (message.isNotEmpty) {
                                      if (botProvider.isSpeechListening) {
                                        botProvider.stopListening();
                                        botProvider.ttsService.stop();
                                      }
                                      botProvider.sendMessage(message);
                                      botProvider.txtController.clear();
                                    }
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColor.secondaryThemeColor,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        print("isListening ${botProvider.isListening}");
                                        if (botProvider.isSpeechListening) {
                                          botProvider.stopListening();
                                          botProvider.ttsService.stop();
                                        } else {
                                          botProvider.ttsService.stop();
                                          botProvider.startListening();
                                        }
                                      },
                                      icon: Icon(
                                        botProvider.isSpeechListening ? Icons.mic : Icons.mic_off,
                                        color: AppColor.black,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  boxW05(),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColor.primaryThemeColor,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        if (botProvider.area.isEmpty) {
                                          botProvider.sendBotMessage(
                                              'Please enter area in which you are searching property.');
                                        } else {
                                          botProvider.pickImage(context);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  MaterialButton(
                                    onPressed: () {
                                      String message = botProvider.txtController.text.trim();
                                      if (botProvider.isSpeechListening) {
                                        botProvider.stopListening();
                                        botProvider.ttsService.stop();
                                      }
                                      if (message.isNotEmpty) {
                                        botProvider.sendMessage(message);
                                        botProvider.txtController.clear();
                                      }
                                    },
                                    minWidth: 0,
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                                    shape: const CircleBorder(),
                                    color: AppColor.app_background,
                                    child: const Icon(
                                      Icons.send,
                                      color: AppColor.primaryThemeColor,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      //     : GestureDetector(
                      //   onTap: () {
                      //     print("object");
                      //     botProvider.toggleTextField();
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(25),
                      //       color: Colors.white.withOpacity(0.7),
                      //       border: Border.all(
                      //         color: Colors.grey.shade200,
                      //         width: 1,
                      //       ),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      //       child: Row(
                      //         children: [
                      //           const Icon(Icons.search, color: Colors.black87, size: 25),
                      //           boxW15(),
                      //           const Text("Ask", style: TextStyle(color: Colors.grey, fontSize: 18)),
                      //           const Spacer(),
                      //           Row(
                      //             children: [
                      //               Container(
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(20),
                      //                   color: AppColor.secondaryThemeColor,
                      //                 ),
                      //                 child: IconButton(
                      //                   onPressed: () {},
                      //                   icon: const Icon(Icons.mic, color: AppColor.black, size: 26),
                      //                 ),
                      //               ),
                      //               boxW05(),
                      //               Container(
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(20),
                      //                   color: AppColor.primaryThemeColor,
                      //                 ),
                      //                 child: IconButton(
                      //                   onPressed: () {},
                      //                   icon: const Icon(
                      //                     Icons.camera_alt_rounded,
                      //                     color: Colors.white,
                      //                     size: 26,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
              const Text(
                "Houzza AI can make mistakes, so double check it.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              boxH25(),
            ],
          ),
          bottomNavigationBar: const CustomBottomNavBar(),
        );

      },
    );
  }

  Widget PropertyType(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Obx(() => ChoiceChip(
        label: Text(text),
        labelStyle: TextStyle(
          color: Provider.of<BotProvider>(context, listen: false)
              .search_controller
              .selectedPropertyType
              .contains(text)
              ? AppColor.primaryThemeColor
              : Colors.black.withOpacity(0.5),
        ),
        selected: Provider.of<BotProvider>(context, listen: false)
            .search_controller
            .selectedPropertyType
            .contains(text),
        onSelected: (isSelected) {
          final botProvider = Provider.of<BotProvider>(context, listen: false);
          if (isSelected) {
            final city = text.replaceFirst('Property in ', '').trim();

            botProvider.search_controller.selectedPropertyType.value = text;
            botProvider.textController.text = city;
            botProvider.sendMessage(city);
          }
        },
        selectedColor: AppColor.primaryThemeColor.withOpacity(0.3),
        showCheckmark: false,
        side: BorderSide(
          color: Provider.of<BotProvider>(context, listen: false)
              .search_controller
              .selectedPropertyType
              .contains(text)
              ? Colors.white
              : Colors.grey.withOpacity(0.3),
          width: 0.8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      )),
    );
  }

}