//
//  SectionView.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/17.
//

import UIKit

open class SectionView: UICollectionView {

    private var manager: SectionManager?

    public convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    public func update(sections: [SectionProtocol]) {
        manager?.update(sections: sections)
    }

    private func initialize() {
        let manager = SectionManager(sectionView: self)
        self.manager = manager
        self.delegate = manager
        self.dataSource = manager
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }

}
