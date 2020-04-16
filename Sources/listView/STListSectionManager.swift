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

public class STListSectionManager: STScrollManager {
    
    public private(set) var sections: [STListSectionProtocol] = []
    
    private unowned var sectionView: UITableView
    
    public init(sectionView: UITableView) {
        self.sectionView = sectionView
        super.init()
        self.sectionView.delegate = self
        self.sectionView.dataSource = self
    }
    
}

// MARK: - public api
public extension STListSectionManager {
    
    // MARK: - SectionProtocol
    
    /// 添加多组 SectionProtocol
    func update(_ newSections: STListSectionProtocol..., animated: Bool = false) {
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

private extension STListSectionManager {

    /// 是否需要重新设置 sections
    func isNeedUpdate(sections sections1: [STListSectionProtocol], with sections2: [STListSectionProtocol]) -> Bool {
        guard sections1.count == sections2.count else {
            return true
        }

        for index in 0..<sections1.count where sections1[index] !== sections2[index] {
            return true
        }

        return false
    }

    func rebase(_ sections: [STListSectionProtocol]) {
        sections.forEach { rebase($0) }
    }

    func rebase(_ section: STListSectionProtocol) {
        section.collectionView = nil
        section.index = -1
    }

    func contains(section: STListSectionProtocol, in sections: [STListSectionProtocol]) -> Bool {
        return sections.contains(where: { $0 === section })
    }

    func calculator(sections: [STListSectionProtocol], in sectionView: UITableView) -> [STListSectionProtocol] {
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

public extension STListSectionManager {
    
    func pick(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 11.0, *) {
            sectionView.performBatchUpdates(updates, completion: completion)
        } else {
            sectionView.beginUpdates()
            updates?()
            sectionView.endUpdates()
            completion?(true)
        }
    }
    
    func refresh() {
        sectionView.reloadData()
    }
    
    func insert(section: STListSectionProtocol,
                at index: Int,
                with animation: UITableView.RowAnimation = .none) {
        guard contains(section: section, in: sections) == false else {
            return
        }
        section.collectionView = sectionView
        section.index = index
        let isEmpty = sections.isEmpty
        if sections.isEmpty || sections.count <= index {
            sections.append(section)
            sections = calculator(sections: sections, in: sectionView)
            isEmpty ? sectionView.reloadData() : sectionView.insertSections(IndexSet([sections.count]), with: animation)
        } else {
            sections.insert(section, at: index)
            sections = calculator(sections: sections, in: sectionView)
            sectionView.insertSections(IndexSet([sections.count]), with: animation)
        }
    }
    
    func delete(at index: Int,
                with animation: UITableView.RowAnimation = .none) {
        if sections.isEmpty || sections.count <= index {
            sectionView.reloadData()
        } else {
            rebase(sections.remove(at: index))
            sections = calculator(sections: sections, in: sectionView)
            sectionView.deleteSections(IndexSet([index]), with: animation)
        }
    }
    
}

// MARK: - UICollectionViewDelegate && UICollectionViewDataSource
extension STListSectionManager: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].itemCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = section.itemCell(at: indexPath)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       return sections[section].headerView
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footerView
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return sections[indexPath.section].didSelectItem(at: indexPath)
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].canMove(at: indexPath.item)
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            sections[sourceIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
        } else {
            sections[sourceIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
            sections[destinationIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
        }
    }
}

