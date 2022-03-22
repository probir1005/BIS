//
//  BISMenuVC.swift
//  BIS
//
//  Created by TSSIOS on 26/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISMenuVC: BaseViewController {

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!

    var dataSource = DrawerViewModel.getDrawerViewModel()
    var selectedModel: DrawerViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addVersion()
    }
    
    private func addVersion() {
        if let info = Bundle.main.infoDictionary {
            let appVersionNumber = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            versionLabel.text = "Version: \(appVersionNumber) (\(appBuild))"
        }
    }

    private func configureTableView() {
        menuTableView.register(cell: DrawerTVCell.self)
        menuTableView.registerHeader(withIdentifier: "DrawerMenuHeaderView")
        let drawerHeaderView: DrawerHeaderView = .fromNib()
        menuTableView.setHeaderView(drawerHeaderView)
        selectedModel = dataSource.first

        let dbWorker = BISVerifyOTPDBWorker(manager: DependencyInjector.get()!)
        dbWorker.fetchUser(callBack: { user in
            if user != nil {
                drawerHeaderView.setViewModel((user!.firstName) + (user!.lastName != nil ? " \(user!.lastName!.trimmed)" : ""))
            }
        })
//        guard let user = UserDefaultsService().getUser() else {
//            return
//        }
//        drawerHeaderView.setViewModel((user.firstName ?? "") + (user.lastName ?? ""))

    }

    private func markSelected(with model: DrawerViewModel, indexPath: IndexPath?) {
        //Will costimize more once done with POC
        self.getCompletion(with: model, and: indexPath) {
            switch indexPath?.section {
            case 0:
                if self.customTabBarController() != nil {
                    self.customTabBarController()!.setSelectedController(index: 0)
                } else {
                    drawer()?.onTabBar?()
                    self.customTabBarController()!.setSelectedController(index: 0)
                }
                drawer()?.closeMenu(completion: nil)
            case 1:
                
                switch model.title {
                case "Management":
                    return
//                    drawer()?.closeMenu(completion: nil)
                case "Sales PIC":
                    drawer()?.onReport?(Utils.getSalesPICData())
                    drawer()?.closeMenu(completion: nil)
                case "Sales Pipeline":
                    drawer()?.onReport?(Utils.getSalesPipelineData())
                    drawer()?.closeMenu(completion: nil)
                default:
                    print("case not exist")
                }
            case 2:
                if self.customTabBarController() != nil {
                    self.customTabBarController()!.setSelectedController(index: 1)
                } else {
                    drawer()?.onTabBar?()
                    self.customTabBarController()!.setSelectedController(index: 1)
                }
                drawer()?.closeMenu(completion: nil)
            case 3:
                if self.customTabBarController() != nil {
                    self.customTabBarController()!.setSelectedController(index: 2)
                } else {
                    drawer()?.onTabBar?()
                    self.customTabBarController()!.setSelectedController(index: 2)
                }
                drawer()?.closeMenu(completion: nil)
            case 4:
                if self.customTabBarController() != nil {
                    self.customTabBarController()!.setSelectedController(index: 3)
                } else {
                    drawer()?.onTabBar?()
                    self.customTabBarController()!.setSelectedController(index: 3)
                }
                drawer()?.closeMenu(completion: nil)
            case 5: self.sendTo(email: "support@TSS.com")
            case 6: UIAlertController.alert("Log out", message: "Are you sure, you want to log out?", cancelActionTitle: "Cancel", destructiveActionTitle: "Yes", okAction: nil, cancelAction: nil, destructiveAction: { _ in
                self.drawer()?.onFinish?()
            }).show()
            default: break
            }

        }
    }
    
    func getCompletion(with model: DrawerViewModel, and indexPath: IndexPath?, completion: () -> Void) {
        // Todo: - Will need to improve when we do code refactoring
        if model.isExpandable {
            for item in dataSource {
                if item.modelType != .report {
                    item.isSelected =  false
                }
            }

            selectedModel?.isSelected = selectedModel?.title == "Reports" ? !model.isSelected : false
            model.isExpanded = !model.isExpanded
            model.isSelected = selectedModel?.title == "Reports" ? selectedModel!.isSelected : !model.isSelected
            self.menuTableView.beginUpdates()
            self.menuTableView.reloadSections(IndexSet(integer: indexPath!.section), with: .automatic)
            self.menuTableView.endUpdates()
            self.menuTableView.reloadSections(IndexSet(integer: selectedModel!.modelIndex), with: .none)

            selectedModel = model
        } else {
            
            if model.modelType == .logout || model.modelType == .feedback {
                completion()
                return
            }
            
            let source = dataSource[indexPath!.section]
            selectedModel?.isSelected = false
            selectedModel?.isExpanded = false
            if let child = selectedModel?.subViews as? [DrawerViewModel] {
                child.forEach { obj in
                    if obj.isSelected {
                        obj.isSelected = false
                    }
                }
            }
            model.isSelected = true
            selectedModel = model

            if source.modelType == .report {
                let item = source.subViews as? [DrawerViewModel]
                var cellSelected = false
                item?.forEach({ rowObj in
                    if rowObj.isSelected {
                        cellSelected = true
                        return
                    }
                })
                source.isExpanded = cellSelected
                source.isSelected = cellSelected
                selectedModel = source
            }

            menuTableView.reloadData()
            completion()
        }
    }
}

// MARK: - Table View Data source and Delegate methods
extension BISMenuVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataSource[section]
        if model.isExpandable && model.isExpanded {
            return model.subViews?.count ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let model = dataSource[indexPath.section].subViews?[indexPath.row] as? DrawerViewModel {
            let cell: DrawerTVCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.configureCell(model: model)
            tableView.allowsSelection = model.title != "Management"
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.section]

        return model.isExpandable && model.isExpanded ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DrawerMenuHeaderView") as! DrawerMenuHeaderView
        headerView.configureView(model: dataSource[section], index: section)
        headerView.delegate = self
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[indexPath.section].subViews?[indexPath.row] as? DrawerViewModel {
            if model.title == "Management" {
                return
            }
            markSelected(with: model, indexPath: indexPath)
        }
    }

}

extension BISMenuVC: DrawerMenuHeaderDelegate {
    func headerTapped(at index: Int) {

        let model = dataSource[index]
        markSelected(with: model, indexPath: IndexPath(row: 0, section: index))
    }
}
