//
//  ObjectsService.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation
import RxSwift
import Moya

class ObjectsService {
    
    var provider: MoyaProvider<ObjectsAPI> = MoyaProvider<ObjectsAPI>(plugins: moyaPlugins)
    
    func getCities(orderField: String?, page: Int?, perPage: Int?) -> Observable<CitiesResponse> {
        return provider.rx.request(.getCities(orderField, page, perPage),
                                   callbackQueue: DispatchQueue.main)
            .decode(CitiesResponse.self)
    }
        
    func getFavorites(orderField: String?, page: Int?, perPage: Int?) -> Observable<ObjectListResponse> {
        return provider.rx.request(.getFavorites(orderField, page, perPage),
                                   callbackQueue: DispatchQueue.main)
            .decode(ObjectListResponse.self)
    }
    
    func getDetail(id: Int) -> Observable<ObjectModel> {
        return provider.rx.request(.getDetail(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(ObjectModel.self)
    }
    
    func getDetailShort(id: Int) -> Observable<ObjectShortModel> {
        return provider.rx.request(.getDetailShort(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(ObjectShortModel.self)
    }
    
    func getList(ids: [Int]?, page: Int?, perPage: Int?) -> Observable<ObjectListResponse> {
        return provider.rx.request(.getList(ids, page, perPage),
                                   callbackQueue: DispatchQueue.main)
            .decode(ObjectListResponse.self)
    }
    
    func addFavorite(id: Int) -> Observable<ObjectModel> {
        return provider.rx.request(.addFavorite(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(ObjectModel.self)
    }
    
    func removeFavorite(id: Int) -> Observable<BaseResponse> {
        return provider.rx.request(.removeFavorite(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }
    
    func getListMap(tl_lat: Double,
                    tl_lon: Double,
                    br_lat: Double,
                    br_lon: Double,
                    tr_lat: Double,
                    tr_lon: Double,
                    bl_lat: Double,
                    bl_lon: Double,
                    start_date: String?,
                    end_date: String?,
                    price_day_from: Int?,
                    price_day_to: Int?,
                    type_id: [String],
                    rooms_counter: [Int],
                    bedrooms_counter: Int?,
                    feature_ids: [Int]) -> Observable<MapListResponse> {
        return provider.rx.request(.getListMap(tl_lat,
                                               tl_lon,
                                               br_lat,
                                               br_lon,
                                               tr_lat,
                                               tr_lon,
                                               bl_lat,
                                               bl_lon,
                                               start_date,
                                               end_date,
                                               price_day_from,
                                               price_day_to,
                                               type_id,
                                               rooms_counter,
                                               bedrooms_counter,
                                               feature_ids),
                                   callbackQueue: DispatchQueue.main)
            .decode(MapListResponse.self)
    }
    
    func getDashboard() -> Observable<DashboardResponse> {
        return provider.rx.request(.getDashboard,
                                   callbackQueue: DispatchQueue.main)
            .decode(DashboardResponse.self)
    }

}


