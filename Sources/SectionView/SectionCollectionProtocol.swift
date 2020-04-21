/// MIT License
///
/// Copyright (c) 2020 linhey
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

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
    func itemSize(at index: Int) -> CGSize
    func item(at index: Int) -> UICollectionViewCell
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

    func deselect(at index: Int, animated: Bool) {
        sectionView?.deselectItem(at: indexPath(from: index), animated: animated)
    }

    func cell(at index: Int) -> UICollectionViewCell? {
        return sectionView?.cellForItem(at: indexPath(from: index))
    }

    func pick(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        sectionView?.performBatchUpdates(updates, completion: completion)
    }

}

public extension SectionCollectionProtocol {

    func reload(at index: Int) {
        reload(at: [index])
    }

    func reload(at indexs: [Int]) {
        sectionView?.reloadItems(at: indexPaths(from: indexs))
    }

}

public extension SectionCollectionProtocol {

    func insert(at index: Int, willUpdate: (() -> Void)? = nil) {
        insert(at: [index])
    }

    func insert(at indexs: [Int], willUpdate: (() -> Void)? = nil) {
        guard indexs.isEmpty == false else {
            return
        }
        willUpdate?()
        if let max = indexs.max(), itemCount <= max {
            sectionView?.reloadData()
        } else {
            sectionView?.insertItems(at: indexPaths(from: indexs))
        }
    }

}

public extension SectionCollectionProtocol {

    func delete(at index: Int, willUpdate: (() -> Void)? = nil) {
        delete(at: [index], willUpdate: willUpdate)
    }

    func delete(at indexs: [Int], willUpdate: (() -> Void)? = nil) {
        guard indexs.isEmpty == false else {
            return
        }
        willUpdate?()
        if itemCount <= 0 {
            sectionView?.reloadData()
        } else {
            sectionView?.deleteItems(at: indexPaths(from: indexs))
        }
    }

}

public extension SectionCollectionProtocol {

    func scroll(to index: Int, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        sectionView?.scrollToItem(at: indexPath(from: index), at: scrollPosition, animated: animated)
    }

    func select(at index: Int?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        sectionView?.selectItem(at: indexPath(from: index), animated: animated, scrollPosition: scrollPosition)
    }

}
