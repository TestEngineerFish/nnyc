//
//  YYKVOImageView.swift
//  YouYou
//
//  Created by pyyx on 2018/10/24.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

@objc public class YXKVOImageView: UIImageView {
    public typealias TouchOnImageBlock = (UIImageView) -> Void
    public typealias ImageDownloadCompletion = ((_ image: UIImage?, _ error: NSError?, _ imageURL: NSURL?) -> Void)
    public typealias ImageDownloadProgress = (CGFloat) -> Void
    
    public var shouldShowProgress: Bool = false
    
    fileprivate var _touchOnBlock: TouchOnImageBlock?
    public var touchOnBlock: TouchOnImageBlock? {
        get {
            return _touchOnBlock
        }
        
        set {
            isUserInteractionEnabled = true
            _touchOnBlock = newValue
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedWithBlock(_:)))
            addGestureRecognizer(tap)
        }
    }
    
    @objc private func tappedWithBlock(_ gestureRecognizer: UIGestureRecognizer) {
        touchOnBlock?(self)
    }
    
    //图片加载显示
    @objc public func showImage(with imageURL: URL,
                          placeholder: UIImage? = nil,
                          progress: ImageDownloadProgress? = nil,
                          completion: ImageDownloadCompletion? = nil) -> Void {
        self.kf.setImage(with: imageURL, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
            let progressValue = ((receivedSize) / (totalSize))
            progress?(CGFloat(progressValue))
        }) { (result: Result<RetrieveImageResult, KingfisherError>) in
            do {
                let imageResult = try result.get()
                let image       = imageResult.image
                let imageUrl    = imageResult.source.url
                completion?(image, nil, (imageUrl as NSURL?))
            } catch {
                completion?(nil, (error as NSError?), nil)
            }
        }
    }
    
    public func showImage(with imageURL: String,
                          placeholder: UIImage? = nil,
                          progress: ImageDownloadProgress? = nil,
                          completion: ImageDownloadCompletion? = nil) -> Void {
        guard let _imageURL = URL(string: imageURL) else {
            return
        }
        
        self.showImage(with: _imageURL, placeholder: placeholder, progress: progress, completion: completion)
    }
    
}
