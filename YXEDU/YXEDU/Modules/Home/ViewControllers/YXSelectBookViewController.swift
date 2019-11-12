//
//  YXSelectBookViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSelectBookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var wordBookModels: [YXSelectWordBookModel] = []
    
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
        for index in 0..<wordBookModels.count {
            let wordBook = wordBookModels[index]
            guard wordBook.isSelected else { continue }
            
            YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v2/book/delbook", parameters: ["bookId": wordBook.bookID ?? 0]) { (response, isSuccess) in
                guard isSuccess else { return }
                                
                if index == 0 {
                    self.fetchWordBookDetail(self.wordBookModels[1])

                } else if index == self.wordBookModels.count - 1 {
                    self.fetchWordBookDetail(self.wordBookModels[index - 1])

                } else {
                    self.fetchWordBookDetail(self.wordBookModels[index + 1])
                }
                
                self.wordBookModels.remove(at: index)
                self.bookCollectionView.reloadData()
                                
                YXWordBookResourceManager.shared.deleteWordBook(by: wordBook.bookID ?? 0)
            }
            break
        }
     }
    
     @IBAction func downloadWordBook(_ sender: UIButton) {
         
     }
     
     @IBAction func startStudy(_ sender: UIButton) {
        for index in 0..<wordBookModels.count {
            let wordBook = wordBookModels[index]
            guard wordBook.isSelected else { continue }
            
//            let seleceUnitView = YXSeleceUnitView(frame: self.view.bounds, units: wordBook.units) { (unitID) in
//                YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v1/unit/change", parameters: ["bookId": "\(bookID)", "unitId": unitID]) { (response, isSuccess) in
//                    guard isSuccess else { return }
//
//                    YXWordBookResourceManage.shared.downloadWordBook(with: URL(string: bookSource)!, and: bookID) { (isSucess) in
//                        guard isSucess else { return }
//                        self.navigationController?.popToRootViewController(animated: true)
//                    }
//                }
//            }
//            
//            self.view.addSubview(seleceUnitView)
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
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/v1/book/indexinfo", parameters: [:]) { (response, isSuccess) in
            guard isSuccess, let response = response?.responseObject as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let result = try decoder.decode(YXAllWordBookModel.self, from: jsonData)
                
                guard var currentLearnWordBook = result.currentLearnWordBook else { return }
                currentLearnWordBook.isSelected = true
                currentLearnWordBook.isCurrentStudy = true
                self.wordBookModels = [currentLearnWordBook]
                self.fetchWordBookDetail(currentLearnWordBook)
                
                if let learnedWordBooks = result.learnedWordBooks, learnedWordBooks.count > 0 {
                    self.wordBookModels.append(contentsOf: learnedWordBooks)
                    
                } else {
                    self.deleteWordBookButton.isHidden = true
                }
                
                var newWordBook = YXSelectWordBookModel()
                newWordBook.bookName = "添加词书"
                newWordBook.isNewWordBook = true
                self.wordBookModels.append(newWordBook)
                
                self.bookCollectionView.reloadData()
                
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchWordBookDetail(_ wordBook: YXSelectWordBookModel) {
        bookNameLabel.text = wordBook.bookName
        unitLabel.text = wordBook.unitName
        
        let countOfDaysForStudyString = "\(wordBook.countOfLearnedDays ?? 0)天"
        let index1 = countOfDaysForStudyString.distance(from: countOfDaysForStudyString.startIndex, to: countOfDaysForStudyString.firstIndex(of: "天")!)
        let attributedText1 = NSMutableAttributedString(string: countOfDaysForStudyString)
        attributedText1.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .semibold), range: NSRange(location: 0, length: index1))
        attributedText1.addAttribute(.foregroundColor, value: UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), range: NSRange(location: 0, length: index1))
        countOfDaysForStudyLabel.attributedText = attributedText1
        
        let countOfWordsForStudyString = "\(wordBook.countOfLearnedWords ?? 0)个"
        let index2 = countOfWordsForStudyString.distance(from: countOfWordsForStudyString.startIndex, to: countOfWordsForStudyString.firstIndex(of: "个")!)
        let attributedText2 = NSMutableAttributedString(string: countOfWordsForStudyString)
        attributedText2.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .semibold), range: NSRange(location: 0, length: index2))
        attributedText2.addAttribute(.foregroundColor, value: UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), range: NSRange(location: 0, length: index2))
        countOfWordsForStudyLabel.attributedText = attributedText2
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
        
        if let countOfWords = wordBook.countOfTotalWords {
            cell.countOfWordsLabel.text = "\(countOfWords)词"
            
        } else {
            cell.countOfWordsLabel.text = ""
        }
        
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
                
            } else {
                startStudyButton.isUserInteractionEnabled = true
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
