//
//  Cells.swift
//  AutoCellFactory
//
//  Created by Oren Rosenblum on 8/11/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation
import UIKit
import AutoCellFactory

class SomeCell: ACBasicCell<SomeCellPresenter> {
    
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureCell() {
        
        label.text = presenter.title
    }
}

class AnotherCell: ACBasicCell<AnotherCellPresenter> {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    
    override func configureCell() {
        label.text = presenter.title
    }
}
