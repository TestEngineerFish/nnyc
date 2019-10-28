//
//  YXExerciseViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 更新View的约束
protocol YXViewConstraintsProtocol {
    func updateHeight(_ height: CGFloat)
}

/// 练习控制器
class YXExerciseViewController: UIViewController, YXViewConstraintsProtocol {
    
    
    // 数据管理器
    var dataManager: YXExerciseDataManager = YXExerciseDataManager()


    var currentExerciseView: YXBaseExerciseView = YXBaseExerciseView()
    var nextExerciseView: YXBaseExerciseView = YXBaseExerciseView()
    
    
    
    // 顶部view
    private var headerView: YXExerciseHeaderView = YXExerciseHeaderView()
    private var bottomView: YXExerciseBottomView = YXExerciseBottomView()
    
    
    private var contentScrollView: UIScrollView = UIScrollView()

    private var questionView = YXQuestionView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        let wordArray = ["e", "f", "u", "p", "w", "v", "m", "x"]

        // ==== 添加问题根视图 ====
        let questionView = YXQuestionView()
        self.contentScrollView.addSubview(questionView)
        questionView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.width.equalTo(332)
            make.height.equalTo(160)
        }

        // ==== 添加子视图 ====
        let charView = YXQuestionSpellView(charModelsArray)
        questionView.addCustomViews([charView])

        // ==== 添加选择视图 ====
        let answerView = YXAnswerSelectLettersView(wordArray)
        kWindow.addSubview(answerView)
        answerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }
    }
    
    
    func createSubviews() {
        self.view.addSubview(headerView)
        self.view.addSubview(contentScrollView)
        self.view.addSubview(bottomView)
        
        self.contentScrollView.addSubview(currentExerciseView)
    }
    
    
    func bindProperty() {
        
        self.view.backgroundColor = UIColor.blue
        
        
        self.headerView.backEvent = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.bottomView.tipsEvent = {//[weak self] in
            print("提示点击事件")
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
        
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(18)
            make.bottom.equalTo(YXExerciseConfig.bottomViewBottom)
        }
        
        
    }

    //MARK: YXQuestionViewConstraintsProtocol
    func updateHeight(_ height: CGFloat) {
        self.questionView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }

}
