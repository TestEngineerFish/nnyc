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
    @IBOutlet weak var tableViewBottomLineHeight: NSLayoutConstraint!
    
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
        
        var heightOfTableView: CGFloat = 0
        
        let cells = tableView.visibleCells
        for cell in cells {
            heightOfTableView = heightOfTableView + cell.frame.height
        }
        
        for section in sections {
            switch section.keys.first {
            case SectionType.fixedMatch.rawValue:
                if ((section.values.first as? [Any])?.count ?? 1) > 1 {
                    heightOfTableView = heightOfTableView + 40
                    
                } else {
                    heightOfTableView = heightOfTableView + 20
                }
                continue

            case SectionType.commonPhrases.rawValue:
                if ((section.values.first as? [Any])?.count ?? 1) > 1 {
                    heightOfTableView = heightOfTableView + 40

                } else {
                    heightOfTableView = heightOfTableView + 20
                }
                continue

            case SectionType.wordAnalysis.rawValue:
                heightOfTableView = heightOfTableView + 20
                continue

            case SectionType.detailedSyntax.rawValue:
                heightOfTableView = heightOfTableView + 20
                continue

            default:
                continue
            }
        }
        
        heightOfTableView = heightOfTableView + CGFloat(16 * sections.count)
        drawDottedLine(lineLength: heightOfTableView)

        heightOfTableView = heightOfTableView + 40
        
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: heightOfTableView)
        contentView.frame = self.bounds
        
        heightChangeClosure?(heightOfTableView)
    }
    
    private func drawDottedLine(lineLength: CGFloat) {
        let sectionsCount = sections.count
        guard sectionsCount > 1 else { return }
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.name = "Dotted Line"
        shapeLayer.strokeColor = UIColor.hex(0x979797).cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 4), NSNumber(value: 4)]

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 28, y: 20))
        path.addLine(to: CGPoint(x: 28, y: lineLength - 20))
        shapeLayer.path = path.cgPath

        for layer in self.tableView.layer.sublayers ?? [] {
            guard layer.name == "Dotted Line" else { continue }
            layer.removeFromSuperlayer()
        }
        
        self.tableView.layer.insertSublayer(shapeLayer, at: 0)
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
                
        let view = YXWordDetailFeaturedSectionFooterView(totalCount: (sections[section].values.first as? [Any])?.count ?? 0)
        view.isExpand = sectionExpandStatus[section]
        view.expandClosure = { [weak self] in
            guard let self = self else { return }
            self.sectionExpandStatus[section] = !self.sectionExpandStatus[section]
            self.tableView.reloadData()
            self.heightChange()
        }
        
        if section == sections.count - 1 {
            view.backgroundColor = .white
            
        } else {
            view.backgroundColor = .clear
        }
        
        if sectionType == SectionType.fixedMatch.rawValue, let sectionData = sections[section].values.first as? [YXWordFixedMatchModel], sectionData.count > 1 {
            return view
            
        } else if sectionType == SectionType.commonPhrases.rawValue, let sectionData = sections[section].values.first as? [YXWordCommonPhrasesModel], sectionData.count > 1 {
            return view
            
        } else {
            let blackView = UIView()
            
            if section == sections.count - 1 {
                blackView.backgroundColor = .white
                
            } else {
                blackView.backgroundColor = .clear
            }
            
            return blackView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = sections[section]
        
        switch section.keys.first {
        case SectionType.fixedMatch.rawValue:
            return ((section.values.first as? [Any])?.count ?? 1) > 1 ? 40 : 20
            
        case SectionType.commonPhrases.rawValue:
            return ((section.values.first as? [Any])?.count ?? 1) > 1 ? 40 : 20
            
        case SectionType.wordAnalysis.rawValue:
            return 20
            
        case SectionType.detailedSyntax.rawValue:
            return 20
            
        default:
            return 0
        }
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
            
            if indexPath.section == sections.count - 1 {
                cell.backgroundColor = .white
                
            } else {
                cell.backgroundColor = .clear
            }
            
            let fixedMatchs = section.values.first as? [YXWordFixedMatchModel]
            let fixedMatch = fixedMatchs?[indexPath.row]
            
            cell.englishLabel.text = fixedMatch?.english
            cell.chineseLabel.text = fixedMatch?.chinese
            cell.exampleLabel.text = (fixedMatch?.englishExample ?? "") + "\n" + (fixedMatch?.chineseExample ?? "")
            
            return cell
            
        case SectionType.commonPhrases.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailCommonPhrasesCell", for: indexPath) as! YXWordDetailCommonPhrasesCell
            
            if indexPath.section == sections.count - 1 {
                cell.backgroundColor = .white
                
            } else {
                cell.backgroundColor = .clear
            }
            
            let commonPhrases = section.values.first as? [YXWordCommonPhrasesModel]
            let commonPhrase = commonPhrases?[indexPath.row]
            
            cell.englishLabel.text = commonPhrase?.english
            cell.chineseLabel.text = commonPhrase?.chinese
            cell.distanceOfChineseLabel.constant = mostCommonPhrasesLength + 20
            
            return cell
            
        case SectionType.wordAnalysis.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailFeaturedClassicCell", for: indexPath) as! YXWordDetailFeaturedClassicCell
            
            if indexPath.section == sections.count - 1 {
                cell.backgroundColor = .white
                
            } else {
                cell.backgroundColor = .clear
            }
            
            let wordAnalysis = section.values.first as? [YXWordAnalysisModel]
            let analysis = wordAnalysis?[indexPath.row]
            
            cell.titleLabel.text = analysis?.title
            
            var content = ""
            for index in 0..<(analysis?.list?.count ?? 0) {
                if index == 0 {
                    content = analysis?.list?[0] ?? ""
                    
                } else {
                    content = content + "\n" + (analysis?.list?[index] ?? "")
                }
            }
            
            cell.contentLabel.text = content
            cell.totalCount = analysis?.list?.count ?? 0
            cell.isExpand = wordAnalysisExpandStatus[indexPath.row]
            cell.expandClosure = { [weak self] in
                guard let self = self else { return }
                self.wordAnalysisExpandStatus[indexPath.row] = !self.wordAnalysisExpandStatus[indexPath.row]
                self.tableView.reloadData()
                self.heightChange()
            }
            
            return cell
            
        case SectionType.detailedSyntax.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailFeaturedClassicCell", for: indexPath) as! YXWordDetailFeaturedClassicCell
            
            if indexPath.section == sections.count - 1 {
                cell.backgroundColor = .white
                
            } else {
                cell.backgroundColor = .clear
            }
            
            let detailedSyntaxs = section.values.first as? [YXWordDetailedSyntaxModel]
            let detailedSyntax = detailedSyntaxs?[indexPath.row]
            
            cell.titleLabel.text = detailedSyntax?.title
            
            var content = ""
            for index in 0..<(detailedSyntax?.list?.count ?? 0) {
                if index == 0 {
                    content = detailedSyntax?.list?[0] ?? ""
                    
                } else {
                    content = content + "\n" + (detailedSyntax?.list?[index] ?? "")
                }
            }
            
            cell.contentLabel.text = content
            cell.totalCount = detailedSyntax?.list?.count ?? 0
            cell.isExpand = detailedSyntaxExpandStatus[indexPath.row]
            cell.expandClosure = { [weak self] in
                guard let self = self else { return }
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
