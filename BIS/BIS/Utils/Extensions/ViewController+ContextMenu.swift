//
//  ViewController+ContextMenu.swift
//  BIS
//
//  Created by TSSIT on 30/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

extension UIPopoverPresentationControllerDelegate where Self: UIViewController {
    
    func addContextMenu(with list: [PopoverOptionModel], frame: CGRect, showArrow: Bool = true, width: CGFloat? = nil) {
        
        let popoverContentController = ContextMenuVC()
        popoverContentController.optionList = list
        popoverContentController.modalPresentationStyle = .popover
        let width = width ?? getMaxWidth(with: list)
        let height = CGFloat(list.count) * ContextMenuVC.cellHeight
        let size = CGSize(width: width, height: height-2)
        popoverContentController.preferredContentSize = size
        popoverContentController.delegate = self as? OptionDropDownViewDelegate 
        let arrowDirection: UIPopoverArrowDirection = showArrow ? (view.bounds.height > (frame.maxY + height + 19) ? .up : .down) : .init(rawValue: 0)
        
        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = arrowDirection
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = showArrow ? frame : CGRect(x: frame.origin.x, y: frame.midY + height/2, width: frame.width, height: frame.height)
            popoverPresentationController.delegate = self
            CustomBackgroundView.isShowArrow = showArrow
            popoverPresentationController.popoverBackgroundViewClass = CustomBackgroundView.self
            present(popoverContentController, animated: true, completion: nil)
        }
    }

    private func getMaxWidth(with list: [PopoverOptionModel]) -> CGFloat {
        var width: CGFloat = 0
        for element in list {
            let font = BISFont.h18.regular
            let newWidth = element.title.width(withConstrainedHeight: ContextMenuVC.cellHeight, font: font)
            width = (newWidth > width) ? newWidth : width
        }
        
        return width + 75
    }
    
    func getFrameFromParent(_ subview: UIView) -> CGRect {
        return view.convert(subview.frame, to: view)
    }
}
