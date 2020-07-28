//
//  YXReportViewController.swift
//  YXEDU
//
//  Created by Jake To on 4/22/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

@objc
class YXStudyReportViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    private var studyResult: YXStudyReportResultModel?
    private var studyContent: [YXStudyReportResultContentModel]?
    @objc var selectDate: TimeInterval = 0
    @objc var canSelectDate = true

    @IBOutlet weak var heightOfCenterView: NSLayoutConstraint!
    @IBOutlet weak var avatarImageView: YXDesignableImageView!
    @IBOutlet weak var registerDaysCountLabel: UILabel!
    @IBOutlet weak var reportDateLabel: UILabel!
    @IBOutlet weak var reportDateLabelLeftOffset: NSLayoutConstraint!
    @IBOutlet weak var reportDateLabelCenter: NSLayoutConstraint!
    @IBOutlet weak var switchDateButton: UIButton!
    @IBOutlet weak var switchDateButtonImage: UIImageView!
    @IBOutlet weak var studyDurationLabel: UILabel!
    @IBOutlet weak var newWordsCountLabel: UILabel!
    @IBOutlet weak var reviewWordsCountLabel: UILabel!
    @IBOutlet weak var betterWordsCountButton: UIButton!
    @IBOutlet weak var betterWordsCountButtonImageView: UIImageView!
    @IBOutlet weak var improveWordsCountButton: UIButton!
    @IBOutlet weak var improveWordsCountButtonImageView: UIImageView!
    @IBOutlet weak var studyContentTableView: UITableView!
    @IBOutlet weak var studyWordsCountLabel: UILabel!
    @IBOutlet weak var studyWordsCountPercentLabel: UILabel!
    @IBOutlet weak var studyWordsCountImageView: UIImageView!
    @IBOutlet weak var studyDaysCountLabel: UILabel!
    @IBOutlet weak var studyDaysCountPercentLabel: UILabel!
    @IBOutlet weak var studyDaysCountImageView: UIImageView!
    @IBOutlet weak var blankView: YXStudyReportBlankView!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hex(0xFFA83E)
        self.customNavigationBar?.title = "学习报告"
        self.customNavigationBar?.titleColor = .white
        self.customNavigationBar?.leftButton.setTitleColor(.white, for: .normal)
        self.viewTopConstraint.constant = kNavHeight
        studyContentTableView.register(UINib(nibName: "YXStudyReportContentCell", bundle: nil), forCellReuseIdentifier: "YXStudyReportContentCell")
        fetchStudyReport(withDate: selectDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if canSelectDate == false {
            switchDateButton.isHidden = true
            switchDateButtonImage.isHidden = true
            
            reportDateLabelCenter.isActive = true
        }
    }
    
    private func fetchStudyReport(withDate date: TimeInterval) {
        let taskListRequest = YXStudyReportRequest.stutyReport(date: date)
        YYNetworkService.default.request(YYStructResponse<YXStudyReportModel>.self, request: taskListRequest, success: { [weak self] response in
            guard let self = self, let data = response.data else { return }
            if let string = data.user?.avatar, let url = URL(string: string) {
                self.avatarImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "challengeAvatar"))
                
            } else {
                self.avatarImageView.image = #imageLiteral(resourceName: "challengeAvatar")
            }
            
            self.registerDaysCountLabel.text = "\(data.registerDaysCount ?? 0)"
            
            self.selectDate = data.date ?? 0
            if Calendar.current.isDateInToday(Date(timeIntervalSince1970: data.date ?? 0)) {
                self.reportDateLabel.text = "今日学习报告"
                
            } else if Calendar.current.isDateInYesterday(Date(timeIntervalSince1970: data.date ?? 0)) {
                self.reportDateLabel.text = "昨日学习报告"
                
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M月d日 学习报告"
                let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: data.date ?? 0))
                self.reportDateLabel.text = dateString
            }
            
            self.studyDurationLabel.text = "\(Int((data.studyDuration ?? 0) / 60))"
            self.newWordsCountLabel.text = "\(data.newWordsCount ?? 0)"
            self.reviewWordsCountLabel.text = "\(data.reviewWordsCount ?? 0)"
            
            self.studyResult = data.studyResult
            if let betterWordsCount = self.studyResult?.betterWords?.count, betterWordsCount > 0 {
                self.betterWordsCountButton.setTitle("\(betterWordsCount)", for: .normal)
                self.betterWordsCountButton.setTitleColor(UIColor.orange1, for: .normal)
                self.betterWordsCountButtonImageView.alpha = 1
                
            } else {
                self.betterWordsCountButton.setTitle("0", for: .normal)
                self.betterWordsCountButton.setTitleColor(UIColor.hex(0xDCDCDC), for: .normal)
                self.betterWordsCountButtonImageView.alpha = 0.5
            }
            
            if let improveWordsCount = self.studyResult?.improveWords?.count, improveWordsCount > 0 {
                self.improveWordsCountButton.setTitle("\(improveWordsCount)", for: .normal)
                self.improveWordsCountButton.setTitleColor(UIColor.orange1, for: .normal)
                self.improveWordsCountButton.alpha = 1
                
            } else {
                self.improveWordsCountButton.setTitle("0", for: .normal)
                self.improveWordsCountButton.setTitleColor(UIColor.hex(0xDCDCDC), for: .normal)
                self.improveWordsCountButtonImageView.alpha = 0.5
            }
            
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
            
            if (data.studyDuration ?? 0) <= 0 {
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
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func changeDate(_ sender: Any) {
        let currentSelectDate = selectDate == 0 ? Date() : Date(timeIntervalSince1970: self.selectDate)
        let calendarView = YXCalendarView(frame: .zero, selected: currentSelectDate)
        calendarView.selectedBlock = { [weak self] date in
            guard let self = self else { return }
            self.selectDate = date.timeIntervalSince1970
            
            if self.selectDate > Date().timeIntervalSince1970 {
                self.selectDate = 0
            }
            
            self.fetchStudyReport(withDate: self.selectDate)
        }
        
        calendarView.show()
    }
    
    @IBAction func showBetterWords(_ sender: Any) {
        guard let words = studyResult?.betterWords, words.count > 0 else { return }
        
        let wrongWordListView = YXWrongWordsListView()
        wrongWordListView.titleLabel.text = "掌握的较好的单词"
        wrongWordListView.bindData(words)
        let h = words.count > 3 ? AdaptSize(367) : AdaptSize(170)
        YXAlertCustomView.share.show(wrongWordListView, h: h)
    }
    
    @IBAction func showImproveWords(_ sender: Any) {
        guard let words = studyResult?.improveWords, words.count > 0 else { return }

        let wrongWordListView = YXWrongWordsListView()
        wrongWordListView.bindData(words)
        let h = words.count > 3 ? AdaptSize(367) : AdaptSize(170)
        YXAlertCustomView.share.show(wrongWordListView, h: h)
    }

    // MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyContent?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YXStudyReportContentCell", for: indexPath) as? YXStudyReportContentCell else {
            return UITableViewCell()
        }
        guard let content = studyContent?[indexPath.row] else { return cell }
        
        cell.nameLabel.text = content.name
        cell.countLabel.text = "\(content.count ?? 0)"

        return cell
    }
}
