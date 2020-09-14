//
//  YXReviewRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

public enum YXReviewRequest: YYBaseRequest {
    case reviewBookList
    case reviewWordList(bookId: Int, bookType: Int)
    case makeReviewPlan(name: String, code: Int?, idsList:String?)
    case updateReviewPlan(planId: Int, planName: String)
    case removeReviewPlan(planId: Int)
    case reviewPlan
    case reviewPlanDetail(planId: Int)
    case reviewResult(type: Int, reviewId: Int, unique: String)
    case reviewPlanStatusList(page: Int)
    case studentStudyList(planId: Int, page: Int)
    case resetReviewPlan(planId: Int)
}

extension YXReviewRequest {
    var method: YYHTTPMethod {
        switch self {
        case .reviewBookList, .reviewWordList, .reviewPlan, .reviewPlanDetail, .reviewResult, .reviewPlanStatusList, .studentStudyList:
            return .get
        case .makeReviewPlan, .updateReviewPlan, .removeReviewPlan, .resetReviewPlan:
            return .post
        }
    }
}

extension YXReviewRequest {
    var path: String {
        switch self {
        case .reviewBookList:
            return YXAPI.Review.reviewBookList
        case .reviewWordList:
            return YXAPI.Review.reviewWordList
        case .makeReviewPlan:
            return YXAPI.Review.maekReviewPlan
        case .updateReviewPlan:
            return YXAPI.Review.updateReviewPlan
        case .removeReviewPlan:
            return YXAPI.Review.removeReviewPlan
        case .reviewPlan:
            return YXAPI.Review.reviewPlan
        case .reviewPlanDetail:
            return YXAPI.Review.reviewPlanDetail
        case .reviewResult:
            return YXAPI.Review.reviewResult
        case .reviewPlanStatusList:
            return YXAPI.Review.reviewPlanStatusList
        case .studentStudyList:
            return YXAPI.Review.studentStudyList
        case .resetReviewPlan:
            return YXAPI.Review.resetReviewPlan
        }
    }
}

extension YXReviewRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .reviewWordList(let bookId, let bookType):
            return ["review_book_id" : bookId, "review_book_type" : bookType]
        case .makeReviewPlan(let name, let code, let idsList):
            return ["review_plan_name" : name, "review_plan_id" : code, "review_word_ids" : idsList]
        case .reviewPlanDetail(let planId):
            return ["review_plan_id" : planId]
        case .updateReviewPlan(let planId, let planName):
            return ["review_plan_id" : planId, "review_plan_name" : planName]
        case .removeReviewPlan(let planId):
            return ["review_plan_id" : planId]
        case .reviewResult(let type, let reviewId, let unique):
            return ["learn_type" : type, "review_id" : reviewId, "unique" : unique]
        case .reviewPlanStatusList(let page):
            return ["page": page]
        case .studentStudyList(let planId, let page):
            return ["review_plan_id": planId, "page": page]
        case .resetReviewPlan(let planId):
            return ["review_plan_id": planId]
        default:
            return nil
        }
    }
}


