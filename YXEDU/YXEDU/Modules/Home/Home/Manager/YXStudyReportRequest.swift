//
//  YXStudyReportRequest.swift
//  YXEDU
//
//  Created by Jake To on 4/23/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

public enum YXStudyReportRequest: YYBaseRequest {
    case stutyReport(date: TimeInterval)
    
    var method: YYHTTPMethod {
        switch self {
        case .stutyReport:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .stutyReport:
            return YXAPI.StudyReport.studyReport
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
        case .stutyReport(let date):
            return ["time": date]
        }
    }
}
