//
//  SectionController.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/14.
//

import UIKit

open class SectionController: UICollectionViewController {
    
    var sectionList: [SectionProtocol] = []
    
    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override init(collectionViewLayout: UICollectionViewLayout) {
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView.backgroundColor = .white
    }
    
    func indexPath(for cell: UICollectionViewCell) -> IndexPath? {
        return collectionView.indexPath(for: cell)
    }

    open func update(sections: [SectionProtocol]) {
        self.sectionList = sections.enumerated().map({ (index, item) -> SectionProtocol in
            var item = item
            item.index = index
            return item
        })

        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionList.count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionList[section].itemCount
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sectionList[indexPath.section]
        let cell = section.itemCell(at: indexPath)
        (cell as? SectionCell)?.indexPath = indexPath
        return cell
    }
    
    override public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view: UICollectionReusableView?
        switch kind {
        case UICollectionView.elementKindSectionHeader: view = sectionList[indexPath.section].headerView(at: indexPath)
        case UICollectionView.elementKindSectionFooter: view = sectionList[indexPath.section].footerView(at: indexPath)
        default: break
        }
        return view ?? UICollectionReusableView()
    }
    
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return sectionList[indexPath.section].didSelectItem(at: indexPath)
    }
    
    @objc func refresh() {
        UIView.performWithoutAnimation {
            self.collectionView.reloadData()
        }
    }
    
}

extension SectionController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sectionList[indexPath.section].itemSize(at: indexPath.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sectionList[section].headerSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return sectionList[section].footerSize
    }
    
}
