// class EnquiryProductData {
//   EnquiryProductData({
//     required this.status,
//     required this.msg,
//     required this.productDetails,
//     required this.data,
//   });
//   late final int status;
//   late final String msg;
//   late final List<ProductDetails> productDetails;
//   late final List<Data> data;
//
//   EnquiryProductData.fromJson(Map<String, dynamic> json){
//     status = json['status'];
//     msg = json['msg'];
//     productDetails = List.from(json['product_details']).map((e)=>ProductDetails.fromJson(e)).toList();
//     data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['msg'] = msg;
//     _data['product_details'] = productDetails.map((e)=>e.toJson()).toList();
//     _data['data'] = data.map((e)=>e.toJson()).toList();
//     return _data;
//   }
// }
//
// class ProductDetails {
//   ProductDetails({
//     required this.id,
//     required this.userId,
//     required this.productName,
//     required this.description,
//     required this.highlights,
//     required this.weight,
//     required this.productDimensions,
//     required this.newArrival,
//     required this.title,
//     required this.colorImage,
//     required this.productImage,
//     required this.colorName,
//     required this.colorNameVisible,
//     required this.size,
//     required this.time,
//     required this.timeUnit,
//     required this.useBy,
//     required this.closureType,
//     required this.sole,
//     required this.specificationTitle,
//     required this.specificationDescription,
//     required this.Manufacturers,
//     required this.Width,
//     required this.height,
//     required this.availableStock,
//     required this.categoryId,
//     required this.grossWt,
//     required this.netWt,
//     required this.moq,
//     required this.isReturn,
//     required this.isExchange,
//     required this.days,
//     required this.stock,
//     required this.StockAlertLimit,
//     required this.productSku,
//     required this.materialId,
//     required this.currencyId,
//     required this.countryProductPriceId,
//     required this.pincodeId,
//     required this.productUnitId,
//     required this.discountId,
//     required this.productImageId,
//     required this.stockAlertLimit,
//     required this.returnTime,
//     required this.exchangeTime,
//     required this.productPrice,
//     required this.updatedAt,
//     required this.createdAt,
//   });
//   late final String id;
//   late final String userId;
//   late final String productName;
//   late final String description;
//   late final String highlights;
//   late final String weight;
//   late final String productDimensions;
//   late final String newArrival;
//   late final String title;
//   late final String colorImage;
//   late final String productImage;
//   late final String colorName;
//   late final String colorNameVisible;
//   late final String size;
//   late final String time;
//   late final String timeUnit;
//   late final String useBy;
//   late final String closureType;
//   late final String sole;
//   late final String specificationTitle;
//   late final String specificationDescription;
//   late final String Manufacturers;
//   late final String Width;
//   late final String height;
//   late final String availableStock;
//   late final String categoryId;
//   late final String grossWt;
//   late final String netWt;
//   late final String moq;
//   late final String isReturn;
//   late final String isExchange;
//   late final String days;
//   late final String stock;
//   late final String StockAlertLimit;
//   late final String productSku;
//   late final String materialId;
//   late final String currencyId;
//   late final String countryProductPriceId;
//   late final String pincodeId;
//   late final String productUnitId;
//   late final String discountId;
//   late final String productImageId;
//   late final String stockAlertLimit;
//   late final String returnTime;
//   late final String exchangeTime;
//   late final String productPrice;
//   late final String updatedAt;
//   late final String createdAt;
//
//   ProductDetails.fromJson(Map<String, dynamic> json){
//     id = json['_id'];
//     userId = json['user_id'];
//     productName = json['product_name'];
//     description = json['description'];
//     highlights = json['highlights'];
//     weight = json['weight'];
//     productDimensions = json['product_dimensions'];
//     newArrival = json['new_arrival'];
//     title = json['title'];
//     colorImage = json['color_image'];
//     productImage = json['product_image'];
//     colorName = json['color_name'];
//     colorNameVisible = json['color_name_visible'];
//     size = json['size'];
//     time = json['time'];
//     timeUnit = json['time_unit'];
//     useBy = json['use_by'];
//     closureType = json['closure_type'];
//     sole = json['sole'];
//     specificationTitle = json['specification_title'];
//     specificationDescription = json['specification_description'];
//     Manufacturers = json['Manufacturers'];
//     Width = json['Width'];
//     height = json['height'];
//     availableStock = json['available_stock'];
//     categoryId = json['category_id'];
//     grossWt = json['gross_wt'];
//     netWt = json['net_wt'];
//     moq = json['moq'];
//     isReturn = json['isReturn'];
//     isExchange = json['isExchange'];
//     days = json['days'];
//     stock = json['stock'];
//     StockAlertLimit = json['Stock_alert_limit'];
//     productSku = json['product_sku'];
//     materialId = json['material_id'];
//     currencyId = json['currency_id'];
//     countryProductPriceId = json['country_product_price_id'];
//     pincodeId = json['pincode_id'];
//     productUnitId = json['product_unit_id'];
//     discountId = json['discount_id'];
//     productImageId = json['product_image_id'];
//     stockAlertLimit = json['stock_alert_limit'];
//     returnTime = json['return_time'];
//     exchangeTime = json['exchange_time'];
//     productPrice = json['product_price'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['_id'] = id;
//     _data['user_id'] = userId;
//     _data['product_name'] = productName;
//     _data['description'] = description;
//     _data['highlights'] = highlights;
//     _data['weight'] = weight;
//     _data['product_dimensions'] = productDimensions;
//     _data['new_arrival'] = newArrival;
//     _data['title'] = title;
//     _data['color_image'] = colorImage;
//     _data['product_image'] = productImage;
//     _data['color_name'] = colorName;
//     _data['color_name_visible'] = colorNameVisible;
//     _data['size'] = size;
//     _data['time'] = time;
//     _data['time_unit'] = timeUnit;
//     _data['use_by'] = useBy;
//     _data['closure_type'] = closureType;
//     _data['sole'] = sole;
//     _data['specification_title'] = specificationTitle;
//     _data['specification_description'] = specificationDescription;
//     _data['Manufacturers'] = Manufacturers;
//     _data['Width'] = Width;
//     _data['height'] = height;
//     _data['available_stock'] = availableStock;
//     _data['category_id'] = categoryId;
//     _data['gross_wt'] = grossWt;
//     _data['net_wt'] = netWt;
//     _data['moq'] = moq;
//     _data['isReturn'] = isReturn;
//     _data['isExchange'] = isExchange;
//     _data['days'] = days;
//     _data['stock'] = stock;
//     _data['Stock_alert_limit'] = StockAlertLimit;
//     _data['product_sku'] = productSku;
//     _data['material_id'] = materialId;
//     _data['currency_id'] = currencyId;
//     _data['country_product_price_id'] = countryProductPriceId;
//     _data['pincode_id'] = pincodeId;
//     _data['product_unit_id'] = productUnitId;
//     _data['discount_id'] = discountId;
//     _data['product_image_id'] = productImageId;
//     _data['stock_alert_limit'] = stockAlertLimit;
//     _data['return_time'] = returnTime;
//     _data['exchange_time'] = exchangeTime;
//     _data['product_price'] = productPrice;
//     _data['updated_at'] = updatedAt;
//     _data['created_at'] = createdAt;
//     return _data;
//   }
// }
//
// class Data {
//   Data({
//     required this.id,
//     required this.customerAutoId,
//     required this.customerName,
//     required this.customerContact,
//     required this.productId,
//     required this.otherUserId,
//     required this.message,
//     required this.registerDate,
//     required this.updatedAt,
//     required this.createdAt,
//   });
//   late final String id;
//   late final String customerAutoId;
//   late final String customerName;
//   late final String customerContact;
//   late final String productId;
//   late final String otherUserId;
//   late final String message;
//   late final String registerDate;
//   late final String updatedAt;
//   late final String createdAt;
//
//   Data.fromJson(Map<String, dynamic> json){
//     id = json['_id'];
//     customerAutoId = json['customer_auto_id'];
//     customerName = json['customer_name'];
//     customerContact = json['customer_contact'];
//     productId = json['product_id'];
//     otherUserId = json['otherUserId'];
//     message = json['message'];
//     registerDate = json['register_date'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['_id'] = id;
//     _data['customer_auto_id'] = customerAutoId;
//     _data['customer_name'] = customerName;
//     _data['customer_contact'] = customerContact;
//     _data['product_id'] = productId;
//     _data['otherUserId'] = otherUserId;
//     _data['message'] = message;
//     _data['register_date'] = registerDate;
//     _data['updated_at'] = updatedAt;
//     _data['created_at'] = createdAt;
//     return _data;
//   }
// }