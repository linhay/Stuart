//
//  SectionTableCellProtocol.swift
//  EmptyPage_Example
//
//  Created by linhey on 2019/9/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol SectionTableCellProtocol {
    static func preferredHeight(tableView: UITableView, data: Any?) -> CGSize
}
