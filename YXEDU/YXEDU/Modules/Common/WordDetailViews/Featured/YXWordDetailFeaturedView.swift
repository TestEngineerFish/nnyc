//
//  YXWordDetailFeaturedView.swift
//  YXEDU
//
//  Created by Jake To on 12/5/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailFeaturedView: UIView, UITableViewDelegate, UITableViewDataSource {
    private var heightChangeClosure: ((_ height: CGFloat) -> Void)?
    
    private enum SectionType: String {
        case fixedMatch = "固定搭配"
        case commonPhrases = "常见短语"
        case wordAnalysis = "单词辨析"
        case detailedSyntax = "语法详解"
    }
    
    private var word: YXWordModel!
    private var sections: [[String: Any]] = []
    private var sectionExpandStatus: [Bool] = []
    private var wordAnalysisExpandStatus: [Bool] = []
    private var detailedSyntaxExpandStatus: [Bool] = []
    private var mostCommonPhrasesLength: CGFloat = 44

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    init(word: YXWordModel, heightChangeClosure: ((_ height: CGFloat) -> Void)?) {
        super.init(frame: .zero)
        self.word = word
        self.heightChangeClosure = heightChangeClosure

        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailFeaturedView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 200)
                
        tableView.register(UINib(nibName: "YXWordDetailFixedMatchCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailFixedMatchCell")
        tableView.register(UINib(nibName: "YXWordDetailCommonPhrasesCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailCommonPhrasesCell")
        tableView.register(UINib(nibName: "YXWordDetailFeaturedClassicCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailFeaturedClassicCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        if let fixedMatchs = word.fixedMatchs, fixedMatchs.count > 0 {
            sections.append([SectionType.fixedMatch.rawValue: fixedMatchs])
            sectionExpandStatus.append(false)
        }
        
        if let commonPhrases = word.commonPhrases, commonPhrases.count > 0 {
            sections.append([SectionType.commonPhrases.rawValue: commonPhrases])
            sectionExpandStatus.append(false)
            
            var mostWidth: CGFloat = 0
            
            for commonPhrase in commonPhrases {
                guard let english = commonPhrase.english else { continue }
                let width = english.textWidth(font: UIFont.systemFont(ofSize: 13), height: 20)
                
                if width > mostWidth {
                    mostWidth = width
                }
            }
            
            mostCommonPhrasesLength = mostCommonPhrasesLength + mostWidth
        }
        
        if let wordAnalysis = word.wordAnalysis, wordAnalysis.count > 0 {
            sections.append([SectionType.wordAnalysis.rawValue: wordAnalysis])
            sectionExpandStatus.append(true)
            
            for _ in wordAnalysis {
                wordAnalysisExpandStatus.append(false)
            }
        }
        
        if let detailedSyntaxs = word.detailedSyntaxs, detailedSyntaxs.count > 0 {
            sections.append([SectionType.detailedSyntax.rawValue: detailedSyntaxs])
            sectionExpandStatus.append(true)
            
            for _ in detailedSyntaxs {
                detailedSyntaxExpandStatus.append(false)
            }
        }
        
        tableView.reloadData()
        heightChange()
    }
    
    private func heightChange() {
        tableView.layoutIfNeeded()
        
        let height = tableView.contentSize.height + 86
        
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        contentView.frame = self.bounds
        
        heightChangeClosure?(height)
    }
    
    
    
    // MARK: - table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return YXWordDetailFeaturedSectionHeaderView(headerTitle: sections[section].keys.first ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionType = sections[section].keys.first
        
        if sectionType == SectionType.fixedMatch.rawValue || sectionType == SectionType.commonPhrases.rawValue {
            let view = YXWordDetailFeaturedSectionFooterView()
            view.isExpand = sectionExpandStatus[section]
            view.expandClosure = {
                self.sectionExpandStatus[section] = !self.sectionExpandStatus[section]
                self.tableView.reloadData()
                self.heightChange()
            }
            
            return view

        } else {
            let view = UIView()
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionExpandState = sectionExpandStatus[section]

        let section = sections[section]
        guard let sectionContent = section.values.first as? [Any] else { return 0 }

        switch section.keys.first {
        case SectionType.fixedMatch.rawValue:
            if sectionExpandState {
                return sectionContent.count
                
            } else {
                return 1
            }
            
        case SectionType.commonPhrases.rawValue:
            if sectionExpandState {
                return sectionContent.count
                
            } else {
                return 1
            }
            
        case SectionType.wordAnalysis.rawValue:
            return sectionContent.count
            
        case SectionType.detailedSyntax.rawValue:
            return sectionContent.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section.keys.first {
        case SectionType.fixedMatch.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailFixedMatchCell", for: indexPath) as! YXWordDetailFixedMatchCell
            
            let fixedMatchs = section.values.first as? [YXWordFixedMatchModel]
            let fixedMatch = fixedMatchs?[indexPath.row]
            
            cell.englishLabel.text = fixedMatch?.english
            cell.chineseLabel.text = fixedMatch?.chinese
            cell.exampleLabel.text = (fixedMatch?.englishExample ?? "") + "\n" + (fixedMatch?.chineseExample ?? "")

            return cell
            
        case SectionType.commonPhrases.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailCommonPhrasesCell", for: indexPath) as! YXWordDetailCommonPhrasesCell
            
            let commonPhrases = section.values.first as? [YXWordCommonPhrasesModel]
            let commonPhrase = commonPhrases?[indexPath.row]
            
            cell.englishLabel.text = commonPhrase?.english
            cell.chineseLabel.text = commonPhrase?.chinese
            cell.distanceOfChineseLabel.constant = mostCommonPhrasesLength
            
            return cell
            
        case SectionType.wordAnalysis.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailFeaturedClassicCell", for: indexPath) as! YXWordDetailFeaturedClassicCell
            
            let wordAnalysis = section.values.first as? [YXWordAnalysisModel]
            let analysis = wordAnalysis?[indexPath.row]
            
            cell.titleLabel.text = analysis?.title
            
            var content = ""
            for index in 0..<(analysis?.list?.count ?? 0) {
                if index == 0 {
                    content = analysis?.list?[0] ?? ""
                    
                } else {
                    content = "\n" + (analysis?.list?[index] ?? "")
                }
            }
            
            cell.contentLabel.text = content
            
            cell.isExpand = wordAnalysisExpandStatus[indexPath.row]
            cell.expandClosure = {
                self.wordAnalysisExpandStatus[indexPath.row] = !self.wordAnalysisExpandStatus[indexPath.row]
                self.tableView.reloadData()
                self.heightChange()
            }
            
            return cell
            
        case SectionType.detailedSyntax.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailFeaturedClassicCell", for: indexPath) as! YXWordDetailFeaturedClassicCell
            
            let detailedSyntaxs = section.values.first as? [YXWordDetailedSyntaxModel]
            let detailedSyntax = detailedSyntaxs?[indexPath.row]
            
            cell.titleLabel.text = detailedSyntax?.title
            
            var content = ""
            for index in 0..<(detailedSyntax?.list?.count ?? 0) {
                if index == 0 {
                    content = detailedSyntax?.list?[0] ?? ""
                    
                } else {
                    content = "\n" + (detailedSyntax?.list?[index] ?? "")
                }
            }
            
            cell.contentLabel.text = content
            
            cell.isExpand = detailedSyntaxExpandStatus[indexPath.row]
            cell.expandClosure = {
                self.detailedSyntaxExpandStatus[indexPath.row] = !self.detailedSyntaxExpandStatus[indexPath.row]
                self.tableView.reloadData()
                self.heightChange()
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
