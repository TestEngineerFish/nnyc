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
                guard wordBook.isSelected, let currentLearningWordBookId = wordBook.bookId else { continue }
                
                var nextLearnWordBook: YXWordBookModel!
                if index == 0 {
                    nextLearnWordBook = self.wordBookModels[1]
                    
                } else if index == self.wordBookModels.count - 1 - 1 {
                    nextLearnWordBook = self.wordBookModels[index - 1 ]
                    
                } else {
                    nextLearnWordBook = self.wordBookModels[index + 1]
                }
                
                YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/adduserbook", parameters: ["user_id": YXConfigure.shared().uuid, "book_id": "\(nextLearnWordBook?.bookId ?? 0)", "unit_id": "\(nextLearnWordBook?.units?.first?.unitId ?? 0)"]) { [weak self] (response, isSuccess) in
                    guard let self = self, isSuccess else { return }
                    
                    YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v2/book/delbook", parameters: ["bookId": currentLearningWordBookId]) { [weak self] (response, isSuccess) in
                        guard let self = self, isSuccess else { return }
                        
                        YXWordBookDaoImpl().deleteBook(bookId: currentLearningWordBookId) { [weak self] (result, isSuccess) in
                            guard let self = self, isSuccess else { return }
                            
                            let wordBooksMaterialURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(currentLearningWordBookId)")
                            try? FileManager.default.removeItem(at: wordBooksMaterialURL)
                            
                            self.fetchWordBookDetail(nextLearnWordBook)
                            self.wordBookModels.remove(at: index)
                            self.bookCollectionView.reloadData()
                        }
                        
                    }
                    
                    YXWordBookDaoImpl().deleteWord(bookId: currentLearningWordBookId) { (result, isSuccess) in
                        
                    }
                }
                
                break
            }
        }
        
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
            guard wordBook.isSelected else { continue }
            
            YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/adduserbook", parameters: ["user_id": YXConfigure.shared().uuid, "book_id": "\(wordBookStateModels.bookId ?? 0)", "unit_id": "\(wordBookStateModels.unitId ?? 0)"]) { [weak self] (response, isSuccess) in
                guard let self = self, isSuccess else { return }

                DispatchQueue.global().async {
                    YXWordBookResourceManager.shared.download(wordBook) { (isSuccess) in
                        guard isSuccess else { return }
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }
            
            break
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookCollectionView.register(UINib(nibName: "YXWordBookCell", bundle: nil), forCellWithReuseIdentifier: "YXWordBookCell")
        
        startStudyButton.isUserInteractionEnabled = false
        fetchWordBooks()
    }
    
    private func fetchWordBooks() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/getuserbooklist", parameters: ["user_id": YXConfigure.shared().uuid]) { [weak self] (response, isSuccess) in
            guard let self = self, isSuccess, let response = response?.responseObject as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                guard let jsonString = String(data: jsonData, encoding: .utf8), let result = YXUserWordBookListModel(JSONString: jsonString), let wordBookStateModels = result.currentLearnWordBookStatus, var learnedWordBooks = result.learnedWordBooks, learnedWordBooks.count > 0 else { return }
                self.wordBookStateModels = wordBookStateModels
                self.fetchWordBookDetail(learnedWordBooks[0])

                learnedWordBooks[0].isSelected = true
                learnedWordBooks[0].isCurrentStudy = true
                self.wordBookModels = learnedWordBooks
                
                if learnedWordBooks.count == 1 {
                    self.deleteWordBookButton.isHidden = true
                }
                
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

        if wordBook.isNewWordBook {
            cell.bookCover.image = #imageLiteral(resourceName: "newBook")

        } else {
            if wordBook.isCurrentStudy {
                cell.bookCover.image = #imageLiteral(resourceName: "currentStudyBook")

            } else {
                if wordBook.isSelected {
                    cell.bookCover.image = #imageLiteral(resourceName: "unstudySelectedBook")

                } else {
                    cell.bookCover.image = #imageLiteral(resourceName: "unstudyBook")
                }
            }
        }
        cell.bookNameLabel.text = wordBook.bookName
        
        cell.countOfWordsLabel.text = ""
        
        if wordBook.isSelected {
            cell.indicatorIcon.isHidden = false
            
        } else {
            cell.indicatorIcon.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == wordBookModels.count - 1 {
            self.performSegue(withIdentifier: "AddBook", sender: nil)
            
        } else {
            let wordBook = wordBookModels[indexPath.row]
            if wordBook.isCurrentStudy {
                startStudyButton.isUserInteractionEnabled = false
                startStudyButton.setTitle("继续学习", for: .normal)
                
            } else {
                startStudyButton.isUserInteractionEnabled = true
                startStudyButton.setTitle("开始学习", for: .normal)
            }
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
