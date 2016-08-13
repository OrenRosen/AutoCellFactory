//
//  AWCellPresentable.swift
//  AWCellFactory
//
//  Created by Oren Rosenblum on 8/8/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation
import UIKit

public class AWBasicCellPresenterHolder: UITableViewCell, AWPresenterHolder {
    var somePresenter: AWModelHolder? {
        get { return nil }
        set(newPresenter) { }
    }
}

public class AWBasicCell<PresenterType: AnyObject where PresenterType: AWCellPresenterer> : AWBasicCellPresenterHolder, AWCellPresentable {
    
    var presenter: PresenterType!
    override var somePresenter: AWModelHolder? {
        get {
            return presenter
        }
        set(newPresenter) {
            presenter = newPresenter as? PresenterType
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        presenter = PresenterType()
        presenter.reloadView = { [weak self] in
            self?.configureCell()
        }
    }
}


public protocol AWModelHolder {
    var someModel: Any? { get set }
}

protocol AWPresenterHolder: class {
    var somePresenter: AWModelHolder? { get set }
}

extension AWPresenterHolder {
    var somePresenter: AWModelHolder? {
        get { return nil }
        set(newPresenter) { }
    }
}


protocol AWCellPresentable {
    associatedtype presenterType: AWCellPresenterer
    func configureCell()
    var presenter: presenterType! { get set }
}

extension AWCellPresentable {
    func configureCell() {
        
    }
}
