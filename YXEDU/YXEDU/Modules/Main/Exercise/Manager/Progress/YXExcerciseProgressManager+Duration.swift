//
//  YXExcerciseProgressManager+Duration.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/6.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension YXExcerciseProgressManager {
    
    func setStartStudyTime() {
        let start = Int(Date().timeIntervalSince1970)
        YYCache.set(start, forKey: key(.startStudyTime))
    }
    
    func setStopStudyTime() {
        if let start = YYCache.object(forKey: key(.startStudyTime)) as? Int {
            let duration = Int(Date().timeIntervalSince1970) - start
            self.updateStudyDuration(duration: duration)
        }
    }
        
    func fetchStudyDuration() -> Int {
        return (YYCache.object(forKey: key(.studyDuration)) as? Int) ?? 0
    }
        
    func updateStudyDuration(duration: Int) {
        if var d = YYCache.object(forKey: key(.studyDuration)) as? Int {
            d += duration
            YYCache.set(d, forKey: key(.studyDuration))
        } else {
            YYCache.set(duration, forKey: key(.studyDuration))
        }
    }
    
}
