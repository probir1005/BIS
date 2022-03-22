//
//  ContextMenuVC.swift
//  BIS
//
//  Created by TSSIT on 30/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

enum PopoverOptionType: String {
    case manageAlerts = "Manage Alerts"
    case annotations = "Annotations"
    case openReport = "Open Report"
}

struct PopoverOptionModel {
    var title: String
    var image: UIImage?
    var type: PopoverOptionType?
}

protocol OptionDropDownViewDelegate: class {
    func popoverContent(controller: ContextMenuVC, didSelectItem index: Int)
}

class ContextMenuVC: BaseViewController {

    // MARK: - Outlets and properties:
    @IBOutlet weak var optionTableView: UITableView!
    
    weak var delegate: OptionDropDownViewDelegate?
    var optionList: [PopoverOptionModel]?
    private var dataSource: [PopoverOptionModel]?
    static var cellHeight: CGFloat = 52
    
    // MARK: - View Controller life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
    }
    
    // MARK: - Private methods
    private func initializeView() {
        dataSource = optionList
        optionTableView.tableFooterView = UIView()
        optionTableView.rowHeight = ContextMenuVC.cellHeight
        optionTableView.register(cell: BISOptioDropdownCell.self)
        optionTableView.reloadData()
    }
}

// MARK: - Table data source and delegate:
extension ContextMenuVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BISOptioDropdownCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let model = dataSource?[indexPath.row]
        cell.configureCell(with: model?.title ?? "", image: model?.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.popoverContent(controller: self, didSelectItem: indexPath.row)
    }
}
