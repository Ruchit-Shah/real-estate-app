class PropertyDetailsModel {
  final dynamic status;
  final Data? data;

  PropertyDetailsModel({
    this.status,
    this.data,
  });

  PropertyDetailsModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] ,
        data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status' : status,
    'data' : data?.toJson()
  };
}

class Data {
  final PropertyDetails? propertyDetails;
  final List<Amenities>? amenities;
  final List<PropertyImages>? propertyImages;
  final List<TourSchedule>? tourSchedule;
  final List<UserDetails>? userDetails;

  Data({
    this.propertyDetails,
    this.amenities,
    this.propertyImages,
    this.tourSchedule,
    this.userDetails,
  });

  Data.fromJson(Map<String, dynamic> json)
      : propertyDetails = (json['property_details'] as Map<String,dynamic>?) != null ? PropertyDetails.fromJson(json['property_details'] as Map<String,dynamic>) : null,
        amenities = (json['amenities'] as List?)?.map((dynamic e) => Amenities.fromJson(e as Map<String,dynamic>)).toList(),
        propertyImages = (json['property_images'] as List?)?.map((dynamic e) => PropertyImages.fromJson(e as Map<String,dynamic>)).toList(),
        tourSchedule = (json['tour_schedule'] as List?)?.map((dynamic e) => TourSchedule.fromJson(e as Map<String,dynamic>)).toList(),
        userDetails = (json['user_details'] as List?)?.map((dynamic e) => UserDetails.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'property_details' : propertyDetails?.toJson(),
    'amenities' : amenities?.map((e) => e.toJson()).toList(),
    'property_images' : propertyImages?.map((e) => e.toJson()).toList(),
    'tour_schedule' : tourSchedule?.map((e) => e.toJson()).toList(),
    'user_details' : userDetails?.map((e) => e.toJson()).toList()
  };
}

class PropertyDetails {
  final String? id;
  bool? isFavorite;
  final String? favoriteId;
  final String? userId;
  final String? propertyName;
  final String? markAsFeatured;
  final String? buildingType;
  final String? propertyType;
  final String? userType;
  final String? address;
  final String? addressArea;
  final String? cityName;
  final String? country;
  final String? state;
  final String? zipCode;
  final String? latitude;
  final String? longitude;
  final double? propertyPrice;
  final String? propertyDescription;
  final String? bhkType;
  final int? bathroom;
  final String? units;
  final double? area;
  final String? areaIn;
  final String? areaType;
  final String? furnishedType;
  final String? totalFloor;
  final String? propertyFloor;
  final String? block;
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
  final String? operatingSince;
  final String? possessionDate;
  final String? ageOfProperty;
  final String? coveredParking;
  final String? uncoveredParking;
  final String? balcony;
  final String? powerBackup;
  final String? facing;
  final String? view;
  final String? flooring;
  final String? propertyVideo;
  final String? waterSource;
  final String? additionalRooms;
  final String? liftAvailability;
  final String? loanAvailability;
  final String? propertyNo;
  final String? plotNo;
  final String? officeSpaceType;
  final String? pantry;
  final String? personalWashroom;
  final String? ceilingHeight;
  final String? parkingAvailability;
  final String? seatType;
  final String? numberOfSeatsAvailable;
  final double? rent;
  final String? rentDuration;
  final String? maintenanceCost;
  final String? maintenanceFrequency;
  final bool? maintenanceIncluded;
  final String? securityDepositType;
  final double? customDepositAmount;
  final String? availableForCompanyLease;
  final String? availableFor;
  final String? availableFrom;
  final String? availableOn;
  final String? suitedFor;
  final String? roomType;
  final String? foodAvailable;
  final String? foodChargesIncluded;
  final String? noticePeriod;
  final String? noticePeriodOtherDays;
  final String? electricityChargesIncluded;
  final String? totalBeds;
  final String? pgRules;
  final String? gateClosingTime;
  final String? gateClosingHour;
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
  final String? deletedAt;

  PropertyDetails({
    this.id,
    this.isFavorite,
    this.favoriteId,
    this.userId,
    this.propertyName,
    this.markAsFeatured,
    this.buildingType,
    this.propertyType,
    this.userType,
    this.address,
    this.addressArea,
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
    this.block,
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
    this.operatingSince,
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
    this.plotNo,
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
    this.availableFrom,
    this.availableOn,
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

  factory PropertyDetails.fromJson(Map<String, dynamic> json) {
    return PropertyDetails(
      id: json['_id'] as String?,
      isFavorite: json['is_favorite'] as bool?,
      favoriteId: json['favorite_id'] as String?,
      userId: json['user_id'] as String?,
      propertyName: json['property_name'] as String?,
      markAsFeatured: json['mark_as_featured'] as String?,
      buildingType: json['building_type'] as String?,
      propertyType: json['property_type'] as String?,
      userType: json['user_type'] as String?,
      address: json['address'] as String?,
      addressArea: json['address_area'] as String?,
      cityName: json['city_name'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      zipCode: json['zip_code'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      propertyPrice: (json['property_price'] as num?)?.toDouble(),
      propertyDescription: json['property_description'] as String?,
      bhkType: json['bhk_type'] as String?,
      bathroom: json['bathroom'] as int?,
      units: json['units'] as String?,
      area: (json['area'] as num?)?.toDouble(),
      areaIn: json['area_in'] as String?,
      areaType: json['area_type'] as String?,
      furnishedType: json['furnished_type'] as String?,
      totalFloor: json['total_floor'] as String?,
      propertyFloor: json['property_floor'] as String?,
      block: json['block'] as String?,
      availableStatus: json['available_status'] as String?,
      amenities: json['amenities'] as String?,
      developer: json['developer'] as String?,
      projectType: json['project_type'] as String?,
      transactionType: json['transaction_type'] as String?,
      coverImage: json['cover_image'] as String?,
      adminApproval: json['admin_approval'] as String?,
      connectToName: json['connect_to_name'] as String?,
      connectToNo: json['connect_to_no'] as String?,
      connectToEmail: json['connect_to_email'] as String?,
      propertyAddedDate: json['property_added_date'] as String?,
      possessionStatus: json['possession_status'] as String?,
      operatingSince: json['operating_since'] as String?,
      possessionDate: json['possession_date'] as String?,
      ageOfProperty: json['age_of_property'] as String?,
      coveredParking: json['covered_parking'] as String?,
      uncoveredParking: json['uncovered_parking'] as String?,
      balcony: json['balcony'] as String?,
      powerBackup: json['power_backup'] as String?,
      facing: json['facing'] as String?,
      view: json['view'] as String?,
      flooring: json['flooring'] as String?,
      propertyVideo: json['property_video'] as String?,
      waterSource: json['water_source'] as String?,
      additionalRooms: json['additional_rooms'] as String?,
      liftAvailability: json['lift_availability'] as String?,
      loanAvailability: json['loan_availability'] as String?,
      propertyNo: json['property_no'] as String?,
      plotNo: json['plot_no'] as String?,
      officeSpaceType: json['office_space_type'] as String?,
      pantry: json['pantry'].toString(),
      personalWashroom: json['personal_washroom'] as String?,
      ceilingHeight: json['ceiling_height'] as String?,
      parkingAvailability: json['parking_availability'] as String?,
      seatType: json['seat_type'] as String?,
      numberOfSeatsAvailable: json['number_of_seats_available'] as String?,
      rent: (json['rent'] as num?)?.toDouble(),
      rentDuration: json['rent_duration'] as String?,
      maintenanceCost: json['maintenance_cost'] as String?,
      maintenanceFrequency: json['maintenance_frequency'] as String?,
      maintenanceIncluded: json['maintenance_included'] as bool?,
      securityDepositType: json['security_deposit_type'] as String?,
      customDepositAmount: (json['custom_deposit_amount'] as num?)?.toDouble(),
      availableForCompanyLease: json['available_for_company_lease'] as String?,
      availableFor: json['available_for'] as String?,
      availableFrom: json['available_from'] as String?,
      availableOn: json['available_on'] as String?,
      suitedFor: json['suited_for'] as String?,
      roomType: json['room_type'] as String?,
      foodAvailable: json['food_available'] as String?,
      foodChargesIncluded: json['food_charges_included'] as String?,
      noticePeriod: json['notice_period'] as String?,
      noticePeriodOtherDays: json['notice_period_other_days'] as String?,
      electricityChargesIncluded: json['electricity_charges_included'] as String?,
      totalBeds: json['total_beds'] as String?,
      pgRules: json['pg_rules'] as String?,
      gateClosingTime: json['gate_closing_time'] as String?,
      gateClosingHour: json['gate_closing_hour'] as String?,
      pgServices: json['pg_services'] as String?,

      minLockinPeriod: json['min_lockin_period'] as String?,
      virtualTourAvailability: json['virtual_tour_availability'] as String?,
      propertyCategoryType: json['property_category_type'] as String?,
      videoUrlType: json['video_url_type'] as String?,
      videoUrl: json['video_url'] as String?,
      flatName: json['flat_name'] as String?,
      nearLandmark: json['near_landmark'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'is_favorite': isFavorite,
    'favorite_id': favoriteId,
    'user_id': userId,
    'property_name': propertyName,
    'mark_as_featured': markAsFeatured,
    'building_type': buildingType,
    'property_type': propertyType,
    'user_type': userType,
    'address': address,
    'address_area': addressArea,
    'city_name': cityName,
    'country': country,
    'state': state,
    'zip_code': zipCode,
    'latitude': latitude,
    'longitude': longitude,
    'property_price': propertyPrice,
    'property_description': propertyDescription,
    'bhk_type': bhkType,
    'bathroom': bathroom,
    'units': units,
    'area': area,
    'area_in': areaIn,
    'area_type': areaType,
    'furnished_type': furnishedType,
    'total_floor': totalFloor,
    'property_floor': propertyFloor,
    'block': block,
    'available_status': availableStatus,
    'amenities': amenities,
    'developer': developer,
    'project_type': projectType,
    'transaction_type': transactionType,
    'cover_image': coverImage,
    'admin_approval': adminApproval,
    'connect_to_name': connectToName,
    'connect_to_no': connectToNo,
    'connect_to_email': connectToEmail,
    'property_added_date': propertyAddedDate,
    'possession_status': possessionStatus,
    'operating_since': operatingSince,
    'possession_date': possessionDate,
    'age_of_property': ageOfProperty,
    'covered_parking': coveredParking,
    'uncovered_parking': uncoveredParking,
    'balcony': balcony,
    'power_backup': powerBackup,
    'facing': facing,
    'view': view,
    'flooring': flooring,
    'property_video': propertyVideo,
    'water_source': waterSource,
    'additional_rooms': additionalRooms,
    'lift_availability': liftAvailability,
    'loan_availability': loanAvailability,
    'property_no': propertyNo,
    'plot_no': plotNo,
    'office_space_type': officeSpaceType,
    'pantry': pantry,
    'personal_washroom': personalWashroom,
    'ceiling_height': ceilingHeight,
    'parking_availability': parkingAvailability,
    'seat_type': seatType,
    'number_of_seats_available': numberOfSeatsAvailable,
    'rent': rent,
    'rent_duration': rentDuration,
    'maintenance_cost': maintenanceCost,
    'maintenance_frequency': maintenanceFrequency,
    'maintenance_included': maintenanceIncluded,
    'security_deposit_type': securityDepositType,
    'custom_deposit_amount': customDepositAmount,
    'available_for_company_lease': availableForCompanyLease,
    'available_for': availableFor,
    'available_from': availableFrom,
    'available_on': availableOn,
    'suited_for': suitedFor,
    'room_type': roomType,
    'food_available': foodAvailable,
    'food_charges_included': foodChargesIncluded,
    'notice_period': noticePeriod,
    'notice_period_other_days': noticePeriodOtherDays,
    'electricity_charges_included': electricityChargesIncluded,
    'total_beds': totalBeds,
    'pg_rules': pgRules,
    'gate_closing_time': gateClosingTime,
    'gate_closing_hour': gateClosingHour,
    'pg_services': pgServices,
    'min_lockin_period': minLockinPeriod,
    'virtual_tour_availability': virtualTourAvailability,
    'property_category_type': propertyCategoryType,
    'video_url_type': videoUrlType,
    'video_url': videoUrl,
    'flat_name': flatName,
    'near_landmark': nearLandmark,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
  };
}


class Amenities {
  final String? name;
  final String? id;
  final String? icon;

  Amenities({
    this.name,
    this.id,
    this.icon,
  });

  Amenities.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['_id'] as String?,
        icon = json['icon'] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    '_id' : id,
    'icon' : icon
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

class TourSchedule {
  final String? id;
  final String? userId;
  final String? agoraToken;
  final String? channelName;
  final String? propertyOwnerId;
  final String? propertyId;
  final String? scheduleDate;
  final String? timeslot;
  final String? timeUnit;
  final String? status;
  final String? tourType;

  TourSchedule({
    this.id,
    this.userId,
    this.agoraToken,
    this.channelName,
    this.propertyOwnerId,
    this.propertyId,
    this.scheduleDate,
    this.timeslot,
    this.timeUnit,
    this.status,
    this.tourType,
  });

  TourSchedule.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        userId = json['user_id'] as String?,
        agoraToken = json['agora_token'] as String?,
        channelName = json['channel_name'] as String?,
        propertyOwnerId = json['property_owner_id'] as String?,
        propertyId = json['property_id'] as String?,
        scheduleDate = json['schedule_date'] as String?,
        timeslot = json['timeslot'] as String?,
        timeUnit = json['time_unit'] as String?,
        status = json['status'] as String?,
        tourType = json['tour_type'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'user_id' : userId,
    'agora_token' : agoraToken,
    'channel_name' : channelName,
    'property_owner_id' : propertyOwnerId,
    'property_id' : propertyId,
    'schedule_date' : scheduleDate,
    'timeslot' : timeslot,
    'time_unit' : timeUnit,
    'status' : status,
    'tour_type' : tourType
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
  final double? experience;
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
        experience = json['experience'] as double?,
        proprietorship = json['proprietorship'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'].toString();

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