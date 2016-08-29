import UIKit
import XCTest
import AutoCellFactory
@testable import AutoCellFactory_Example

var expectedSomeCellIndexes = [2]
var expectedAnotherCellIndexes = [0,1]
var dataSource: [Any] = [
    AnotherModel(anotherName: "someAnotherModel"),
    AnotherModel(anotherName: "anotherAnotherModel"),
    SomeModel(someName: "someSomeModel")
]

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
    init(someName: String) { self.someName = someName }
}

struct AnotherModel {
    var anotherName: String!
    init(anotherName: String) { self.anotherName = anotherName }
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
        let reuseIdentifier = dataSource[indexPath.row] is SomeModel ? "SomeTestCell" : "AnotherTestCell"
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
    
    func testSomeCellsDequed() {
        expectedSomeCellIndexes.forEach(testSomeCellsDequedAtIndex)
    }
    
    func testAnotherCellsDequed() {
        expectedAnotherCellIndexes.forEach(testAnotherCellsDequedAtIndex)
    }
    
    func testConfigureCellIsCalledFromNib() {
        expectedSomeCellIndexes.forEach(testConfigureCellIsCalledFromNibAtIndex)
    }

    func testInstantiateFromNib() {
        expectedSomeCellIndexes.forEach(testInstantiateFromNibAtIndex)
    }
    
    func testConfigureCellCalledWhenInstantiated() {
        expectedAnotherCellIndexes.forEach(testConfigureCellCalledWhenInstantiatedAtIndex)
    }
    
    func testSomeCellsPresenter() {
        expectedSomeCellIndexes.forEach(testSomeCellsPresenterAtIndex)
    }
    
    func testAnotherCellsPresenters() {
        expectedAnotherCellIndexes.forEach(testAnotherCellsPresentersAtIndex)
    }
    
    func testSomeCellsDequedAtIndex(index: Int) {
        tableView.wasSomeTestCalled = false
        tableView.wasAnotherTestCalled = false
        tvFactory.getCell(forIndexPath: NSIndexPath(forRow: index, inSection: 0))
        XCTAssertTrue(tableView.wasSomeTestCalled)
        XCTAssertFalse(tableView.wasAnotherTestCalled)
    }
    
    func testAnotherCellsDequedAtIndex(index: Int) {
        tableView.wasSomeTestCalled = false
        tableView.wasAnotherTestCalled = false
        tvFactory.getCell(forIndexPath: NSIndexPath(forRow: index, inSection: 0))
        XCTAssertTrue(tableView.wasAnotherTestCalled)
        XCTAssertFalse(tableView.wasSomeTestCalled)
    }
    
    func testConfigureCellIsCalledFromNibAtIndex(index: Int) {
        let cell = someTestCellAtIndex(index)
        XCTAssertTrue(cell.wasCalled)
    }
    
    func testInstantiateFromNibAtIndex(index: Int) {
        let cell = someTestCellAtIndex(index)
        XCTAssertNotNil(cell.label)
    }
    
    func testConfigureCellCalledWhenInstantiatedAtIndex(index: Int) {
        let cell = anotherTestCellAtIndex(index)
        XCTAssertTrue(cell.wasCalled)
    }
    
    func testAnotherCellsPresentersAtIndex(index: Int) {
        let cell = anotherTestCellAtIndex(index)
        let model = dataSource[index] as! AnotherModel
        XCTAssertEqual(cell.presenter.model!.anotherName, model.anotherName)
    }
    
    func testSomeCellsPresenterAtIndex(index: Int) {
        let cell = someTestCellAtIndex(index)
        let model = dataSource[index] as! SomeModel
        XCTAssertEqual(cell.presenter.model!.someName, model.someName)
    }

    func someTestCellAtIndex(index: Int) -> SomeTestCell {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        return tvFactory.getCell(forIndexPath: indexPath) as! SomeTestCell
    }
    
    func anotherTestCellAtIndex(index: Int) -> AnotherTestCell {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        return tvFactory.getCell(forIndexPath: indexPath) as! AnotherTestCell
    }

}









