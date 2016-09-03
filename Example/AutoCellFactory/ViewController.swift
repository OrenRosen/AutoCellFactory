//
//  ViewController.swift
//  AotoCellCellFactory
//
//  Created by Oren Rosenblum on 8/8/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import UIKit
import AutoCellFactory

class ViewModel: AutoCellFactoryViewModelable {
    
    var numberOfRows: Int { return dataSource.count }
    
    let dataSource: [Any] = [
        SomeCellModel(title: "first some model"),
        AnotherCellModel(title: "first another model"),
        SomeCellModel(title: "second some model")
    ]
    
    func modelForIndexPath(indexPath: NSIndexPath) -> Any? {
        return dataSource[indexPath.row]
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: ViewModel = ViewModel()
    lazy var acFactory: AutoCellFactory = AutoCellFactory(tableView: self.tableView, delegate: self.viewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        acFactory.registerForNib([(SomeCell.self, SomeCellModel.self), (AnotherCell.self, AnotherCellModel.self)])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return acFactory.getCell(forIndexPath: indexPath)
    }
    
    

}

