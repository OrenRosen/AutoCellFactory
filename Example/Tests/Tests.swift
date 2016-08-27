import UIKit
import XCTest
import AutoCellFactory
@testable import AutoCellFactory_Example

var cells: [UITableViewCell.Type] = [SomeTestCell.self, SomeTestCell.self, AnotherTestCell.self]

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
    var someName = ""
}

struct AnotherModel {
    var anotherName = ""
}

class SomeTestCellViewModel: AWBasePresenter<SomeModel> {
    required init() {}
    var someTitle: String { return model?.someName ?? "" }
}

class AnotherTestCellViewModel: AWBasePresenter<AnotherModel> {
    required init() {}
    var anotherTitle: String { return model?.anotherName ?? "" }
}

class SomeTestCell: AWBasicCell<SomeTestCellViewModel> {
    
    @IBOutlet weak var label: UILabel!
    
    var wasCalled = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
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
    
    var dataSource: [Any] = []
    
    override init() {
        super.init()
        cells.forEach { (klass) in
            (klass == SomeTestCell.self) ? dataSource.append(SomeModel()) : dataSource.append(AnotherModel())
        }
    }
    
    func modelForIndexPath(indexPath: NSIndexPath) -> Any? {
        return dataSource[indexPath.row]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = cells[indexPath.row] == SomeTestCell.self ? "SomeTestCell" : "AnotherTestCell"
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
            ])
        tvFactory.registerWithClass(tableView: tableView, cellsAndModels: [(AnotherTestCell.self, AnotherModel.self)])
    }
    
    override func tearDown() {
        super.tearDown()
        tableView.wasSomeTestCalled = false
        tableView.wasAnotherTestCalled = false
    }
    
    func testCalledDeque() {
        for (index, klass) in cells.enumerate() {
            cellCalledTestForClass(klass, index: NSIndexPath(forRow: index, inSection: 0))
        }
    }
    
    func cellCalledTestForClass(klass: UITableViewCell.Type, index: NSIndexPath) {
        tableView.wasSomeTestCalled = false
        tableView.wasAnotherTestCalled = false
        tvFactory.getCell(forIndexPath: index)
        let needTrue = klass == SomeTestCell.self ? tableView.wasSomeTestCalled : tableView.wasAnotherTestCalled
        let needFalse = klass == SomeTestCell.self ? tableView.wasAnotherTestCalled : tableView.wasSomeTestCalled
        XCTAssertTrue(needTrue)
        XCTAssertFalse(needFalse)
    }
    
    func testConfigureCellIsCalledFromNib() {
        for (index, klass) in cells.enumerate() where klass == SomeTestCell.self {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = tvFactory.getCell(forIndexPath: indexPath) as! SomeTestCell
            XCTAssertTrue(cell.wasCalled)
        }
    }
    
    func testInstantiateFromNib() {
        for (index, klass) in cells.enumerate() where klass == SomeTestCell.self {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = tvFactory.getCell(forIndexPath: indexPath) as! SomeTestCell
            XCTAssertNotNil(cell.label)
        }
    }
    
    func testConfigureCellCalledWhenInstantiated() {
        for (index, klass) in cells.enumerate() where klass == AnotherTestCell.self {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = tvFactory.getCell(forIndexPath: indexPath) as! AnotherTestCell
            XCTAssertTrue(cell.wasCalled)
        }
    }
}









