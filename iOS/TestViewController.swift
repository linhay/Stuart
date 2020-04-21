//
//  ViewController.swift
//  iOS
//
//  Created by 林翰 on 2020/1/8.
//  Copyright © 2020 linhey.pod.template.ios. All rights reserved.
//

import UIKit
import SnapKit
import Stuart

class TestViewController: SectionCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tapAction(_ sender: UIButton) {
        manager.update(CollectionSection(),
                       CollectionSection(),
                       CollectionSection(),
                       CollectionSection())
        manager.sections.forEach { item in
            print(item.sectionView)
        }
    }

}


class CollectionSection: SectionCollectionProtocol {

    var core: SectionCore?

    var itemCount: Int = 0

    func item(at index: Int) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func itemSize(at index: Int) -> CGSize {
        .zero
    }

    func config(sectionView: UICollectionView) {
        sectionView
    }

    func didSelectItem(at indexPath: IndexPath) {

    }

}
