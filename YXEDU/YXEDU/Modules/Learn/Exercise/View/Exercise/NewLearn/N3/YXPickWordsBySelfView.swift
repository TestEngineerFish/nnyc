//
//  YXPickWordsBySelfView.swift
//  YXEDU
//
//  Created by Jake To on 2020/5/29.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXPickWordsBySelfView: YXBaseQuestionView, UITableViewDelegate, UITableViewDataSource {

    private var tapStartLearnClosure: ((_ exerciseModel: YXExerciseModel) -> Void)!

    @IBOutlet weak var startButton: YXDesignableButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!

    @IBOutlet weak var bottomView: YXDesignableView!
    @IBOutlet weak var startCenterY: NSLayoutConstraint!

    init(frame: CGRect, exerciseModel: YXExerciseModel, tapStartLearnClosure: @escaping ((_ exerciseModel: YXExerciseModel) -> Void)) {
        super.init(exerciseModel: exerciseModel)
        self.tapStartLearnClosure = tapStartLearnClosure
        initializationFromNib()
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXPickWordsBySelfView", owner: self, options: nil)
        self.bottomViewHeight.constant += isPad() ? AdaptSize(30) : kSafeBottomMargin
        self.startCenterY.constant -= isPad() ? AdaptSize(7) : 0
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UINib(nibName: "YXPickWordsBySelfViewCell", bundle: nil), forCellReuseIdentifier: "YXPickWordsBySelfViewCell")
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    @IBAction func startLearn(_ sender: Any) {
        self.tapStartLearnClosure?(self.exerciseModel)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseModel.n3List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXPickWordsBySelfViewCell", for: indexPath) as! YXPickWordsBySelfViewCell
        let exerciseModel = self.exerciseModel.n3List[indexPath.row]
        cell.wordLabel.text = exerciseModel.word?.word
        cell.isPicked = exerciseModel.word?.isSelected == .some(true)
        cell.wordLabel.textColor = exerciseModel.word?.isSelected == .some(true) ? UIColor.black4 : UIColor.black1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _isSelect = (self.exerciseModel.n3List[indexPath.row].word?.isSelected == .some(true))
        self.exerciseModel.n3List[indexPath.row].word?.isSelected = !_isSelect
        self.exerciseModel.n3List[indexPath.row].status           = !_isSelect ? .right : .wrong
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
