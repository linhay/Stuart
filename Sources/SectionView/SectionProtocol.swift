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
}
