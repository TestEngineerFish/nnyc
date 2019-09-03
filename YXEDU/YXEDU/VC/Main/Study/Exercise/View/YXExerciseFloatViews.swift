//
//  YXExerciseFloatView.swift
//  YXEDU
//
//  Created by shiji on 2018/6/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

import UIKit

@objc protocol YXExerciseFloatViewDelegate : NSObjectProtocol {
    @objc optional func submitBtnClicked(sender:UIButton);
}

class YXExerciseFloatViews: UIView {
    var maskedView: UIView!
    var floatView : UIView!
    var screentShotView : UIImageView!
    var iconImageView : UIImageView!
    var titleBtn : UIButton!
    weak var delegate:YXExerciseFloatViewDelegate?
    // 屏幕大小
    let frameSize:CGSize = UIScreen.main.bounds.size
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHidden: Bool {
        willSet  {
            if newValue {
                removeAllSubViews()
            } else {
                recreateSubViews()
            }
            print(newValue)
        }
        
        didSet {
            print("good")
        }
    }
    
    func removeAllSubViews() {
        RELEASE(v: maskedView)
        RELEASE(v: floatView)
        RELEASE(v: screentShotView)
        RELEASE(v: iconImageView)
        RELEASE(v: titleBtn)
        YXUtils.removeScreenShout()
    }
    
    func recreateSubViews() {
        self.maskedView = UIView(frame: CGRect(x:0, y:0, width:frameSize.width,  height:frameSize.height))
        self.maskedView.alpha = 1
        self.maskedView.isUserInteractionEnabled = true;
        self.maskedView.isExclusiveTouch = true;
        self.addSubview(self.maskedView)
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapAction))
        self.maskedView.addGestureRecognizer(tapGesture)
        
        self.floatView = UIView(frame: CGRect(x:frameSize.width-109, y:(frameSize.height-160)/2.0, width:100, height:160))
        self.floatView.isExclusiveTouch = true;
        self.floatView.backgroundColor = UIColorOfHex(rgbValue:0x535353);
        self.floatView.isUserInteractionEnabled = true;
        self.addSubview(self.floatView)
        
        self.screentShotView = UIImageView(frame: CGRect(x:7, y:7, width:86, height:114))
        self.screentShotView.image =  UIImage(named: "home_flower")
        self.floatView.addSubview(self.screentShotView)
        self.screentShotView.sd_setImage(with: URL(fileURLWithPath: YXUtils.screenShoutPath()))
        
        self.iconImageView = UIImageView(frame: CGRect(x:12, y:134, width:16, height:16))
        self.iconImageView.image = UIImage(named: "study_screen_icon")
        self.floatView.addSubview(self.iconImageView)
        
        self.titleBtn = UIButton(frame: CGRect(x:35, y:130, width:60, height:20))
        self.titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.titleBtn.setTitle("反馈问题", for: UIControlState.normal)
        self.titleBtn.setTitleColor(UIColorOfHex(rgbValue:0xFFBF4C), for: UIControlState.normal)
        self.titleBtn.addTarget(self, action: #selector(gotoSubmitVC), for: UIControlEvents.touchUpInside)
        self.floatView.addSubview(self.titleBtn)
    }
    
    func tapAction(sender:UIGestureRecognizer?) {
        self.isUserInteractionEnabled = false;
        UIView.animate(withDuration: 0.2, animations: {
            self.floatView.frame = CGRect(x:self.frameSize.width, y:(self.frameSize.height-160)/2.0, width:100, height:160)
            self.maskedView.alpha = 0
        }) { (true) in
            self.isHidden = true
            self.isUserInteractionEnabled = true
        };
    }
    
    func gotoSubmitVC(sender:UIButton) {
        tapAction(sender: nil)
        if let delegateOK = self.delegate {
            delegateOK.submitBtnClicked!(sender: sender)
        }
    }
    
    func UIColorOfHex(rgbValue:Int64) -> UIColor {
        let red = CGFloat(CGFloat(((rgbValue & 0xFF0000) >> 16))/255.0);
        let green = CGFloat(CGFloat(((rgbValue & 0xFF00) >> 8))/255.0);
        let blue = CGFloat(CGFloat((rgbValue & 0xFF))/255.0);
        return UIColor(red: red , green: green, blue: blue, alpha: 1.0)
    }
    
    func RELEASE(v:UIView?) {
        if v != nil {
            v?.removeFromSuperview()
        }
    }
}
