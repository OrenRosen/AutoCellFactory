# AutoCellFactory

[![CI Status](http://img.shields.io/travis/OrenRosen/AutoCellFactory.svg?style=flat)](https://travis-ci.org/OrenRosen/AutoCellFactory)
[![Version](https://img.shields.io/cocoapods/v/AutoCellFactory.svg?style=flat)](http://cocoapods.org/pods/AutoCellFactory)
[![License](https://img.shields.io/cocoapods/l/AutoCellFactory.svg?style=flat)](http://cocoapods.org/pods/AutoCellFactory)
[![Platform](https://img.shields.io/cocoapods/p/AutoCellFactory.svg?style=flat)](http://cocoapods.org/pods/AutoCellFactory)

**`AutoCellFactory`** is based on **`Model-View-ViewModel (MVVM)`** architacture, which basically means that the cell owns a `ViewModel` (called a `presenter`), which holds the model, and when the `AutoCellFactory` sets the model, the presenter automatically calls `reloadView` and triggers the `configureView` at the Cell. A flappy diagram will look like this:

 ![](https://cloud.githubusercontent.com/assets/5252381/17618351/e7bec226-6087-11e6-9865-3229451c2867.png)

In the `configureView`, the cell configures itself by asking the presenter the fields it needs.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- swift 2.1
- iOS 8.0

## Installation

AutoCellFactory is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AutoCellFactory"
```

## How To Use

Example for presenting `UITableViewCell` with `Model` by a `Presenter`

You'll need to add the following object:
- **Model** - can be a struct or a class, of any type
- **Presenter** - inherits from `ACBasePresenter<[YOUR MODEL TYPE]>`
- **Cell** - inherits from ACBasicCell<SomeCellPresenter>
- **xib** - the nib of your custom class, set the name and the reuse identifier as your cell name 

### The Model
```swift
struct SomeModel { 
    var name: String = ""
}
```

### The Presenter

Create a presenter for the cell, subclass of `ACBasePresenter`, with a generic type as your model. In this case - `SomeModel`.

The presenter is the only one that will know about the model, and will give the cell the configuration based on this model. Its superclass will take care for automatic reloading the view when the model is set

It must include `required init()`, so `ACBasicCell`, which owns the presenter, could automatically initial it, without involving the subclass
```swift
class SomeCellPresenter: ACBasePresenter<SomeModel> {
    required init() {}
}
```

### The cell

Create a subclass of `ACBasicCell`, with a generic type as your presenter. In this case - `SomeCellPresenter`.

```swift
class SomeCell: ACBasicCell<SomeCellPresenter> {
    override func configureCell() {
        // Do some configuration for your cell
    }
}
```
The generic type will promise that the superclass will init the presenter with this type, and will trigger `configureCell` automatically when the model is set

### The nib
Be sure you create a nib file for that cell, named exactly like the cell, and set the reuse identifier in the same name

![](https://cloud.githubusercontent.com/assets/5252381/17617553/75fc819a-6083-11e6-9eba-6039f806337c.png)
 
### Factory part

Now its only left to actually show the cell using the AutoCellFactory

**Register**

create an instance of AutoCellFactory:

```swift
lazy var acFactory: AutoCellFactory = AutoCellFactory(tableView: self.tableView, delegate: self.viewModel)
```
The delegate needs to conforms to `AutoCellFactoryViewDelegate`, and to implement the method:
```swift
func modelForIndexPath(indexPath: NSIndexPath) -> Any?
```

Call register method at your `AutoCellFactory` instance:

```swift
public func registerForNib(cellsAndModels: [AutoCellFactoryRegistrationType])
```

Pass the tableView, and an array of `AutoCellFactoryRegistrationType`

```swift
public typealias AutoCellFactoryRegistrationType = (cellType: ACBasicCellPresenterHolder.Type, modelType: Any.Type)
```

This way the factory knows which model belongs to each cell, for example:
```swift
acFactory.registerForNib([(SomeCell.self, SomeModel.self)])
```

And in `cellForRow`, just return the cell from the acFactory:

```swift
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return acFactory.getCell(forIndexPath: indexPath)
}
```

That's it 💃 

## Author

Oren Rosenblum, oren@minutemedia.com

## License

AutoCellFactory is available under the MIT license. See the LICENSE file for more info.
