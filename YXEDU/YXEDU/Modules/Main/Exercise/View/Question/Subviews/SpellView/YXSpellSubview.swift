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
    let margin = CGFloat(10)
    let charH  = CGFloat(30)
    var maxX   = CGFloat(0)

    var exerciseModel: YXWordExerciseModel
    var wordViewList = [YXLackWordView]()
    var resultArrary: [NSTextCheckingResult]?

    init(_ model: YXWordExerciseModel) {
        self.exerciseModel = model
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
                let wordView = YXLackWordView()
                wordView.textField.text = lackWord
                wordView.type = .normal
                self.addSubview(wordView)
                self.wordViewList.append(wordView)
            }
            // 添加不可见字母
            var letter2 = word.substring(fromIndex: _result.range.location, length: _result.range.length)
            letter2.removeFirst()
            letter2.removeLast()
            if !letter2.isEmpty {
                let wordView = YXLackWordView()
                wordView.textField.text = ""
                wordView.type = .blank
                self.addSubview(wordView)
                self.wordViewList.append(wordView)
            }
            offset = _result.range.location + _result.range.length
            if index >= array.count - 1 {
                // 添加可见字母
                let lackWord = word.substring(fromIndex: offset, length: word.count - offset)
                if !lackWord.isEmpty {
                    let wordView = YXLackWordView()
                    wordView.textField.text = lackWord
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
            if let text = view.text, !text.isEmpty {
                let w = text.textWidth(font: view.textField.font!, height: charH)
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
                make.top.equalToSuperview().offset(CGFloat(54))
                make.width.equalTo(maxX - margin)
                make.height.equalTo(30)
            }
        }
    }

    // TODO: Event

    /// 添加单词
    func insertLetter(_ button: YXLetterButton) -> Int? {
        var index = 0
        for wordView in self.wordViewList {
            if wordView.text.isNilOrEmpty {
                wordView.text = button.currentTitle
                wordView.tag  = button.tag
                // 修改宽度
                self.resetConstraints()
                return index
            }
            if wordView.type == .blank {
                index += 1
            }
        }
        return nil
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
