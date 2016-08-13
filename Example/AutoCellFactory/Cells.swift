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
    
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configureCell() {
        
        label.text = presenter.title
    }
}

class AnotherCell: AWBasicCell<AnotherCellPresenter> {
    @IBOutlet weak var label: UILabel!
    
    override func configureCell() {
        label.text = presenter.title
    }
}
