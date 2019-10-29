//
//  YXMineViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXMineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var avatarImageView: YXDesignableImageView!
    @IBOutlet weak var nameLabel: NSLayoutConstraint!
    @IBOutlet weak var myIntegralLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var totalMedalLabel: UILabel!
    
    @IBOutlet weak var ownedMedalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break

        case 1:
            break

        case 2:
            self.performSegue(withIdentifier: "ManageMaterial", sender: self)
            break

        case 3:
            self.performSegue(withIdentifier: "SetReminder", sender: self)
            break

        case 4:
            self.performSegue(withIdentifier: "AboutUs", sender: self)
            break

        case 5:
            self.performSegue(withIdentifier: "FeedBack", sender: self)
            break
            
        default:
            break
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
