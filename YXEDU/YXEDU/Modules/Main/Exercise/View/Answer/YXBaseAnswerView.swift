//
//  YXExerciseAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 答题视图相关协议方法
protocol YXAnswerViewDelegate: NSObjectProtocol {
    /// 答题完成时，对错的结果回调
    /// - Parameter right: 是否答对
    func answerCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool)

    ///  切换问题
    /// - returns: 是否切题成功,如果是最后一题,则切题失败
    func switchQuestionView() -> Bool
}

/// 答案视图基类，所有的答案区都需要继承自该类
class YXBaseAnswerView: UIView, YXAudioPlayerViewDelegate {

    var contentScrollView: UIScrollView?
    /// 练习数据模型
    var exerciseModel: YXWordExerciseModel

    var delegate: YXAnswerEventProtocol?

    init(exerciseModel: YXWordExerciseModel) {
        self.exerciseModel = exerciseModel
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.createSubview()
        self.bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var answerDelegate: YXAnswerViewDelegate?

    func createSubview() {
        self.contentScrollView = UIScrollView()
        self.addSubview(contentScrollView!)
        self.contentScrollView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    func bindData() {}

    override func layoutSubviews() {
        super.layoutSubviews()
        self.adjustConstraints()
    }

    /// 校准scrollView高度
    private func adjustConstraints() {
        guard let scrollView = self.contentScrollView else {
            return
        }
        if scrollView.bounds.height > scrollView.contentSize.height {
            scrollView.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(scrollView.contentSize.height)
            }
        }
    }

    // 答题完成时，子类必须调用该方法
    func answerCompletion(right: Bool) {
        self.answerDelegate?.answerCompletion(exerciseModel, right)
    }

    // MARK: YXAudioPlayerViewDelegate
    func playAudioStart() {}
    func playAudioFinished() {}
}
