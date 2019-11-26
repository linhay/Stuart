//
//  SectionType.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/14.
//

import UIKit

public protocol SectionProtocol {
    
    var index: Int { get set }

    var collectionView: UICollectionView { get }

    var itemCount: Int { get }

    var headerSize: CGSize { get }
    var footerSize: CGSize { get }

    var minimumLineSpacing: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }

    var sectionInset: UIEdgeInsets { get }

    func itemSize(at index: Int) -> CGSize
    func itemCell(at indexPath: IndexPath) -> UICollectionViewCell
    func didSelectItem(at indexPath: IndexPath)

    func headerView(at indexPath: IndexPath) -> UICollectionReusableView?
    func footerView(at indexPath: IndexPath) -> UICollectionReusableView?

    func refresh()
}

public extension SectionProtocol {

    var itemCount: Int { return 0 }

    var headerSize: CGSize { return .zero }
    var footerSize: CGSize { return .zero }

    var minimumLineSpacing: CGFloat { return 0 }
    var minimumInteritemSpacing: CGFloat { return 0 }

    var sectionInset: UIEdgeInsets { return .zero }

    func itemSize(at index: Int) -> CGSize { return .zero }
    func didSelectItem(at indexPath: IndexPath) { }

    func headerView(at indexPath: IndexPath) -> UICollectionReusableView? { return nil }
    func footerView(at indexPath: IndexPath) -> UICollectionReusableView? { return nil }

    func refresh() {
        UIView.performWithoutAnimation {
            collectionView.reloadSections(IndexSet(arrayLiteral: index))
        }
    }

    func refresh(item at: Int) {
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [IndexPath.init(row: at, section: index)])
        }
    }
}
