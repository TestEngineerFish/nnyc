//
//  YYScrollRefreshAnimator.swift
//  YouYou
//
//  Created by 杨杰 on 2018/11/18.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation

public protocol YYScrollRefreshAnimator: class {
    
    /**
     *  支持刷新功能ScrollView
     */
    var refreshCompomentScrollView: UIScrollView? { set get}
    
    /**
     *  获取headerRefreshView
     */
    var headerRefreshView: MJRefreshHeader? { get }
    
    /**
     *  获取footerRefreshView
     */
    var footerRefreshView: MJRefreshFooter? { get }
}

private struct AssociatedKeys {
    static var kRefreshCompomentScrollView = "kRefreshCompomentScrollView"
    static var kHeaderRefreshView = "kHeaderRefreshView"
    static var kFooterRefreshView = "kFooterRefreshView"
}

public extension YYScrollRefreshAnimator {
    
    var refreshCompomentScrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kRefreshCompomentScrollView) as? UIScrollView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kRefreshCompomentScrollView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var headerRefreshView: MJRefreshHeader? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kHeaderRefreshView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshCompomentScrollView?.mj_header = newValue
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kHeaderRefreshView) as? YYRefrshHeaderView
        }
    }
    
    var footerRefreshView: MJRefreshFooter? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kFooterRefreshView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshCompomentScrollView?.mj_footer = newValue
        }
        
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.kFooterRefreshView) as? YYRefrshFooterView
        }
        
    }
    
    func addHeaderPullToRefresh(_ block: @escaping () -> Void) -> Void {
        if self.headerRefreshView == nil {
            self.headerRefreshView = YYRefrshHeaderView(refreshingBlock: {
                block()
            })
        }
    }
    
    func addFooterPullToRefresh(_ block: @escaping () -> Void) -> Void {
        if self.footerRefreshView == nil {
            self.footerRefreshView = YYRefrshFooterView(refreshingBlock: {
                block()
            })
        }
    }
    
    func headerBeginRefreshing() {
        self.refreshCompomentScrollView?.mj_header?.beginRefreshing()
    }
    
    func footerBeginRefreshing() {
        self.refreshCompomentScrollView?.mj_footer?.beginRefreshing()
    }
    
    func headerEndRefreshing() {
        self.refreshCompomentScrollView?.mj_header?.endRefreshing()
    }
    
    func footerEndRefreshing() {
        self.refreshCompomentScrollView?.mj_footer?.endRefreshing()
    }
    
    
    func removeRefreshHeader() {
        self.refreshCompomentScrollView?.mj_header = nil
        self.headerRefreshView = nil
    }
    
    func removeRefreshFooter() {
        self.refreshCompomentScrollView?.mj_footer = nil
        self.footerRefreshView = nil
    }
    
    func endRefreshing() {
        self.headerEndRefreshing()
        self.footerEndRefreshing()
    }
}
