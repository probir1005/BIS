//
//  BISChartDetailsVC.swift
//  BIS
//
//  Created by TSSIT on 18/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol BISChartDetailsBusinessLogic {
    func getChartData(fromJson: HomeChartDTO?)
}

protocol ChartDetailsVCProtocol {
    var onFinish: (() -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
}

class BISChartDetailsVC: BISDashboardBaseVC, ChartDetailsVCProtocol {
    
    // MARK: - ChartDetailsVCProtocol:
    var onFinish: (() -> Void)?
    var onBack: (() -> Void)?
    
    // MARK: - Outlets and properties:
    private var interactor: BISChartDetailsBusinessLogic?
    var chartJson: String?
    var chartData: HomeChartDTO?
    
    // MARK: - View Controller life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.ScreenTitle.details
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customTabBarController()?.hideTabBar(isHide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        customTabBarController()?.hideTabBar(isHide: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.layoutIfNeeded()
    }
    
    override func setupDependencyConfigurator() {
        let interactor = BISChartDetailsInteractor()
        let presenter = BISChartDetailsPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    override func staggerLayout(_ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight, .portraitUpsideDown:
            height = collectionView.frame.height - 32
        default:
            height = (collectionView.frame.height-48.0)/2
        }
        let model = dataSource?[indexPath.section].rows?[indexPath.item]
        if let chartModel = model as? HomeChartDTO, chartModel.charts.contains("bullet") {
            height = 155
        }
        return height
    }
    
    // MARK: - Private methods:
    private func initializeView() {
        interactor?.getChartData(fromJson: chartData)
        self.leftBackAction { _ in
            self.onBack?()
        }
    }
}

// MARK: - ChartDetails Display Logic methods
extension BISChartDetailsVC: BISChartDetailsDisplayLogic {
    func displayData(_ dataSource: [SectionViewModel]) {
        self.dataSource = dataSource
        collectionView.reloadData()
    }
    
    func displayError(_ error: String) {
        
    } 
}

// MARK: - extension for collection view methods:
extension BISChartDetailsVC {
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize.zero
        
        if CustomNavigationController.appDelegate.landscape {
            size = CGSize(width: (collectionView.frame.width - 48.0)/2, height: collectionView.frame.height - 32)
        } else {
            size = CGSize(width: collectionView.frame.width - 32.0, height: (collectionView.frame.height-48.0)/2)
        }
        return size
    }
}
