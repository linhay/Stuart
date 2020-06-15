//
//  SectionCollectionManager.swift
//  iDxyer
//
//  Created by 林翰 on 2020/6/12.
//

import UIKit

public class SectionCollectionManager: SectionScrollManager {

    private let sectionManager: SectionManager<UICollectionView>
    var sectionView: UICollectionView { sectionManager.sectionView }
    public var sections: [SectionCollectionProtocol] { sectionManager.sections as! [SectionCollectionProtocol] }

    public init(sectionView: UICollectionView) {
        sectionManager = .init(sectionView: sectionView)
        super.init()
        sectionView.delegate = self
        sectionView.dataSource = self
    }

}

public extension SectionCollectionManager {

    func operational(_ refresh: SectionManager<UICollectionView>.Refresh) {
        switch refresh {
        case .none:
            break
        case .reload:
            sectionView.reloadData()
        case .insert(let indexSet):
            sectionView.insertSections(indexSet)
        case .delete(let indexSet):
            sectionView.deleteSections(indexSet)
        case .move(from: let from, to: let to):
            sectionView.moveSection(from, toSection: to)
        }
    }

    func reload() {
        operational(sectionManager.reload())
    }

    func update(_ sections: SectionCollectionProtocol...) {
        update(sections)
    }

    func update(_ sections: [SectionCollectionProtocol]) {
        operational(sectionManager.update(sections))
        sections.forEach({ $0.config(sectionView: sectionView) })
    }

    func insert(section: SectionCollectionProtocol, at index: Int) {
        operational(sectionManager.insert(section: section, at: index))
        section.config(sectionView: sectionView)
    }

    func delete(at index: Int) {
        operational(sectionManager.delete(at: index))
    }

    func move(from: Int, to: Int) {
        operational(sectionManager.move(from: from, to: to))
    }

}

// MARK: - UICollectionViewDelegate && UICollectionViewDataSource
extension SectionCollectionManager: UICollectionViewDelegate, UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].itemCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].item(at: indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view: UICollectionReusableView?
        switch kind {
        case UICollectionView.elementKindSectionHeader: view = sections[indexPath.section].headerView
        case UICollectionView.elementKindSectionFooter: view = sections[indexPath.section].footerView
        default: break
        }
        return view ?? UICollectionReusableView()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return sections[indexPath.section].didSelectItem(at: indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            sections[sourceIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
        } else {
            sections[sourceIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
            sections[destinationIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].canMove(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SectionCollectionManager: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].itemSize(at: indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sections[section].itemCount == 0 ? .zero : sections[section].headerSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return sections[section].itemCount == 0 ? .zero : sections[section].footerSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].itemCount == 0 ? .zero : sections[section].minimumLineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].itemCount == 0 ? .zero : sections[section].minimumInteritemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].itemCount == 0 ? .zero : sections[section].sectionInset
    }
}
