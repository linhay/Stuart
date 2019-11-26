//
//  SectionController.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/14.
//

import UIKit

open class SectionController: UIViewController {
    
    public let sectionView  = SectionView()
    public lazy var manager = SectionManager(sectionView: sectionView)

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if view.backgroundColor == nil {
            view.backgroundColor = .white
        }
        view.addSubview(sectionView)
        sectionView.frame = view.bounds
    }
    
    open func update(sections: [SectionProtocol]) {
        manager.update(sections: sections)
    }
    
}
