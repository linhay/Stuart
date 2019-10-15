//
//  SectionType.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/14.
//

import UIKit

public protocol SectionProtocol {
    
    var index: Int { set get }

    var sectionController: SectionController { get }
    var collectionView: UICollectionView { get }

    var itemCount: Int { get }

    var headerSize: CGSize { get }
    var footerSize: CGSize { get }

    var sectionInset: UIEdgeInsets { get }

    func itemSize(at indexPath: IndexPath) -> CGSize
    func itemCell(at indexPath: IndexPath) -> UICollectionViewCell
    func didSelectItem(at indexPath: IndexPath)

    func headerView(at indexPath: IndexPath) -> UICollectionReusableView?
    func footerView(at indexPath: IndexPath) -> UICollectionReusableView?

    func refresh(complete: @escaping (Error?) -> Void)
}

extension SectionProtocol {
    var collectionView: UICollectionView {
        return sectionController.collectionView
    }

    var headerSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 28)
    }

    var footerSize: CGSize {
        return CGSize.zero
    }

    var sectionInset: UIEdgeInsets {
        if footerSize.height == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        } else {
            return UIEdgeInsets.zero
        }
    }

    func didSelectItem(at indexPath: IndexPath) {

    }

    func headerView(at indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }

    func footerView(at indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }

    func refresh(complete: @escaping (Error?) -> Void) {
        UIView.performWithoutAnimation {
            collectionView.reloadSections(IndexSet(arrayLiteral: index))
        }
    }
}
