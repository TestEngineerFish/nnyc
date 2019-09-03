//
//  YXExerciseSubmitErrorViews.swift
//  YXEDU
//
//  Created by shiji on 2018/6/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

import UIKit
typealias FinishedBlock = () -> Void

class YXExerciseSubmitErrorViews: UIView ,UITextViewDelegate{
    var maskedView: UIControl!
    var whiteBackView : UIView!
    var titleLab : UILabel!
    var btnView : UIView!
    var feedBackTextView : UITextView!
    var numLab : UILabel!
    var submitBtn : UIButton!
    
    var viewModel : YXFeedBackViewModel?
    var dataArr : NSMutableArray?
    var completeBlock : FinishedBlock!
    
    // 屏幕大小
    let frameSize:CGSize = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = YXFeedBackViewModel()
        self.dataArr = NSMutableArray()
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
        RELEASE(v: whiteBackView)
        RELEASE(v: titleLab)
        RELEASE(v: btnView)
        RELEASE(v: feedBackTextView)
        RELEASE(v: numLab)
        RELEASE(v: submitBtn)
        YXUtils.removeScreenShout()
    }
    
    func recreateSubViews() {
        self.maskedView = UIControl(frame: CGRect(x:0, y:0, width:frameSize.width,  height:frameSize.height))
        self.maskedView.addTarget(self, action: #selector(tapAction), for: UIControlEvents.touchUpInside)
        self.maskedView.alpha = 0;
        self.maskedView.isUserInteractionEnabled = true
        self.addSubview(self.maskedView)
        
        self.whiteBackView = UIView(frame: CGRect(x:0, y:frameSize.height-122, width:frameSize.width,  height:frameSize.height))
        self.whiteBackView.backgroundColor = UIColorOfHex(rgbValue: 0xffffff);
        self.whiteBackView.isExclusiveTouch = true;
        self.addSubview(self.whiteBackView)
        
        self.titleLab = UILabel(frame: CGRect(x:0, y:20, width:frameSize.width,  height:25));
        self.titleLab.font = UIFont.systemFont(ofSize: 18)
        self.titleLab.textColor = UIColorOfHex(rgbValue: 0x535353);
        self.titleLab.clipsToBounds = false;
        self.titleLab.textAlignment = NSTextAlignment.center;
        self.titleLab.text = "请选择报错原因";
        self.whiteBackView.addSubview(self.titleLab)
        
        self.btnView = UIView(frame: CGRect(x:0, y:self.titleLab.frame.maxY, width:frameSize.width,  height:80))
        self.whiteBackView.addSubview(self.btnView)
        
        for i in 0..<6 {
            let btn_x = CGFloat(i % 3 + 1)*(frameSize.width-270)/4.0 + CGFloat(i % 3)*90
            let btn_y = 10+40*CGFloat(i/3)
            let btn = UIButton(frame: CGRect(x:btn_x, y:btn_y, width:90,  height:30))
            btn.tag = i
            btn.setBackgroundImage(UIImage(named: "study_error_selected"), for: UIControlState.selected)
            btn.setBackgroundImage(UIImage(named: "study_error_unselected"), for: UIControlState.normal)
            btn.addTarget(self, action: #selector(btnClicked), for: UIControlEvents.touchUpInside)
            
            btn.setTitleColor(UIColorOfHex(rgbValue: 0x535353), for: UIControlState.normal)
            btn.setTitleColor(UIColorOfHex(rgbValue: 0x999999), for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            self.btnView.addSubview(btn)
            if i==0 {
                btn.setTitle("单词发音", for: UIControlState.normal)
            } else if i==1 {
                btn.setTitle("单词拼写", for: UIControlState.normal)
            } else if i==1 {
                btn.setTitle("单词意译", for: UIControlState.normal)
            } else if i==1 {
                btn.setTitle("例句", for: UIControlState.normal)
            } else if i==1 {
                btn.setTitle("图片不对", for: UIControlState.normal)
            } else if i==1 {
                btn.setTitle("答案有误", for: UIControlState.normal)
            }
        }
        
        self.feedBackTextView = UITextView(frame: CGRect(x: 20, y: self.btnView.frame.maxY+10, width: frameSize.width-40, height: 100))
        self.feedBackTextView.backgroundColor = UIColorOfHex(rgbValue: 0xF8F8F8)
        self.feedBackTextView.delegate = self
        self.feedBackTextView.font = UIFont.systemFont(ofSize: 14)
        self.feedBackTextView.setPlaceholder("欢迎吐槽，我们会努力变得更好~", placeholdColor: UIColor.lightGray)
        self.whiteBackView.addSubview(self.feedBackTextView)
        
        self.numLab = UILabel(frame: CGRect(x: frameSize.width-80, y: 80+self.btnView.frame.maxY+10, width: 50, height: 10))
        self.numLab.textColor = UIColorOfHex(rgbValue: 0x999999)
        self.numLab.text = "0/50"
        self.numLab.font = UIFont.systemFont(ofSize: 12)
        self.whiteBackView.addSubview(self.numLab)
        
        self.submitBtn = UIButton(frame: CGRect(x: (frameSize.width-240)/2.0, y: self.feedBackTextView.frame.maxY+20, width: 240, height: 42))
        self.submitBtn.setTitle("提  交", for: UIControlState.normal)
        self.submitBtn.setTitleColor(UIColorOfHex(rgbValue: 0xffffff), for: UIControlState.normal)
        self.submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.submitBtn.addTarget(self, action: #selector(submitBtnClicked), for: UIControlEvents.touchUpInside)
        self.submitBtn.setBackgroundImage(UIImage(named: "login_btn"), for: UIControlState.normal)
        self.whiteBackView.addSubview(self.submitBtn)
        disableSubmitBtn()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.whiteBackView.frame = CGRect(x: 0, y: 122, width: self.frameSize.width, height: self.frameSize.height-122)
            self.maskedView.alpha = 0.3
        }) { (false) in
            self.feedBackTextView.becomeFirstResponder()
            self.completeBlock()
        }
    }
    
    func tapAction(sender:UIControl?) {
        
    }
    
    func btnClicked(sender:UIButton) {
        
    }
    
    func submitBtnClicked(sender:UIButton) {
        
    }
    
    func disableSubmitBtn() {
        
    }
    
    func enableSubmitBtn() {
        
    }
    
    func RELEASE(v:UIView?) {
        if v != nil {
            v?.removeFromSuperview()
        }
    }
    
    func UIColorOfHex(rgbValue:Int64) -> UIColor {
        let red = CGFloat(CGFloat(((rgbValue & 0xFF0000) >> 16))/255.0);
        let green = CGFloat(CGFloat(((rgbValue & 0xFF00) >> 8))/255.0);
        let blue = CGFloat(CGFloat((rgbValue & 0xFF))/255.0);
        return UIColor(red: red , green: green, blue: blue, alpha: 1.0)
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if textView.text.count > 50 {
//            textView.text = textView.text.substring(to: String.Index)
//        }
//        var result = textView.text.replacingCharacters(in: range, with: text)
//        if result.count == 0 && self.dataArr.count == 0 {
//            disableSubmitBtn()
//        } else {
//            enableSubmitBtn()
//        }
//        return true
//    }
}
