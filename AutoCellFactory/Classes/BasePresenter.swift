//
//  ACBasePresenter.swift
//  AotoCellCellFactory
//
//  Created by Oren Rosenblum on 8/8/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation


public class ACBasePresenter<ModelType: Any>: AutoCellPresenterer {
    
    required public init() { }
    
    public var reloadView: (() -> ())?
    
    public var acModelPlaceHolder: Any? {
        get {
            return model
        }
        set(newModel) {
            model = newModel as? ModelType
        }
    }
    
    public var model: ModelType?  {
        didSet {
            reloadView?()
        }
    }
}


public protocol AutoCellPresenterer: ACModelHolder {
    associatedtype ModelType
    var model: ModelType? { get set }
    var reloadView: (() -> ())? { get set }
    
    init()
}


