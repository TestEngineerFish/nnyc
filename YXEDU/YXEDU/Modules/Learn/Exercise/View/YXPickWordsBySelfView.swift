//
//  YXPickWordsBySelfView.swift
//  YXEDU
//
//  Created by Jake To on 2020/5/29.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXPickWordsBySelfView: UIView, UITableViewDelegate, UITableViewDataSource {
    private var words: [YXWordModel] = []
    private var tapStartLearnClosure: ((_ words: [YXWordModel]) -> Void)!

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    init(frame: CGRect, words: [YXWordModel], tapStartLearnClosure: @escaping ((_ words: [YXWordModel]) -> Void)) {
        super.init(frame: frame)
        
        self.words = words
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
        contentView.frame = self.bounds
        
        tableView.register(UINib(nibName: "YXPickWordsBySelfViewCell", bundle: nil), forCellReuseIdentifier: "YXPickWordsBySelfViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    @IBAction func startLearn(_ sender: Any) {
        tapStartLearnClosure(words.filter({ $0.isSelected }))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXPickWordsBySelfViewCell", for: indexPath) as! YXPickWordsBySelfViewCell
        let word = words[indexPath.row]
        
        cell.wordLabel.text = word.word
        cell.isPicked = word.isSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        words[indexPath.row].isSelected = !words[indexPath.row].isSelected
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
