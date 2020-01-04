//
//  YXReviewResultViewController.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/2.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewResultViewController: YXViewController {
    
    var type: YXExerciseDataType = .aiReview
    var model: YXReviewResultModel?
    
    init(type: YXExerciseDataType, model: YXReviewResultModel) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        
        let resultView = YXReviewResultView(type: type, model: model)
//        resultView.model = model
        self.view.addSubview(resultView)
        resultView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    

}
