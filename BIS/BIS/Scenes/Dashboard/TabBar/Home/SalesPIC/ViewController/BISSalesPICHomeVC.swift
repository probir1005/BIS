//
//  BISSalesPICHomeVC.swift
//  BIS
//
//  Created by TSSIOS on 03/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol BISSalesPICBusinessLogic {
    func getChartData()
}

protocol SalesPICHomeVCProtocol {

    var onDetail: ((_ data: HomeChartDTO) -> Void)? { get set }
}

class BISSalesPICHomeVC: BISDashboardBaseVC, SalesPICHomeVCProtocol {
    // MARK: - SalesPICHomeVCProtocol:
    var onDetail: ((HomeChartDTO) -> Void)?

    // MARK: - Outlets and properties:
    private var interactor: BISSalesPICBusinessLogic?
    
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
        let interactor = BISSalesPICInrterator()
        let presenter = BISSalesPICPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    // MARK: - Action methods
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

// MARK: - SalesPIC Display Logic methods:
extension BISSalesPICHomeVC: BISSalesPICDisplayLogic {
    func displayData(_ dataSource: [SectionViewModel]) {
        self.dataSource = dataSource
        collectionView.reloadData()
    }
    
    func displayError(_ error: String) {
        
    }
}
