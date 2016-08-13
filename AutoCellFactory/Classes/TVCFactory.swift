//
//  TVCFactory.swift
//  AWCellFactory
//
//  Created by Oren Rosenblum on 8/8/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation
import UIKit

public protocol TVCFactoryViewModelable {
    func modelForIndexPath(indexPath: NSIndexPath) -> Any?
}

protocol TVCFactoryCellDelegate {
    func getSupportingCells() -> [AWBasicCellPresenterHolder.Type]
}

public class TVCFactory {
    
    var delegate: TVCFactoryViewModelable
    public typealias TVCFactoryRegistrationType = (cellType: AWBasicCellPresenterHolder.Type, modelType: Any.Type)
    
    weak var tableView: UITableView?
    private var cellTypes: [AWBasicCellPresenterHolder.Type] = []
    private var reuseIdentifierToFactories: [String : TVCMiniFactory] = [:]
    private var modelNameToCellType: [String : AWBasicCellPresenterHolder.Type] = [:]

    public init(delegate: TVCFactoryViewModelable) {
        self.delegate = delegate
    }
    
    public func register(tableView tableView: UITableView, cellsAndModels: [TVCFactoryRegistrationType]) {
        self.tableView = tableView
        cellsAndModels.forEach { (regitrationTuple) in
            cellTypes.append(regitrationTuple.cellType)
            let reuseIdentifier = regitrationTuple.cellType.defaultReuseIdentifier
            tableView.registerNib(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            modelNameToCellType[stringFromModel(regitrationTuple.modelType)] = regitrationTuple.cellType
        }
        initMiniFactories()
    }
    
    public func getCell(forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let factory = getMiniFactoryForIndexPath(indexPath)
        return factory.getCell(withTableView: tableView!, forIndexPath: indexPath)
    }
    
    
    // Private 
    
    private func initMiniFactories() {
        cellTypes.forEach { (cellType) in
            self.reuseIdentifierToFactories[cellType.defaultReuseIdentifier] = TVCMiniFactory(reuseIdentifier: cellType.defaultReuseIdentifier, viewModelable: self.delegate)
        }
    }
    
    private func getMiniFactoryForIndexPath(indexPath: NSIndexPath) -> TVCMiniFactory {
        guard let model = delegate.modelForIndexPath(indexPath) else {
            fatalError("Didn't get model for indexPath: \(indexPath)")
        }
        let modelName = stringFromModel(model.dynamicType)
        guard let reuseIdentifier = modelNameToCellType[modelName]?.defaultReuseIdentifier else {
            fatalError("Did not regitered for model: \(modelName)")
        }
        return reuseIdentifierToFactories[reuseIdentifier]!
    }
    
    private func stringFromModel(modelType: Any.Type) -> String {
        return String(reflecting: modelType)
    }
}


private class TVCMiniFactory {
    
    var viewModelable: TVCFactoryViewModelable

    var reuseIdentifier: String
    
    init(reuseIdentifier: String, viewModelable: TVCFactoryViewModelable) {
        self.reuseIdentifier = reuseIdentifier
        self.viewModelable = viewModelable
    }
    
    func getCell(withTableView tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        setWidth(cell, tableView.frame.width)
        cell.layoutIfNeeded()
        (cell as? AWBasicCellPresenterHolder)?.somePresenter?.someModel = viewModelable.modelForIndexPath(indexPath)
        return cell
    }
    
    func setWidth(cell: UITableViewCell, _ width: CGFloat) {
        var frame = cell.frame
        frame.size.width = width
        cell.frame = frame
    }
}







