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

public protocol STListSectionProtocol: class {
    
    /**
     Section 所在的位置, 会由 SectionManager 重新分配, 可随意填值
     */
    var index: Int { get set }
    
    /**
     设置 Section 所在的 UICollectionView
     - Default:  0
     */
    var collectionView: UITableView? { get set }
    
    /**
     设置 Section 的 Cell s数量
     */
    var itemCount: Int { get }
    
    /**
     设置 Section 的最小行边距
     - Default:  0
     */
    var minimumLineSpacing: CGFloat { get }
    
    /**
     设置 Section 的最小列边距
     - Default:  0
     */
    var minimumInteritemSpacing: CGFloat { get }
    
    /**
     设置 Section 的边距
     - Default:  UIEdgeInsets.zero
     */
    var sectionInset: UIEdgeInsets { get }
    
    /**
     设置 Section 中 Cell 的大小
     - Parameter index: indexPath
     */
    func itemSize(at index: Int) -> CGSize
    
    /**
     设置 Section 中 headerView 的大小
     - Parameter index: indexPath
     - Default:  CGSize.zero
     */
    var headerSize: CGSize { get }
    
    /**
     设置 Section 中 footerView 的大小
     - Parameter index: indexPath
     - Default:  CGSize.zero
     */
    var footerSize: CGSize { get }
    
    /**
     设置 Section 的 Cell
     - Parameter index: indexPath
     */
    func itemCell(at indexPath: IndexPath) -> UITableViewCell
    
    /**
     设置 Section 的 headerView
     - Parameter index: indexPath
     - Default:  nil
     */
    var headerView: UITableViewHeaderFooterView? { get }
    
    /**
     设置 Section 的 footerView
     - Parameter index: indexPath
     - Default:  nil
     */
    var footerView: UITableViewHeaderFooterView? { get }
    
    /**
     响应 Section 的 Cell 点击事件
     - Parameter index: indexPath
     */
    func didSelectItem(at indexPath: IndexPath)
    
    /**
     刷新 Section
     - Important: 默认采用 `reloadSections` 的方式刷新
     */
    func refresh()
    
    /**
     刷新 Section 中指定 Cell
     - Parameter at: 指定 Cell 位置
     - Important: 默认采用 `reloadItems` 的方式刷新
     */
    func refresh(at index: Int)
    
    /**
     刷新 Section 中指定 Cell
     - Parameter at: 指定 Cell 位置
     - Important: 默认采用 `reloadItems` 的方式刷新
     */
    func refresh(at indexs: [Int])
    
    func config(collectionView: UITableView)
    
    func canMove(at: Int) -> Bool
    func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

public extension STListSectionProtocol {
    
    var sectionView: UITableView {
        return collectionView!
    }

}

public extension STListSectionProtocol {
    
    var minimumLineSpacing: CGFloat { return 0 }
    var minimumInteritemSpacing: CGFloat { return 0 }
    var sectionInset: UIEdgeInsets { return .zero }
    
}

public extension STListSectionProtocol {
    
    var headerSize: CGSize { return .zero }
    var footerSize: CGSize { return .zero }
    
    var headerView: UITableViewHeaderFooterView? { return nil }
    var footerView: UITableViewHeaderFooterView? { return nil }
    
}

public extension STListSectionProtocol {
    
    func pick(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 11.0, *) {
            collectionView?.performBatchUpdates(updates, completion: completion)
        } else {
            collectionView?.beginUpdates()
            updates?()
            collectionView?.endUpdates()
            completion?(true)
        }
    }
    
}

public extension STListSectionProtocol {
    
    func canMove(at: Int) -> Bool { false }
    func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
    
}

public extension STListSectionProtocol {
    
    func reload(at index: Int, with animation: UITableView.RowAnimation = .none) {
        reload(at: [index], with: animation)
    }
    
    func reload(at indexs: [Int], with animation: UITableView.RowAnimation = .none) {
        collectionView?.reloadRows(at: indexPaths(from: indexs), with: animation)
    }
    
}

public extension STListSectionProtocol {
    
    func insert(at index: Int,
                with animation: UITableView.RowAnimation = .none,
                willUpdate: (() -> Void)? = nil) {
        insert(at: [index])
    }
    
    func insert(at indexs: [Int],
                with animation: UITableView.RowAnimation = .none,
                willUpdate: (() -> Void)? = nil) {
        guard indexs.isEmpty == false else {
            return
        }
        willUpdate?()
        if let max = indexs.max(), itemCount <= max {
            collectionView?.reloadData()
        } else {
            collectionView?.insertRows(at: indexPaths(from: indexs), with: animation)
        }
    }
    
}

public extension STListSectionProtocol {
    
    func delete(at index: Int,
                with animation: UITableView.RowAnimation = .none,
                willUpdate: (() -> Void)? = nil) {
        delete(at: [index], willUpdate: willUpdate)
    }
    
    func delete(at indexs: [Int],
                with animation: UITableView.RowAnimation = .none,
                willUpdate: (() -> Void)? = nil) {
        guard indexs.isEmpty == false else {
            return
        }
        willUpdate?()
        if itemCount <= 0 {
            collectionView?.reloadData()
        } else {
            collectionView?.deleteRows(at: indexPaths(from: indexs), with: animation)
        }
    }
    
}

public extension STListSectionProtocol {
    
    func didSelectItem(at indexPath: IndexPath) { }
    
    func cell(at index: Int) -> UITableViewCell? {
        return collectionView?.cellForRow(at: indexPath(from: index))
    }
    
    func scroll(to index: Int, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        collectionView?.scrollToRow(at: indexPath(from: index), at: scrollPosition, animated: animated)
    }
    
    func deselect(at index: Int, animated: Bool) {
        collectionView?.deselectRow(at: indexPath(from: index), animated: animated)
    }
    
    func select(at index: Int?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        collectionView?.selectRow(at: indexPath(from: index), animated: animated, scrollPosition: scrollPosition)
    }
    
}

public extension STListSectionProtocol {
    
    func refresh() {
        collectionView?.reloadData()
    }
    
    func refresh(at index: Int) {
        refresh(at: [index])
    }
    
    func refresh(at indexs: [Int], with animation: UITableView.RowAnimation) {
        collectionView?.reloadRows(at: indexPaths(from: indexs), with: animation)
    }
    
}

private extension STListSectionProtocol {
    
    func indexPath(from value: Int?) -> IndexPath? {
        return value.map({ IndexPath(item: $0, section: index) })
    }
    
    func indexPath(from value: Int) -> IndexPath {
        return IndexPath(item: value, section: index)
    }
    
    func indexPaths(from value: [Int]) -> [IndexPath] {
        return value.map({ IndexPath(item: $0, section: index) })
    }
    
}
