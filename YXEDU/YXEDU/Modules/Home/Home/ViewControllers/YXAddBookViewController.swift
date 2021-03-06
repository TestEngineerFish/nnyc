//
//  YXAddBookViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import GrowingCoreKit

class YXAddBookViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {
    private var grades: [YXGradeWordBookListModel] = []
    private var filterGrades: [YXGradeWordBookListModel] = []
    private var filterVersion = "所有版本"
    private var selectGradeView: YXSelectGradeView?
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seleteGradeViewStateImageView: UIImageView!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    @IBAction func showOrHideSelectGradeView(_ sender: Any) {
        if selectGradeView?.isHidden == true {
            selectGradeView?.isHidden = false
        } else {
            selectGradeView?.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewTopConstraint.constant      = kNavHeight
        self.tableViewTopConstraint.constant = kNavBarHeight + 44.5
        self.customNavigationBar?.title      = "添加词书"
        tableView.register(UINib(nibName: "YXGroupWordBookCell", bundle: nil), forCellReuseIdentifier: "YXGroupWordBookCell")
        loadData()
    }
    
    private func loadData() {
        let request = YXHomeRequest.getBookList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXGradeWordBookListModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let data = response.dataArray else { return }
            self.grades       = data
            self.filterGrades = self.grades
            
            self.tableView.reloadData()
            self.createGradeSelectView()
            
        }) { error in
            YXLog("获取全部词书失败：", error.localizedDescription)
        }
    }
        
    private func createGradeSelectView() {
        selectGradeView = YXSelectGradeView(frame: CGRect(x: 0, y: (kNavHeight + 44), width: screenWidth, height: screenHeight), grades: grades, selectClosure: { [weak self] gradeName, versionName in
            guard let self = self else { return }
            self.filterButton.setTitle("  " + gradeName + " " + (versionName ?? "所有版本") + "  ", for: .normal)
            self.filterButton.setTitleColor(.orange1, for: .normal)
            self.filterButton.backgroundColor = UIColor.orange1.withAlphaComponent(0.1)
            self.filterButton.layer.cornerRadius = 14
            
            self.filterVersion = versionName ?? "所有版本"
            self.filterGrade(by: gradeName)

            if versionName != nil {
                self.selectGradeView?.isHidden = true
            }
        })
        
        selectGradeView?.isHidden = true
        self.view.addSubview(selectGradeView!)
    }
    
    private func filterGrade(by gradeName: String) {
        if gradeName == "所有年级" {
            self.filterGrades = self.grades
            
        } else {
            for grade in self.grades {
                guard grade.gradeName == gradeName else { continue }
                self.filterGrades = [grade]
                break
            }
        }
        
        tableView.reloadData()
        tableView.scrollsToTop = true
    }
    
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterGrades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YXGroupWordBookCell", for: indexPath) as? YXGroupWordBookCell else {
            return UITableViewCell()
        }
        let grade = filterGrades[indexPath.row]
        cell.bookCollectionView.tag = indexPath.row
        cell.setData(gradeModel: grade, gradeName: grade.gradeName, versionName: filterVersion, hideDivider: indexPath.row == 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if filterVersion == "所有版本" {
            if let count = filterGrades[indexPath.row].wordBooks?.count, count != 0 {
                if count <= 3 {
                    return 228

                } else {
                    var countOfRow = Int(count / 3)
                    
                    if countOfRow != 0 {
                        countOfRow = countOfRow - 1
                    }
                    
                    if count % 3 != 0 {
                        countOfRow = countOfRow + 1
                    }
                    
                    return CGFloat(228 + (countOfRow * 182))
                }

            } else {
                return 0
            }

        } else {
            var count = 0

            for wordBook in filterGrades[indexPath.row].wordBooks ?? [] {
                guard wordBook.bookVersionName == filterVersion else { continue }
                count = count + 1
            }

            if count == 0 {
                return 0

            } else if count <= 3 {
                return 228

            } else {
                var countOfRow = Int(count / 3)
                    
                if countOfRow != 0 {
                    countOfRow = countOfRow - 1
                }
                
                if count % 3 != 0 {
                    countOfRow = countOfRow + 1
                }
                
                return CGFloat(228 + (countOfRow * 182))
            }
        }
    }
}
