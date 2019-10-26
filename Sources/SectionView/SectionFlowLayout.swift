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

open class SectionFlowLayout: UICollectionViewFlowLayout {
    
    public enum ContentMode {
        /// 左对齐
        case left
        case none
    }
    
    public var contentMode = ContentMode.none
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        switch contentMode {
        case .left:
            guard let attributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() }) as? [UICollectionViewLayoutAttributes] else {
                return nil
            }
            
            var lineStore = [CGFloat: [UICollectionViewLayoutAttributes]]()
            var list = [UICollectionViewLayoutAttributes]()
            
            for item in attributes {
                if let lastItem = lineStore[item.frame.minY]?.last {
                    item.frame.origin.x = lastItem.frame.maxX + minimumInteritemSpacing
                    lineStore[item.frame.minY]?.append(item)
                } else {
                    lineStore[item.frame.minY] = [item]
                }
                list.append(item)
            }
            return list
        case .none:
            return super.layoutAttributesForElements(in: rect)
        }
    }
    
}
