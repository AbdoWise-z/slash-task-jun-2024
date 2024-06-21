
import 'dart:convert';

import 'package:slash_task/pages/home/bloc/shop_items/shop_items_bloc.dart';
import 'package:slash_task/pages/home/models/offers.model.dart';
import 'package:slash_task/pages/home/models/shop_item.model.dart';
import 'package:slash_task/shared/api/api.dart';
import 'package:slash_task/shared/base.dart';

enum ShopItemType{
  Best_Selling,
  New_Arrivals,
  Recommended,
}

class HomeRepo {
  HomeRepo._();

  static Future<ApiResponse<List<OfferModel>>> loadOffers() async {
    // may need to add more params here, account token, etc..
    ApiResponse<List<OfferModel>> res = await Api.apiGet(ApiPath.fetchOffers);

    if (res.code == ApiResponse.CODE_SUCCESS){
      res.data = [];
      // if the request was complete successfully, we parse the data
      var data = jsonDecode(res.responseBody!);
      if (!mockAPI){
        data = data["record"];
      }

      for (var item in data){
        res.data!.add(OfferModel.fromJson(item));
      }
    }

    return res;
  }

  static Future<ApiResponse<List<ShopItemModel>>> loadShopItems(ShopItemType type) async {
    // may need to add more params here, account token, etc..
    ApiPath path = ApiPath.fetchBestSelling;
    switch (type){
      case ShopItemType.Best_Selling:
        path = ApiPath.fetchBestSelling;
        break;
      case ShopItemType.New_Arrivals:
        path = ApiPath.fetchNewArrivals;
        break;
      case ShopItemType.Recommended:
        path = ApiPath.fetchRecommended;
        break;
    }

    ApiResponse<List<ShopItemModel>> res = await Api.apiGet(path);

    if (res.code == ApiResponse.CODE_SUCCESS){
      res.data = [];
      // if the request was complete successfully, we parse the data
      var data = jsonDecode(res.responseBody!);
      if (!mockAPI){
        data = data["record"];
      }
      for (var item in data){
        res.data!.add(ShopItemModel.fromJson(item));
      }
    }

    return res;
  }
}