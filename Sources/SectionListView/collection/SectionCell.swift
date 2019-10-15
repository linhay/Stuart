//
//  SectionCellType.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/14.
//

import UIKit

open class SectionCell: UICollectionViewCell {

    open var indexPath = IndexPath()

    open class func preferredSize(collectionView: UICollectionView, data: Any?) -> CGSize {
        return .zero
    }

}
