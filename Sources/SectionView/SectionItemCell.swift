//
//  SectionItemCell.swift
//  Stuart
//
//  Created by 林翰 on 2019/10/14.
//

import UIKit

open class SectionItemCell<Model>: UICollectionViewCell {
    
    open class func preferredSize(collectionView: UICollectionView, model: Model?) -> CGSize {
        return .zero
    }
    
}
