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

public class STSectionManager: STScrollManager {
    
    public private(set) var sections: [STSectionProtocol] = []
    
    private unowned var sectionView: UICollectionView

    public init(sectionView: UICollectionView) {
        self.sectionView = sectionView
        super.init()
        self.sectionView.delegate = self
        self.sectionView.dataSource = self
    }
    
}

// MARK: - public api
public extension STSectionManager {
    
    // MARK: - SectionProtocol
    
    /// 添加多组 SectionProtocol
    func update(_ newSections: STSectionProtocol..., animated: Bool = false) {
        let isNeedUpdateSections = isNeedUpdate(sections: sections, with: newSections)
        rebase(sections)
        sections = calculator(sections: newSections, in: sectionView)

        guard isNeedUpdateSections else {
            return
        }

        if animated {
            sectionView.reloadData()
        } else {
            UIView.performWithoutAnimation { [weak self] in
                self?.sectionView.reloadData()
            }
        }
    }

}

private extension STSectionManager {

    /// 是否需要重新设置 sections
    func isNeedUpdate(sections sections1: [STSectionProtocol], with sections2: [STSectionProtocol]) -> Bool {
        guard sections1.count == sections2.count else {
            return true
        }

        for index in 0..<sections1.count where sections1[index] !== sections2[index] {
            return true
        }

        return false
    }

    func rebase(_ sections: [STSectionProtocol]) {
        sections.forEach { rebase($0) }
    }

    func rebase(_ section: STSectionProtocol) {
        section.collectionView = nil
        section.index = -1
    }

    func contains(section: STSectionProtocol, in sections: [STSectionProtocol]) -> Bool {
        return sections.contains(where: { $0 === section })
    }

    func calculator(sections: [STSectionProtocol], in sectionView: UICollectionView) -> [STSectionProtocol] {
        return sections.enumerated().compactMap { [weak sectionView] index, section in
            guard let sectionView = sectionView else {
                return nil
            }
            section.index = index
            section.collectionView = sectionView
            section.config(collectionView: sectionView)
            return section
        }
    }

}

public extension STSectionManager {
    
    func pick(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        sectionView.performBatchUpdates(updates, completion: completion)
    }
    
    func refresh() {
        sectionView.reloadData()
    }
    
    func insert(section: STSectionProtocol, at index: Int) {
        guard contains(section: section, in: sections) == false else {
            return
        }
        section.collectionView = sectionView
        section.index = index
        let isEmpty = sections.isEmpty
        if sections.isEmpty || sections.count <= index {
            sections.append(section)
            sections = calculator(sections: sections, in: sectionView)
            isEmpty ? sectionView.reloadData() : sectionView.insertSections(IndexSet([sections.count]))
        } else {
            sections.insert(section, at: index)
            sections = calculator(sections: sections, in: sectionView)
            sectionView.insertSections(IndexSet([index]))
        }
    }
    
    func delete(at index: Int) {
        if sections.isEmpty || sections.count <= index {
            sectionView.reloadData()
        } else {
            rebase(sections.remove(at: index))
            sections = calculator(sections: sections, in: sectionView)
            sectionView.deleteSections(IndexSet([index]))
        }
    }
    
}

// MARK: - UICollectionViewDelegate && UICollectionViewDataSource
extension STSectionManager: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            sections[sourceIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
        } else {
            sections[sourceIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
            sections[destinationIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].canMove(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension STSectionManager: UICollectionViewDelegateFlowLayout {
    
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
