import UIKit
import XCTest
import AutoCellFactory
@testable import AutoCellFactory_Example

var someCellIndex = 0
var anotherCellIndex = 1

var someCellIndexPath = NSIndexPath(forRow: someCellIndex, inSection: 0)
var anotherCellIndexPath = NSIndexPath(forRow: anotherCellIndex, inSection: 0)

class FakeTableView: UITableView {
    
    var wasSomeTestCalled = false
    var wasAnotherTestCalled = false
    
    override func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        wasSomeTestCalled = identifier == "SomeTestCell"
        wasAnotherTestCalled = identifier == "AnotherTestCell"
        return super.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}

struct SomeModel {
    
}

struct AnotherModel {
    
}

class SomeTestCellViewModel: AWBasePresenter<SomeModel> {
    required init() {}
}

class AnotherTestCellViewModel: AWBasePresenter<AnotherModel> {
    required init() {}
}

class SomeTestCell: AWBasicCell<SomeTestCellViewModel> {
    
    var wasCalled = false
    
    override func configureCell() {
        wasCalled = true
    }
}

class AnotherTestCell: AWBasicCell<AnotherTestCellViewModel> {
    
    var wasCalled = false
    
    override func configureCell() {
        wasCalled = true
    }
}

class ViewModel: NSObject, TVCFactoryViewModelable, UITableViewDelegate, UITableViewDataSource {
    func modelForIndexPath(indexPath: NSIndexPath) -> Any? {
        return indexPath.row == someCellIndex ? SomeModel() : AnotherModel()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = indexPath.row == someCellIndex ? "SomeTestCell" : "AnotherTestCell"
        return tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
}

class Tests: XCTestCase {
    
    var tvFactory: TVCFactory!
    var viewModel = ViewModel()
    var tableView = FakeTableView()
    
    override func setUp() {
        super.setUp()
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tvFactory = TVCFactory(delegate: viewModel)
        tvFactory.register(tableView: tableView, cellsAndModels: [
            (SomeTestCell.self, SomeModel.self),
            (AnotherTestCell.self, AnotherModel.self)
            ])
    }
    
    override func tearDown() {
        super.tearDown()
        tableView.wasSomeTestCalled = false
        tableView.wasAnotherTestCalled = false
    }
    
    func testSomeCellCalled() {
        XCTAssertFalse(tableView.wasSomeTestCalled)
        tvFactory.getCell(forIndexPath: someCellIndexPath)
        XCTAssertTrue(tableView.wasSomeTestCalled)
    }
    
    func testAnotherCellCalled() {
        XCTAssertFalse(tableView.wasAnotherTestCalled)
        tvFactory.getCell(forIndexPath: anotherCellIndexPath)
        XCTAssertTrue(tableView.wasAnotherTestCalled)
    }
    
    func testConfigureCellIsCalledFromNib() {
        let cell = tvFactory.getCell(forIndexPath: someCellIndexPath) as! SomeTestCell
        XCTAssertTrue(cell.wasCalled)
    }
    
    func testConfigureCellCalledWhenInstantiated() {
        let cell = tvFactory.getCell(forIndexPath: anotherCellIndexPath) as! AnotherTestCell
        XCTAssertTrue(cell.wasCalled)
    }
}









