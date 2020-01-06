//
//  YXExerciseDataManager+Time.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/4.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension YXExerciseDataManager {
     
    
    
    func startExercise() {
        
    }
    
    
    func stopExercise() {
        
        self.progressManager.updateStudyDuration(duration: 0)
        
    }
    
}
