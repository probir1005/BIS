//
//  BISManagementHomeVC.swift
//  BIS
//
//  Created by TSSIOS on 03/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol BISManagementHomeBusinessLogic {
    func getChartData()
}

protocol ManagementVCProtocol {
    var onDetail: ((_ data: HomeChartDTO) -> Void)? { get set }
}

class BISManagementHomeVC: BISDashboardBaseVC {
    // MARK: - ManagementVCProtocol:
    var onDetail: ((HomeChartDTO) -> Void)?
    private var interactor: BISManagementHomeBusinessLogic?
    
    // MARK: - View Controller life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getChartData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.layoutIfNeeded()
    }

    override func setupDependencyConfigurator() {
        let interactor = BISManagementHomeInteractor()
        let presenter = BISManagementHomePresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    // MARK: - Private methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        
        if let model = dataSource?[indexPath.section].rows?[indexPath.item] as? HomeChartDTO {
            self.onDetail?(model)
        } else if (dataSource?[indexPath.section].rows?[indexPath.item] as? HomeDescriptionDTO) != nil {
            if let selectedCell = collectionView.cellForItem(at: indexPath) {
                expandView(cell: selectedCell)
            }
        }
    }

}

// MARK: - BISManagementHomeDisplayLogic methods
extension BISManagementHomeVC: BISManagementHomeDisplayLogic {
    func displayData(_ dataSource: [SectionViewModel]) {
        self.dataSource = dataSource
        collectionView.reloadData()
    }
    
    func displayError(_ error: String) {
        
    }
    
}
