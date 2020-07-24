//
//  YXAddBookGuideCell.swift
//  YXEDU
//
//  Created by Jake To on 2/25/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXAddBookGuideView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var dataSource: [String] = []
    var selectedIndex: Int?
    var selectedClosure: (() -> Void)?
    var editClosure: (() -> Void)?
    
    private var isSelecting = true
    private let hideTimeInterval = 0.2
    private let moveTimeInterval = 0.2
    private let alphaTimeInterval = 0.2
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var animationView: YXDesignableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopOffSet: NSLayoutConstraint!
    private var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: screenWidth - 40 - 80, y: -64, width: 80, height: 64))
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "chooseGuideBook")
        return imageView
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXAddBookGuideView", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        
        collectionView.register(UINib(nibName: "YXAddBookGuideItem", bundle: nil), forCellWithReuseIdentifier: "YXAddBookGuideItem")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = YXCollectionViewLeftFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
        
        self.backgroundColor = .clear
        self.addSubview(imageView)
    }
    
    func select(_ data: [String]) {
        dataSource = data
        isSelecting = true
        selectedIndex = nil

        enterSelectMode()
    }
    
    private func enterSelectMode() {
        isSelecting = true
        
        UIView.animate(withDuration: hideTimeInterval) {
            self.animationView.alpha = 1
            self.imageView.alpha = 1
        }
        
        if let index = selectedIndex {
            isUserInteractionEnabled = false
            
            UIView.animate(withDuration: alphaTimeInterval, animations: {
                if self.descriptionLabel.isHidden == false, let description = self.descriptionLabel.text, description.isEmpty == false {
                    self.descriptionLabel.alpha = 1
                    let descriptionHeight = description.textHeight(font: UIFont.systemFont(ofSize: 14), width: screenWidth - 88)
                    self.collectionViewTopOffSet.constant = 6 + descriptionHeight + 26
                    
                } else {
                    self.descriptionLabel.alpha = 0
                    self.collectionViewTopOffSet.constant = 20
                }
                
                self.layoutIfNeeded()
                
            }) { _ in
                self.isUserInteractionEnabled = true
            }
            
            collectionView.collectionViewLayout.prepare()
            collectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + moveTimeInterval) {
                let date = self.dataSource[0]
                self.dataSource.remove(at: 0)
                self.dataSource.insert(date, at: index)
                self.collectionView.moveItem(at: IndexPath(row: 0, section: 0), to: IndexPath(row: index, section: 0))
            }
            
        } else {
            if descriptionLabel.isHidden == false, let description = descriptionLabel.text, description.isEmpty == false {
                let descriptionHeight = description.textHeight(font: UIFont.systemFont(ofSize: 14), width: screenWidth - 88)
                collectionViewTopOffSet.constant = 6 + descriptionHeight + 26
                
            } else {
                collectionViewTopOffSet.constant = 20
            }
            
            collectionView.layoutIfNeeded()
            collectionView.reloadData()
        }
    }
    
    private func outSelectMode() {
        isSelecting = false
        
        guard let index = selectedIndex else { return }
        isUserInteractionEnabled = false

        UIView.animate(withDuration: alphaTimeInterval, animations: {
            self.descriptionLabel.alpha = 0
            self.collectionViewTopOffSet.constant = 20
            self.layoutIfNeeded()
            
        }) { _ in
            self.isUserInteractionEnabled = true
        }
        
        collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + moveTimeInterval) {
            let date = self.dataSource[index]
            self.dataSource.remove(at: index)
            self.dataSource.insert(date, at: 0)
            self.collectionView.moveItem(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
            
            UIView.animate(withDuration: self.hideTimeInterval, delay: 0, options: .curveEaseOut, animations: {
                self.animationView.alpha = 0
                self.imageView.alpha = 0
            }, completion: nil)
        }
    }
    
    
    
    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXAddBookGuideItem", for: indexPath) as? YXAddBookGuideItem else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = dataSource[indexPath.row]
        
        if let index = selectedIndex {
            if isSelecting {
                if indexPath.row == 0 {
                    cell.selectIconView.isHidden = true
                    cell.titleLabel.textColor = .black
                    cell.colorView.borderColor = UIColor.hex(0xC0C0C0)
                    cell.colorView.alpha = 1
                    
                } else {
                    cell.selectIconView.isHidden = true
                    cell.titleLabel.textColor = .black
                    cell.colorView.borderColor = UIColor.hex(0xC0C0C0)
                    cell.colorView.alpha = 0
                    
                    UIView.animate(withDuration: alphaTimeInterval, animations: {
                        cell.colorView.alpha = 1
                    })
                }
                
            } else {
                if indexPath.row == index {
                    DispatchQueue.main.asyncAfter(deadline: .now() + moveTimeInterval) {
                        cell.selectIconView.isHidden = false
                        cell.titleLabel.textColor = UIColor.orange1
                        cell.colorView.borderColor = UIColor.orange1
                        cell.colorView.alpha = 1
                    }
                    
                } else {
                    cell.selectIconView.isHidden = true
                    cell.titleLabel.textColor = .black
                    cell.colorView.borderColor = UIColor.hex(0xC0C0C0)
                    cell.colorView.alpha = 1
                    
                    UIView.animate(withDuration: alphaTimeInterval, animations: {
                        cell.colorView.alpha = 0

                    }) { _ in
                        guard indexPath.row == (index == 0 ? 1 : 0) else { return }
                        UIView.animate(withDuration: self.hideTimeInterval, animations: {

                        })
                    }
                }
            }
            
        } else {
            cell.selectIconView.isHidden = true
            cell.titleLabel.textColor = .black
            cell.colorView.borderColor = UIColor.hex(0xC0C0C0)
            cell.colorView.alpha = 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelecting {
            selectedIndex = indexPath.row
            outSelectMode()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + hideTimeInterval) {
                self.selectedClosure?()
            }
            
        } else {
            enterSelectMode()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.editClosure?()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textWidth = dataSource[indexPath.row].textWidth(font: UIFont.systemFont(ofSize: 15), height: 22)
        
        if textWidth > (((screenWidth - 110) / 3) - 44) {
            return CGSize(width: textWidth + 44 , height: 30)

        } else {
            return CGSize(width: (screenWidth - 110) / 3 , height: 30)
        }
    }
}
