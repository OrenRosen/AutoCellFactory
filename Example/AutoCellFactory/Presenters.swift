//
//  Presenters.swift
//  AWCellFactory
//
//  Created by Oren Rosenblum on 8/11/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation
import AutoCellFactory

class SomeCellPresenter: AWBasePresenter<SomeCellModel> {
    
    var title: String { return model?.someName ?? "" }
    required init() {}
}

class AnotherCellPresenter: AWBasePresenter<AnotherCellModel> {
    
    var title: String { return model?.anotherName ?? "" }
    required init() {}
}