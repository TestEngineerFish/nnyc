//
//  ChooseWordView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class ChooseWordView: UIView {
    var wordsArray  = [String]()
    let contentView = UIView()

    let itemSize    = CGFloat(60)
    let margin      = CGFloat(10)
    let horItemNum  = 4
    var verItemNum  = 2

    func bindData(_ wordsArray: [String]) {
        self.wordsArray = wordsArray
    }

    func createUI() {
        addSubview(contentView)

        let contentW = getContentW()
        var contentH = getContentH()
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(contentW)
            make.height.equalTo(contentH)
        }
        var x = CGFloat(-margin)
        var y    = CGFloat(0)
        for word in wordsArray {
            var w = itemSize
            if word.count > horItemNum {
                w = itemSize * 2 + margin
            }
            let h = itemSize

            x = x + margin
            if (x + w) > contentW {
                x = 0
                y = y + itemSize + margin
            }

            let button = self.createWordView(word)
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            contentView.addSubview(button)
            x += w
        }
        // 布局结束后更新当前content高度
        contentH = y + itemSize
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentH)
        }
    }

    private func createWordView(_ word: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor   = UIColor.white
        button.layer.borderColor = UIColor.hex(0xC0C0C0).cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.setTitle(word, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        return button
    }

    // TODO: Tools
    /// 获取内容视图宽
    private func getContentW() -> CGFloat {
        let width = CGFloat(horItemNum) * (itemSize + margin) - margin
        return width
    }

     /// 获取内容视图高
    private func getContentH() -> CGFloat {
        let height = CGFloat(verItemNum) * (itemSize + margin) - margin
        return height
    }

}
