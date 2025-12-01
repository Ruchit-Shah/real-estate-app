class PropertyAgentProfileModel {
  final int? status;
  final String? message;
  final List<Data>? data;
  final int? buyCount;
  final int? rentCount;
  final int? commercialCount;
  final List<UserDetails>? userDetails;
  final int? totalCount;
  final int? totalPages;
  final int? currentPage;
  final int? nextPage;
  final int? previousPage;

  PropertyAgentProfileModel({
    this.status,
    this.message,
    this.data,
    this.buyCount,
    this.rentCount,
    this.commercialCount,
    this.userDetails,
    this.totalCount,
    this.totalPages,
    this.currentPage,
    this.nextPage,
    this.previousPage,
  });

  PropertyAgentProfileModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList(),
        buyCount = json['buy_count'] as int?,
        rentCount = json['rent_count'] as int?,
        commercialCount = json['commercial_count'] as int?,
        userDetails = (json['user_details'] as List?)?.map((dynamic e) => UserDetails.fromJson(e as Map<String,dynamic>)).toList(),
        totalCount = json['total_count'] as int?,
        totalPages = json['total_pages'] as int?,
        currentPage = json['current_page'] as int?,
        nextPage = json['next_page'] as int?,
        previousPage = json['previous_page'] as int?;

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList(),
    'buy_count' : buyCount,
    'rent_count' : rentCount,
    'commercial_count' : commercialCount,
    'user_details' : userDetails?.map((e) => e.toJson()).toList(),
    'total_count' : totalCount,
    'total_pages' : totalPages,
    'current_page' : currentPage,
    'next_page' : nextPage,
    'previous_page' : previousPage
  };
}

class Data {
  final String? id;
  final List<PropertyImages>? propertyImages;
  final bool? isFavorite;
  final String? favoriteId;
  final int? daysSinceCreated;
  final String? userId;
  final String? propertyName;
  final String? markAsFeatured;
  final String? buildingType;
  final String? propertyType;
  final String? userType;
  final String? address;
  final String? cityName;
  final String? country;
  final String? state;
  final String? zipCode;
  final String? latitude;
  final String? longitude;
  final String? propertyPrice;
  final String? propertyDescription;
  final String? bhkType;
  final int? bathroom;
  final String? units;
  final int? area;
  final String? areaIn;
  final String? areaType;
  final String? furnishedType;
  final dynamic totalFloor;
  final dynamic propertyFloor;
  final String? availableStatus;
  final String? amenities;
  final String? developer;
  final String? projectType;
  final String? transactionType;
  final String? coverImage;
  final String? adminApproval;
  final String? connectToName;
  final String? connectToNo;
  final String? connectToEmail;
  final String? propertyAddedDate;
  final String? possessionStatus;
  final dynamic possessionDate;
  final String? ageOfProperty;
  final String? coveredParking;
  final String? uncoveredParking;
  final String? balcony;
  final String? powerBackup;
  final String? facing;
  final String? view;
  final String? flooring;
  final dynamic propertyVideo;
  final dynamic waterSource;
  final String? additionalRooms;
  final String? liftAvailability;
  final String? loanAvailability;
  final String? propertyNo;
  final String? officeSpaceType;
  final String? pantry;
  final String? personalWashroom;
  final String? ceilingHeight;
  final String? parkingAvailability;
  final String? seatType;
  final String? numberOfSeatsAvailable;
  final String? rent;
  final String? rentDuration;
  final String? maintenanceCost;
  final String? maintenanceFrequency;
  final bool? maintenanceIncluded;
  final String? securityDepositType;
  final String? customDepositAmount;
  final String? availableForCompanyLease;
  final String? availableFor;
  final String? suitedFor;
  final String? roomType;
  final String? foodAvailable;
  final String? foodChargesIncluded;
  final String? noticePeriod;
  final dynamic noticePeriodOtherDays;
  final String? electricityChargesIncluded;
  final String? totalBeds;
  final String? pgRules;
  final String? gateClosingTime;
  final dynamic gateClosingHour;
  final String? pgServices;
  final String? minLockinPeriod;
  final String? virtualTourAvailability;
  final String? propertyCategoryType;
  final String? videoUrlType;
  final String? videoUrl;
  final String? flatName;
  final String? nearLandmark;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  Data({
    this.id,
    this.propertyImages,
    this.isFavorite,
    this.favoriteId,
    this.daysSinceCreated,
    this.userId,
    this.propertyName,
    this.markAsFeatured,
    this.buildingType,
    this.propertyType,
    this.userType,
    this.address,
    this.cityName,
    this.country,
    this.state,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.propertyPrice,
    this.propertyDescription,
    this.bhkType,
    this.bathroom,
    this.units,
    this.area,
    this.areaIn,
    this.areaType,
    this.furnishedType,
    this.totalFloor,
    this.propertyFloor,
    this.availableStatus,
    this.amenities,
    this.developer,
    this.projectType,
    this.transactionType,
    this.coverImage,
    this.adminApproval,
    this.connectToName,
    this.connectToNo,
    this.connectToEmail,
    this.propertyAddedDate,
    this.possessionStatus,
    this.possessionDate,
    this.ageOfProperty,
    this.coveredParking,
    this.uncoveredParking,
    this.balcony,
    this.powerBackup,
    this.facing,
    this.view,
    this.flooring,
    this.propertyVideo,
    this.waterSource,
    this.additionalRooms,
    this.liftAvailability,
    this.loanAvailability,
    this.propertyNo,
    this.officeSpaceType,
    this.pantry,
    this.personalWashroom,
    this.ceilingHeight,
    this.parkingAvailability,
    this.seatType,
    this.numberOfSeatsAvailable,
    this.rent,
    this.rentDuration,
    this.maintenanceCost,
    this.maintenanceFrequency,
    this.maintenanceIncluded,
    this.securityDepositType,
    this.customDepositAmount,
    this.availableForCompanyLease,
    this.availableFor,
    this.suitedFor,
    this.roomType,
    this.foodAvailable,
    this.foodChargesIncluded,
    this.noticePeriod,
    this.noticePeriodOtherDays,
    this.electricityChargesIncluded,
    this.totalBeds,
    this.pgRules,
    this.gateClosingTime,
    this.gateClosingHour,
    this.pgServices,
    this.minLockinPeriod,
    this.virtualTourAvailability,
    this.propertyCategoryType,
    this.videoUrlType,
    this.videoUrl,
    this.flatName,
    this.nearLandmark,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        propertyImages = (json['property_images'] as List?)?.map((dynamic e) => PropertyImages.fromJson(e as Map<String,dynamic>)).toList(),
        isFavorite = json['is_favorite'] as bool?,
        favoriteId = json['favorite_id'] as String?,
        daysSinceCreated = json['days_since_created'] as int?,
        userId = json['user_id'] as String?,
        propertyName = json['property_name'] as String?,
        markAsFeatured = json['mark_as_featured'] as String?,
        buildingType = json['building_type'] as String?,
        propertyType = json['property_type'] as String?,
        userType = json['user_type'] as String?,
        address = json['address'] as String?,
        cityName = json['city_name'] as String?,
        country = json['country'] as String?,
        state = json['state'] as String?,
        zipCode = json['zip_code'] as String?,
        latitude = json['latitude'] as String?,
        longitude = json['longitude'] as String?,
        propertyPrice = json['property_price'] as String?,
        propertyDescription = json['property_description'] as String?,
        bhkType = json['bhk_type'] as String?,
        bathroom = json['bathroom'] as int?,
        units = json['units'] as String?,
        area = json['area'] as int?,
        areaIn = json['area_in'] as String?,
        areaType = json['area_type'] as String?,
        furnishedType = json['furnished_type'] as String?,
        totalFloor = json['total_floor'],
        propertyFloor = json['property_floor'],
        availableStatus = json['available_status'] as String?,
        amenities = json['amenities'] as String?,
        developer = json['developer'] as String?,
        projectType = json['project_type'] as String?,
        transactionType = json['transaction_type'] as String?,
        coverImage = json['cover_image'] as String?,
        adminApproval = json['admin_approval'] as String?,
        connectToName = json['connect_to_name'] as String?,
        connectToNo = json['connect_to_no'] as String?,
        connectToEmail = json['connect_to_email'] as String?,
        propertyAddedDate = json['property_added_date'] as String?,
        possessionStatus = json['possession_status'] as String?,
        possessionDate = json['possession_date'],
        ageOfProperty = json['age_of_property'] as String?,
        coveredParking = json['covered_parking'] as String?,
        uncoveredParking = json['uncovered_parking'] as String?,
        balcony = json['balcony'] as String?,
        powerBackup = json['power_backup'] as String?,
        facing = json['facing'] as String?,
        view = json['view'] as String?,
        flooring = json['flooring'] as String?,
        propertyVideo = json['property_video'],
        waterSource = json['water_source'],
        additionalRooms = json['additional_rooms'] as String?,
        liftAvailability = json['lift_availability'] as String?,
        loanAvailability = json['loan_availability'] as String?,
        propertyNo = json['property_no'] as String?,
        officeSpaceType = json['office_space_type'] as String?,
        pantry = json['pantry'] as String?,
        personalWashroom = json['personal_washroom'] as String?,
        ceilingHeight = json['ceiling_height'] as String?,
        parkingAvailability = json['parking_availability'] as String?,
        seatType = json['seat_type'] as String?,
        numberOfSeatsAvailable = json['number_of_seats_available'] as String?,
        rent = json['rent'] as String?,
        rentDuration = json['rent_duration'] as String?,
        maintenanceCost = json['maintenance_cost'] as String?,
        maintenanceFrequency = json['maintenance_frequency'] as String?,
        maintenanceIncluded = json['maintenance_included'] as bool?,
        securityDepositType = json['security_deposit_type'] as String?,
        customDepositAmount = json['custom_deposit_amount'] as String?,
        availableForCompanyLease = json['available_for_company_lease'] as String?,
        availableFor = json['available_for'] as String?,
        suitedFor = json['suited_for'] as String?,
        roomType = json['room_type'] as String?,
        foodAvailable = json['food_available'] as String?,
        foodChargesIncluded = json['food_charges_included'] as String?,
        noticePeriod = json['notice_period'] as String?,
        noticePeriodOtherDays = json['notice_period_other_days'],
        electricityChargesIncluded = json['electricity_charges_included'] as String?,
        totalBeds = json['total_beds'] as String?,
        pgRules = json['pg_rules'] as String?,
        gateClosingTime = json['gate_closing_time'] as String?,
        gateClosingHour = json['gate_closing_hour'],
        pgServices = json['pg_services'] as String?,
        minLockinPeriod = json['min_lockin_period'] as String?,
        virtualTourAvailability = json['virtual_tour_availability'] as String?,
        propertyCategoryType = json['property_category_type'] as String?,
        videoUrlType = json['video_url_type'] as String?,
        videoUrl = json['video_url'] as String?,
        flatName = json['flat_name'] as String?,
        nearLandmark = json['near_landmark'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'];

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'property_images' : propertyImages?.map((e) => e.toJson()).toList(),
    'is_favorite' : isFavorite,
    'favorite_id' : favoriteId,
    'days_since_created' : daysSinceCreated,
    'user_id' : userId,
    'property_name' : propertyName,
    'mark_as_featured' : markAsFeatured,
    'building_type' : buildingType,
    'property_type' : propertyType,
    'user_type' : userType,
    'address' : address,
    'city_name' : cityName,
    'country' : country,
    'state' : state,
    'zip_code' : zipCode,
    'latitude' : latitude,
    'longitude' : longitude,
    'property_price' : propertyPrice,
    'property_description' : propertyDescription,
    'bhk_type' : bhkType,
    'bathroom' : bathroom,
    'units' : units,
    'area' : area,
    'area_in' : areaIn,
    'area_type' : areaType,
    'furnished_type' : furnishedType,
    'total_floor' : totalFloor,
    'property_floor' : propertyFloor,
    'available_status' : availableStatus,
    'amenities' : amenities,
    'developer' : developer,
    'project_type' : projectType,
    'transaction_type' : transactionType,
    'cover_image' : coverImage,
    'admin_approval' : adminApproval,
    'connect_to_name' : connectToName,
    'connect_to_no' : connectToNo,
    'connect_to_email' : connectToEmail,
    'property_added_date' : propertyAddedDate,
    'possession_status' : possessionStatus,
    'possession_date' : possessionDate,
    'age_of_property' : ageOfProperty,
    'covered_parking' : coveredParking,
    'uncovered_parking' : uncoveredParking,
    'balcony' : balcony,
    'power_backup' : powerBackup,
    'facing' : facing,
    'view' : view,
    'flooring' : flooring,
    'property_video' : propertyVideo,
    'water_source' : waterSource,
    'additional_rooms' : additionalRooms,
    'lift_availability' : liftAvailability,
    'loan_availability' : loanAvailability,
    'property_no' : propertyNo,
    'office_space_type' : officeSpaceType,
    'pantry' : pantry,
    'personal_washroom' : personalWashroom,
    'ceiling_height' : ceilingHeight,
    'parking_availability' : parkingAvailability,
    'seat_type' : seatType,
    'number_of_seats_available' : numberOfSeatsAvailable,
    'rent' : rent,
    'rent_duration' : rentDuration,
    'maintenance_cost' : maintenanceCost,
    'maintenance_frequency' : maintenanceFrequency,
    'maintenance_included' : maintenanceIncluded,
    'security_deposit_type' : securityDepositType,
    'custom_deposit_amount' : customDepositAmount,
    'available_for_company_lease' : availableForCompanyLease,
    'available_for' : availableFor,
    'suited_for' : suitedFor,
    'room_type' : roomType,
    'food_available' : foodAvailable,
    'food_charges_included' : foodChargesIncluded,
    'notice_period' : noticePeriod,
    'notice_period_other_days' : noticePeriodOtherDays,
    'electricity_charges_included' : electricityChargesIncluded,
    'total_beds' : totalBeds,
    'pg_rules' : pgRules,
    'gate_closing_time' : gateClosingTime,
    'gate_closing_hour' : gateClosingHour,
    'pg_services' : pgServices,
    'min_lockin_period' : minLockinPeriod,
    'virtual_tour_availability' : virtualTourAvailability,
    'property_category_type' : propertyCategoryType,
    'video_url_type' : videoUrlType,
    'video_url' : videoUrl,
    'flat_name' : flatName,
    'near_landmark' : nearLandmark,
    'created_at' : createdAt,
    'updated_at' : updatedAt,
    'deleted_at' : deletedAt
  };
}

class PropertyImages {
  final String? id;
  final String? image;
  final String? createdAt;

  PropertyImages({
    this.id,
    this.image,
    this.createdAt,
  });

  PropertyImages.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        image = json['image'] as String?,
        createdAt = json['created_at'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'image' : image,
    'created_at' : createdAt
  };
}

class UserDetails {
  final String? id;
  final String? countryCode;
  final String? mobileNumber;
  final String? fullName;
  final String? email;
  final dynamic profileImage;
  final String? otp;
  final dynamic city;
  final String? userType;
  final String? accountType;
  final dynamic experience;
  final String? proprietorship;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  UserDetails({
    this.id,
    this.countryCode,
    this.mobileNumber,
    this.fullName,
    this.email,
    this.profileImage,
    this.otp,
    this.city,
    this.userType,
    this.accountType,
    this.experience,
    this.proprietorship,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  UserDetails.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        countryCode = json['country_code'] as String?,
        mobileNumber = json['mobile_number'] as String?,
        fullName = json['full_name'] as String?,
        email = json['email'] as String?,
        profileImage = json['profile_image'],
        otp = json['otp'] as String?,
        city = json['city'],
        userType = json['user_type'] as String?,
        accountType = json['account_type'] as String?,
        experience = json['experience'],
        proprietorship = json['proprietorship'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'];

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'country_code' : countryCode,
    'mobile_number' : mobileNumber,
    'full_name' : fullName,
    'email' : email,
    'profile_image' : profileImage,
    'otp' : otp,
    'city' : city,
    'user_type' : userType,
    'account_type' : accountType,
    'experience' : experience,
    'proprietorship' : proprietorship,
    'created_at' : createdAt,
    'updated_at' : updatedAt,
    'deleted_at' : deletedAt
  };
}