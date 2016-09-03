//
//  AutoCellFactory.swift
//  AotoCellCellFactory
//
//  Created by Oren Rosenblum on 8/8/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation
import UIKit


public protocol AutoCellFactoryViewModelable {
    func modelForIndexPath(indexPath: NSIndexPath) -> Any?
}

public class AutoCellFactory {
    
    var delegate: AutoCellFactoryViewModelable
    public typealias AutoCellFactoryRegistrationType = (cellType: ACBasicCellPresenterHolder.Type, modelType: Any.Type)
    
    weak var tableView: UITableView!
    private var cellTypes: [ACBasicCellPresenterHolder.Type] = []
    private var reuseIdentifierToFactories: [String : TVCMiniFactory] = [:]
    private var modelNameToCellType: [String : ACBasicCellPresenterHolder.Type] = [:]

    public init(tableView: UITableView, delegate: AutoCellFactoryViewModelable) {
        self.tableView = tableView
        self.delegate = delegate
    }
    
    public func registerForNib(cellsAndModels: [AutoCellFactoryRegistrationType]) {
        cellsAndModels.forEach { (regitrationTuple) in
            cellTypes.append(regitrationTuple.cellType)
            let reuseIdentifier = regitrationTuple.cellType.defaultReuseIdentifier
            self.tableView.registerNib(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            modelNameToCellType[stringFromModel(regitrationTuple.modelType)] = regitrationTuple.cellType
        }
        initMiniFactories()
    }
    
    public func registerForClass(cellsAndModels: [AutoCellFactoryRegistrationType]) {
        cellsAndModels.forEach { (regitrationTuple) in
            cellTypes.append(regitrationTuple.cellType)
            self.tableView.registerClass(regitrationTuple.cellType, forCellReuseIdentifier: regitrationTuple.cellType.defaultReuseIdentifier)
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
        cellTypes.forEach(initMiniFactoryWithCellType)
    }
    
    private func initMiniFactoryWithCellType(cellType: ACBasicCellPresenterHolder.Type) {
        self.reuseIdentifierToFactories[cellType.defaultReuseIdentifier] = TVCMiniFactory(reuseIdentifier: cellType.defaultReuseIdentifier, viewModelable: self.delegate)
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
    
    var viewModelable: AutoCellFactoryViewModelable

    var reuseIdentifier: String
    
    init(reuseIdentifier: String, viewModelable: AutoCellFactoryViewModelable) {
        self.reuseIdentifier = reuseIdentifier
        self.viewModelable = viewModelable
    }
    
    func getCell(withTableView tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        setWidth(cell, tableView.frame.width)
        cell.layoutIfNeeded()
        (cell as? ACBasicCellPresenterHolder)?.acPresenterPlaceHolder?.acModelPlaceHolder = viewModelable.modelForIndexPath(indexPath)
        return cell
    }
    
    func setWidth(cell: UITableViewCell, _ width: CGFloat) {
        var frame = cell.frame
        frame.size.width = width
        cell.frame = frame
    }
}







