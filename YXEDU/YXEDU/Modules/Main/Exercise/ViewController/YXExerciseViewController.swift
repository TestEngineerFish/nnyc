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
    
    
    // 数据管理器
    var dataManager: YXExerciseDataManager = YXExerciseDataManager()


    var currentExerciseView: YXBaseExerciseView = YXBaseExerciseView()
    var nextExerciseView: YXBaseExerciseView = YXBaseExerciseView()
    
    
    
    // 顶部view
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

        contentScrollView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        contentScrollView.addGestureRecognizer(tap)
        contentScrollView.backgroundColor = UIColor.white
    }

    @objc private func tapView() {
        // ===== 数据准备 ====
        var charModelsArray = [YXCharacterModel]()
        for index in 0..<2 {
            let model = YXCharacterModel("sam", isBlank: index%2>0)
            charModelsArray.append(model)
        }

        // ==== 添加问题跟视图 ====
        let view = YXQuestionView()
        kWindow.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(332)
            make.height.equalTo(160)
        }

        // ==== 添加子视图 ====
        let charView = YXQuestionSpellView()
        charView.createUI(charModelsArray)

        let height = view.addCustomViews([charView])
        view.snp.updateConstraints { (make) in
            make.height.equalTo(height)
               }
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
