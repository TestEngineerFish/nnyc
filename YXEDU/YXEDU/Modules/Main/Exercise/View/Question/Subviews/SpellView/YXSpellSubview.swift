//
//  YXSpellSubview.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import SnapKit

struct YXCharacterModel {
    var character: String
    var isBlank: Bool
    init(_ char: String, isBlank: Bool) {
        self.character = char
        self.isBlank = isBlank
    }
}

class YXSpellSubview: UIView {
    var margin: CGFloat {
        return isTitle ? AdaptSize(9)  : AdaptSize(3)
    }
    var charH: CGFloat {
        isTitle ? AdaptSize(28) : AdaptSize(22)
    }
    var maxX   = CGFloat(0)
    var isTitle: Bool

    var exerciseModel: YXWordExerciseModel
    var wordViewList = [YXLackWordView]()
    var resultArrary: [NSTextCheckingResult]?

    init(_ model: YXWordExerciseModel, isTitle: Bool) {
        self.exerciseModel = model
        self.isTitle       = isTitle
        super.init(frame: CGRect.zero)
        self.bindData()
        self.createUI()
        self.resetConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindData() {
        guard let question = self.exerciseModel.question, let word = question.word else {
            return
        }
        do {
            let regular = "(\\[\\w+\\])"
            let regex = try NSRegularExpression(pattern: regular, options: .caseInsensitive)
            resultArrary = regex.matches(in: word, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: word.count))

        } catch {

        }
    }

    private func createUI() {
        guard let array = resultArrary, let question = self.exerciseModel.question, let word = question.word  else {
            return
        }
        var offset = 0
        for (index, _result) in array.enumerated() {
            // 添加可见字母
            let lackWord = word.substring(fromIndex: offset, length: _result.range.location - offset)
            if !lackWord.isEmpty {
                let wordView = YXLackWordView(frame: CGRect.zero, isTitle: isTitle)
                wordView.textField.text = lackWord
                wordView.rightText      = lackWord
                wordView.type           = .normal
                self.addSubview(wordView)
                self.wordViewList.append(wordView)
            }
            // 添加不可见字母
            var letter2 = word.substring(fromIndex: _result.range.location, length: _result.range.length)
            letter2.removeFirst()
            letter2.removeLast()
            if !letter2.isEmpty {
                let wordView = YXLackWordView(frame: CGRect.zero, isTitle: isTitle)
                wordView.textField.text = ""
                wordView.rightText      = letter2
                wordView.type           = .blank
                self.addSubview(wordView)
                self.wordViewList.append(wordView)
            }
            offset = _result.range.location + _result.range.length
            if index >= array.count - 1 {
                // 添加可见字母
                let lackWord = word.substring(fromIndex: offset, length: word.count - offset)
                if !lackWord.isEmpty {
                    let wordView = YXLackWordView(frame: CGRect.zero, isTitle: isTitle)
                    wordView.textField.text = lackWord
                    wordView.rightText      = lackWord
                    wordView.type = .normal
                    self.addSubview(wordView)
                    self.wordViewList.append(wordView)
                }
            }
        }
    }

    ///  重新设定约束
    private func resetConstraints() {
        maxX = 0
        self.wordViewList.forEach { (view) in
            var _width = CGFloat(AdaptSize(20))
            if !view.text.isEmpty {
                let w = view.text.textWidth(font: view.textField.font!, height: charH)
                _width = w > _width ? w : _width
            }
            view.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(maxX)
                make.top.equalToSuperview()
                make.width.equalTo(_width)
                make.height.equalTo(charH)
            }
            maxX += _width + margin
        }
        if self.superview != nil {
            self.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(AdaptSize(64))
                make.width.equalTo(maxX - margin)
                make.height.equalTo(charH)
            }
        }
    }

    // TODO: Event

    /// 添加单词
    func insertLetter(_ button: YXLetterButton) -> Bool {
        var result = false
        for wordView in self.wordViewList {
            if wordView.text.isEmpty {
                wordView.text = button.currentTitle ?? ""
                wordView.tag  = button.tag
                // 修改宽度
                self.resetConstraints()
                result = true
                break
            }
        }
        return result
    }

    /// 移除单词
    func removeLetter(_ button: YXLetterButton) {
        for wordView in self.wordViewList {
            if wordView.tag == button.tag {
                wordView.text = ""
                // 修改宽度
                self.resetConstraints()
            }
        }
    }

    /// 检验结果
    /// - returns: Bool: 是否需要更新结果, [Int]: 错误结果
    func checkResult() -> (Bool, [Int]) {
        var showResult = false
        var errorTagList = [Int]()
        // 检测是否有未填充的空格
        let emptyBlankList = self.wordViewList.filter { (wordView) -> Bool in
            if wordView.type == .blank && wordView.text.isEmpty {
                return true
            } else {
                return false
            }
        }
        // 如果没有未填充的空格,则显示结果
        if emptyBlankList.isEmpty {
            showResult = true
            // 校验错误的tag
            self.wordViewList.forEach { (wordView) in
                if wordView.text != wordView.rightText {
                    errorTagList.append(wordView.tag)
                }
            }
            self.showResultView(errorList: errorTagList)
        }
        return (showResult, errorTagList)
    }

    /// 显示结果
    func showResultView(errorList list: [Int]) {
        self.wordViewList.forEach { (lackWord) in
            if lackWord.type == .blank {
                if list.contains(lackWord.tag) {
                    lackWord.status = .error
                } else {
                    lackWord.status = .right
                }
            }
        }
    }
}
