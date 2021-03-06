//
//  YXSelectBookViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//
import GrowingCoreKit
import UIKit

class YXSelectBookViewController: YXViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var wordBookStateModels: YXWordBookStatusModel?
    private var wordBookModels: [YXWordBookModel] = []
    
    @IBOutlet weak var distanceOfDownloadButtonBetweenLeft: NSLayoutConstraint!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var deleteWordBookButton: YXDesignableButton!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var countOfDaysForStudyLabel: UILabel!
    @IBOutlet weak var countOfWordsForStudyLabel: UILabel!
    @IBOutlet weak var startStudyButton: YXDesignableButton!
    
    @IBOutlet weak var bookListTopConstraint: NSLayoutConstraint!
    @IBAction func back(_ sender: UIBarButtonItem) {
         navigationController?.popViewController(animated: true)
     }
     
     @IBAction func deleteWordBook(_ sender: UIButton) {
        let alertView = YXAlertView()
        alertView.descriptionLabel.text = "删除这本词书后你的学习进度会保留，重新添加词书可以继续学习这本书"
        alertView.doneClosure = { [weak self] (text: String?) in
            guard let self = self else { return }
            for index in 0..<self.wordBookModels.count {
                let wordBook = self.wordBookModels[index]
                guard wordBook.isSelected, let selectedBookId = wordBook.bookId else { continue }
                
                var nextSelectWordBook: YXWordBookModel?
                if (index == self.wordBookModels.count - 2) && self.wordBookModels.count > (index - 1) {
                    nextSelectWordBook = self.wordBookModels[index - 1]
                } else {
                    if self.wordBookModels.count > (index + 1) {
                        nextSelectWordBook = self.wordBookModels[index + 1]
                    }
                }
                
                let request = YXWordBookRequest.deleteBook(bookId: selectedBookId)
                YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                    guard let self = self, let wordBook = nextSelectWordBook else { return }
                    
                    if (index == self.wordBookModels.count - 2) && self.wordBookModels.count > (index - 1) {
                        self.wordBookModels[index - 1 ].isSelected = true
                    } else {
                        if self.wordBookModels.count > (index + 1) {
                            self.wordBookModels[index + 1].isSelected = true
                        }
                    }

                    self.fetchWordBookDetail(wordBook)
                    self.wordBookModels.remove(at: index)
                    self.bookCollectionView.reloadData()
                    
                    YXWordBookDaoImpl().deleteBook(bookId: selectedBookId)
                }) { error in
                    YXUtils.showHUD(nil, title: error.message)
                }
                
                break
            }
        }
        
        alertView.adjustAlertHeight()
        YXAlertQueueManager.default.addAlert(alertView: alertView)
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
            guard wordBook.isSelected, let bookId = wordBookStateModels?.bookId, let unitId = wordBookStateModels?.unitId else { continue }
            
            guard index != 0 else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            // ---- Growing ----
            let bookGrade: String? = wordBook.bookGrade == nil ? nil : "\(wordBook.bookGrade ?? 0)"
            YXGrowingManager.share.uploadChangeBook(grade: bookGrade, versionName: wordBook.bookVersionName)
            
            let request = YXWordBookRequest.addWordBook(userId: YXUserModel.default.uuid ?? "", bookId: bookId, unitId: unitId)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                guard let self = self else { return }
                YXUserModel.default.currentBookId = bookId
                YXUserModel.default.currentGrade  = wordBook.bookGrade
                let taskModel = YXWordBookResourceModel(type: .single, book: bookId) {
                    YXWordBookResourceManager.shared.contrastBookData(by: bookId)
                }
                YXWordBookResourceManager.shared.addTask(model: taskModel)
                self.navigationController?.popViewController(animated: true)
            }) { error in
                YXUtils.showHUD(nil, title: error.message)
            }
            break
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "选择词书"
        self.bookListTopConstraint.constant = kNavBarHeight
        bookCollectionView.register(UINib(nibName: "YXWordBookCell", bundle: nil), forCellWithReuseIdentifier: "YXWordBookCell")
        self.view.backgroundColor = UIColor.hex(0xF5F5F5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWordBooks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    private func fetchWordBooks() {
        let request = YXWordBookRequest.userBookList(userId: YXUserModel.default.uuid ?? "")
        YYNetworkService.default.request(YYStructResponse<YXUserWordBookListModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let result = response.data, let wordBookStateModels = result.currentLearnWordBookStatus, var learnedWordBooks = result.learnedWordBooks, learnedWordBooks.count > 0 else { return }
            
            learnedWordBooks[0].isSelected     = true
            learnedWordBooks[0].isCurrentStudy = true
            self.wordBookModels = learnedWordBooks
            
            self.wordBookStateModels = wordBookStateModels
            self.fetchWordBookDetail(learnedWordBooks[0])
            
            var newWordBook = YXWordBookModel()
            newWordBook.bookName      = "添加词书"
            newWordBook.isNewWordBook = true
            self.wordBookModels.append(newWordBook)
            self.bookCollectionView.reloadData()
            
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
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
        
        let request = YXWordBookRequest.getBooksStatus(userId: YXUserModel.default.uuid ?? "", bookId: wordBook.bookId ?? 0)
        YYNetworkService.default.request(YYStructResponse<YXWordBookStatusModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let result = response.data else { return }
            self.wordBookStateModels = result
            
            self.unitLabel.text = self.wordBookStateModels?.learningUnit
            
            let countOfDaysForStudyString = "\(self.wordBookStateModels?.learnedDays ?? 0)天"
            let index1 = countOfDaysForStudyString.distance(from: countOfDaysForStudyString.startIndex, to: countOfDaysForStudyString.firstIndex(of: "天")!)
            let attributedText1 = NSMutableAttributedString(string: countOfDaysForStudyString)
            attributedText1.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .semibold), range: NSRange(location: 0, length: index1))
            attributedText1.addAttribute(.foregroundColor, value: UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), range: NSRange(location: 0, length: index1))
            self.countOfDaysForStudyLabel.attributedText = attributedText1
            
            let countOfWordsForStudyString = "\(self.wordBookStateModels?.learnedWordsCount ?? 0)个"
            let index2 = countOfWordsForStudyString.distance(from: countOfWordsForStudyString.startIndex, to: countOfWordsForStudyString.firstIndex(of: "个")!)
            let attributedText2 = NSMutableAttributedString(string: countOfWordsForStudyString)
            attributedText2.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .semibold), range: NSRange(location: 0, length: index2))
            attributedText2.addAttribute(.foregroundColor, value: UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), range: NSRange(location: 0, length: index2))
            self.countOfWordsForStudyLabel.attributedText = attributedText2
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }
    
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordBookModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXWordBookCell", for: indexPath) as? YXWordBookCell else {
            return UICollectionViewCell()
        }
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
