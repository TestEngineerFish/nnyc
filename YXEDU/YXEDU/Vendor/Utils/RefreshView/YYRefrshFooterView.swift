//
//  YYRefrshFooterView.swift
//  YouYou
//
//  Created by pyyx on 2018/11/26.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import MJRefresh
import CocoaLumberjack

public class YYRefrshFooterView: MJRefreshAutoFooter {
    private lazy var refreshFrashContentView: YYRefreshFrashContentView = {
        let _refreshFrashContentView = YYRefreshFrashContentView(frame: self.bounds)
        return _refreshFrashContentView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.mj_h = 50.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func placeSubviews() {
        super.placeSubviews()
        
        if self.refreshFrashContentView.superview == nil {
            self.addSubview(self.refreshFrashContentView)
        }
    }
    
    override public func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
    
    override public func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    override public func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    override public var state: MJRefreshState {
        set {
            super.state = newValue
            switch newValue {
            case .idle:
                self.refreshFrashContentView.stopAnimation()
            case .pulling:
                YXLog("pulling")
            case .refreshing:
                self.refreshFrashContentView.beginAnimation()
            default:
                break
            }
        }
        
        get {
            return super.state
        }
    }
    
    override public var pullingPercent: CGFloat {
        set {
            super.pullingPercent = newValue
            self.refreshFrashContentView.complet = newValue
        }
        
        get {
            return super.pullingPercent
        }
    }
}
