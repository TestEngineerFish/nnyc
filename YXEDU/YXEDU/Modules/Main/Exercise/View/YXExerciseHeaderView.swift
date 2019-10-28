//
//  YXExerciseHeaderView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXExerciseHeaderView: UIView {
    
    var backEvent: (() -> Void)?
    
    var learningProgress: String? {
        didSet {
            self.learningProgressLabel.text = learningProgress
        }
    }
    
    var reviewProgress: String? {
        didSet {
            self.reviewProgressLabel.text = reviewProgress
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var backButton: UIButton = UIButton()
    
    private var learningLabel: UILabel = UILabel()
    private var reviewLabel: UILabel = UILabel()
    
    private var learningProgressLabel: UILabel = UILabel()
    private var reviewProgressLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubviews() {
        self.addSubview(backButton)
        self.addSubview(learningLabel)
        self.addSubview(reviewLabel)
        self.addSubview(learningProgressLabel)
        self.addSubview(reviewProgressLabel)
    }
    
    func bindProperty() {
        self.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        
        self.backButton.setBackgroundImage(UIImage.imageWithColor(UIColor.red), for: .normal)
        self.backButton.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        
        
        self.learningLabel.text = "学习"
        self.learningLabel.textColor = UIColor.black3
        self.learningLabel.font = UIFont.regularFont(ofSize: 10)
        
        self.reviewLabel.text = "学习"
//        self.reviewLabel.textColor = UIColor.black3
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalTo(22)
            make.height.equalTo(24)
        }
    }
    
    
    @objc func clickBackButton() {
        self.backEvent?()
    }
}
