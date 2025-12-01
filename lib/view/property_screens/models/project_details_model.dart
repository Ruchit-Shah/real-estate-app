class ProjectDetailsModel {
  final int? status;
  final ProjectDetailsData? data;

  ProjectDetailsModel({
    this.status,
    this.data,
  });

  ProjectDetailsModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        data = (json['data'] as Map<String,dynamic>?) != null ? ProjectDetailsData.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status' : status,
    'data' : data?.toJson()
  };
}

class ProjectDetailsData {
  final ProjectDetails? projectDetails;
  final List<Amenities>? amenities;
  final List<ProjectImages>? projectImages;
  final List<ProjectProperties>? projectProperties;
  final List<TourSchedule>? tourSchedule;
  final List<UserDetails>? userDetails;

  ProjectDetailsData({
    this.projectDetails,
    this.amenities,
    this.projectImages,
    this.projectProperties,
    this.tourSchedule,
    this.userDetails,
  });

  ProjectDetailsData.fromJson(Map<String, dynamic> json)
      : projectDetails = (json['project_details'] as Map<String,dynamic>?) != null ? ProjectDetails.fromJson(json['project_details'] as Map<String,dynamic>) : null,
        amenities = (json['amenities'] as List?)?.map((dynamic e) => Amenities.fromJson(e as Map<String,dynamic>)).toList(),
        projectImages = (json['project_images'] as List?)?.map((dynamic e) => ProjectImages.fromJson(e as Map<String,dynamic>)).toList(),
        projectProperties = (json['project_properties'] as List?)?.map((dynamic e) => ProjectProperties.fromJson(e as Map<String,dynamic>)).toList(),
        tourSchedule = (json['tour_schedule'] as List?)?.map((dynamic e) => TourSchedule.fromJson(e as Map<String,dynamic>)).toList(),
        userDetails = (json['user_details'] as List?)?.map((dynamic e) => UserDetails.fromJson(e as Map<String,dynamic>)).toList();


  Map<String, dynamic> toJson() => {
    'project_details' : projectDetails?.toJson(),
    'amenities' : amenities?.map((e) => e.toJson()).toList(),
    'project_images' : projectImages?.map((e) => e.toJson()).toList(),
    'project_properties' : projectProperties?.map((e) => e.toJson()).toList(),
    'tour_schedule' : tourSchedule?.map((e) => e.toJson()).toList(),

    'user_details' : userDetails?.map((e) => e.toJson()).toList()

  };
}

class ProjectDetails {
  final String? id;
  final String? userId;
  late final bool? isFavorite;
  final String? favoriteId;
  final String? adminApproval;
  final String? projectName;
  final String? markAsFeatured;
  final String? buildingType;
  final String? projectType;
  final String? userType;
  final String? address;
  final String? cityName;
  final String? country;
  final String? state;
  final String? zipCode;
  final String? latitude;
  final String? longitude;
  final String? connectToName;
  final String? connectToNo;
  final String? connectToEmail;
  final String? totalProjectSize;
  final String? averageProjectPrice;
  final String? congfigurations;
  final String? launchDate;
  final String? possessionStart;
  final String? constructionStatus;
  final String? reraId;
  final String? floorLivingDining;
  final String? floorKitchenToilet;
  final String? floorBedroom;
  final String? floorBalcony;
  final String? wallsLivingDining;
  final String? wallsKitchenToilet;
  final String? wallsServantRoom;
  final String? ceiling;
  final String? ceilingsServantRoom;
  final String? countersKitchenToilet;
  final String? fittingsFixturesKitchenToilet;
  final String? fittingsFixturesServantRoomToilet;
  final String? doorWindowInternalDoor;
  final String? doorWindowExternalGlazing;
  final String? electrical;
  final String? backup;
  final String? securitySystem;
  final String? projectDescription;
  final String? amenities;
  final String? coverImage;
  final String? brochureDoc;
  final String? virtualTourAvailability;
  final String? propertyVideo;
  final String? videoUrlType;
  final String? videoUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ProjectDetails({
    this.id,
    this.userId,
    this.isFavorite,
    this.favoriteId,
    this.adminApproval,
    this.projectName,
    this.markAsFeatured,
    this.buildingType,
    this.projectType,
    this.userType,
    this.address,
    this.cityName,
    this.country,
    this.state,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.connectToName,
    this.connectToNo,
    this.connectToEmail,
    this.totalProjectSize,
    this.averageProjectPrice,
    this.congfigurations,
    this.launchDate,
    this.possessionStart,
    this.constructionStatus,
    this.reraId,
    this.floorLivingDining,
    this.floorKitchenToilet,
    this.floorBedroom,
    this.floorBalcony,
    this.wallsLivingDining,
    this.wallsKitchenToilet,
    this.wallsServantRoom,
    this.ceiling,
    this.ceilingsServantRoom,
    this.countersKitchenToilet,
    this.fittingsFixturesKitchenToilet,
    this.fittingsFixturesServantRoomToilet,
    this.doorWindowInternalDoor,
    this.doorWindowExternalGlazing,
    this.electrical,
    this.backup,
    this.securitySystem,
    this.projectDescription,
    this.amenities,
    this.coverImage,
    this.brochureDoc,
    this.virtualTourAvailability,
    this.propertyVideo,
    this.videoUrlType,
    this.videoUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  ProjectDetails.fromJson(Map<String, dynamic> json)
      : id = json['_id']?.toString(),
        userId = json['user_id']?.toString(),
        isFavorite = json['is_favorite']??false,
        favoriteId = json['favorite_id']?.toString(),
        adminApproval = json['admin_approval']?.toString(),
        projectName = json['project_name']?.toString(),
        markAsFeatured = json['mark_as_featured']?.toString(),
        buildingType = json['building_type']?.toString(),
        projectType = json['project_type']?.toString(),
        userType = json['user_type']?.toString(),
        address = json['address']?.toString(),
        cityName = json['city_name']?.toString(),
        country = json['country']?.toString(),
        state = json['state']?.toString(),
        zipCode = json['zip_code']?.toString(),
        latitude = json['latitude']?.toString(),
        longitude = json['longitude']?.toString(),
        connectToName = json['connect_to_name']?.toString(),
        connectToNo = json['connect_to_no']?.toString(),
        connectToEmail = json['connect_to_email']?.toString(),
        totalProjectSize = json['total_project_size']?.toString(),
        averageProjectPrice = json['average_project_price']?.toString(),
        congfigurations = json['congfigurations']?.toString(),
        launchDate = json['launch_date']?.toString(),
        possessionStart = json['possession_start']?.toString(),
        constructionStatus = json['construction_status']?.toString(),
        reraId = json['rera_id']?.toString(),
        floorLivingDining = json['floor_living_dining']?.toString(),
        floorKitchenToilet = json['floor_kitchen_toilet']?.toString(),
        floorBedroom = json['floor_bedroom']?.toString(),
        floorBalcony = json['floor_balcony']?.toString(),
        wallsLivingDining = json['walls_living_dining']?.toString(),
        wallsKitchenToilet = json['walls_kitchen_toilet']?.toString(),
        wallsServantRoom = json['walls_servant_room']?.toString(),
        ceiling = json['ceiling']?.toString(),
        ceilingsServantRoom = json['ceilings_servant_room']?.toString(),
        countersKitchenToilet = json['counters_kitchen_toilet']?.toString(),
        fittingsFixturesKitchenToilet = json['fittings_fixtures_kitchen_toilet']?.toString(),
        fittingsFixturesServantRoomToilet = json['fittings_fixtures_servant_room_toilet']?.toString(),
        doorWindowInternalDoor = json['door_window_internal_door']?.toString(),
        doorWindowExternalGlazing = json['door_window_external_glazing']?.toString(),
        electrical = json['electrical']?.toString(),
        backup = json['backup']?.toString(),
        securitySystem = json['security_system']?.toString(),
        projectDescription = json['project_description']?.toString(),
        amenities = json['amenities']?.toString(),
        coverImage = json['cover_image']?.toString(),
        brochureDoc = json['brochure_doc']?.toString(),
        virtualTourAvailability = json['virtual_tour_availability']?.toString(),
        propertyVideo = json['property_video']?.toString(),
        videoUrlType = json['video_url_type']?.toString(),
        videoUrl = json['video_url']?.toString(),
        createdAt = json['created_at']?.toString(),
        updatedAt = json['updated_at']?.toString(),
        deletedAt = json['deleted_at']?.toString();

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user_id': userId,
    'is_favorite': isFavorite,
    'favorite_id': favoriteId,
    'admin_approval': adminApproval,
    'project_name': projectName,
    'mark_as_featured': markAsFeatured,
    'building_type': buildingType,
    'project_type': projectType,
    'user_type': userType,
    'address': address,
    'city_name': cityName,
    'country': country,
    'state': state,
    'zip_code': zipCode,
    'latitude': latitude,
    'longitude': longitude,
    'connect_to_name': connectToName,
    'connect_to_no': connectToNo,
    'connect_to_email': connectToEmail,
    'total_project_size': totalProjectSize,
    'average_project_price': averageProjectPrice,
    'congfigurations': congfigurations,
    'launch_date': launchDate,
    'possession_start': possessionStart,
    'construction_status': constructionStatus,
    'rera_id': reraId,
    'floor_living_dining': floorLivingDining,
    'floor_kitchen_toilet': floorKitchenToilet,
    'floor_bedroom': floorBedroom,
    'floor_balcony': floorBalcony,
    'walls_living_dining': wallsLivingDining,
    'walls_kitchen_toilet': wallsKitchenToilet,
    'walls_servant_room': wallsServantRoom,
    'ceiling': ceiling,
    'ceilings_servant_room': ceilingsServantRoom,
    'counters_kitchen_toilet': countersKitchenToilet,
    'fittings_fixtures_kitchen_toilet': fittingsFixturesKitchenToilet,
    'fittings_fixtures_servant_room_toilet': fittingsFixturesServantRoomToilet,
    'door_window_internal_door': doorWindowInternalDoor,
    'door_window_external_glazing': doorWindowExternalGlazing,
    'electrical': electrical,
    'backup': backup,
    'security_system': securitySystem,
    'project_description': projectDescription,
    'amenities': amenities,
    'cover_image': coverImage,
    'brochure_doc': brochureDoc,
    'virtual_tour_availability': virtualTourAvailability,
    'property_video': propertyVideo,
    'video_url_type': videoUrlType,
    'video_url': videoUrl,
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

class ProjectImages {
  final String? id;
  final String? image;
  final String? createdAt;

  ProjectImages({
    this.id,
    this.image,
    this.createdAt,
  });

  ProjectImages.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        image = json['image'] as String?,
        createdAt = json['created_at'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'image' : image,
    'created_at' : createdAt
  };
}

class ProjectProperties {
  final String? id;
  final String? price;
  final String? bhk;
  final double? area;
  final String? areaIn;
  final String? areaType;
  final String? image;

  ProjectProperties({
    this.id,
    this.price,
    this.bhk,
    this.area,
    this.areaIn,
    this.areaType,
    this.image,
  });

  ProjectProperties.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        price = json['price'].toString(),
        bhk = json['bhk'] as String?,
        area = (json['area'] as num?)?.toDouble(),
        areaIn = json['area_in'] as String?,
        areaType = json['area_type'] as String?,
        image = json['image'] as String?;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'price': price,
    'bhk': bhk,
    'area': area,
    'area_in': areaIn,
    'area_type': areaType,
    'image': image,
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
    '_id': id,
    'user_id': userId,
    'agora_token': agoraToken,
    'channel_name': channelName,
    'property_owner_id': propertyOwnerId,
    'property_id': propertyId,
    'schedule_date': scheduleDate,
    'timeslot': timeslot,
    'time_unit': timeUnit,
    'status': status,
    'tour_type': tourType,
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