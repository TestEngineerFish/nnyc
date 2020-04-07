//
//  YXReviewRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

public enum YXReviewRequest: YYBaseRequest {
    case reviewBookList
    case reviewWordList(bookId: Int, unitId: Int)
    case unitList(bookId: Int)
    case wordListWithWrong(page: Int)
    case wordListWithReviewPlan(id: Int, page: Int)
    case makeReviewPlan(name: String, code: Int?, idsList:String?)
    case updateReviewPlan(planId: Int, planName: String)
    case removeReviewPlan(planId: Int)
    case reviewPlan
    case reviewPlanDetail(planId: Int)
    case reviewResult(type: Int, planId: Int?)
    case reviewPlanStatusList(page: Int)
    case studentStudyList(planId: Int)
}

extension YXReviewRequest {
    var method: YYHTTPMethod {
        switch self {
        case .reviewBookList, .reviewWordList, .reviewPlan, .reviewPlanDetail, .reviewResult, .reviewPlanStatusList, .studentStudyList, .unitList, .wordListWithWrong, .wordListWithReviewPlan:
            return .get
        case .makeReviewPlan, .updateReviewPlan, .removeReviewPlan:
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
        case .unitList:
            return YXAPI.Review.unitList
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
        case .wordListWithWrong:
            return YXAPI.Review.wordListWithWrong
        case .wordListWithReviewPlan:
            return YXAPI.Review.wordListWithReviewPlan
        }
    }
}

extension YXReviewRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .reviewWordList(let bookId, let unitId):
            return ["book_id" : bookId, "unit_id" : unitId]
        case .makeReviewPlan(let name, let code, let idsList):
            return ["review_plan_name" : name, "review_plan_id" : code, "review_word_ids" : idsList]
        case .reviewPlanDetail(let planId):
            return ["review_plan_id" : planId]
        case .updateReviewPlan(let planId, let planName):
            return ["review_plan_id" : planId, "review_plan_name" : planName]
        case .removeReviewPlan(let planId):
            return ["review_plan_id" : planId]
        case .reviewResult(let type, let planId):
            return ["learn_type" : type, "review_id" : planId]
        case .reviewPlanStatusList(let page):
            return ["page": page]
        case .wordListWithWrong(let page):
            return ["page": page]
        case .wordListWithReviewPlan(let id, let page):
            return ["review_plan_id": id, "page": page]
        case .unitList(let bookId):
            return ["book_id": bookId]
        case .studentStudyList(let planId):
            return ["review_plan_id": planId]
        default:
            return nil
        }
    }
}


