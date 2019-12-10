//
//  YXEditWordListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXEditWordListType {
    case collected
    case familiar
}

class YXEditWordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var editWordListType: YXEditWordListType!
    var words: [YXWordModel] = []
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var redButton: YXDesignableButton!
    @IBOutlet weak var bottonViewHeight: NSLayoutConstraint!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapRedButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottonViewHeight.constant = bottonViewHeight.constant + kSafeBottomMargin
        
        tableView.register(UINib(nibName: "YXWordListEditCell", bundle: nil), forCellReuseIdentifier: "YXWordListEditCell")

        if editWordListType == .collected {
            title = "收藏夹"
            headerLabel.text = "请选择想取消收藏的单词"
            redButton.setTitle("取消收藏", for: .normal)
            
        } else {
            title = "熟识的单词"
            headerLabel.text = "请选择想删除的熟识的单词"
            redButton.setTitle("清除", for: .normal)
        }
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListEditCell", for: indexPath) as! YXWordListEditCell
        
        return cell
    }
}
