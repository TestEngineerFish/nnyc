//
//  YXSelectSchoolRequestManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/23.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

public enum YXSelectSchoolRequestManager: YYBaseRequest {
    case searchSchool(name: String, areaId: Int)
    case submit(schoolId: Int, areaId: Int)
}

extension YXSelectSchoolRequestManager {
    var method: YYHTTPMethod {
        switch self {
        case .searchSchool:
            return .get
        case .submit:
            return .post
        }
    }
}

extension YXSelectSchoolRequestManager {
    var path: String {
        switch self {
        case .searchSchool:
            return YXAPI.SelectSchool.searchSchool
        case .submit:
            return YXAPI.SelectSchool.submit
        }
    }
}

extension YXSelectSchoolRequestManager {
    var parameters: [String : Any?]? {
        switch self {
        case .searchSchool(let name, let areaId):
            return ["school_name": name, "area_id": areaId]
        case .submit(let schoolId, let areaId):
            return ["school_student_id": schoolId, "area_id": areaId]
        }
    }
}
