//
//  BISHomeVC.swift
//  BIS
//
//  Created by TSSIT on 30/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol BISDashboardExpandDelegate: class {
    func expandButtonTapped(cell: UICollectionViewCell)
    func optionButtonTapped(cell: UICollectionViewCell)
}

protocol DashboardBaseVCProtocol {
    var onAnnotation: ((_ data: UIImage?) -> Void)? { get set }
    var onManageAlert: ((_ data: HomeDescriptionDTO?) -> Void)? { get set }
    var onReport: ((_ data: [Any]) -> Void)? { get set }
}

class BISDashboardBaseVC: BaseViewController, DashboardBaseVCProtocol, StaggerLayoutDelegate {
    
    // MARK: - DashboardBaseVCProtocol:
    var onAnnotation: ((UIImage?) -> Void)?
    var onManageAlert: ((HomeDescriptionDTO?) -> Void)?
    var onReport: (([Any]) -> Void)?
    
    // MARK: - Outlets and properties:
    @IBOutlet weak var collectionView: UICollectionView!

    var refreshControl: UIRefreshControl!
    var dataSource: [SectionViewModel]?
    var overlay: UIView?
    let spacing: CGFloat = 16.0
    let descCellHeight: CGFloat = 155
    let chartCellHeight: CGFloat = 300
    
    private var selectedDTO: BaseDashboardDTOProtocol?
    private var selectedCell: UICollectionViewCell?
    
    // MARK: - View Controller life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Private methods
    private func addPulltoRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Strings.AlertMessage.reloading)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    private func initializeView() {
        title = Strings.ScreenTitle.home
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(orientationChanged(notification:)),
        name: UIDevice.orientationDidChangeNotification,
        object: nil)
        initializeCollectionView()
        self.addPulltoRefresh()
    }
    
    private func initializeCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(cell: BISDescriptionCVCell.self)
        collectionView.register(cell: BISChartHomeCVCell.self)
        collectionView.register(cell: BISTableCVCell.self)
        
        let customLayout = StaggerCVLayout()
        customLayout.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        collectionView.collectionViewLayout = customLayout
        customLayout.updateView()
        
        // Automatic dimentions of collection view
//        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = UICollectionViewFlowLayout.automaticSize
//        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 50, height: 50)
        
    }

    private func openReport(with dataModel: [Any]) {
        onReport?(dataModel)
    }

    private func openManageAlertScreen(with dto: HomeDescriptionDTO?) {
        self.onManageAlert?(dto)
    }
    
    private func openAnnotationScreen(image: UIImage?) {
        onAnnotation?(image)
    }
    
    // MARK: - Action methods
    @objc func orientationChanged(notification: NSNotification) {
        // dismiss popup on orientation change
        if let top = topMostViewController() as? ContextMenuVC {
            top.dismiss(animated: false, completion: nil)
        }
        
        (self.collectionView?.collectionViewLayout as? StaggerCVLayout)?.updateView()
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            self.collectionView?.collectionViewLayout.invalidateLayout()
        case .portrait, .portraitUpsideDown:
            self.collectionView?.collectionViewLayout.invalidateLayout()
        default: break
        }
    }
    
    @objc func refresh(_ sender: Any) {
        refreshControl.endRefreshing()
    }
    
    // MARK: - Public methods
    func staggerLayout(_ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        
        let model = dataSource?[indexPath.section].rows?[indexPath.item]
        
        if model is HomeDescriptionDTO {
            height = descCellHeight
        } else if let chartModel = model as? HomeChartDTO {
            
            if chartModel.charts.contains(#""type": "bullet""#) {
                height = descCellHeight
            } else {
                height = chartCellHeight
            }
        } else {
            height = chartCellHeight
        }
        
        return height
    }
}

// MARK: - Collection view Data Source and Delegate methods:
extension BISDashboardBaseVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?[section].rows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = dataSource?[indexPath.section].rows?[indexPath.item]
        
        if let desModel = model as? HomeDescriptionDTO {
            let desCell: BISDescriptionCVCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            desCell.configureCell(model: desModel)
            desCell.expandDelegate = self
            return desCell
        } else if let chartModel = model as? HomeChartDTO {
            let chartCell: BISChartHomeCVCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            chartCell.configureCell(with: chartModel.charts, title: chartModel.title)
            if self is BISChartDetailsVC {
                chartCell.chartView.isUserInteractionEnabled = true
            }
            chartCell.expandDelegate = self
            return chartCell
        } else if let tableModel = model as? TableDetailsModel {
            let tableCell: BISTableCVCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            tableCell.configureCell(title: tableModel.title ?? "", tableModel: tableModel)
            tableCell.expandDelegate = self
            return tableCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 0.0
        
        let model = dataSource?[indexPath.section].rows?[indexPath.item]

        if model is HomeDescriptionDTO {
            height = descCellHeight
        } else if let chartModel = model as? HomeChartDTO {

            if chartModel.charts.contains(#""type": "bullet""#) {
                height = descCellHeight
            } else {
                height = chartCellHeight
            }
        } else {
            height = chartCellHeight
        }
        
        if CustomNavigationController.appDelegate.landscape || UIDevice.current.orientation == .portraitUpsideDown {
            return CGSize(width: (collectionView.frame.width - 50.0)/2, height: height)
        } else {
            return CGSize(width: collectionView.frame.width - 30.0, height: height)
        }
    }
}

// MARK: - BISDashboardExpandDelegate methods
extension BISDashboardBaseVC: BISDashboardExpandDelegate {
    
    func expandButtonTapped(cell: UICollectionViewCell) {
        expandView(cell: cell)
    }

    func expandView(cell: UICollectionViewCell) {        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let model = dataSource?[indexPath.section].rows?[indexPath.row]
        
        let fullScreenView: BISExpandedDashboardView = UIView.fromNib()
        fullScreenView.configureView(model: model)
        
        let startingPoint = cell.contentView.convert(cell.bounds, to: nil)
        
        fullScreenView.frame = CGRect(x: 10, y: 40, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 80) //startingPoint
        fullScreenView.addShadow()
        fullScreenView.layer.borderColor = UIColor.shadow.cgColor
        fullScreenView.layer.borderWidth = 1
        fullScreenView.layer.cornerRadius = 8
        fullScreenView.clipsToBounds = true
        fullScreenView.collapseDelegate = self
        fullScreenView.startingFrame = startingPoint
        
        guard let window = AppDelegate.getKeyWindow() else { return }
        
        overlay = UIView.getOverlay()
        overlay!.frame = window.bounds 

        overlay!.autoresizingMask = UIView.AutoresizingMask.init(arrayLiteral: [.flexibleHeight, .flexibleWidth])
        window.addSubview(overlay!)
        overlay!.addSubviewWithZoomInAnimation(fullScreenView, startingFrame: startingPoint, duration: 0.4, options: .curveEaseInOut)

    }
    
    func optionButtonTapped(cell: UICollectionViewCell) {
        showPopover(cell: cell)
    }
    
    private func showPopover(cell: UICollectionViewCell) {
        
        var frame = CGRect.zero
        if let descCell = cell as? BISDescriptionCVCell {
            frame = cell.contentView.convert(descCell.optionButton.frame, to: view)
        } else if let chartCell = cell as? BISChartHomeCVCell {
            frame = cell.contentView.convert(chartCell.optionButton.frame, to: view)
        } else if let tableCell = cell as? BISTableCVCell {
            frame = cell.contentView.convert(tableCell.optionButton.frame, to: view)
        } else {
            return
        }
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let model = dataSource?[indexPath.section].rows?[indexPath.row] as? BaseDashboardDTOProtocol
        selectedDTO = model
        selectedCell = cell
        self.addContextMenu(with: model?.optionList ?? [], frame: frame)
    }
}

// MARK: - BISExpandedDashboardViewDelegate methods
extension BISDashboardBaseVC: BISExpandedDashboardViewDelegate {
    func collapseButtonTaaped() {
        guard let fullScreenView = overlay?.subviews.first(where: {$0 is BISExpandedDashboardView}) as? BISExpandedDashboardView else {
            return
        } 
        
        let dto = fullScreenView.dto as? BaseDashboardDTOProtocol
        guard let index = dataSource?[0].rows?.firstIndex(where: { (item) -> Bool in
            return (item as? BaseDashboardDTOProtocol)?.title == dto?.title 
        }) else {
            return
        }
        
        var endingFrame = fullScreenView.startingFrame ?? CGRect.zero
        if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) {
            endingFrame = cell.contentView.convert(cell.bounds, to: nil)
        }
        
        self.overlay?.backgroundColor = UIColor.clear
        fullScreenView.removeWithZoomOutAnimation(duration: 0.4, endingFrame: endingFrame, options: .curveEaseInOut, completionHandler: { 
            self.overlay?.removeFromSuperview()
            self.overlay = nil
        })
    }
    
    func optionButtonTapped(sender: UIButton) {
        
        guard let fullScreenView = overlay?.subviews.first(where: {$0 is BISExpandedDashboardView}) as? BISExpandedDashboardView else {
            return
        }
        let frame = fullScreenView.convert(sender.frame, to: view)
        
        selectedDTO = fullScreenView.dto as? BaseDashboardDTOProtocol
        let optionList = selectedDTO?.optionList
        addContextMenu(with: optionList ?? [], frame: frame)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate methods
extension BISDashboardBaseVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        selectedDTO = nil
        selectedCell = nil
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    }

}

// MARK: - OptionDropDownViewDelegate methods
extension BISDashboardBaseVC: OptionDropDownViewDelegate {
    func popoverContent(controller: ContextMenuVC, didSelectItem index: Int) {
        controller.dismiss(animated: true) { 
            if let selectedDto = self.selectedDTO {
                switch selectedDto.optionList[index].type {
                case .manageAlerts:
                    self.overlay?.removeFromSuperview()
                    self.overlay = nil
                    self.openManageAlertScreen(with: selectedDto as? HomeDescriptionDTO)
                case .annotations: 
                    var image: UIImage?
                    if let expandView = self.overlay?.subviews.first(where: {$0 is BISExpandedDashboardView}) as? BISExpandedDashboardView {
                        image = expandView.subviews.first?.asImage()
                        self.overlay?.removeFromSuperview()
                        self.overlay = nil
                    } else if let cell = self.selectedCell {
                        image = cell.contentView.asImage()
                    }
                    self.openAnnotationScreen(image: image)
                    
                case .openReport:
                    self.overlay?.removeFromSuperview()
                    self.overlay = nil
                    if self is BISSalesPICHomeVC {
                        let dataModel = Utils.getSalesPICData()
                        self.openReport(with: dataModel)
                    } else if self is BISOperationsHomeVC {
                        let dataModel = Utils.getSalesPipelineData()
                        self.openReport(with: dataModel)
                    }
                default:
                    print("case not handled")
                }
            }
            self.selectedDTO = nil
            self.selectedCell = nil
        }
    }
}
