import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/common_widgets/RequiredTextWidget.dart';
import 'package:real_estate_app/common_widgets/custom_textformfield.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';

Widget fieldErrorMsg() => const Text('Field is required',style: TextStyle(color: AppColor.red),);

Widget makeeAsFeatured(PostPropertyController controller) => Obx(() => Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Checkbox(
      value: controller.isFeatured.value,
      activeColor: AppColor.primaryThemeColor,
      onChanged: (value) {
        controller.isFeatured.value = value!;
      },
    ),
    const Expanded(
        child: Text("Mark As featured ")
    ),
  ],
));

Widget securityDepositField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.securityDepositController,
    size: 50,
    maxLines: 2,
    labelText: 'Security Deposit',
    keyboardType: TextInputType.number,
  );
}
Widget MiniumLockInField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.miniumLockController,
    size: 50,
    maxLines: 2,
    labelText: 'Minimum Lock-in period',
    keyboardType: TextInputType.text,
  );
}
Widget totalProjectSizeField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.totalProjectSizeController,
    size: 50,

     maxLines: 2,

    labelText: 'Total Project Size / Total Unit',
    keyboardType: TextInputType.number,
  );
}
Widget avgProjectPriceField(PostPropertyController controller) {
  return CustomTextFormField(

    controller: controller.avgProjectPriceController,
    size: 50,

     maxLines: 2,

    labelText: 'Avg. Project Price',
    keyboardType: TextInputType.number,
  );
}
Widget configurationField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.configurationController,
    size: 50,

     maxLines: 2,

    labelText: 'Configurations',
    keyboardType: TextInputType.text,
  );
}
Widget reraIdField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.reraIDController,
    size: 50,
     maxLines: 2,
    labelText: 'RERA ID',
    keyboardType: TextInputType.number,
  );
}

Widget minimumLock_inPeriod(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.MinimumPreferredController,
    size: 50,
     maxLines: 2,
    labelText: 'Minimum Lock-in period preferred',
    keyboardType: TextInputType.text,
    // validator: (val) {
    //   if (val == null || val.trim().isEmpty) {
    //     return 'Please enter Minimum Lock-in period preferred';
    //   }
    //   return null;
    // },
  );
}

Widget statusField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.statusController,
    keyboardType: TextInputType.text,
    size: 50,

     maxLines: 2,

    labelText: 'Status',
    // validator: (val) {
    //   if (val == null || val.trim().isEmpty) {
    //     return 'Please enter status';
    //   }
    //   return null;
    // },
  );
}

Widget developerField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.develoeperController,
    keyboardType: TextInputType.text,
    size: 50,

     maxLines: 2,

    labelText: 'Developer',
    // validator: (val) {
    //   if (val == null || val.trim().isEmpty) {
    //     return 'Please enter developer';
    //   }
    //   return null;
    // },
  );
}

Widget floorNumberField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.florController,
    size: 50,
    maxLines: 2,
    labelText: 'Floor Number',
    keyboardType: TextInputType.number,
    // validator: (val) {
    //   if (val == null || val.trim().isEmpty) {
    //     return 'Please enter floor number';
    //   }
    //   return null;
    // },
  );
}

Widget towerBlockField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.TowerBlockController,
    size: 50,
    maxLines: 2,
    labelText: 'Tower/Block',
    keyboardType: TextInputType.number,
  );
}
Widget pgNoOfBeds(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.pgNoOfBedsController,
    size: 50,
    maxLines: 2,
    labelText: 'Total Number of Bed"s ',
    keyboardType: TextInputType.number,
  );
}

Widget pgServices(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.pgSevicesController,
    size: 50,
    maxLines: 2,
    labelText: 'PG Services',
    keyboardType: TextInputType.text,
  );
}

Widget unitNoField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.UnitController,
    size: 50,
    maxLines: 2,
    labelText: 'Unit No',
    keyboardType: TextInputType.number,
  );
}

Widget totalFloorField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.totalFloorController,
    keyboardType: TextInputType.number,
    size: 50,

     maxLines: 2,

    labelText: 'Total Floor',
    // validator: (val) {
    //   if (val == null || val.trim().isEmpty) {
    //     return 'Please enter total floor';
    //   }
    //   return null;
    // },
  );
}

Widget transactionTypeField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.transactionController,
    keyboardType: TextInputType.text,
    size: 50,

     maxLines: 2,

    labelText: 'Transaction Type',
    // validator: (val) {
    //   if (val == null || val.trim().isEmpty) {
    //     return 'Please enter transaction type';
    //   }
    //   return null;
    // },
  );
}

Widget plotNoField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.UnitController,
    size: 50,

     maxLines: 2,

    labelText: 'Plot No',
    keyboardType: TextInputType.number,
  );
}

Widget ceilingHeightField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.ceilingHeightController,
    keyboardType: TextInputType.text,
    size: 50,

     maxLines: 2,

    labelText: 'Ceiling Height',
  );
}

Widget numberOfSeatsField(PostPropertyController controller) {
  return CustomTextFormField(
    controller: controller.numberofSeatsAvailableController,
    keyboardType: TextInputType.text,
    size: 50,

     maxLines: 2,

    labelText: 'Number of Seats Available',
    // validator: (val) {
    //   if (val == null || val.trim().isEmpty) {
    //     return 'Please enter Number of Seats Available';
    //   }
    //   return null;
    // },
  );
}

Widget facingDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Facing",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.FacingList.contains(controller.Facing.value)
                  ? controller.Facing.value
                  : null,
              hint: const Text("Facing"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.Facing.value = newValue;
                }
              },
              items: controller.FacingList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget possessionStatusDropdown(PostPropertyController controller,BuildContext context) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius:
      const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Possession Status",
            style: TextStyle(
                color: Colors.grey, fontSize: 15),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children:
            controller.PossessionStatus.map<Widget>(
                    (String value) {
                  return RadioListTile<String>(
                    title: Text(value),
                    value: value,
                    groupValue: controller
                        .selectedPossessionStatus.value,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedPossessionStatus
                            .value = newValue;
                        if (newValue !=
                            "Under Construction") {
                          controller.possessionDateController
                              .clear(); // clear if switching away
                        }
                      }
                    },
                  );
                }).toList(),
          ),

          // Show date picker field only when "Under Construction" is selected
          if (controller.selectedPossessionStatus.value ==
              "Under Construction")
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  controller
                      .possessionDateController.text =
                      DateFormat('yyyy-MM-dd')
                          .format(picked);
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller:
                  controller.possessionDateController,
                  decoration: const InputDecoration(
                    hintText: 'Possession Date',
                    prefixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
Widget constructionStatusDropdown(PostPropertyController controller, BuildContext context) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormField<String>(
        validator: (value) {
          if (controller.selectedConstructionStatus.value.isEmpty) {
            return 'Please select construction status';
          }
          return null;
        },
        builder: (formFieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RequiredTextWidget(label: "Construction Status"),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: controller.projectConstructionStatus.entries.map<Widget>((entry) {
                  final String key = entry.key;
                  final String displayValue = entry.value;
                  return RadioListTile<String>(
                    title: Text(displayValue),
                    value: key,
                    groupValue: controller.selectedConstructionStatus.value,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedConstructionStatus.value = newValue;
                        formFieldState.didChange(newValue); // notify validator
                      }
                    },
                  );
                }).toList(),
              ),
              if (formFieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: Text(
                    formFieldState.errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              if (controller.selectedConstructionStatus.value == 'Ongoing') ...[
                boxH08(),

                /// Launch Date with validation
                // FormField<String>(
                //   validator: (_) {
                //     if (controller.launchDateController.text.trim().isEmpty) {
                //       return 'Please select Launch Date';
                //     }
                //     return null;
                //   },
                //   builder: (state) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const RequiredTextWidget(label: "Launch Date"),
                //         const SizedBox(height: 10,),
                //         GestureDetector(
                //           onTap: () async {
                //             DateTime? picked = await showDatePicker(
                //               context: context,
                //               initialDate: DateTime.now(),
                //               firstDate: DateTime(2000),
                //               lastDate: DateTime(2100),
                //             );
                //             if (picked != null) {
                //               controller.launchDateController.text =
                //                   DateFormat('yyyy-MM-dd').format(picked);
                //               state.didChange(controller.launchDateController.text); // trigger validation
                //             }
                //           },
                //           child: AbsorbPointer(
                //             child: TextFormField(
                //               controller: controller.launchDateController,
                //               decoration: const InputDecoration(
                //                 hintText: 'Launch Date',
                //                 fillColor: AppColor.white,
                //                 prefixIcon: Icon(Icons.calendar_month),
                //                 border: OutlineInputBorder(
                //                   borderRadius: BorderRadius.all(Radius.circular(12)),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //         if (state.hasError)
                //           Padding(
                //             padding: const EdgeInsets.only(top: 4, left: 8),
                //             child: Text(
                //               state.errorText!,
                //               style: const TextStyle(color: Colors.red, fontSize: 12),
                //             ),
                //           ),
                //       ],
                //     );
                //   },
                // ),
                //
                // boxH10(),
                //
                // /// Possession Date with validation
                // FormField<String>(
                //   validator: (_) {
                //     if (controller.possessionDateController.text.trim().isEmpty) {
                //       return 'Please select Possession Date';
                //     }
                //     return null;
                //   },
                //   builder: (state) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const RequiredTextWidget(label: "Possession Date"),
                //         GestureDetector(
                //           onTap: () async {
                //             DateTime? picked = await showDatePicker(
                //               context: context,
                //               initialDate: DateTime.now(),
                //               firstDate: DateTime(2000),
                //               lastDate: DateTime(2100),
                //             );
                //             if (picked != null) {
                //               controller.possessionDateController.text =
                //                   DateFormat('yyyy-MM-dd').format(picked);
                //               state.didChange(controller.possessionDateController.text); // trigger validation
                //             }
                //           },
                //           child: AbsorbPointer(
                //             child: TextFormField(
                //               controller: controller.possessionDateController,
                //               decoration: const InputDecoration(
                //                 hintText: 'Possession Date',
                //                 fillColor: AppColor.white,
                //                 prefixIcon: Icon(Icons.calendar_month),
                //                 border: OutlineInputBorder(
                //                   borderRadius: BorderRadius.all(Radius.circular(12)),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //         if (state.hasError)
                //           Padding(
                //             padding: const EdgeInsets.only(top: 4, left: 8),
                //             child: Text(
                //               state.errorText!,
                //               style: const TextStyle(color: Colors.red, fontSize: 12),
                //             ),
                //           ),
                //       ],
                //     );
                //   },
                // ),

                /// Launch Date with validation
                FormField<String>(
                  validator: (_) {
                    if (controller.launchDateController.text.trim().isEmpty) {
                      return 'Please select Launch Date';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RequiredTextWidget(label: "Launch Date"),
                        const SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              // Set the new Launch Date
                              controller.launchDateController.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              state.didChange(controller.launchDateController.text); // trigger validation

                              // 🧹 Clear Possession Date if it exists
                              controller.possessionDateController.clear();
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: controller.launchDateController,
                              decoration: const InputDecoration(
                                hintText: 'Launch Date',
                                fillColor: AppColor.white,
                                prefixIcon: Icon(Icons.calendar_month),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 8),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                boxH10(),

                /// Possession Date with validation
                FormField<String>(
                  validator: (_) {
                    if (controller.possessionDateController.text.trim().isEmpty) {
                      return 'Please select Possession Date';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RequiredTextWidget(label: "Possession Date"),
                        GestureDetector(
                          onTap: () async {
                            // Ensure launch date is selected before picking possession date
                            if (controller.launchDateController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select Launch Date first')),
                              );
                              return;
                            }

                            DateTime launchDate = DateTime.parse(controller.launchDateController.text);
                            DateTime now = DateTime.now();

                            DateTime firstDate = launchDate.isAfter(now) ? launchDate : now;
                            DateTime initialDate = firstDate;

                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: firstDate,
                              lastDate: DateTime(2100),
                            );

                            if (picked != null) {
                              controller.possessionDateController.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              state.didChange(controller.possessionDateController.text);
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: controller.possessionDateController,
                              decoration: const InputDecoration(
                                hintText: 'Possession Date',
                                fillColor: AppColor.white,
                                prefixIcon: Icon(Icons.calendar_month),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 8),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),



              ]

            ],
          );
        },
      ),
    ),
  );
}

Widget viewDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "View",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.ViewList.contains(controller.View.value)
                  ? controller.View.value
                  : null,
              hint: const Text("View"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.View.value = newValue;
                }
              },
              items: controller.ViewList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget seatsTypesDropdown(PostPropertyController controller) {
  return Obx(() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(10)),
          color: AppColor.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                "Seats Type",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15),
              ),
              DropdownButton<String>(
                value: controller.seatsTypeList
                    .contains(controller
                    .selectedSeatsType
                    .value)
                    ? controller
                    .selectedSeatsType.value
                    : null,
                hint:
                const Text("Select Seats Type"),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedSeatsType
                        .value = newValue;
                    // controller.showFurnishTypeError.value = false;
                  }
                },
                items: controller.seatsTypeList
                    .map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                underline: const SizedBox(),
                isExpanded: true,
                icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ],
  ));
}

Widget liftAvailabilityDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lift Availability",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.LiftAvailabilityList
                  .contains(controller.LiftAvailability.value)
                  ? controller.LiftAvailability.value
                  : null,
              hint: const Text("Lift Availability"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.LiftAvailability.value = newValue;
                }
              },
              items: controller.LiftAvailabilityList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget loanAvailableDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Loan available",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.LiftAvailabilityList
                  .contains(controller.LiftAvailability.value)
                  ? controller.LiftAvailability.value
                  : null,
              hint: const Text("Loan available"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.LiftAvailability.value = newValue;
                }
              },
              items: controller.LiftAvailabilityList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget ageOfPropertyDropdown(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Age of Property (Years)",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          DropdownButton<String>(
            value: controller.AgeofProperty.contains(controller.AgeProperty.value)
                ? controller.AgeProperty.value
                : null,
            hint: const Text("Age of Property (Years)"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.AgeProperty.value = newValue;
              }
            },
            items: controller.AgeofProperty.map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget balconyCheckBoxDropdown(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius:
      const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Balcony",
            style: TextStyle(
                color: Colors.grey, fontSize: 15),
          ),
          Obx(() => ListView(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            children:
            controller.BalconyList.map<Widget>(
                    (String value) {
                  return CheckboxListTile(
                    title: Text(value),
                    value: controller
                        .selectedBalconyList
                        .contains(value),
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                          if (newValue) {
                            controller
                                .selectedBalconyList
                                .add(value);
                          } else {
                            controller
                                .selectedBalconyList
                                .remove(value);
                          }
                      }
                    },
                  );
                }).toList(),
          ))
        ],
      ),
    ),
  );
}

Widget officeSpaceTypeDropdown(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Office Space Type",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          DropdownButton<String>(
            value: controller.OfficeSpaceTypeList.contains(controller.OfficeSpaceType.value)
                ? controller.OfficeSpaceType.value
                : null,
            hint: const Text("Office Space Type"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.OfficeSpaceType.value = newValue;
              }
            },
            items: controller.OfficeSpaceTypeList.map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget pantryListDropdown(PostPropertyController controller) => Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pantry",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          DropdownButton<String>(
            value: controller.PantryList.contains(controller.Pantry.value)
                ? controller.Pantry.value
                : null,
            hint: const Text("Pantry"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.Pantry.value = newValue;
              }
            },
            items: controller.PantryList.map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ),
        ],
      ),
    ),
  );

Widget personalWashroomDropdown(PostPropertyController controller) => Obx(() => Container(
  width: Get.width,
  decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    color: AppColor.white,
    border: Border.all(
      color: Colors.grey.shade300,
      width: 2.0,
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Personal Washroom",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        DropdownButton<String>(
          value: controller.yesOrNoValue.contains(controller.selectedPersonalWashroom.value)
              ? controller.selectedPersonalWashroom.value
              : null,
          hint: const Text("Personal Washroom"),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.selectedPersonalWashroom.value = newValue;
            }
          },
          items: controller.yesOrNoValue.map<DropdownMenuItem<String>>(
                  (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          underline: const SizedBox(),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ],
    ),
  ),
));

Widget furnishTypeDropdown(PostPropertyController controller) {
  return Obx(() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppColor.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const RequiredTextWidget(label: "Furnishing Type",),
              DropdownButton<String>(
                value: controller.furnishTypes.contains(controller.furnishType.value)
                    ? controller.furnishType.value
                    : null,
                hint: const Text("Select Furnishing Type"),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.furnishType.value = newValue;
                    controller.showFurnishTypeError.value = false;
                  }
                },
                items: controller.furnishTypes.map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                underline: const SizedBox(),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
              controller.showFurnishTypeError.value ? fieldErrorMsg(): const SizedBox.shrink()
            ],
          ),
        ),
      ),
    ],
  ));
}

Widget waterSourceDropdown(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Water Source",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          Obx(() => ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: controller.WaterSourceList
                .map<Widget>((String value) {
              return CheckboxListTile(
                title: Text(value),
                value:
                controller.selectedWaterSourceList.contains(value),
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    if (newValue) {
                      controller.selectedWaterSourceList.add(value);
                    } else {
                      controller.selectedWaterSourceList.remove(value);
                    }
                  }
                },
              );
            }).toList(),
          ))
        ],
      ),
    ),
  );
}

// Additional dropdown widgets needed for Office Space
Widget coveredParkingDropdown(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Covered Parking",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          DropdownButton<String>(
            value: controller.CoveredParkingList.contains(controller.CoveredParking.value)
                ? controller.CoveredParking.value
                : null,
            hint: const Text("Covered Parking"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.CoveredParking.value = newValue;
              }
            },
            items: controller.CoveredParkingList.map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget numberOfBathroomDropdown(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Number of Bathroom",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          DropdownButton<String>(
            value: controller.CoveredParkingList.contains(controller.numberOfBathroom.value)
                ? controller.numberOfBathroom.value
                : null,
            hint: const Text("Number of Bathroom"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.numberOfBathroom.value = newValue;
              }
            },
            items: controller.CoveredParkingList.map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget additionalRoomsDropdown(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius:
      const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Additional Rooms",
            style: TextStyle(
                color: Colors.grey, fontSize: 15),
          ),
          Obx(() => ListView(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            children: controller.additionalType
                .map<Widget>((String value) {
              return CheckboxListTile(
                title: Text(value),
                value: controller
                    .selectedAdditionalRooms
                    .contains(value),
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                      if (newValue) {
                        controller
                            .selectedAdditionalRooms
                            .add(value);
                      } else {
                        controller
                            .selectedAdditionalRooms
                            .remove(value);
                      }
                  }
                },
              );
            }).toList(),
          ))
        ],
      ),
    ),
  );
}

Widget uncoveredParkingDropdown(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Open/Uncovered Parking",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          DropdownButton<String>(
            value: controller.UnCoveredParkingList.contains(controller.UnCoveredParking.value)
                ? controller.UnCoveredParking.value
                : null,
            hint: const Text("Open/Uncovered Parking"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.UnCoveredParking.value = newValue;
              }
            },
            items: controller.UnCoveredParkingList.map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget powerBackupDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Power Back-up",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.PoweBackupList.contains(controller.PoweBackup.value)
                  ? controller.PoweBackup.value
                  : null,
              hint: const Text("Power Back-up"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.PoweBackup.value = newValue;
                }
              },
              items: controller.PoweBackupList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget flooringDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Flooring",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.FlooringList.contains(controller.Flooring.value)
                  ? controller.Flooring.value
                  : null,
              hint: const Text("Flooring"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.Flooring.value = newValue;
                }
              },
              items: controller.FlooringList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget availableFromDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Available From",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.availableFromList.contains(controller.selectedAvailableFrom.value)
                  ? controller.selectedAvailableFrom.value
                  : null,
              hint: const Text("Available From"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.selectedAvailableFrom.value = newValue;
                }
              },
              items: controller.availableFromList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget availableForDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RequiredTextWidget(label: "Available For",),
            DropdownButton<String>(
              value: controller.availableForList.contains(controller.selectedAvailableFor.value)
                  ? controller.selectedAvailableFor.value
                  : null,
              hint: const Text("Available For"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.selectedAvailableFor.value = newValue;
                  controller.showAvailableForError.value = false;
                }
              },
              items: controller.availableForList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
            controller.showAvailableForError.value ? fieldErrorMsg() : const SizedBox.shrink()
          ],
        ),
      ),
    ),
  );
}

Widget suitedForDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RequiredTextWidget(label: "Suited For"),

            DropdownButton<String>(
              value: controller.suitedForList.contains(controller.selectedSuitedFor.value)
                  ? controller.selectedSuitedFor.value
                  : null,
              hint: const Text("Suited For"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.selectedSuitedFor.value = newValue;
                  controller.showSuitedForError.value = false;
                }
              },
              items: controller.suitedForList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
            controller.showSuitedForError.value ? fieldErrorMsg() : const SizedBox.shrink()
          ],
        ),
      ),
    ),
  );
}

Widget roomTypeCheckBox(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius:
      const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RequiredTextWidget(label: "Room Type"),
          Obx(() => ListView(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            children:
            controller.roomTypeList.map<Widget>(
                    (String value) {
                  return CheckboxListTile(
                    title: Text(value),
                    value: controller
                        .selectedRoomTypesList
                        .contains(value),
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        if (newValue) {
                          controller
                              .selectedRoomTypesList
                              .add(value);
                          controller.showRoomTypeError.value = false;
                        } else {
                          controller
                              .selectedRoomTypesList
                              .remove(value);
                        }
                      }

                    },
                  );
                }).toList(),
          )),
          Obx(() => controller.showRoomTypeError.value ? fieldErrorMsg() : const SizedBox.shrink())
        ],
      ),
    ),
  );
}

Widget pgFoodDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Food Available",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.foodAvailableList.contains(controller.pgFood.value)
                  ? controller.pgFood.value
                  : null,
              hint: const Text("Food Available"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.pgFood.value = newValue;
                }
              },
              items: controller.foodAvailableList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget foodChargesIncludedDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RequiredTextWidget(label: "Food Charges Included"),

            DropdownButton<String>(
              value: controller.yesOrNoValue.contains(controller.foodCharges.value)
                  ? controller.foodCharges.value
                  : null,
              hint: const Text("Select"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.foodCharges.value = newValue;
                  controller.showFoodChargeError.value = false;
                }
              },
              items: controller.yesOrNoValue.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
            controller.showFoodChargeError.value ? fieldErrorMsg() : const SizedBox.shrink()
          ],
        ),
      ),
    ),
  );
}

Widget noticePeriodDaysDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notice Period(Day's)",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.NoticePeriodDaysList.contains(controller.noticeDays.value)
                  ? controller.noticeDays.value
                  : null,
              hint: const Text("Notice Period(Day's)"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.noticeDays.value = newValue;
                }
              },
              items: controller.NoticePeriodDaysList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget OperatingSinceDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Operating Since(Year's)",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.OperatingSinceYearsList.contains(controller.operatingYears.value)
                  ? controller.operatingYears.value
                  : null,
              hint: const Text("Operating Since(Year's)"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.operatingYears.value = newValue;
                }
              },
              items: controller.OperatingSinceYearsList.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget electricityChargesIncludedDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Electricity Charges Included",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.yesOrNoValue.contains(controller.electricityCharges.value)
                  ? controller.electricityCharges.value
                  : null,
              hint: const Text("Food Charges Included"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.electricityCharges.value = newValue;
                }
              },
              items: controller.yesOrNoValue.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget parkingAvailableDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Parking available",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.yesOrNoValue.contains(controller.parkingAvailable.value)
                  ? controller.parkingAvailable.value
                  : null,
              hint: const Text("Parking available"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.parkingAvailable.value = newValue;
                }
              },
              items: controller.yesOrNoValue.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget gateClosingTimeDropdown(PostPropertyController controller) {
  return Obx(
        () => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gate Closing Time",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButton<String>(
              value: controller.yesOrNoValue.contains(controller.gateClosingTime.value)
                  ? controller.gateClosingTime.value
                  : null,
              hint: const Text("Gate Closing Time"),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.gateClosingTime.value = newValue;
                }
              },
              items: controller.yesOrNoValue.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget pgRulesCheckBox(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius:
      const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PG,Hostel Rules",
            style: TextStyle(
                color: Colors.grey, fontSize: 15),
          ),
          Obx(() => ListView(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            children:
            controller.PG_HostelRulesList.map<Widget>(
                    (String value) {
                  return CheckboxListTile(
                    title: Text(value),
                    value: controller
                        .selectedPGRulesList
                        .contains(value),
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        if (newValue) {
                          controller
                              .selectedPGRulesList
                              .add(value);
                        } else {
                          controller
                              .selectedPGRulesList
                              .remove(value);
                        }
                      }
                    },
                  );
                }).toList(),
          ))
        ],
      ),
    ),
  );
}

Widget pgServicesCheckBox(PostPropertyController controller) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius:
      const BorderRadius.all(Radius.circular(10)),
      color: AppColor.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available PG Services",
            style: TextStyle(
                color: Colors.grey, fontSize: 15),
          ),
          Obx(() => ListView(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            children:
            controller.AvailablePGServicesList.map<Widget>(
                    (String value) {
                  return CheckboxListTile(
                    title: Text(value),
                    value: controller
                        .selectedPGServiceList
                        .contains(value),
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        if (newValue) {
                          controller
                              .selectedPGServiceList
                              .add(value);
                        } else {
                          controller
                              .selectedPGServiceList
                              .remove(value);
                        }
                      }
                    },
                  );
                }).toList(),
          ))
        ],
      ),
    ),
  );
}