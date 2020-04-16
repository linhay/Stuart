//
//  STScrollManager.swift
//  Stuart
//
//  Created by 林翰 on 2020/4/16.
//

import UIKit

public class STScrollManager: NSObject, UIScrollViewDelegate {
    
    private var observeScrollStore: [String: WeakBox<UIScrollViewDelegate>] = [:]
    
}

public extension STScrollManager {
    
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

// MARK: - scrollViewDelegate
public extension STScrollManager {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidScroll?(scrollView) }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidZoom?(scrollView) }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewWillBeginDragging?(scrollView) }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        observeScrollStore.values.forEach { $0.value?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset) }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate) }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewWillBeginDecelerating?(scrollView) }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidEndDecelerating?(scrollView) }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidEndScrollingAnimation?(scrollView) }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for box in observeScrollStore.values {
            guard let target = box.value, let view = target.viewForZooming?(in: scrollView) else {
                continue
            }
            return view
        }
        return nil
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        observeScrollStore.values.forEach { $0.value?.scrollViewWillBeginZooming?(scrollView, with: view) }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale) }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        for box in observeScrollStore.values {
            guard let target = box.value, let result = target.scrollViewShouldScrollToTop?(scrollView), result == false else {
                continue
            }
            return result
        }
        return true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidScrollToTop?(scrollView) }
    }
    
    @available(iOS 11.0, *)
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        observeScrollStore.values.forEach { $0.value?.scrollViewDidChangeAdjustedContentInset?(scrollView) }
    }
    
}
