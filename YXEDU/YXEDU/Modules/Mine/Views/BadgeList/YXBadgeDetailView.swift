//
//  YXBadgeDetailView.swift
//  YXEDU
//
//  Created by Jake To on 12/27/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXBadgeDetailView: YXTopWindowView {

    public var isReport: Bool = false
    private var badge: YXBadgeModel?
    private var didCompleted = false

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completedImageView: UIImageView!
    @IBOutlet weak var completedDescriptionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var incompleteDescriptionLabel: UILabel!
    @IBOutlet weak var currentProgressLabel: UILabel!
    @IBOutlet weak var totalProgressLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!

    init(badge: YXBadgeModel, didCompleted: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.badge = badge
        self.didCompleted = didCompleted

        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXBadgeDetailView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame     = self.bounds
        titleLabel.text       = badge?.name
        descriptionLabel.text = badge?.description
        
        let textHeight = badge?.description?.textHeight(font: UIFont.systemFont(ofSize: 14), width: screenWidth - 120)
        viewHeight.constant = viewHeight.constant - 20 + (textHeight ?? 0)
        self.imageTopConstraint.constant = AdaptSize(46)
        if didCompleted {
            if let imageOfCompletedStatus = badge?.imageOfCompletedStatus {
                badgeImageView.sd_setImage(with: URL(string: imageOfCompletedStatus), completed: nil)
            }
            
            if let time = badge?.finishDateTimeInterval {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                let dateString = NSDate(timeIntervalSince1970: time).formatYMD() ?? ""
                descriptionLabel.text = "已获得 " + dateString
            }
            
            completedDescriptionLabel.text      = badge?.description
            backgroundImageView.image           = #imageLiteral(resourceName: "badgeCompletedBackground")
            completedImageView.isHidden         = false
            completedDescriptionLabel.isHidden  = false
            progressBar.isHidden                = true
            incompleteDescriptionLabel.isHidden = true
            currentProgressLabel.isHidden       = true
            totalProgressLabel.isHidden         = true

        } else {
            if let imageOfIncompletedStatus = badge?.imageOfIncompletedStatus {
                badgeImageView.sd_setImage(with: URL(string: imageOfIncompletedStatus), completed: nil)
            }
            
            descriptionLabel.text               = badge?.description
            backgroundImageView.image           = #imageLiteral(resourceName: "badgeIncompleteBackground")
            completedImageView.isHidden         = true
            completedDescriptionLabel.isHidden  = true
            progressBar.isHidden                = false
            progressBar.progressImage           = progressBar.progressImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
            incompleteDescriptionLabel.isHidden = false
            currentProgressLabel.isHidden       = false
            totalProgressLabel.isHidden         = false
            
            if let currentProgress = badge?.currentProgress, let totalProgress = badge?.totalProgress {
                progressBar.setProgress(Float(currentProgress) / Float(totalProgress), animated: true)
                currentProgressLabel.text = "\(currentProgress)"
                totalProgressLabel.text = "/\(totalProgress)"
            }
        }
    }

    @IBAction func close(_ sender: Any) {
        if isReport {
            let request = YXMineRequest.badgeDisplayReport(badgeId: badge?.badgeId ?? 0)
            YYNetworkService.default.request(YYStructResponse<YXBadgeReportModel>.self, request: request, success: { [weak self] (response) in
                guard let self = self, let model = response.data else { return }
                YXLog("徽章显示\(self.badge?.badgeId ?? 0)，上报状态: ", model.state == 1)
            }) { error in
                YXUtils.showHUD(nil, title: error.message)
            }
        }
        
        UIView.animate(withDuration: 0.2, animations: {  [weak self] in
            guard let self = self else { return }
            self.contentView.alpha = 0
        }, completion: { [weak self] completed in
            self?.removeFromSuperview()
        })
    }
    
    override func show() {
        YXLog("开始弹框！！")
        kWindow.addSubview(self)
        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        containerView.alpha  = 0
        backgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.containerView.transform = .identity
            self.containerView.alpha     = 1
            self.backgroundView.alpha    = 0.7
        }, completion: nil)
    }
}
