//
//  YXWordDetailFeaturedView.swift
//  YXEDU
//
//  Created by Jake To on 12/5/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailFeaturedView: UIView, UITableViewDelegate, UITableViewDataSource {
    var heightChangeClosure: ((_ height: CGFloat) -> Void)?
    
    private enum SectionType: String {
        case fixedMatch = "固定搭配"
        case commonPhrases = "常见短语"
        case wordAnalysis = "单词辨析"
        case detailedSyntax = "语法详解"
    }
    
    private var word: YXWordModel!
    private var sections: [[String: Any]] = []
    private var sectionExpandStatus: [Bool] = []

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    init(frame: CGRect, word: YXWordModel) {
        super.init(frame: frame)
        self.word = word
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailFeaturedView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        tableView.register(UINib(nibName: "YXWordDetailFixedMatchCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailFixedMatchCell")
        tableView.register(UINib(nibName: "YXWordDetailCommonPhrasesCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailCommonPhrasesCell")
        tableView.register(UINib(nibName: "YXWordDetailFeaturedClassicCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailFeaturedClassicCell")
        
        if let fixedMatchs = word.fixedMatchs, fixedMatchs.count > 0 {
            sections.append([SectionType.fixedMatch.rawValue: fixedMatchs])
            sectionExpandStatus.append(false)
        }
        
        if let commonPhrases = word.commonPhrases, commonPhrases.count > 0 {
            sections.append([SectionType.commonPhrases.rawValue: commonPhrases])
            sectionExpandStatus.append(false)
        }
        
        if let wordAnalysis = word.wordAnalysis, wordAnalysis.count > 0 {
            sections.append([SectionType.wordAnalysis.rawValue: wordAnalysis])
            sectionExpandStatus.append(true)
        }
        
        if let detailedSyntaxs = word.detailedSyntaxs, detailedSyntaxs.count > 0 {
            sections.append([SectionType.detailedSyntax.rawValue: detailedSyntaxs])
            sectionExpandStatus.append(true)
        }
        
        tableView.reloadData()
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
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
            
            return view

        } else {
            let view = UIView()
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
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
            return cell
            
        case SectionType.commonPhrases.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailCommonPhrasesCell", for: indexPath) as! YXWordDetailCommonPhrasesCell
            return cell
            
        case SectionType.wordAnalysis.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailFeaturedClassicCell", for: indexPath) as! YXWordDetailFeaturedClassicCell
            return cell
            
        case SectionType.detailedSyntax.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailFeaturedClassicCell", for: indexPath) as! YXWordDetailFeaturedClassicCell
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
