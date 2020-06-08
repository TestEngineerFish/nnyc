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

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
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
        addSubview(contentView)
//        contentView.frame = self.bounds
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.exerciseModel.n3List[indexPath.row].word?.isSelected = !(self.exerciseModel.n3List[indexPath.row].word?.isSelected == .some(true))
        self.exerciseModel.n3List[indexPath.row].mastered = self.exerciseModel.n3List[indexPath.row].word?.isSelected == .some(true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
