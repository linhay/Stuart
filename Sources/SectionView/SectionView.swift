//
//  SectionView.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/17.
//

import UIKit

open class SectionView: UICollectionView {

    /// 滚动方向
    public var scrollDirection: UICollectionView.ScrollDirection? {
        set {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = newValue ?? UICollectionView.ScrollDirection.vertical
        }
        get {
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection
        }
    }
    
    public var layoutMode: SectionFlowLayout.ContentMode {
        set {
            (collectionViewLayout as? SectionFlowLayout)?.contentMode = newValue
        }
        get {
            return (collectionViewLayout as? SectionFlowLayout)?.contentMode ?? .none
        }
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: SectionFlowLayout())
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {

        if backgroundColor == .some(UIColor.black) {
            backgroundColor = .white
        }
        
        // 从 xib 创建时 为 nil
        if collectionViewLayout == nil {
            collectionViewLayout = SectionFlowLayout()
        }
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
}
