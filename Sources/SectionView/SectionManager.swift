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

fileprivate final class WeakBox<T: AnyObject> {

    weak var value: T?

    init(_ value: T) {
        self.value = value
    }

}

public class SectionManager: NSObject {
    
    private weak var sectionView: UICollectionView?
    private(set) var sections: [SectionProtocol] = []
    private var observeScrollStore: [String: WeakBox<UIScrollViewDelegate>] = [:]

    public init(sectionView: UICollectionView) {
        self.sectionView = sectionView
        super.init()
        self.sectionView?.delegate = self
        self.sectionView?.dataSource = self
    }
    
}

// MARK: - public api
extension SectionManager {

    // MARK: - SectionProtocol

    /// 添加多组 SectionProtocol
    public func update(sections: [SectionProtocol], animated: Bool = false) {

        /// 是否需要重新设置 sections
        func isNeedUpdate(sections: [SectionProtocol]) -> Bool {
            guard sections.count == self.sections.count else {
                return true
            }

            for index in 0..<sections.count where sections[index] !== self.sections[index] {
                return true
            }

            return false
        }

        let isNeedUpdateSections = isNeedUpdate(sections: sections)

        if isNeedUpdateSections {
            self.sections = sections
        }

        /// 刷新 sections 的 index
        self.sections.enumerated().forEach { index, item in
            item.index = index
        }
        
        if isNeedUpdateSections {
            if animated {
                self.sectionView?.reloadData()
            } else {
                UIView.performWithoutAnimation {
                    self.sectionView?.reloadData()
                }
            }
        }
    }

    /// 添加多组 SectionProtocol
    public func update(sections: SectionProtocol...) {
        update(sections: sections)
    }

    /// 刷新多组 Section
    public func refresh() {
        sectionView?.reloadData()
    }

    // MARK: - ObserveScroll
    func addObserveScroll(target: NSObject & UIScrollViewDelegate) {
        observeScrollStore[target.self.description] = WeakBox(target)
    }

    func addObserveScroll(targets: [NSObject & UIScrollViewDelegate]) {
        targets.forEach { addObserveScroll(target: $0) }
    }

    func removeObserveScroll(target: NSObject & UIScrollViewDelegate) {
        observeScrollStore[target.self.description] = nil
    }

}

// MARK: - UICollectionViewDelegate && UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegateFlowLayout
extension SectionManager: UICollectionViewDelegateFlowLayout {
    
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

// MARK: - scrollViewDelegate
extension SectionManager {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidScroll?(scrollView) }
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidZoom?(scrollView) }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewWillBeginDragging?(scrollView) }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        observeScrollStore.values.forEach { $0.value?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset) }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate) }
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewWillBeginDecelerating?(scrollView) }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidEndDecelerating?(scrollView) }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidEndScrollingAnimation?(scrollView) }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for box in observeScrollStore.values {
            guard let target = box.value, let view = target.viewForZooming?(in: scrollView) else {
                continue
            }
            return view
        }
        return nil
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        observeScrollStore.values.forEach { $0.value?.scrollViewWillBeginZooming?(scrollView, with: view) }
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale) }
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        for box in observeScrollStore.values {
            guard let target = box.value, let result = target.scrollViewShouldScrollToTop?(scrollView), result == false else {
                continue
            }
            return result
        }
        return true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidScrollToTop?(scrollView) }
    }
    
    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidChangeAdjustedContentInset?(scrollView) }
    }
    
}
