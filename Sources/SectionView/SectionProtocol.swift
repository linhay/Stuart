//
//  Stuart
//
//  github: https://github.com/linhay/Stuart
//  Copyright (c) 2019 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import UIKit

public protocol SectionProtocol: class {

    /**
     Section 所在的位置, 会由 SectionManager 重新分配, 可随意填值
     */
    var index: Int { get set }

    /**
     设置 Section 所在的 UICollectionView
     - Default:  0
     */
    var collectionView: UICollectionView { get }

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
    func itemCell(at indexPath: IndexPath) -> UICollectionViewCell

    /**
     设置 Section 的 headerView
     - Parameter index: indexPath
     - Default:  nil
     */
    func headerView(at indexPath: IndexPath) -> UICollectionReusableView?

    /**
     设置 Section 的 footerView
     - Parameter index: indexPath
     - Default:  nil
     */
    func footerView(at indexPath: IndexPath) -> UICollectionReusableView?

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
    func refresh(item at: Int)

    /**
     刷新 Section 中指定 Cell
     - Parameter at: 指定 Cell 位置
     - Important: 默认采用 `reloadItems` 的方式刷新
     */
    func refresh(items at: [Int])
}

public extension SectionProtocol {

    var headerSize: CGSize { return .zero }
    var footerSize: CGSize { return .zero }

    var minimumLineSpacing: CGFloat { return 0 }
    var minimumInteritemSpacing: CGFloat { return 0 }

    var sectionInset: UIEdgeInsets { return .zero }

    func didSelectItem(at indexPath: IndexPath) { }

    func headerView(at indexPath: IndexPath) -> UICollectionReusableView? { return nil }
    func footerView(at indexPath: IndexPath) -> UICollectionReusableView? { return nil }

    func refresh() {
        UIView.performWithoutAnimation {
            collectionView.reloadData()
        }
    }

    func refresh(item at: Int) {
        refresh(items: [at])
    }

    func refresh(items at: [Int]) {
        UIView.performWithoutAnimation {
            collectionView.reloadData()
        }
    }
}
