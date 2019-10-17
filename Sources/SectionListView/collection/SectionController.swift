//
//  SectionController.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/14.
//

import UIKit

open class SectionController: UIViewController {
    
    let sectionView = SectionView()
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .white
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        view.addSubview(sectionView)
        sectionView.frame = view.bounds
        sectionView.backgroundColor = view.backgroundColor
    }
    
    open func update(sections: [SectionProtocol]) {
        sectionView.update(sections: sections)
    }
    
}
