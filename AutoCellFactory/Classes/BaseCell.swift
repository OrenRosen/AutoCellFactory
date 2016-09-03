//
//  BaseCell.swift
//  AotoCellCellFactory
//
//  Created by Oren Rosenblum on 8/8/16.
//  Copyright © 2016 Oren Rosenblum. All rights reserved.
//

import Foundation
import UIKit

public class ACBasicCellPresenterHolder: UITableViewCell, ACPresenterHolder, ACReusableView {
    var acPresenterPlaceHolder: ACModelHolder? {
        get { return nil }
        set(newPresenter) { }
    }
    
    public func getPresenter() -> ACModelHolder? {
        return acPresenterPlaceHolder
    }
}

public class ACBasicCell<PresenterType: AnyObject where PresenterType: AWCellPresenterer> : ACBasicCellPresenterHolder {
    
    public var presenter: PresenterType!
    override var acPresenterPlaceHolder: ACModelHolder? {
        get {
            return presenter
        }
        set(newPresenter) {
            presenter = newPresenter as? PresenterType
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public func configureCell() { }
    
    private func setup() {
        presenter = PresenterType()
        presenter.reloadView = { [weak self] in
            self?.configureCell()
        }
    }
}


public protocol ACModelHolder {
    var acModelPlaceHolder: Any? { get set }
}

protocol ACPresenterHolder: class {
    var acPresenterPlaceHolder: ACModelHolder? { get set }
}

extension ACPresenterHolder {
    var acPresenterPlaceHolder: ACModelHolder? {
        get { return nil }
        set(newPresenter) { }
    }
}
