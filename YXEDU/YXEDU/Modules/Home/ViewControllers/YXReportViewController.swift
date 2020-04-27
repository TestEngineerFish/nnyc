//
//  YXReportViewController.swift
//  YXEDU
//
//  Created by Jake To on 4/22/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXStudyReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var studyResult: YXStudyReportResultModel?
    private var studyContent: [YXStudyReportResultContentModel]?
    private var selectDate: TimeInterval = 0
    
    @IBOutlet weak var heightOfCenterView: NSLayoutConstraint!
    @IBOutlet weak var avatarImageView: YXDesignableImageView!
    @IBOutlet weak var registerDaysCountLabel: UILabel!
    @IBOutlet weak var reportDateLabel: UILabel!
    @IBOutlet weak var studyDurationLabel: UILabel!
    @IBOutlet weak var newWordsCountLabel: UILabel!
    @IBOutlet weak var reviewWordsCountLabel: UILabel!
    @IBOutlet weak var betterWordsCountButton: UIButton!
    @IBOutlet weak var improveWordsCountButton: UIButton!
    @IBOutlet weak var studyContentTableView: UITableView!
    @IBOutlet weak var studyWordsCountLabel: UILabel!
    @IBOutlet weak var studyWordsCountPercentLabel: UILabel!
    @IBOutlet weak var studyWordsCountImageView: UIImageView!
    @IBOutlet weak var studyDaysCountLabel: UILabel!
    @IBOutlet weak var studyDaysCountPercentLabel: UILabel!
    @IBOutlet weak var studyDaysCountImageView: UIImageView!
    @IBOutlet weak var blankView: YXStudyReportBlankView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studyContentTableView.register(UINib(nibName: "YXStudyReportContentCell", bundle: nil), forCellReuseIdentifier: "YXStudyReportContentCell")
        fetchStudyReport(withDate: selectDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

        self.navigationController?.navigationBar.barTintColor = UIColor.hex(0xFFA83E)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func fetchStudyReport(withDate date: TimeInterval) {
        let taskListRequest = YXStudyReportRequest.stutyReport(date: date)
        YYNetworkService.default.request(YYStructResponse<YXStudyReportModel>.self, request: taskListRequest, success: { [weak self] response in
            guard let self = self else { return }
            
            if let data = response.data {
                if let string = data.user?.avatar, let url = URL(string: string) {
                    self.avatarImageView.sd_setImage(with: url)
                }
                
                self.registerDaysCountLabel.text = "\(data.registerDaysCount ?? 0)"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M月d日 学习报告"
                let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: data.date ?? 0))
                self.reportDateLabel.text = dateString

                self.studyDurationLabel.text = "\(data.studyDuration ?? 0)"
                self.newWordsCountLabel.text = "\(data.newWordsCount ?? 0)"
                self.reviewWordsCountLabel.text = "\(data.reviewWordsCount ?? 0)"

                self.studyResult = data.studyResult
                self.betterWordsCountButton.setTitle("\(self.studyResult?.betterWords?.count ?? 0)", for: .normal)
                self.improveWordsCountButton.setTitle("\(self.studyResult?.improveWords?.count ?? 0)", for: .normal)

                self.studyContent = data.studyContent
                self.heightOfCenterView.constant = CGFloat(406 + ((self.studyContent?.count ?? 0) * 28))
                self.studyContentTableView.reloadData()
                
                self.studyWordsCountLabel.text = "\(data.studyAnaliysis?.studyWordsCount ?? 0)"
                self.studyWordsCountPercentLabel.text = "\(data.studyAnaliysis?.studyWordsCountPercent ?? 0)%"
                if let badge = data.studyBadge, badge.count > 0, let url = URL(string: badge[0]) {
                    self.studyWordsCountImageView.sd_setImage(with: url)
                }
                self.studyDaysCountLabel.text = "\(data.studyAnaliysis?.studyDaysCount ?? 0)"
                self.studyDaysCountPercentLabel.text = "\(data.studyAnaliysis?.studyDaysCountPercent ?? 0)%"
                if let badge = data.studyBadge, badge.count > 1, let url = URL(string: badge[1]) {
                    self.studyDaysCountImageView.sd_setImage(with: url)
                }

            } else {
                self.showBlankView()
            }
            
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
    
    private func showBlankView() {
        heightOfCenterView.constant = 240
        blankView.isHidden = false
        blankView.tapButtonClosure = {
            
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func changeDate(_ sender: Any) {
        let currentSelectDate = selectDate == 0 ? Date() : Date(timeIntervalSince1970: selectDate)
        let calendarView = YXCalendarView(frame: .zero, selected: currentSelectDate)
        calendarView.selectedBlock = { date in
            self.selectDate = date.timeIntervalSince1970
            self.fetchStudyReport(withDate: self.selectDate)
        }
        
        calendarView.show()
    }
    
    @IBAction func showBetterWords(_ sender: Any) {
        let wrongWordListView = YXWrongWordsListView()
        wrongWordListView.titleLabel.text = ""
        let wordsList = studyResult?.betterWords ?? []
        wrongWordListView.bindData(wordsList)
        let h = wordsList.count > 3 ? AdaptSize(367) : AdaptSize(170)
        YXAlertCustomView.share.show(wrongWordListView, h: h)
    }
    
    @IBAction func showImproveWords(_ sender: Any) {
        let wrongWordListView = YXWrongWordsListView()
        let wordsList = studyResult?.improveWords ?? []
        wrongWordListView.bindData(wordsList)
        let h = wordsList.count > 3 ? AdaptSize(367) : AdaptSize(170)
        YXAlertCustomView.share.show(wrongWordListView, h: h)
    }

    // MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyContent?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXStudyReportContentCell", for: indexPath) as! YXStudyReportContentCell
        guard let content = studyContent?[indexPath.row] else { return cell }
        
        cell.nameLabel.text = content.name
        cell.countLabel.text = "\(content.count ?? 0)"

        return cell
    }
}
