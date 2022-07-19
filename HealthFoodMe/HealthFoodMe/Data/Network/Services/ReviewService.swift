//
//  ReviewService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

class ReviewService: BaseService {
    static let shared = ReviewService()
    
    private override init() {}
}

extension ReviewService {
    func requestReviewList(restaurantId: String,
                           completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(ReviewRouter.getReviewList(restaurantId: restaurantId),
                      type: [ReviewListEntity].self,
                      decodingMode: .model,
                      completion: completion)
    }
    
    func requestBlogReviewList(restaurantName: String,
                               completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(ReviewRouter.getBlogReviewList(restaurantName: restaurantName),
                      type: BlogReviewListEntity.self,
                      decodingMode: .model,
                      completion: completion)
    }
    
    func requestUserReview(userId: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(ReviewRouter.requestUserReview(userId: userId), type: [MyReviewEntity].self, decodingMode: .model, completion: completion)
    }
}
