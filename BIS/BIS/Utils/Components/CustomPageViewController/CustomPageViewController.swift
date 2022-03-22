//
//  CustomPageViewController.swift
//  BIS
//
//  Created by TSSIOS on 03/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

 class CustomPageViewController: CustomNavigationController {

    open var isInfinity: Bool = false
    open var option: CustomPageOption = CustomPageOption()
    open var pageItems: [(viewController: UIViewController, title: String)] = []
     public let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var contentView = UIView()

    var currentIndex: Int? {
        guard let viewController = pageController.viewControllers?.first else {
            return nil
        }

        return pageItems.map { $0.viewController }.firstIndex(of: viewController)
    }

    fileprivate var beforeIndex: Int = 0
    fileprivate var tabItemsCount: Int {
        return pageItems.count
    }
    fileprivate var defaultContentOffsetX: CGFloat {
        return self.view.bounds.width
    }
    fileprivate var shouldScrollCurrentBar: Bool = true
    lazy var tabView: TabView = self.configuredTabView()
    lazy fileprivate var containerPageView: UIView = self.configuredPageController()
    fileprivate var statusView: UIView?
    fileprivate var statusViewHeightConstraint: NSLayoutConstraint?
    fileprivate var tabBarTopConstraint: NSLayoutConstraint?

    public init(pages: [(viewController: UIViewController, title: String)]) {
        super.init(nibName: nil, bundle: nil)
        self.pageItems = pages
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setupPageViewController()
            self.setupScrollView()
        }

        updateNavigationBar()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if tabView.superview == nil {
            tabView = configuredTabView()
        }

        if containerPageView.superview == nil {
            containerPageView = configuredPageController()
        }

        if let currentIndex = currentIndex, isInfinity {
            tabView.updateCurrentIndex(currentIndex, shouldScroll: true)
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationBar()
        tabView.layouted = true
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if tabView.collectionView != nil {
            if !isInfinity {
                option.tabWidth = UIScreen.main.bounds.width/CGFloat(pageItems.count)
            }
            tabView.collectionView.collectionViewLayout.invalidateLayout()
            tabView.collectionView.layoutIfNeeded()
        }
    }
}

// MARK: - Public Interface

 extension CustomPageViewController {

    public func displayControllerWithIndex(_ index: Int, direction: UIPageViewController.NavigationDirection, animated: Bool) {

        beforeIndex = index
        shouldScrollCurrentBar = false

        let nextViewControllers: [UIViewController] = [pageItems[index].viewController]

        let completion: ((Bool) -> Void) = { [weak self] _ in
            self?.shouldScrollCurrentBar = true
            self?.beforeIndex = index
        }

        pageController.setViewControllers(
            nextViewControllers,
            direction: direction,
            animated: animated,
            completion: completion)

        guard isViewLoaded else { return }
        tabView.updateCurrentIndex(index, shouldScroll: true)
    }
}

// MARK: - View

extension CustomPageViewController {

    fileprivate func setupPageViewController() {
        pageController.delegate = self
        pageController.dataSource = self
        if pageItems.count > 0 {
            pageController.setViewControllers([pageItems[beforeIndex].viewController],
            direction: .forward,
            animated: false,
            completion: nil)
        }

    }

    fileprivate func setupScrollView() {
        // Disable PageViewController's ScrollView bounce
        let scrollView = pageController.view.subviews.compactMap { $0 as? UIScrollView }.first
        scrollView?.contentInsetAdjustmentBehavior = .never
        scrollView?.automaticallyAdjustsScrollIndicatorInsets = true
        scrollView?.scrollsToTop = false
        scrollView?.delegate = self
        scrollView?.backgroundColor = option.pageBackgoundColor
    }

    /**
     Update NavigationBar
     */

    fileprivate func updateNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(option.tabBackgroundImage, for: .default)
            navigationBar.isTranslucent = option.isTranslucent
        }
    }

    fileprivate func configuredPageController() -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.lightGray
        view.addSubview(contentView)

        let top = NSLayoutConstraint(item: contentView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: tabView,
                                     attribute: .bottom,
                                     multiplier: 1.0,
                                     constant: 0.0)

        var contentViewConstraints = [top]
        var abc = self.getConstraint(itemView: contentView, toItemView: view)
        abc.removeFirst()
        contentViewConstraints.append(contentsOf: abc)

        view.addConstraints(contentViewConstraints)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(pageController)
        contentView.addSubview(pageController.view)

        let pageControllerConstraints = self.getConstraint(itemView: pageController.view!, toItemView: contentView)
        contentView.addConstraints(pageControllerConstraints)

        return contentView
    }

    fileprivate func configuredTabView() -> TabView {
        let tabView = TabView(isInfinity: isInfinity, option: option)
        tabView.translatesAutoresizingMaskIntoConstraints = false

        let height = NSLayoutConstraint(item: tabView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: option.tabHeight)
        tabView.addConstraint(height)
        view.addSubview(tabView)

        var constraints = getConstraint(itemView: tabView, toItemView: self.view!)
        constraints.removeLast()

        view.addConstraints(constraints)

        tabView.pageTabItems = pageItems.map({ $0.title})
        tabView.updateCurrentIndex(beforeIndex, shouldScroll: true)

        tabView.pageItemPressedBlock = { [weak self] (index: Int, direction: UIPageViewController.NavigationDirection) in
            self?.displayControllerWithIndex(index, direction: direction, animated: true)
        }

        tabBarTopConstraint = constraints.first

        return tabView
    }

    func getConstraint(itemView: UIView, toItemView: UIView) -> [NSLayoutConstraint] {
        let top = NSLayoutConstraint(item: itemView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: toItemView,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 0.0)

        let left = NSLayoutConstraint(item: itemView,
                                      attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: toItemView,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: 0.0)

        let right = NSLayoutConstraint(item: toItemView,
                                       attribute: .trailing,
                                       relatedBy: .equal,
                                       toItem: itemView,
                                       attribute: .trailing,
                                       multiplier: 1.0,
                                       constant: 0.0)

        let bottom = NSLayoutConstraint(item: itemView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: toItemView,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: 0.0)

        return [top, left, right, bottom]
    }

    private func setupStatusView() {
        let statusView = UIView()
        statusView.backgroundColor = option.tabBackgroundColor
        statusView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)

//        let top = NSLayoutConstraint(item: statusView,
//                                     attribute: .top,
//                                     relatedBy: .equal,
//                                     toItem: view,
//                                     attribute: .top,
//                                     multiplier: 1.0,
//                                     constant: 0.0)
//
//        let left = NSLayoutConstraint(item: statusView,
//                                      attribute: .leading,
//                                      relatedBy: .equal,
//                                      toItem: view,
//                                      attribute: .leading,
//                                      multiplier: 1.0,
//                                      constant: 0.0)
//
//        let right = NSLayoutConstraint(item: view,
//                                       attribute: .trailing,
//                                       relatedBy: .equal,
//                                       toItem: statusView,
//                                       attribute: .trailing,
//                                       multiplier: 1.0,
//                                       constant: 0.0)

        var constraints = self.getConstraint(itemView: statusView, toItemView: self.view!)
        constraints.removeLast()

        let height = NSLayoutConstraint(item: statusView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: self.view.safeAreaInsets.top)
        constraints.append(height)

        view.addConstraints(constraints)

        statusViewHeightConstraint = height
        self.statusView = statusView
    }

    public func updateNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        guard let navigationController = navigationController else { return }

        switch option.hidesTopViewOnSwipeType {
        case .tabBar:
            tabBarTopConstraint?.constant = 0.0
            updateTabBarOrigin(hidden: hidden)
        case .navigationBar:
            if hidden {
                navigationController.setNavigationBarHidden(true, animated: true)
            } else {
                showNavigationBar()
            }
        case .all:
            updateTabBarOrigin(hidden: hidden)
            if hidden {
                navigationController.setNavigationBarHidden(true, animated: true)
            } else {
                showNavigationBar()
            }
        default:
            break
        }
        if statusView == nil {
            setupStatusView()
        }

        statusViewHeightConstraint!.constant = self.view.safeAreaInsets.top
    }

    public func showNavigationBar() {
        guard let navigationController = navigationController else { return }
        guard navigationController.isNavigationBarHidden  else { return }
        guard let tabBarTopConstraint = tabBarTopConstraint else { return }

        if option.hidesTopViewOnSwipeType != .none {
            tabBarTopConstraint.constant = 0.0
            UIView.animate(withDuration: TimeInterval(UINavigationController.hideShowBarDuration)) {
                self.view.layoutIfNeeded()
            }
        }

        navigationController.setNavigationBarHidden(false, animated: true)

    }

    private func updateTabBarOrigin(hidden: Bool) {
        guard let tabBarTopConstraint = tabBarTopConstraint else { return }

        tabBarTopConstraint.constant = hidden ? -(20.0 + option.tabHeight) : 0.0
        UIView.animate(withDuration: TimeInterval(UINavigationController.hideShowBarDuration)) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension CustomPageViewController: UIPageViewControllerDataSource {

    fileprivate func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {

        guard var index = pageItems.map({$0.viewController}).firstIndex(of: viewController) else {
            return nil
        }

        if index == 0 && !isAfter {
            return nil
        } else if index == pageItems.count - 1 && isAfter {
            return nil
        }

        if isAfter {
            index += 1
        } else {
            index -= 1
        }

        if isInfinity {
            if index < 0 {
                index = pageItems.count - 1
            } else if index == pageItems.count {
                index = 0
            }
        }

        if index >= 0 && index < pageItems.count {
           return pageItems[index].viewController
        }
        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        return nextViewController(viewController, isAfter: true)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: false)
    }
}

// MARK: - UIPageViewControllerDelegate

extension CustomPageViewController: UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        shouldScrollCurrentBar = true
        tabView.scrollToHorizontalCenter()

        // Order to prevent the the hit repeatedly during animation
        tabView.updateCollectionViewUserInteractionEnabled(false)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let currentIndex = currentIndex, currentIndex < tabItemsCount {
            tabView.updateCurrentIndex(currentIndex, shouldScroll: false)
            beforeIndex = currentIndex
        }

        tabView.updateCollectionViewUserInteractionEnabled(true)
    }
}

// MARK: - UIScrollViewDelegate

extension CustomPageViewController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.x == defaultContentOffsetX || !shouldScrollCurrentBar {
            return
        }

        // (0..<tabItemsCount)
        var index: Int
        if scrollView.contentOffset.x > defaultContentOffsetX {
            index = beforeIndex + 1
        } else {
            index = beforeIndex - 1
        }

        if index == tabItemsCount {
            index = 0
        } else if index < 0 {
            index = tabItemsCount - 1
        }

        let scrollOffsetX = scrollView.contentOffset.x - view.frame.width
        tabView.scrollCurrentBarView(index, contentOffsetX: scrollOffsetX)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabView.updateCurrentIndex(beforeIndex, shouldScroll: true)
    }
}
