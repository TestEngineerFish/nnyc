//
//  YXMineViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXMineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "CellOne")!
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "CellTwo")!
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "CellThree")!
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "CellFour")!
        case 4:
            return tableView.dequeueReusableCell(withIdentifier: "CellFive")!
        case 5:
            return tableView.dequeueReusableCell(withIdentifier: "CellSix")!
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CellSeven")!
        }
    }
    
    
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.cellForItem(at: indexPath)!
    }
}
