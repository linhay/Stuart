//
//  SectionView.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/17.
//

import UIKit

open class SectionView: UICollectionView {

    var manager: SectionManager?

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

    func update(sections: [SectionProtocol]) {
        manager?.update(sections: sections)
    }

    func initialize() {
        let manager = SectionManager(sectionView: self)
        self.manager = manager
        self.delegate = manager
        self.dataSource = manager
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }

}


class SectionManager: NSObject {

    private weak var sectionView: UICollectionView?
    public private(set) var sections: [SectionProtocol] = []

    init(sectionView: UICollectionView) {
        self.sectionView = sectionView
    }

}

// MARK: - public api
extension SectionManager {

    func update(sections: [SectionProtocol]) {
        self.sections = sections.enumerated().map({ (index, item) -> SectionProtocol in
            var item = item
            item.index = index
            return item
        })
        self.sectionView?.reloadData()
    }

    @objc func refresh() {
        sections.forEach { (section) in
            section.refresh()
        }
    }

}

// MARK: - SectionManager
extension SectionManager: UICollectionViewDelegate, UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].itemCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let cell = section.itemCell(at: indexPath)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view: UICollectionReusableView?
        switch kind {
        case UICollectionView.elementKindSectionHeader: view = sections[indexPath.section].headerView(at: indexPath)
        case UICollectionView.elementKindSectionFooter: view = sections[indexPath.section].footerView(at: indexPath)
        default: break
        }
        return view ?? UICollectionReusableView()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return sections[indexPath.section].didSelectItem(at: indexPath)
    }

}

extension SectionManager: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].itemSize(at: indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sections[section].headerSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return sections[section].footerSize
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].minimumInteritemSpacing
    }

}
