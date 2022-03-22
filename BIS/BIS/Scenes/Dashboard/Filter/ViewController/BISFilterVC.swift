//
//  BISFilterVC.swift
//  BIS
//
//  Created by TSSIOS on 30/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

enum FilterCategoryType: Int {
    case calendar
    case client
    case region
    case market
    case salesPIC
    case none
}

protocol FilterVCProtocol {
    var onFinish: (() -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
}

class BISFilterVC: BaseViewController, FilterVCProtocol {

    @IBOutlet weak var applyButton: UIButton!
    private var spacing: CGFloat = 0.0
    private let cellHeight: CGFloat = 50.0
    private let headerHeight: CGFloat = 40.0
    @IBOutlet weak var filterResultTableView: UITableView!
//    @IBOutlet weak var filterResultCollectionView: UICollectionView!
    @IBOutlet weak var filterSearchBar: UISearchBar!
    @IBOutlet weak var clientResultView: UIView!
    @IBOutlet weak var calendarResultView: UIView!

    @IBOutlet weak var filterResultView: UIView!
    @IBOutlet weak var filterCategoryView: UIView!
    var onFinish: (() -> Void)?
    var onBack: (() -> Void)?
    var selectedTag: Int = 1000
    var filtersDTO: FilterDTO?
    var searchArray = [ItemFilterDTO]()
    var selectedArray = [ItemFilterDTO]()
    var filterCategoryType: FilterCategoryType = .none
    var isSearching = Bool()
    var selectedYear: [Int] = [Int]()
    var selectedMonth: [Int] = [Int]()
    var selectedWeek: [Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.addBlurView()
        self.initializeCategoriesButton()
//        NotificationCenter.default.addObserver(
//        self,
//        selector: #selector(orientationChanged(notification:)),
//        name: UIDevice.orientationDidChangeNotification,
//        object: nil)
        filterResultTableView.register(cell: BISFilterTVCell.self)
        self.initializeCollectionView()
//        print(Date.currentDate)
//        print(Date.currentDay)
//        print(DateHelper.filterDaysArray(year: Date.currentYear, month: Date.currentMonth, week: Date.currentWeek - 1))
    }

//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
//    }

//    @objc func orientationChanged(notification: NSNotification) {
//        switch UIDevice.current.orientation {
//        case .landscapeLeft, .landscapeRight, .portraitUpsideDown, .portrait:
//            if self.view.frame.size == UIScreen.main.bounds.size {
//                print(self.view.frame.size)
//                print(true)
//            } else {
//                print(false)
//            }
//        default:
//            break
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearArray()
        self.resetSearching()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.invalidateAllCollectionViewLayout()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            // This is called during the animation
            self.orientationChange()
        }, completion: nil)
    }

    func orientationChange() {
        guard let selectedButton = self.filterCategoryView.viewWithTag(selectedTag) as? FilterButton else {
                   return
               }

        for layer: CALayer in self.view.layer.sublayers! {
            if layer.name == "LineLayer" || layer.name == "ShadowSubLayer" {
                 layer.removeFromSuperlayer()
            }
        }
        self.view.layoutIfNeeded()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.selectCategory(sender: selectedButton)
        }
    }

    private func clearArray() {
        self.selectedArray.removeAll()
        self.selectedYear.removeAll()
        self.selectedMonth.removeAll()
        self.selectedWeek.removeAll()
    }
    private func resetSearching() {
        searchArray.removeAll()
        isSearching = false
        filterSearchBar.text = ""
        self.view.endEditing(true)
    }

    private func loadData() {
        self.filtersDTO = FilterDTO(json: self.filterData)
    }

    func addBlurView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.view.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurredEffectView)
        view.sendSubviewToBack(blurredEffectView)
    }

    func initializeCollectionView() {
        self.calendarResultView.subviews.forEach { subView in
            subView.subviews.forEach { subSubView in
                if subSubView.isKind(of: UIView.self) {
                    subSubView.subviews.forEach { vw in
                        if let filterResultCollectionView = vw as? UICollectionView {
                            filterResultCollectionView.register(cell: BISFilterCalendarCVCell.self)
                        }
                    }
                }
            }
        }
    }

    func invalidateAllCollectionViewLayout() {

        self.calendarResultView.subviews.forEach { subView in
            subView.subviews.forEach { subSubView in
                if subSubView.isKind(of: UIView.self) {
                    subSubView.subviews.forEach { vw in
                        if let filterResultCollectionView = vw as? UICollectionView {
                            filterResultCollectionView.collectionViewLayout.invalidateLayout()
                        }
                    }
                }
            }
        }
    }

    func initializeCategoriesButton() {
        filterCategoryView.layer.masksToBounds = true
        for subView in self.filterCategoryView.subviews {
            if let button = subView as? FilterButton {
                if button.tag == 1000 {
                    button.layer.cornerRadius = 8
                    button.layer.maskedCorners = [.layerMinXMinYCorner]
                } else if button.tag == 1004 {
                    button.layer.cornerRadius = 8
                    button.layer.maskedCorners = [.layerMinXMaxYCorner]
                }
                button.isExclusiveTouch = true
                button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
            }
        }

        guard let initalButton = self.filterCategoryView.viewWithTag(1000) as? FilterButton else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.selectCategory(sender: initalButton)
        }
    }

    @objc
    func categoryButtonPressed(sender: FilterButton) {
        self.selectedTag = sender.tag
        self.selectCategory(sender: sender)
    }

    func selectCategory(sender: UIButton) {
        self.resetSearching()
        self.filterCategoryView.subviews.forEach { if $0 is UILabel { self.filterCategoryView.bringSubviewToFront($0) }
        }

        self.filterResultView.subviews.forEach { $0.isHidden = true }
        self.filterCategoryView.subviews.forEach { ($0 as? FilterButton)?.isSelected = false }

        sender.isSelected = true

        guard let vw = self.filterResultView.viewWithTag(sender.tag == 1000 ? 5000 : 5001) else {
            return
        }
        self.applyButton.isEnabled = !self.selectedYear.isEmpty || !self.selectedArray.isEmpty
        self.filterCategoryType = FilterCategoryType(rawValue: sender.tag - 1000)!
        self.filterResultTableView.reloadData()
        vw.isHidden = false
        self.addCustomShadow(sender: sender)
        self.filterCategoryView.bringSubviewToFront(sender)
    }

    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.onBack?()
    }

    @IBAction func resetButtonAction(_ sender: UIButton) {
        self.applyButton.isEnabled = false
        self.resetSearching()
        self.loadData()
        self.filterResultTableView.reloadData()
        self.clearArray()
        self.reloadCollectionView()
        disableFilterCollectionView()
    }

    @IBAction func ApplyButtonAction(_ sender: UIButton) {
        self.onFinish?()
    }

    func reloadCollectionView() {
        self.calendarResultView.subviews.forEach { subView in
            subView.subviews.forEach { subSubView in
                if subSubView.isKind(of: UIView.self) {
                    subSubView.subviews.forEach { vw in
                        if let filterResultCollectionView = vw as? UICollectionView {
                            filterResultCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }

    func addCustomShadow(sender: UIButton) {
        for layer: CALayer in self.view.layer.sublayers! {
            if layer.name == "LineLayer" || layer.name == "ShadowSubLayer" {
                 layer.removeFromSuperlayer()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let line = CAShapeLayer()
            line.name = "LineLayer"
            let path = UIBezierPath()
            path.move(to: CGPoint(x: self.filterResultView.frame.origin.x + 3.5, y: self.filterCategoryView.frame.origin.y + sender.frame.origin.y - 2))
            path.addLine(to: CGPoint(x: self.filterResultView.frame.origin.x + 3.5, y: self.filterResultView.frame.origin.y + 3))
            path.addLine(to: CGPoint(x: self.filterResultView.frame.origin.x + self.filterResultView.frame.size.width - 3.5, y: self.filterResultView.frame.origin.y + 3))
            path.addLine(to: CGPoint(x: self.filterResultView.frame.origin.x + self.filterResultView.frame.size.width - 3.5, y: self.filterResultView.frame.origin.y + self.filterResultView.frame.size.height - 3))
            path.addLine(to: CGPoint(x: self.filterResultView.frame.origin.x + 3.5, y: self.filterResultView.frame.origin.y + self.filterResultView.frame.size.height - 3))
            path.addLine(to: CGPoint(x: self.filterResultView.frame.origin.x + 3.5, y: self.filterCategoryView.frame.origin.y + (sender.frame.origin.y + sender.frame.size.height) + 2))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.fillColor = UIColor.clear.cgColor
            line.lineWidth = 2
            self.filterResultView.layer.addSublayer(line)

            let shadowSubLayer = self.createShadowLayer()
            shadowSubLayer.name = "ShadowSubLayer"
            shadowSubLayer.insertSublayer(line, at: 0)
            self.view.layer.addSublayer(shadowSubLayer)
            self.view.bringSubviewToFront(self.filterResultView)
        }

    }

    func createShadowLayer() -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowRadius = 7.0
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        return shadowLayer
    }
}

extension BISFilterVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterCategoryType {
        case .calendar, .none:
            return 0
        case .client:
            guard let item = self.isSearching ? self.searchArray : filtersDTO?.clientFilters else {
                return 0
            }
            return item.count
        case .region:
            guard let item = self.isSearching ? self.searchArray : filtersDTO?.regionFilters else {
                return 0
            }
            return item.count
        case .market:
            guard let item = self.isSearching ? self.searchArray : filtersDTO?.marketFilters else {
                return 0
            }
            return item.count
        case .salesPIC:
            guard let item = self.isSearching ? self.searchArray : filtersDTO?.salesPICFilters else {
                return 0
            }
            return item.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterCell: BISFilterTVCell = tableView.dequeueReusableCell(indexPath: indexPath)

        switch filterCategoryType {
        case .calendar, .none:
            return UITableViewCell()
        case .client:
            guard let item = self.isSearching ? self.searchArray[indexPath.row] : filtersDTO?.clientFilters?[indexPath.row] else {
                return UITableViewCell()
            }
            filterCell.configureCell(with: item, isLast: ((filtersDTO?.clientFilters?.count ?? 0) - 1 == indexPath.item))
        case .region:
            guard let item = self.isSearching ? self.searchArray[indexPath.row] : filtersDTO?.regionFilters?[indexPath.row] else {
                return UITableViewCell()
            }
            filterCell.configureCell(with: item, isLast: ((filtersDTO?.regionFilters?.count ?? 0) - 1 == indexPath.item))
        case .market:
            guard let item = self.isSearching ? self.searchArray[indexPath.row] : filtersDTO?.marketFilters?[indexPath.row] else {
                return UITableViewCell()
            }
            filterCell.configureCell(with: item, isLast: ((filtersDTO?.marketFilters?.count ?? 0) - 1 == indexPath.item))
        case .salesPIC:
            guard let item = self.isSearching ? self.searchArray[indexPath.row] : filtersDTO?.salesPICFilters?[indexPath.row] else {
                return UITableViewCell()
            }
            filterCell.configureCell(with: item, isLast: ((filtersDTO?.salesPICFilters?.count ?? 0) - 1 == indexPath.item))
        }

        return filterCell

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSearching {
            self.searchArray[indexPath.row].isSelected = !self.searchArray[indexPath.row].isSelected
        }
        switch filterCategoryType {
        case .calendar, .none:
            break
        case .client:
            self.filtersDTO?.clientFilters![indexPath.row].isSelected = !(self.filtersDTO?.clientFilters![indexPath.row].isSelected)!
        case .region:
            self.filtersDTO?.regionFilters![indexPath.row].isSelected = !(self.filtersDTO?.regionFilters![indexPath.row].isSelected)!
        case .market:
            self.filtersDTO?.marketFilters![indexPath.row].isSelected = !(self.filtersDTO?.marketFilters![indexPath.row].isSelected)!
        case .salesPIC:
            self.filtersDTO?.salesPICFilters![indexPath.row].isSelected = !(self.filtersDTO?.salesPICFilters![indexPath.row].isSelected)!

//            guard var item = filtersDTO?.salesPICFilters?[indexPath.row] else {
//                return
//            }
//             item.isSelected = !(item.isSelected ?? false)
        }

        self.selectedArray = [self.filtersDTO!.clientFilters!, self.filtersDTO!.regionFilters!, self.filtersDTO!.marketFilters!, self.filtersDTO!.salesPICFilters!].flatMap({ (element: [ItemFilterDTO]) -> [ItemFilterDTO] in
            return element.filter { $0.isSelected }
        })
        self.applyButton.isEnabled = !self.selectedYear.isEmpty || !self.selectedArray.isEmpty
        self.filterResultTableView.reloadData()
    }

}

extension BISFilterVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 10000:
            guard let item = filtersDTO?.calendarFilters?.calendarYearFilter else {
                return 0
            }
            return item.count
        case 10001:
            guard let item = filtersDTO?.calendarFilters?.calendarMonthFilter else {
                return 0
            }
            return item.count
        case 10002:
            guard let item = filtersDTO?.calendarFilters?.calendarWeekFilter else {
                return 0
            }
            return item.count
        case 10003:
            guard let item = filtersDTO?.calendarFilters?.calendarDateFilter else {
                return 0
            }
            return item.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarCell: BISFilterCalendarCVCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        switch collectionView.tag {
        case 10000:
            guard let item = filtersDTO?.calendarFilters?.calendarYearFilter?[indexPath.item] else {
                return UICollectionViewCell()
            }
            calendarCell.configureCell(with: item)
        case 10001:
            guard let item = filtersDTO?.calendarFilters?.calendarMonthFilter?[indexPath.item] else {
                return UICollectionViewCell()
            }
            calendarCell.configureCell(with: item)
        case 10002:
            guard let item = filtersDTO?.calendarFilters?.calendarWeekFilter?[indexPath.item] else {
                return UICollectionViewCell()
            }
            calendarCell.configureCell(with: item)
        case 10003:
            guard let item = filtersDTO?.calendarFilters?.calendarDateFilter?[indexPath.item] else {
                return UICollectionViewCell()
            }
            calendarCell.configureCell(with: item)
        default:
            return UICollectionViewCell()
        }
        return calendarCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 10003:
            return CGSize(width: 60, height: 57)
        default:
            return CGSize(width: 60, height: 37)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 10000:
            filtersDTO?.calendarFilters?.calendarYearFilter?[indexPath.item].isSelected = !(filtersDTO?.calendarFilters?.calendarYearFilter?[indexPath.item].isSelected ?? false)
            if filtersDTO?.calendarFilters?.calendarYearFilter?[indexPath.item].isSelected ?? false {
                self.selectedYear.append(Int(filtersDTO?.calendarFilters?.calendarYearFilter?[indexPath.item].title ?? "\(Date.currentYear)")!)
            } else {
                self.selectedYear.removeAll { $0 == Int((filtersDTO?.calendarFilters?.calendarYearFilter?[indexPath.item].title)!) }
            }
            filtersDTO?.calendarFilters?.calendarMonthFilter = self.getMonths()
            self.selectedMonth.removeAll()
            self.selectedWeek.removeAll()
            self.disableFilterCollectionView()
        case 10001:
           filtersDTO?.calendarFilters?.calendarMonthFilter?[indexPath.item].isSelected = !(filtersDTO?.calendarFilters?.calendarMonthFilter?[indexPath.item].isSelected ?? false)
           if filtersDTO?.calendarFilters?.calendarMonthFilter?[indexPath.item].isSelected ?? false {
            self.selectedMonth.append(indexPath.item + 1)
           } else {
            self.selectedMonth.removeAll { $0 == indexPath.item + 1 }
           }
           self.selectedWeek.removeAll()
           self.disableFilterCollectionView()
            if self.selectedYear.count == 1 && self.selectedMonth.count == 1 {
                filtersDTO?.calendarFilters?.calendarWeekFilter? = self.getWeekDays(year: self.selectedYear.first!, month: self.selectedMonth.first!)
            }
        case 10002:
            filtersDTO?.calendarFilters?.calendarWeekFilter?[indexPath.item].isSelected = !(filtersDTO?.calendarFilters?.calendarWeekFilter?[indexPath.item].isSelected ?? false)

            if filtersDTO?.calendarFilters?.calendarWeekFilter?[indexPath.item].isSelected ?? false {
                self.selectedWeek.append(Int(filtersDTO?.calendarFilters?.calendarWeekFilter?[indexPath.item].title ?? "\(Date.currentWeek)")!)
            } else {
                self.selectedWeek.removeAll { $0 == Int((filtersDTO?.calendarFilters?.calendarWeekFilter?[indexPath.item].title)!) }
            }
            self.disableFilterCollectionView()

            if self.selectedYear.count == 1 && self.selectedMonth.count == 1 && self.selectedWeek.count == 1 {
                filtersDTO?.calendarFilters?.calendarDateFilter? = self.getDays(year: self.selectedYear.first!, month: self.selectedMonth.first!, week: self.selectedWeek.first!)
            }

        case 10003:
            filtersDTO?.calendarFilters?.calendarDateFilter?[indexPath.item].isSelected = !(filtersDTO?.calendarFilters?.calendarDateFilter?[indexPath.item].isSelected ?? false)
        default:
            return
        }

        self.applyButton.isEnabled = !self.selectedYear.isEmpty || !self.selectedArray.isEmpty
        self.reloadCollectionView()
    }

    func getMonths() -> [ItemFilterDTO] {
        return DateHelper.filterMonthArray.map {ItemFilterDTO(title: $0.0, isSelected: $0.1)}
    }

    func getWeekDays(year: Int, month: Int) -> [ItemFilterDTO] {
        return DateHelper.filterWeekArray(year: year, month: month).map {ItemFilterDTO(title: $0.0, isSelected: $0.1)}
    }

    func getDays(year: Int, month: Int, week: Int) -> [ItemFilterDTO] {
        return DateHelper.filterDaysArray(year: year, month: month, week: week).map {ItemFilterDTO(title: $0.0, isSelected: $0.1)}
    }

    func disableFilterCollectionView() {

        let monthStatus = self.selectedYear.count == 1
        let weekStatus = monthStatus && self.selectedMonth.count == 1
        let onlyDays = weekStatus && self.selectedWeek.count == 1

        self.calendarResultView.subviews.forEach { subView in
            subView.subviews.forEach { subSubView in
                if subSubView.isKind(of: UIView.self) {
                    subSubView.subviews.forEach { vw in
                        switch vw.tag {
                        case 50001:
                            vw.isHidden = monthStatus
                        case 50002:
                            vw.isHidden = weekStatus
                        case 50003:
                            vw.isHidden = onlyDays
                        default:
                            vw.isHidden = false
                        }
                    }
                }
            }
        }
    }

}

extension BISFilterVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resetSearching()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isSearching = searchText.trimmed.count > 0

        switch filterCategoryType {
        case .calendar, .none:
            break
        case .client:
            self.searchArray = filtersDTO?.clientFilters!.filter { ($0.title?.lowercased().contains(searchText.lowercased().trimmed))! } ?? []
        case .region:
            self.searchArray = filtersDTO?.regionFilters?.filter { ($0.title?.lowercased().contains(searchText.lowercased().trimmed))! } ?? []
        case .market:
            self.searchArray = filtersDTO?.marketFilters?.filter { ($0.title?.lowercased().contains(searchText.lowercased().trimmed))! } ?? []
        case .salesPIC:
            self.searchArray = filtersDTO?.salesPICFilters?.filter { ($0.title?.lowercased().contains(searchText.lowercased().trimmed))! } ?? []
        }
        self.filterResultTableView.reloadData()
    }
}

extension BISFilterVC {

    var calendarData: [String: Any] {

        return ["year": DateHelper.filterYearArray.map { ["name": $0.0, "isSelected": $0.1] }, "month": DateHelper.filterMonthArray.map { ["name": $0.0, "isSelected": $0.1] }, "week": DateHelper.filterWeekArray(year: Date.currentYear, month: Date.currentMonth).map { ["name": $0.0, "isSelected": $0.1] }, "days": DateHelper.filterDaysArray(year: Date.currentYear, month: Date.currentMonth, week: Date.currentWeek).map { ["name": $0.0, "isSelected": $0.1] }]
    }

    var clientData: [[String: Any]] {
        return [[ "name": "Abdul", "isSelected": false], ["name": "Amit", "isSelected": false], ["name": "John", "isSelected": false], ["name": "Karim", "isSelected": false], ["name": "Prashant", "isSelected": false]]
    }

    var regionData: [[String: Any]] {
        return [["name": "India", "isSelected": false], ["name": "Thailand", "isSelected": false], ["name": "Japan", "isSelected": false], ["name": "London", "isSelected": false], ["name": "Spain", "isSelected": false], ["name": "Italy", "isSelected": false]]
    }

    var marketData: [[String: Any]] {
        return [["name": "TSS", "isSelected": false], ["name": "KTT", "isSelected": false], ["name": "JTB", "isSelected": false], ["name": "JTC", "isSelected": false], ["name": "JKK", "isSelected": false]]
    }

    var salesPICData: [[String: Any]] {
        return [["name": "Amar", "isSelected": false], ["name": "Amit", "isSelected": false], ["name": "Sushma", "isSelected": false], ["name": "Gurcharan", "isSelected": false], ["name": "Mandeep", "isSelected": false], ["name": "Neeraj", "isSelected": false], ["name": "Nisha", "isSelected": false], ["name": "Neha", "isSelected": false], ["name": "Chanchal", "isSelected": false]]
    }

    var filterData: [String: Any] {
        return ["calendarData": calendarData, "clientData": clientData, "regionData": regionData, "marketData": marketData, "salesPICData": salesPICData]
    }

}

extension BISFilterVC: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gesture.translation(in: self.view!)
            let verticalMovement = translation.y / self.view.bounds.height
            if verticalMovement <= 0 && translation.y <= 0 {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}
