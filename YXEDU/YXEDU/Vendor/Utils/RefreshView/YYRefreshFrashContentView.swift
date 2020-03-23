//
//  YYRefreshFrashContentView.swift
//  YouYou
//
//  Created by pyyx on 2018/11/26.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation

class YYRefreshFrashContentView: UIView {
    
    private lazy var loadingView: UIImageView = {
        let _loadingView = UIImageView()
        _loadingView.contentMode = .scaleAspectFit;
//        _loadingView.image = UIImage(named: "refresh_icon")
        
        return _loadingView
    }()
    
    var complet: CGFloat {
        set {
            if _complet != newValue {
                _complet = newValue
            }
        }
        
        get {
            return _complet
        }
    }
    private var _complet: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubViews()
    }
    
    private func createSubViews() {
        self.addSubview(self.loadingView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.loadingView.size = CGSize(width: 26.0, height: 26.0)
        self.loadingView.top = (self.superview?.height ?? 0) / 2.0 - self.loadingView.height / 2.0
        self.loadingView.left = (self.superview?.width ?? 0.0) / 2.0 - self.loadingView.width / 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        var _animation: CABasicAnimation? = self.loadingView.layer.animation(forKey: "rotationAnimation") as? CABasicAnimation
        if _animation == nil {
            _animation = CABasicAnimation(keyPath: "transform.rotation.z")
            _animation?.toValue = NSNumber(value: Double.pi * 12.0)
            _animation?.duration = 3.5
            _animation?.repeatCount = Float.greatestFiniteMagnitude
            _animation?.isRemovedOnCompletion = false
            self.loadingView.layer.add(_animation!, forKey: "rotationAnimation")
        }
    }
    
    func stopAnimation() {
        self.loadingView.transform = CGAffineTransform.identity
        self.loadingView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
