//
//  YXSelectBookViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSelectBookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var wordBookStateModels: YXWordBookStatusModel!
    private var wordBookModels: [YXWordBookModel] = []
    
    @IBOutlet weak var distanceOfDownloadButtonBetweenLeft: NSLayoutConstraint!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var deleteWordBookButton: YXDesignableButton!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var countOfDaysForStudyLabel: UILabel!
    @IBOutlet weak var countOfWordsForStudyLabel: UILabel!
    @IBOutlet weak var startStudyButton: YXDesignableButton!
    
     @IBAction func back(_ sender: UIBarButtonItem) {
         navigationController?.popViewController(animated: true)
     }
     
     @IBAction func deleteWordBook(_ sender: UIButton) {
        let alertView = YXAlertView()
        alertView.descriptionLabel.text = "删除这本词书后你的学习进度会保留，重新添加词书可以继续学习这本书"
        alertView.doneClosure = { _ in
            for index in 0..<self.wordBookModels.count {
                let wordBook = self.wordBookModels[index]
                guard wordBook.isSelected, let selectedBookId = wordBook.bookId else { continue }
                
                var nextSelectWordBook: YXWordBookModel!
                if index == self.wordBookModels.count - 1 - 1 {
                    nextSelectWordBook = self.wordBookModels[index - 1 ]
                    
                } else {
                    nextSelectWordBook = self.wordBookModels[index + 1]
                }
                
                YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/api/v1/book/deluserbook", parameters: ["book_id": selectedBookId]) { [weak self] (response, isSuccess) in
                    guard let self = self, isSuccess else { return }
                    
                    if index == self.wordBookModels.count - 1 - 1 {
                        self.wordBookModels[index - 1 ].isSelected = true
                        
                    } else {
                        self.wordBookModels[index + 1].isSelected = true
                    }
                    
                    self.fetchWordBookDetail(nextSelectWordBook)
                    self.wordBookModels.remove(at: index)
                    self.bookCollectionView.reloadData()
                    
                    YXWordBookDaoImpl().deleteBook(bookId: selectedBookId)
//                    try? FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(selectedBookId)"))
                }
                
                break
            }
        }
        
        alertView.adjustAlertHeight()
        alertView.show()
    }
    
    @IBAction func downloadWordBook(_ sender: UIButton) {
//        for index in 0..<wordBookModels.count {
//            let wordBook = wordBookModels[index]
//            guard wordBook.isSelected else { continue }
//
//            DispatchQueue.global().async {
//                YXWordBookResourceManager.shared.downloadMaterial(in: wordBook) { (isSuccess) in
//                    guard isSuccess else { return }
//                    DispatchQueue.main.async {
//                        self.navigationController?.popToRootViewController(animated: true)
//                    }
//                }
//            }
//        }
    }
     
     @IBAction func startStudy(_ sender: UIButton) {
        for index in 0..<wordBookModels.count {
            let wordBook = wordBookModels[index]
            guard wordBook.isSelected, let bookId = wordBookStateModels.bookId, let unitId = wordBookStateModels.unitId else { continue }
            
            guard index != 0 else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            let request = YXWordBookRequest.addWordBook(userId: YXUserModel.default.uuid ?? "", bookId: bookId, unitId: unitId)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                YXWordBookResourceManager.shared.download(by: bookId) { (isSuccess) in
                    guard isSuccess else { return }
                    self.navigationController?.popViewController(animated: true)
                }
                
            }) { error in
                print("❌❌❌\(error)")
            }
            
            break
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookCollectionView.register(UINib(nibName: "YXWordBookCell", bundle: nil), forCellWithReuseIdentifier: "YXWordBookCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.hex(0xF5F5F5)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

        fetchWordBooks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    private func fetchWordBooks() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/getuserbooklist", parameters: ["user_id": YXConfigure.shared().uuid]) { [weak self] (response, isSuccess) in
            guard let self = self, isSuccess, let response = response?.responseObject as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                guard let jsonString = String(data: jsonData, encoding: .utf8), let result = YXUserWordBookListModel(JSONString: jsonString), let wordBookStateModels = result.currentLearnWordBookStatus, var learnedWordBooks = result.learnedWordBooks, learnedWordBooks.count > 0 else { return }
                learnedWordBooks[0].isSelected = true
                learnedWordBooks[0].isCurrentStudy = true
                self.wordBookModels = learnedWordBooks
                
                self.wordBookStateModels = wordBookStateModels
                self.fetchWordBookDetail(learnedWordBooks[0])
                
                var newWordBook = YXWordBookModel()
                newWordBook.bookName = "添加词书"
                newWordBook.isNewWordBook = true
                self.wordBookModels.append(newWordBook)
                self.bookCollectionView.reloadData()
                
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchWordBookDetail(_ wordBook: YXWordBookModel) {
        bookNameLabel.text = wordBook.bookName
        
        if wordBook.isCurrentStudy {
            deleteWordBookButton.isHidden = true
            distanceOfDownloadButtonBetweenLeft.constant = 12
            startStudyButton.setTitle("继续学习", for: .normal)
            
        } else {
            deleteWordBookButton.isHidden = false
            distanceOfDownloadButtonBetweenLeft.constant = 84
            startStudyButton.setTitle("开始学习", for: .normal)
        }
        
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/getuserbookstatus", parameters: ["user_id": YXConfigure.shared().uuid, "book_id": "\(wordBook.bookId ?? 0)"]) { [weak self] (response, isSuccess) in
            guard let self = self, isSuccess, let response = response?.responseObject as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                guard let jsonString = String(data: jsonData, encoding: .utf8), let result = YXWordBookStatusModel(JSONString: jsonString) else { return }
                self.wordBookStateModels = result
    
                self.unitLabel.text = self.wordBookStateModels.learningUnit
                
                let countOfDaysForStudyString = "\(self.wordBookStateModels.learnedDays ?? 0)天"
                let index1 = countOfDaysForStudyString.distance(from: countOfDaysForStudyString.startIndex, to: countOfDaysForStudyString.firstIndex(of: "天")!)
                let attributedText1 = NSMutableAttributedString(string: countOfDaysForStudyString)
                attributedText1.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .semibold), range: NSRange(location: 0, length: index1))
                attributedText1.addAttribute(.foregroundColor, value: UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), range: NSRange(location: 0, length: index1))
                self.countOfDaysForStudyLabel.attributedText = attributedText1
                
                let countOfWordsForStudyString = "\(self.wordBookStateModels.learnedWordsCount ?? 0)个"
                let index2 = countOfWordsForStudyString.distance(from: countOfWordsForStudyString.startIndex, to: countOfWordsForStudyString.firstIndex(of: "个")!)
                let attributedText2 = NSMutableAttributedString(string: countOfWordsForStudyString)
                attributedText2.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .semibold), range: NSRange(location: 0, length: index2))
                attributedText2.addAttribute(.foregroundColor, value: UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), range: NSRange(location: 0, length: index2))
                self.countOfWordsForStudyLabel.attributedText = attributedText2
                
            } catch {
                print(error)
            }
        }
    }
    
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordBookModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXWordBookCell", for: indexPath) as! YXWordBookCell
        let wordBook = wordBookModels[indexPath.row]

        cell.countOfWordsLabel.text = "\(wordBook.countOfWords ?? 0)词"
        cell.bookNameLabel.text = wordBook.bookName
        
        cell.isCurrentStudy = wordBook.isCurrentStudy
        cell.didFinished = wordBook.didFinished == 1
        cell.isAddBook = wordBook.isNewWordBook
        cell.isSelected = wordBook.isSelected
        cell.adjustCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == wordBookModels.count - 1 {
            self.performSegue(withIdentifier: "AddBook", sender: nil)

        } else {
            let wordBook = wordBookModels[indexPath.row]
            fetchWordBookDetail(wordBook)
            
            for index in 0..<wordBookModels.count {
                wordBookModels[index].isSelected = false
            }
            wordBookModels[indexPath.row].isSelected = true
            
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 124)
    }
}
