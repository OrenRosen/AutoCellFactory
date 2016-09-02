//
//  Presenters.swift
//  AotoCellCellFactory
//
//  Created by Oren Rosenblum on 8/11/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation
import AutoCellFactory

class SomeCellPresenter: ACBasePresenter<SomeCellModel> {
    
    var title: String { return model?.someName ?? "" }
    required init() {}
}

class AnotherCellPresenter: ACBasePresenter<AnotherCellModel> {
    
    var title: String { return model?.anotherName ?? "" }
    required init() {}
}