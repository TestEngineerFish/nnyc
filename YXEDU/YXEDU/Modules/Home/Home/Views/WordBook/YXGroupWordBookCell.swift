//
//  YXGroupWordBookCell.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGroupWordBookCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var filterVersion: String?
    var gradeModel: YXGradeWordBookListModel?
    @IBOutlet weak var gradeTitleLabel: UILabel!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var divierView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bookCollectionView.delegate   = self
        self.bookCollectionView.dataSource = self
        self.bookCollectionView.register(UINib(nibName: "YXSingleGroupWordBookCell", bundle: nil), forCellWithReuseIdentifier: "YXSingleGroupWordBookCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(gradeModel: YXGradeWordBookListModel?, gradeName: String?, versionName: String?, hideDivider: Bool) {
        self.gradeModel           = gradeModel
        self.gradeTitleLabel.text = gradeName
        self.filterVersion        = versionName
        self.divierView.isHidden  = hideDivider
        self.bookCollectionView.reloadData()
    }

    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filterVersion == "所有版本" {
            return self.gradeModel?.wordBooks?.count ?? 0

        } else {
            var count = 0

            for wordBook in self.gradeModel?.wordBooks ?? [] {
                guard wordBook.bookVersionName == filterVersion else { continue }
                count = count + 1
            }

            return count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSingleGroupWordBookCell", for: indexPath) as? YXSingleGroupWordBookCell else {
            return UICollectionViewCell()
        }

        if filterVersion == "所有版本" {
            let wordBookModel = self.gradeModel?.wordBooks?[indexPath.row]
            cell.coverImageView.sd_setImage(with: URL(string: wordBookModel?.coverImagePath ?? ""), placeholderImage: nil, options: [.lowPriority], progress: nil, completed: nil)
            cell.nameLabel.text = wordBookModel?.bookName

        } else {
            var wordBookModels: [YXWordBookModel] = []

            for wordBook in self.gradeModel?.wordBooks ?? [] {
                guard wordBook.bookVersionName == filterVersion else { continue }
                wordBookModels.append(wordBook)
            }

            let wordBookModel = wordBookModels[indexPath.row]
            cell.coverImageView.sd_setImage(with: URL(string: wordBookModel.coverImagePath ?? ""), placeholderImage: nil, options: [.lowPriority], progress: nil, completed: nil)
            cell.nameLabel.text = wordBookModel.bookName
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var wordBook: YXWordBookModel?

        if filterVersion == "所有版本" {
            guard let wordBookMocel = self.gradeModel?.wordBooks?[indexPath.row] else { return }
            wordBook = wordBookMocel

        } else {
            var wordBookModels: [YXWordBookModel] = []

            for wordBook in self.gradeModel?.wordBooks ?? [] {
                guard wordBook.bookVersionName == filterVersion else { continue }
                wordBookModels.append(wordBook)
            }

            wordBook = wordBookModels[indexPath.row]
        }

        guard let bookId = wordBook?.bookId, let units = wordBook?.units else { return }
        let seleceUnitView = YXSeleceUnitView(units: units) { [weak self] (unitId) in
            guard let self = self, let unitId = unitId else { return }

            // ---- Growing ----
            let gradeId = self.gradeModel?.gradeId
            let bookGrade: String? = gradeId == nil ? nil : "\(gradeId ?? 0)"
            YXGrowingManager.share.uploadChangeBook(grade: bookGrade, versionName: wordBook?.bookVersionName)

            let request = YXWordBookRequest.addWordBook(userId: YXUserModel.default.uuid ?? "", bookId: bookId, unitId: unitId)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                YXUserModel.default.currentBookId   = bookId
                YXUserModel.default.currentGrade    = gradeId
                YRRouter.sharedInstance().currentNavigationController()?.popToRootViewController(animated: true)
                let taskModel = YXWordBookResourceModel(type: .single, book: bookId) {
                    YXWordBookResourceManager.shared.contrastBookData(by: bookId)
                }
                YXWordBookResourceManager.shared.addTask(model: taskModel)
            }) { error in
                YXUtils.showHUD(nil, title: error.message)
            }
        }

        seleceUnitView.show()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 100) / 3, height: 156)
    }
    
}
