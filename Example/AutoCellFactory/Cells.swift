//
//  Cells.swift
//  AWCellFactory
//
//  Created by Oren Rosenblum on 8/11/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation
import UIKit
import AutoCellFactory

class SomeCell: AWBasicCell<SomeCellPresenter> {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        // Do some configureation for your cell
    }
}

class AnotherCell: AWBasicCell<AnotherCellPresenter> {
    func configureCell() {
        
    }
}
