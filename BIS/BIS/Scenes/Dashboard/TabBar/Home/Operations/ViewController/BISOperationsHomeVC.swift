//
//  BISOperationsHomeVC.swift
//  BIS
//
//  Created by TSSIOS on 03/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol BISOperationBusinessLogic {
    func getChartData()
}

protocol OperationsHomeVCProtocol {

    var onDetail: ((_ data: HomeChartDTO) -> Void)? { get set }
}

class BISOperationsHomeVC: BISDashboardBaseVC, OperationsHomeVCProtocol {
    // MARK: - OperationsHomeVCProtocol:
    var onDetail: ((HomeChartDTO) -> Void)?

    // MARK: - Outlets and properties:
    private var interactor: BISOperationBusinessLogic?
    
    // MARK: - View Controller life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getChartData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.layoutIfNeeded()
    }
    
    override func setupDependencyConfigurator() {
        let interactor = BISOperationsInteractor()
        let presenter = BISOperationsPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    // MARK: - Action methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = dataSource?[indexPath.section].rows?[indexPath.item] as? HomeChartDTO {
            self.onDetail?(model)
        } else if (dataSource?[indexPath.section].rows?[indexPath.item] as? HomeDescriptionDTO) != nil {
            if let selectedCell = collectionView.cellForItem(at: indexPath) {
                expandView(cell: selectedCell)
            }
        }
    }
}

// MARK: - SalesPipeline Display Logic methods:
extension BISOperationsHomeVC: BISOperationsDisplayLogic {
    func displayData(_ dataSource: [SectionViewModel]) {
        self.dataSource = dataSource
        collectionView.reloadData()
    }
    
    func displayError(_ error: String) {
        
    }
}
