//
//  SectionReusableView.swift
//  iDxyer
//
//  Created by 林翰 on 2019/10/18.
//

import UIKit

open class SectionReusableView<Model>: UICollectionReusableView {

    open class func preferredSize(collectionView: UICollectionView, model: Model?) -> CGSize {
        return .zero
    }

}
