import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/common_widgets/height.dart';
import 'package:real_estate_app/global/app_color.dart';
import 'package:real_estate_app/view/property_screens/post_property_screen/NewChanges/fields_widgets.dart';
import 'package:real_estate_app/view/property_screens/properties_controllers/post_property_controller.dart';

/// Commercial
List<Widget> getOfficeSpaceWidgets(PostPropertyController controller,BuildContext context) {
  return [
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
    //  avgProjectPriceField(controller),
   //   boxH08(),
   //   configurationField(controller),
      boxH08(),
    ],
    floorNumberField(controller),
    boxH08(),
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    officeSpaceTypeDropdown(controller),
    boxH08(),
    MiniumLockInField(controller),

    boxH08(),
    pantryListDropdown(controller),
    boxH08(),
    personalWashroomDropdown(controller),
    boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    liftAvailabilityDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),
    boxH08(),
  ];
}
List<Widget> getShopWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
   //   avgProjectPriceField(controller),
   //   boxH08(),
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
                .launchDateController.text =
                DateFormat('yyyy-MM-dd')
                    .format(picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller:
            controller.launchDateController,
            decoration: const InputDecoration(
              hintText: 'Launch Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH10(),
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
              hintText: 'Possession Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH08(),
    //  configurationField(controller),
      boxH08(),
    ],
    floorNumberField(controller),
    boxH08(),
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    pantryListDropdown(controller),
    boxH08(),
    personalWashroomDropdown(controller),
    boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    ceilingHeightField(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    liftAvailabilityDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context)
  ];
}
List<Widget> getLandWidgets(PostPropertyController controller,BuildContext context) {
  return [
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
     // avgProjectPriceField(controller),
     // boxH08(),
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
                .launchDateController.text =
                DateFormat('yyyy-MM-dd')
                    .format(picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller:
            controller.launchDateController,
            decoration: const InputDecoration(
              hintText: 'Launch Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH10(),
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
              hintText: 'Possession Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH08(),
    //  configurationField(controller),
      boxH08(),
    ],
    plotNoField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    loanAvailableDropdown(controller),
  ];
}
List<Widget> getOfficeSpaceInITWidgets(PostPropertyController controller,BuildContext context) {
  return  [
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
      //avgProjectPriceField(controller),
     // boxH08(),
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
                .launchDateController.text =
                DateFormat('yyyy-MM-dd')
                    .format(picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller:
            controller.launchDateController,
            decoration: const InputDecoration(
              hintText: 'Launch Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH10(),
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
              hintText: 'Possession Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH08(),
    //  configurationField(controller),
      boxH08(),
    ],
    floorNumberField(controller),
    boxH08(),
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    officeSpaceTypeDropdown(controller),
    boxH08(),
    pantryListDropdown(controller),
    boxH08(),
    personalWashroomDropdown(controller),
    boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    liftAvailabilityDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),
  ];
}
List<Widget> getShowroomWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
     // avgProjectPriceField(controller),
     // boxH08(),
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
                .launchDateController.text =
                DateFormat('yyyy-MM-dd')
                    .format(picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller:
            controller.launchDateController,
            decoration: const InputDecoration(
              hintText: 'Launch Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH10(),
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
              hintText: 'Possession Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH08(),
     // configurationField(controller),
      boxH08(),
    ],
    floorNumberField(controller),
    boxH08(),
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    totalFloorField(controller),
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    pantryListDropdown(controller),
    boxH08(),
    personalWashroomDropdown(controller),
    boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    ceilingHeightField(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    liftAvailabilityDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),

  ];
}
List<Widget> getIndustrialPlotWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
     // avgProjectPriceField(controller),
   //   boxH08(),
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
                .launchDateController.text =
                DateFormat('yyyy-MM-dd')
                    .format(picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller:
            controller.launchDateController,
            decoration: const InputDecoration(
              hintText: 'Launch Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH10(),
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
              hintText: 'Possession Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH08(),
   //   configurationField(controller),
      boxH08(),
    ],
    plotNoField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    loanAvailableDropdown(controller),
  ];
}
List<Widget> getCoworkingSpaceWidgets(PostPropertyController controller,BuildContext context) {
  return  [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
     // avgProjectPriceField(controller),
     // boxH08(),
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
                .launchDateController.text =
                DateFormat('yyyy-MM-dd')
                    .format(picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller:
            controller.launchDateController,
            decoration: const InputDecoration(
              hintText: 'Launch Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH10(),
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
              hintText: 'Possession Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH08(),
    //  configurationField(controller),
      boxH08(),
    ],
    floorNumberField(controller),
    boxH08(),
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    minimumLock_inPeriod(controller),
    boxH08(),
    numberOfSeatsField(controller),
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    officeSpaceTypeDropdown(controller),
    boxH08(),
    pantryListDropdown(controller),
    boxH08(),
    personalWashroomDropdown(controller),
    boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    seatsTypesDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    liftAvailabilityDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),

  ];
}
List<Widget> getWarehouseWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
    //  avgProjectPriceField(controller),
    //  boxH08(),
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
                .launchDateController.text =
                DateFormat('yyyy-MM-dd')
                    .format(picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller:
            controller.launchDateController,
            decoration: const InputDecoration(
              hintText: 'Launch Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH10(),
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
              hintText: 'Possession Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH08(),
    //  configurationField(controller),
      boxH08(),
    ],
    ageOfPropertyDropdown(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    personalWashroomDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
  ];
}

/// Residential
List<Widget> getApartmentWidgets(PostPropertyController controller,BuildContext context) {

  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH10(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
     // avgProjectPriceField(controller),
     // boxH08(),
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
                .launchDateController.text =
                DateFormat('yyyy-MM-dd')
                    .format(picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller:
            controller.launchDateController,
            decoration: const InputDecoration(
              hintText: 'Launch Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH10(),
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
              hintText: 'Possession Date',fillColor: AppColor.white,
              prefixIcon: Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      boxH08(),
    //  configurationField(controller),
      boxH08(),
    ],

    boxH08(),
    additionalRoomsDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),

    liftAvailabilityDropdown(controller),
    boxH08(),

    waterSourceDropdown(controller),
    boxH08(),
    floorNumberField(controller),
    boxH08(),
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    totalFloorField(controller),
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    // numberOfBathroomDropdown(controller),
    // boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),

    facingDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),

  ];
}
List<Widget> getPlotWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
   //   avgProjectPriceField(controller),

     // configurationField(controller),

    ],
    plotNoField(controller),
    boxH08(),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    loanAvailableDropdown(controller),
  ];
}
List<Widget> getIndependentHouseWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
    //  avgProjectPriceField(controller),
    //  boxH08(),

    ],
    totalFloorField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    additionalRoomsDropdown(controller),
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    // numberOfBathroomDropdown(controller),
    // boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),
    waterSourceDropdown(controller),
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    liftAvailabilityDropdown(controller),
    boxH08(),
    waterSourceDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),

  ];
}
List<Widget> getVillaWidgets(PostPropertyController controller,BuildContext context)  {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
  //    avgProjectPriceField(controller),
    //  boxH08(),

    ],
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    totalFloorField(controller),
    boxH08(),
    additionalRoomsDropdown(controller),
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    // numberOfBathroomDropdown(controller),
    // boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    liftAvailabilityDropdown(controller),
    boxH08(),
    waterSourceDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),

  ];
}
List<Widget> getBuilderFloorWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
   //   avgProjectPriceField(controller),
  //    boxH08(),

    ],
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    floorNumberField(controller),
    boxH08(),
    additionalRoomsDropdown(controller),
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    // numberOfBathroomDropdown(controller),
    // boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),

    liftAvailabilityDropdown(controller),
    boxH08(),
    waterSourceDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),

  ];
}
List<Widget> getPenthouseWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
     // avgProjectPriceField(controller),
    //  boxH08(),

    ],
    floorNumberField(controller),
    boxH08(),
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],

    boxH08(),
    totalFloorField(controller),
    boxH08(),
    additionalRoomsDropdown(controller),

    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    // numberOfBathroomDropdown(controller),
    // boxH08(),
    coveredParkingDropdown(controller),
    boxH08(),
    uncoveredParkingDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    liftAvailabilityDropdown(controller),

    boxH08(),
    waterSourceDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller),

  ];
}
List<Widget> getPGWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    availableForDropdown(controller),
    boxH08(),
    suitedForDropdown(controller),
    boxH08(),
    roomTypeCheckBox(controller),
    boxH08(),
    foodChargesIncludedDropdown(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),boxH08()],
    pgNoOfBeds(controller),
    boxH08(),
    availableFromDropdown(controller),
    boxH08(),
    waterSourceDropdown(controller),
    boxH08(),
    pgFoodDropdown(controller),
    boxH08(),
    noticePeriodDaysDropdown(controller),
    boxH08(),
    OperatingSinceDropdown(controller),
    boxH08(),
    electricityChargesIncludedDropdown(controller),
    boxH08(),
    parkingAvailableDropdown(controller),
boxH08(),
    pgRulesCheckBox(controller),
    boxH08(),
    gateClosingTimeDropdown(controller),
    boxH08(),
    pgServices(controller),
    boxH08(),
    ageOfPropertyDropdown(controller),
    boxH08(),
    numberOfBathroomDropdown(controller),
    boxH08(),
    balconyCheckBoxDropdown(controller),
    boxH08(),
    powerBackupDropdown(controller),
    boxH08(),
    facingDropdown(controller),
    boxH08(),
    viewDropdown(controller),
    boxH08(),
    flooringDropdown(controller)
  ];
}

///project
List<Widget> getApartmentProjectWidgets(PostPropertyController controller,BuildContext context) {

  return [
    boxH08(),
    constructionStatusDropdown(controller, context) ,

    boxH08(),
    totalProjectSizeField(controller),
    boxH08(),
    reraIdField(controller),
    boxH08(),
    // avgProjectPriceField(controller),
    // boxH08(),

    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),

  ];
}
List<Widget> getPlotProjectWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
      //   avgProjectPriceField(controller),

      // configurationField(controller),

    ],
    plotNoField(controller),
    boxH08(),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),

    loanAvailableDropdown(controller),
  ];
}
List<Widget> getIndependentProjectHouseWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
      //  avgProjectPriceField(controller),
      //  boxH08(),

    ],
    totalFloorField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],


  ];
}

List<Widget> getVillaProjectsWidgets(PostPropertyController controller,BuildContext context)  {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
      //    avgProjectPriceField(controller),
      //  boxH08(),

    ],
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    totalFloorField(controller),


  ];
}
List<Widget> getBuilderProjectFloorWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
      //   avgProjectPriceField(controller),
      //    boxH08(),

    ],
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],
    boxH08(),
    floorNumberField(controller),

  ];
}
List<Widget> getPenthouseProjectWidgets(PostPropertyController controller,BuildContext context) {
  return [
    boxH08(),
    controller.selectedIndex.value == 1 ? constructionStatusDropdown(controller, context) :
    possessionStatusDropdown(controller, context),
    boxH08(),
    furnishTypeDropdown(controller),
    boxH08(),
    unitNoField(controller),
    boxH08(),
    if(controller.selectedIndex.value == 1)...[
      totalProjectSizeField(controller),
      boxH08(),
      reraIdField(controller),
      boxH08(),
      // avgProjectPriceField(controller),
      //  boxH08(),

    ],
    floorNumberField(controller),
    boxH08(),
    towerBlockField(controller),
    if (controller.categoryPriceselected.value == 1)...[boxH08(),
      securityDepositField(controller),],

    boxH08(),
    totalFloorField(controller),


  ];
}