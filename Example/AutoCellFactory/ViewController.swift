//
//  ViewController.swift
//  AWCellFactory
//
//  Created by Oren Rosenblum on 8/8/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import UIKit
import AutoCellFactory

class ViewModel: TVCFactoryViewModelable {
    
    func modelForIndexPath(indexPath: NSIndexPath) -> Any? {
        return indexPath.row == 1 ? SomeCellModel() : AnotherCellModel()
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: ViewModel = ViewModel()
    lazy var tvcFactory: TVCFactory = TVCFactory(delegate: self.viewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tvcFactory.register(tableView: tableView, cellsAndModels: [(SomeCell.self, SomeCellModel.self), (AnotherCell.self, AnotherCellModel.self)])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tvcFactory.getCell(forIndexPath: indexPath)
    }
    
    

}

