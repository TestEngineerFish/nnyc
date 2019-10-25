//
//  YXExerciseViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 练习控制器
class YXExerciseViewController: UIViewController {
    
    
    var exerciseModelArray: [YXWordExerciseModel] = [YXWordExerciseModel(.lookWordChooseImage),
                                                     YXWordExerciseModel(.lookExampleChooseImage)]

    
    
    var currentExerciseView: YXBaseExerciseView = YXBaseExerciseView()
    var nextExerciseView: YXBaseExerciseView = YXBaseExerciseView()
    
    
    private var headerView: YXExerciseHeaderView = YXExerciseHeaderView()
    
    private var contentScrollView: UIScrollView = UIScrollView()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSubviews()
        self.bindProperty()
        
        currentExerciseView.exerciseModel = YXWordExerciseModel(.lookWordChooseImage)

    }
    
    
    func createSubviews() {
        self.view.addSubview(headerView)
        self.view.addSubview(contentScrollView)
        
        self.contentScrollView.addSubview(currentExerciseView)
    }
    
    
    func bindProperty() {
        
        self.view.backgroundColor = UIColor.blue
        
        
        self.headerView.backEvent = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        
        
        contentScrollView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        contentScrollView.frame = CGRect(x: 0, y: YXExerciseConfig.contentViewTop, width: screenWidth, height: screenHeight - YXExerciseConfig.contentViewTop - 86)
        contentScrollView.contentSize = contentScrollView.bounds.size
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(YXExerciseConfig.headerViewTop)
            make.left.right.equalTo(0)
            make.height.equalTo(28)
            
        }
        
        currentExerciseView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
        
    }

}
