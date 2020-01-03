//
//  BPSegmentControllerView.swift
//  BPSegmentController
//
//  Created by 沙庭宇 on 2019/12/4.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

protocol BPSegmentDataSource: NSObjectProtocol {
    /// 页面数
    func pagesNumber() -> Int
    /// 自定义Item视图
    func segment(_ segment: BPSegmentView, itemForRowAt indexPath: IndexPath) -> UIView
    /// 自定义Content视图
    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView
    /// 选中Item视图
    func segment(didSelectRowAt indexPath: IndexPath, previousSelectRowAt preIndexPath: IndexPath)
}

extension BPSegmentDataSource {
    /// 页面数
    func pagesNumber() -> Int {
        return 0
    }
    /// 自定义Item视图
    func segment(_ segment: BPSegmentView, itemForRowAt indexPath: IndexPath) -> UIView {
        return UIView()
    }
    /// 自定义Content视图
    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView {
        return UIView()
    }
    /// 点击Item视图
    func segment(didSelectRowAt indexPath: IndexPath, previousSelectRowAt preIndexPath: IndexPath) {
        
    }
}

struct BPSegmentConfig {
    var headerHeight       = CGFloat.zero
    var headerItemSize     = CGSize.zero
    var headerItemSpacing  = CGFloat.zero
    var contentItemSize    = CGSize.zero
    var contentItemSpacing = CGFloat.zero
    var firstIndexPath     = IndexPath(item: 0, section: 0)
    var headerBackgroundColor  = UIColor.clear
    var contentBackgroundColor = UIColor.clear
}

class BPSegmentControllerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // ---- 数据
    var titleArray: [String]?
    final let headerItemIdf  = "BPItemView"
    final let contentItemIdf = "BPItemContentView"
    var config: BPSegmentConfig
    var lastSelectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    // ---- 子视图
    var headerScrollView: BPSegmentView!
    var contentScrollView: BPSegmentView!
    var headerFlowLayout: UICollectionViewFlowLayout!
    var contentFlowLayout: UICollectionViewFlowLayout!

    weak var delegate: BPSegmentDataSource?

    init(_ config: BPSegmentConfig, frame: CGRect) {
        self.config = config
        self.lastSelectedIndex = config.firstIndexPath
        super.init(frame: frame)
        self.createSubviews()
    }

    deinit {
        headerScrollView.delegate    = nil
        contentScrollView.delegate   = nil
        headerScrollView.dataSource  = nil
        contentScrollView.dataSource = nil
        headerScrollView  = nil
        contentScrollView = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.selectItem(with: self.lastSelectedIndex, animation: false)
        }
        self.headerScrollView.reloadData()
        self.contentScrollView.reloadData()
    }

    private func createSubviews() {
        headerFlowLayout = UICollectionViewFlowLayout()
        headerFlowLayout.scrollDirection         = .horizontal
        headerFlowLayout.itemSize                = self.config.headerItemSize
        headerFlowLayout.minimumLineSpacing      = self.config.headerItemSpacing
        headerFlowLayout.sectionInset            = UIEdgeInsets.zero

        contentFlowLayout = UICollectionViewFlowLayout()
        contentFlowLayout.scrollDirection         = .horizontal
        contentFlowLayout.itemSize                = self.config.contentItemSize
        contentFlowLayout.minimumLineSpacing      = self.config.contentItemSpacing
        contentFlowLayout.sectionInset            = UIEdgeInsets.zero
        
        let headerFrame  = CGRect(x: 0, y: 0, width: self.frame.width, height: self.config.headerHeight)
        headerScrollView = BPSegmentView(frame: headerFrame, collectionViewLayout: headerFlowLayout)
        headerScrollView.backgroundColor = self.config.headerBackgroundColor
        let contentFrame = CGRect(x: 0, y: headerScrollView.frame.maxY, width: self.frame.width, height: self.frame.height - headerScrollView.frame.height)
        contentScrollView = BPSegmentView(frame: contentFrame, collectionViewLayout: contentFlowLayout)
        contentScrollView.backgroundColor = self.config.contentBackgroundColor
        self.addSubview(headerScrollView)
        self.addSubview(contentScrollView)

        headerScrollView.register(BPItemHeaderView.classForCoder(), forCellWithReuseIdentifier: headerItemIdf)
        contentScrollView.register(BPItemContentView.classForCoder(), forCellWithReuseIdentifier: contentItemIdf)

        headerScrollView.delegate      = self
        headerScrollView.dataSource    = self
        contentScrollView.delegate     = self
        contentScrollView.dataSource   = self

        headerScrollView.isHeaderView  = true
        contentScrollView.isHeaderView = false

        headerScrollView.isPagingEnabled  = false
        contentScrollView.isPagingEnabled = true
    }

    // TODO: ==== UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.pagesNumber() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let segmentView = collectionView as? BPSegmentView else {
            return UICollectionViewCell()
        }
        if segmentView.isHeaderView {
            // 通过注册获取View
            guard let _itemView = collectionView.dequeueReusableCell(withReuseIdentifier: headerItemIdf, for: indexPath) as? BPItemHeaderView else {
                return UICollectionViewCell()
            }
            // 获取自定义View,如果有的话
            if let itemSubview = self.delegate?.segment(segmentView, itemForRowAt: indexPath) {
                _itemView.contentView.removeAllSubviews()
                _itemView.contentView.addSubview(itemSubview)
                itemSubview.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            // 设置标识符
            _itemView.tag = indexPath.row
            return _itemView
        } else {
            // 通过注册获取View
            guard let _contentView = collectionView.dequeueReusableCell(withReuseIdentifier: contentItemIdf, for: indexPath) as? BPItemContentView else {
                return UICollectionViewCell()
            }
            // 获取自定义View,如果有的话
            if let contentSubview = self.delegate?.segment(segmentView, contentForRowAt: indexPath){
                _contentView.contentView.removeAllSubviews()
                _contentView.contentView.addSubview(contentSubview)
                contentSubview.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            // 设置标识符
            _contentView.tag = indexPath.row
            return _contentView
        }
    }

    // TODO: ==== UICollectionViewDelegate ====
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectItem(with: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let segmentView = collectionView as? BPSegmentView else {
            return false
        }
        if segmentView.isHeaderView {
            return true
        } else {
            return false
        }
    }

    // TODO: ==== UICollectionViewDelegateFlowLayout ====
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let segmentView = collectionView as? BPSegmentView, segmentView.isHeaderView else {
            return UIEdgeInsets.zero
        }
        let pagesNumber = CGFloat(self.delegate?.pagesNumber() ?? 0)
        let headerMaxWidth = pagesNumber * (self.config.headerItemSize.width + self.config.headerItemSpacing) - self.config.headerItemSpacing
        let margin = self.width - headerMaxWidth
        let offsetX = margin > 0 ? margin / 2 : self.config.headerItemSpacing
        return UIEdgeInsets(top: 0, left: offsetX, bottom: 0, right: self.config.headerItemSpacing)
    }

    // MARK: ==== UIScrollViewDelegate ====
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.contentScrollView {
            // 计算偏移
            let indexPath = self.shouldIndexPath(offset: scrollView.contentOffset.x, in: self.contentScrollView)
            if indexPath != self.lastSelectedIndex {
                self.selectItem(with: indexPath)
            }
        }
    }

    // TODO: ==== Event ====

    /// 选中Item,滑动显示到页面中间
    /// - Parameters:
    ///   - indexPath: 选中的位置
    ///   - collectionView: 视图对象
    func selectItem(with indexPath: IndexPath, animation: Bool = true) {

        // 通知业务层处理点击事件
        self.delegate?.segment(didSelectRowAt: indexPath, previousSelectRowAt: self.lastSelectedIndex)

        // 如果选中不是已选中的Item,则更新最后选中位置
//        if indexPath != self.lastSelectedIndex {
            // 滑动到中间
            self.scrollView(to: indexPath, animation: animation)
            // 更新选中
            self.lastSelectedIndex = indexPath
//        }
    }

    /// 滑动到对应位置
    private func scrollView(to indexPath: IndexPath, animation: Bool) {
        self.headerScrollView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animation)
        self.contentScrollView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animation)
    }

    // TODO: ==== Tools ===

    /// 根据偏移量获取当前视图的IndexPath
    /// - Parameters:
    ///   - x: 偏移量
    ///   - collectionView: 视图容器
    private func shouldIndexPath(offset x: CGFloat, in collectionView: BPSegmentView) -> IndexPath {
        if collectionView.isHeaderView {
            // 暂无根据偏移量获取Header中IndexPath的需求
            return IndexPath(item: 0, section: 0)
        } else {
            let offsetItem = (x + collectionView.width / 2) / collectionView.width
            let indexPath = IndexPath(item: Int(offsetItem), section: 0)
            return indexPath
        }
    }

}

