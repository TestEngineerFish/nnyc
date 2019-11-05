//
//  YXSelectBookViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSelectBookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var wordBookModels: [YXWordBookModel] = []
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var countOfDaysForStudyLabel: UILabel!
    @IBOutlet weak var countOfWordsForStudyLabel: UILabel!

     @IBAction func back(_ sender: UIBarButtonItem) {
         navigationController?.popViewController(animated: true)
     }
     
     @IBAction func deleteWordBook(_ sender: UIButton) {
         
     }
    
     @IBAction func downloadWordBook(_ sender: UIButton) {
         
     }
     
     @IBAction func startStudy(_ sender: UIButton) {
         
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookCollectionView.register(UINib(nibName: "YXWordBookCell", bundle: nil), forCellWithReuseIdentifier: "YXWordBookCell")
        
        fetchWordBooks()
    }
    
    private func fetchWordBooks() {
        var newWordBook = YXWordBookModel()
        newWordBook.bookName = "添加词书"
        newWordBook.coverImage = #imageLiteral(resourceName: "newBook")
        wordBookModels.append(newWordBook)
    }
    
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordBookModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXWordBookCell", for: indexPath) as! YXWordBookCell
        let wordBook = wordBookModels[indexPath.row]

        if let coverImagePath = wordBook.coverImagePath {
            cell.bookCover.sd_setImage(with: URL(string: coverImagePath), completed: nil)
        } else {
            cell.bookCover.image = wordBook.coverImage
        }
        cell.bookNameLabel.text = wordBook.bookName
        
        if let countOfWords = wordBook.countOfWords {
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
            var wordBook = wordBookModels[indexPath.row]

            bookNameLabel.text = "--"
            unitLabel.text = "--"
            
            let countOfDaysForStudyString = "--天"
            let index1 = countOfDaysForStudyString.firstIndex(of: "天").hashValue
            let attributedText1 = NSMutableAttributedString(string: countOfDaysForStudyString)
            attributedText1.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .semibold), range: NSRange(location: 0, length: index1))
            attributedText1.addAttribute(.foregroundColor, value: UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), range: NSRange(location: 0, length: index1))
            countOfDaysForStudyLabel.attributedText = attributedText1
            
            let countOfWordsForStudyString = "--个"
            let index2 = countOfDaysForStudyString.firstIndex(of: "个").hashValue
            let attributedText2 = NSMutableAttributedString(string: countOfWordsForStudyString)
            attributedText2.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .semibold), range: NSRange(location: 0, length: index2))
            attributedText2.addAttribute(.foregroundColor, value: UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), range: NSRange(location: 0, length: index2))
            countOfWordsForStudyLabel.attributedText = attributedText2
            
            for var wordBook in wordBookModels {
                wordBook.isSelected = false
            }
            wordBook.isSelected = true
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 124)
    }
}
