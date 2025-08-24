//
//  ReviewService.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation
import RxSwift
import Moya

class ReviewService {
    
    var provider: MoyaProvider<ReviewAPI> = MoyaProvider<ReviewAPI>(plugins: moyaPlugins)
    
    func getList(id: Int) -> Observable<ReviewsResponse> {
        return provider.rx.request(.getList(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(ReviewsResponse.self)
    }
    
    func createReview(id: Int, review: String?, rates: [[String:Any]]) -> Observable<BaseResponse> {
        return provider.rx.request(.createReview(id, review, rates),
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }

}


