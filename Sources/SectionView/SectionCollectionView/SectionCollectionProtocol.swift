//
//  SectionCollectionProtocol.swift
//  iDxyer
//
//  Created by 林翰 on 2020/6/12.
//

import UIKit

public protocol SectionCollectionProtocol: SectionProtocol {
    var minimumLineSpacing: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }
    var sectionInset: UIEdgeInsets { get  }
    var sectionView: UICollectionView? { get }
    var headerView: UICollectionReusableView? { get }
    var footerView: UICollectionReusableView? { get }
    var headerSize: CGSize { get }
    var footerSize: CGSize { get }
    func config(sectionView: UICollectionView)
    func itemSize(at row: Int) -> CGSize
    func item(at row: Int) -> UICollectionViewCell
}

public extension SectionCollectionProtocol {

    var headerView: UICollectionReusableView? { nil }
    var footerView: UICollectionReusableView? { nil }
    var headerSize: CGSize { .zero }
    var footerSize: CGSize { .zero }
    var sectionView: UICollectionView? { return core?.sectionView as? UICollectionView }
    var collectionView: UICollectionView { core?.sectionView as! UICollectionView }

}

public extension SectionCollectionProtocol {
    var minimumLineSpacing: CGFloat { 0 }
    var minimumInteritemSpacing: CGFloat { 0 }
    var sectionInset: UIEdgeInsets { .zero }
}

public extension SectionCollectionProtocol {

    func dequeue<T: UICollectionViewCell>(at row: Int, identifier: String = String(describing: T.self)) -> T {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath(from: row)) as! T
    }

    func dequeue<T: UICollectionReusableView>(kind: SectionCollectionViewKind, identifier: String = String(describing: T.self)) -> T {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: identifier, for: IndexPath(row: 0, section: index)) as! T
    }

}

public extension SectionCollectionProtocol {

    func deselect(at row: Int, animated: Bool) {
        sectionView?.deselectItem(at: indexPath(from: row), animated: animated)
    }

    func cell(at row: Int) -> UICollectionViewCell? {
        return sectionView?.cellForItem(at: indexPath(from: row))
    }

    func row(for cell: UICollectionViewCell) -> Int? {
        guard let indexPath = sectionView?.indexPath(for: cell), indexPath.section == core?.index else {
            return nil
        }
        return indexPath.row
    }

    func pick(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        sectionView?.performBatchUpdates(updates, completion: completion)
    }

}

public extension SectionCollectionProtocol {

    func reload() {
        sectionView?.reloadData()
    }

    func reload(at row: Int) {
        reload(at: [row])
    }

    func reload(at rows: [Int]) {
        sectionView?.reloadData()
    }

}

public extension SectionCollectionProtocol {

    func insert(at row: Int, willUpdate: (() -> Void)? = nil) {
        insert(at: [row])
    }

    func insert(at rows: [Int], willUpdate: (() -> Void)? = nil) {
        guard rows.isEmpty == false else {
            return
        }
        willUpdate?()
        if let max = rows.max(), (sectionView?.numberOfItems(inSection: index) ?? 0) <= max {
            sectionView?.reloadData()
        } else {
            sectionView?.insertItems(at: indexPaths(from: rows))
        }
    }

}

public extension SectionCollectionProtocol {

    func delete(at row: Int, willUpdate: (() -> Void)? = nil) {
        delete(at: [row], willUpdate: willUpdate)
    }

    func delete(at rows: [Int], willUpdate: (() -> Void)? = nil) {
        guard rows.isEmpty == false else {
            return
        }
        willUpdate?()
        if itemCount <= 0 {
            sectionView?.reloadData()
        } else {
            sectionView?.deleteItems(at: indexPaths(from: rows))
        }
    }

}

public extension SectionCollectionProtocol {

    func scroll(to row: Int, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        sectionView?.scrollToItem(at: indexPath(from: row), at: scrollPosition, animated: animated)
    }

    func select(at row: Int?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        sectionView?.selectItem(at: indexPath(from: row), animated: animated, scrollPosition: scrollPosition)
    }

}
