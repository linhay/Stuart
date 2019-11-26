//
//  SectionFlowLayout.swift
//  iDxyer
//
//  Created by 林翰 on 2019/10/18.
//

import UIKit

open class SectionFlowLayout: UICollectionViewFlowLayout {
    
    public enum ContentMode {
        /// 左对齐
        case left
        case none
    }
    
    public var contentMode = ContentMode.none

    func modeLeft(collectionView: UICollectionView, attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes]? {
        var lineStore = [CGFloat: [UICollectionViewLayoutAttributes]]()
        var list = [UICollectionViewLayoutAttributes]()

        for item in attributes {
            guard item.representedElementCategory == .cell,
                let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
                /// self.minimumInteritemSpacing 获取时与 delegate 中数值不一致
                let minimumInteritemSpacing = delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: item.indexPath.section) else {
                    list.append(item)
                    continue
            }

            if let lastItem = lineStore[item.frame.minY]?.last {
                item.frame.origin.x = lastItem.frame.maxX + minimumInteritemSpacing
                lineStore[item.frame.minY]?.append(item)
            } else {
                lineStore[item.frame.minY] = [item]
            }
            list.append(item)
        }
        return list
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let attributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() }) as? [UICollectionViewLayoutAttributes],

            let collectionView = collectionView else {
                return nil
        }

        switch contentMode {
        case .left:
            return modeLeft(collectionView: collectionView, attributes: attributes)
        case .none:
            return super.layoutAttributesForElements(in: rect)
        }
    }
    
}
