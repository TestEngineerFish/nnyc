//
//  YXTableViewCell.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/18.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXTableViewCell<T>: UITableViewCell {
    
    var model: T?
    
    func createSubviews() {}
    
    func bindProperty() {}
        
    func bindData() {}
    
    class func viewHeight(model: T) -> CGFloat {
        return 0
    }
}
