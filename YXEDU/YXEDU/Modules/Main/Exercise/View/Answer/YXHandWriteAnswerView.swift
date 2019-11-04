//
//  YXHandWriteAnswerView.swift
//  YXEDU
//
//  Created by Jake To on 11/4/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXHandWriteAnswerView: UIView {
    
    private var timer: Timer?
    private var path = UIBezierPath()
    private var startPoint = CGPoint()
    private var touchPoint = CGPoint()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXHandWriteAnswerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        
        contentView.clipsToBounds = true
        contentView.isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: contentView) {
            startPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: contentView) {
            touchPoint = point
        }
        
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        draw()
    }
    
    private func draw() {
        timer?.invalidate()
        timer = nil
        
        imageView.image = UIGraphicsImageRenderer(size: self.size).image{ context in
            context.cgContext.setStrokeColor(UIColor.orange.cgColor)
            context.cgContext.setLineWidth(44)
            context.cgContext.setLineCap(.round)
            context.cgContext.addPath(path.cgPath)
            
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        if timer == nil {
            timer = Timer(fire: Date().addingTimeInterval(1), interval: 0, repeats: false, block: { (time) in
                self.recognizeText(in: self.imageView.image!)
            })
        }
    }
    
    private func recognizeText(in image: UIImage) {
        print("---------")

        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
            tesseract.image = imageView.image!
            tesseract.recognize()
            
            print(tesseract.recognizedText)
        }
    }
}
