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

open class SectionHorizontalListCell: UICollectionViewCell {
    
    public let sectionView = SectionView()
    private(set) lazy var manager = SectionManager(sectionView: sectionView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    open func config(section: SectionProtocol) {
        self.manager.update([section])
    }
    
    private func initialize() {
        contentView.addSubview(sectionView)
        sectionView.scrollDirection = .horizontal
        sectionView.translatesAutoresizingMaskIntoConstraints = false
        sectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        sectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        sectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        sectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}
