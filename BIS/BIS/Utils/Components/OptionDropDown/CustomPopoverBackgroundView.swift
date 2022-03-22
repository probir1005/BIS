//
//  CustomPopoverBackgroundView.swift
//  BIS
//
//  Created by TSSIT on 04/08/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

enum PopoverBackgroundImageType {
    case none
    case arrowUp
    case arrowUpRight
    case arrowDown
    case arrowDownRight
    case downRight
    case arrowSide
    case arrowSideTop
    case arrowSideBottom
}

struct PopoverExtents {
    var left: CGFloat
    var right: CGFloat
    var top: CGFloat
    var bottom: CGFloat
}

class CustomBackgroundView: UIPopoverBackgroundView {
    private static let kPopoverArrowWidth: CGFloat = 30 // Returned by +arrowBase, irrespective of orientation. The length of the base of the arrow's triangle.
    private static let kPopoverArrowHeight: CGFloat = 19.0 // Returned by +arrowHeight, irrespective of orientation. The height of the arrow from base to tip.
    private let kPopoverCornerRadius: CGFloat = 4.0 // Used in a bounds check to determine if the arrow is too close to the popover's edge.
    private let kSideArrowCenterOffset: CGFloat = 4.0 // Added to the arrow's center for ...Side.png image to account for the taller top half.

    /// Content and background insets.
    private static let kPopoverEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0) // Distance between the edge of the background view and the edge of the content view.

    private let kArrowUpInsets = UIEdgeInsets(top: 41.0, left: 9.0, bottom: 9.0, right: 47.0)
    private let kArrowUpRightInsets = UIEdgeInsets(top: 41.0, left: 9.0, bottom: 9.0, right: 42.0)
    private let kArrowDownInsets = UIEdgeInsets(top: 23.0, left: 9.0, bottom: 27.0, right: 47.0)
    private let kArrowDownRightInsets = UIEdgeInsets(top: 23.0, left: 9.0, bottom: 27.0, right: 42.0)
    private let kArrowSideInsets = UIEdgeInsets(top: 24.0, left: 9.0, bottom: 47.0, right: 27.0)
    private let kArrowSideTopInsets = UIEdgeInsets(top: 43.0, left: 9.0, bottom: 23.0, right: 27.0)
    private let kArrowSideBottomInsets = UIEdgeInsets(top: 23.0, left: 9.0, bottom: 43.0, right: 27.0)

    private let kSecondHalfBottomInset: CGFloat = 9.0 // Value for .bottom inset in the second half of a two-part vertical stretch operation.
    private let kSecondHalfRightInset: CGFloat = 9.0 // Value for .right inset in the seconf half of a two-part horizontal stretch operation.

    private var popoverExtents: PopoverExtents?
    private var halfBase: CGFloat = 0.0
    private var arrowCenter: CGFloat = 0.0
    private var popoverBackground: UIImageView
    private var offset: CGFloat = 0.0
    private var direction: UIPopoverArrowDirection = .init(rawValue: 0)
    static var isShowArrow = true
    
    override var arrowOffset: CGFloat {
        get {
            return offset
        }
        set {
            offset = newValue
            setNeedsLayout()

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let popoverCornerRadius = self.popoverCornerRadius()
        popoverExtents = PopoverExtents.init(left: self.bounds.minX + popoverCornerRadius, right: self.bounds.maxX - popoverCornerRadius, top: self.bounds.minY + popoverCornerRadius, bottom: self.bounds.maxY - popoverCornerRadius)

        halfBase = halfArrowBase()
        arrowCenter = popoverArrowCenter()

        popoverBackground.center = center
        popoverBackground.bounds = bounds

        if arrowDirection == .init(rawValue: 0) {
            self.backgroundColor = .white
            self.layer.cornerRadius = 4.0
        } else {
            popoverBackground.image = wantsUpOrDownArrow() ? upOrDownArrowImage() : sideArrowImage()
        }
    }

    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return direction
        }
        set {
            direction = newValue
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        popoverBackground = UIImageView.init(frame: CGRect.init(origin: .zero, size: frame.size))
        super.init(frame: frame)
        addSubview(popoverBackground)
        self.addShadow(offset: CGSize(width: 0, height: 3), color: .shadow, opacity: 1.0, radius: 4.0)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return kPopoverEdgeInsets
    }
    
    override class func arrowBase() -> CGFloat {
        return kPopoverArrowWidth
    }
    
    override class func arrowHeight() -> CGFloat {
        return isShowArrow ? kPopoverArrowHeight : CGFloat.zero
    }
    
    func halfArrowBase() -> CGFloat {
        return Self.arrowBase()/2.0
    }

    func upOrDownArrowImage() -> UIImage? {
        var imageType: PopoverBackgroundImageType
        var insets: UIEdgeInsets
        let wantsUpArrow = self.wantsUpArrow()

        if isArrowBetweenLeftAndRightEdgesOfPopover() {     // side arrow(not in center)
            imageType = (wantsUpArrow) ? .arrowUp : .arrowDown
            insets = (wantsUpArrow) ? arrowUpInsets() : arrowDownInsets()
            return twoPartStretchableImage(with: imageType, insets: insets)
        } else {
            imageType = (wantsUpArrow) ? .arrowUpRight : .arrowDownRight
            insets = (wantsUpArrow) ? arrowUpRightInsets() : arrowDownRightInsets()
            return stretchableImage(with: imageType, insets: insets, mirrored: isArrowAtLeftEdgeOfPopover())
        }
    }
 
    func sideArrowImage() -> UIImage? {
        adjustCentersIfNecessary()

        if isArrowBetweenTopAndBottomEdgesOfPopover() {
            return twoPartStretchableImage(with: .arrowSide, insets: arrowSideInsets())
        } else {
            let imageType = isArrowAtTopEdgeOfPopover() ? PopoverBackgroundImageType.arrowSideTop : PopoverBackgroundImageType.arrowSideBottom
            let insets = isArrowAtTopEdgeOfPopover() ? arrowSideTopInsets() : arrowSideBottomInsets()
            return stretchableImage(with: imageType, insets: insets, mirrored: (arrowDirection == UIPopoverArrowDirection.left))
        }
    }
    
    func popoverArrowCenter() -> CGFloat {
        let mid = (wantsUpOrDownArrow()) ? bounds.midX : bounds.midY
        return mid + arrowOffset
    }

    func wantsUpOrDownArrow() -> Bool {
        return wantsUpArrow() || arrowDirection == UIPopoverArrowDirection.down
    }

    func wantsUpArrow() -> Bool {
        return arrowDirection == UIPopoverArrowDirection.up
    }

    func isArrowBetweenLeftAndRightEdgesOfPopover() -> Bool {
        return !isArrowAtRightEdgeOfPopover() && !isArrowAtLeftEdgeOfPopover()
    }

    func isArrowAtLeftEdgeOfPopover() -> Bool {
        return arrowCenter - halfBase < popoverExtents!.left
    }

    func isArrowAtRightEdgeOfPopover() -> Bool {
        return arrowCenter + halfBase > popoverExtents!.right
    }

    func isArrowBetweenTopAndBottomEdgesOfPopover() -> Bool {
        return !isArrowAtTopEdgeOfPopover() && !isArrowAtBottomEdgeOfPopover()
    }
    
    func isArrowAtTopEdgeOfPopover() -> Bool {
        return arrowCenter - halfBase < popoverExtents!.top
    }

    func isArrowAtBottomEdgeOfPopover() -> Bool {
        return arrowCenter + halfBase > popoverExtents!.bottom
    }

    func adjustCentersIfNecessary() {
        // fix centers of left-pointing popovers so that their shadows are drawn correctly.   
        if arrowDirection == UIPopoverArrowDirection.left {
            center = CGPoint(x: center.x + CustomBackgroundView.arrowHeight(), y: center.y)
            popoverBackground.center = CGPoint(x: popoverBackground.center.x - CustomBackgroundView.arrowHeight(), y: popoverBackground.center.y)
        }
    }
    
    // MARK: - Sizing and Insets
    func popoverCornerRadius() -> CGFloat {
        return kPopoverCornerRadius
    }

    func sideArrowCenterOffset() -> CGFloat {
        return kSideArrowCenterOffset
    }

    func arrowUpInsets() -> UIEdgeInsets {
        return kArrowUpInsets
    }

    func arrowUpRightInsets() -> UIEdgeInsets {
        return kArrowUpRightInsets
    }

    func arrowDownInsets() -> UIEdgeInsets {
        return kArrowDownInsets
    }

    func arrowDownRightInsets() -> UIEdgeInsets {
        return kArrowDownRightInsets
    }

    func arrowSideInsets() -> UIEdgeInsets {
        return kArrowSideInsets
    }

    func arrowSideTopInsets() -> UIEdgeInsets {
        return kArrowSideTopInsets
    }

    func arrowSideBottomInsets() -> UIEdgeInsets {
        return kArrowSideBottomInsets
    }

    func secondHalfBottomInset() -> CGFloat {
        return kSecondHalfBottomInset
    }

    func secondHalfRightInset() -> CGFloat {
        return kSecondHalfRightInset
    }

    // MARK: - Stretching

    func stretchableImage(with imageType: PopoverBackgroundImageType, insets: UIEdgeInsets, mirrored: Bool) -> UIImage? {
        var image: UIImage?
        
        switch imageType {
        case .arrowDown:
            image = arrowDownImage()
        case .arrowDownRight:
            image = arrowDownRightImage()
        case .arrowSide:
            image = arrowSideImage()
        case .arrowSideBottom:
            image = arrowSideBottomImage()
        case .arrowSideTop:
            image = arrowSideTopImage()
        case .arrowUp:
            image = arrowUpImage()
        case .arrowUpRight:
            image = arrowUpRightImage()
        default:
            break
        }

        return (mirrored) ? mirroredImage(image)?.resizableImage(withCapInsets: mirroredInsets(insets)) : image?.resizableImage(withCapInsets: insets)
    }
    
    func twoPartStretchableImage(with imageType: PopoverBackgroundImageType, insets: UIEdgeInsets) -> UIImage? {
        var insets = insets
        var image: UIImage?

        switch imageType {
        case .arrowDown:
            image = arrowDownImage()
        case .arrowDownRight:
            image = arrowDownRightImage()
        case .arrowSide:
            image = arrowSideImage()
        case .arrowSideBottom:
            image = arrowSideBottomImage()
        case .arrowSideTop:
            image = arrowSideTopImage()
        case .arrowUp:
            image = arrowUpImage()
        case .arrowUpRight:
            image = arrowUpRightImage()
        default:
            break
        }

        if arrowDirection == UIPopoverArrowDirection.left {
            image = mirroredImage(image)
            insets = mirroredInsets(insets)
        }
        let firstHalfImage = image?.resizableImage(withCapInsets: insets)
        let stretchedImage = imageFromImageContext(withSourceImage: firstHalfImage, size: contextSize(forFirstHalfImage: image))
        return stretchedImage?.resizableImage(withCapInsets: secondHalfInsets(forStretchedImage: stretchedImage, insets: insets))

    }
    
    func firstHalfStretchAmount(for image: UIImage?) -> CGFloat {
        
        let val: CGFloat
        
        if wantsUpOrDownArrow() {
            val = arrowCenter + ((image?.size.width ?? 0.0) - 1) / 2.0
        } else {
            val = arrowCenter + ((image?.size.height ?? 0.0) / 2) - 1 - sideArrowCenterOffset()
        }
        
        return val
//        return CGFloat(roundf(Float(wantsUpOrDownArrow() ? arrowCenter + ((image?.size.width ?? 0.0) - 1) / 2.0 : arrowCenter + ((image?.size.height ?? 0.0) / 2) - 1 - sideArrowCenterOffset())))
    }

    func contextSize(forFirstHalfImage image: UIImage?) -> CGSize {
        let stretch = firstHalfStretchAmount(for: image)
        return wantsUpOrDownArrow() ? CGSize(width: stretch, height: image?.size.height ?? 0.0) : CGSize(width: image?.size.width ?? 0.0, height: stretch)
    }

    func secondHalfInsets(forStretchedImage stretchedImage: UIImage?, insets: UIEdgeInsets) -> UIEdgeInsets {
        return wantsUpOrDownArrow() ? horizontalInsets(forStretchedImage: stretchedImage, insets: insets) : verticalInsets(forStretchedImage: stretchedImage, insets: insets)
    }
    
    func horizontalInsets(forStretchedImage stretchedImage: UIImage?, insets: UIEdgeInsets) -> UIEdgeInsets {
        let secondHalfRightInset = self.secondHalfRightInset()
        let edgeInsets = UIEdgeInsets(top: insets.top, left: (stretchedImage?.size.width ?? 0.0) - (secondHalfRightInset + 1), bottom: insets.bottom, right: secondHalfRightInset)
        return edgeInsets
    }

    func verticalInsets(forStretchedImage stretchedImage: UIImage?, insets: UIEdgeInsets) -> UIEdgeInsets {
        let secondHalfBottomInset = self.secondHalfBottomInset()
        let edgeInsets = UIEdgeInsets(top: (stretchedImage?.size.height ?? 0.0) - (secondHalfBottomInset + 1), left: insets.left, bottom: secondHalfBottomInset, right: insets.right)
        return edgeInsets
    }

    func mirroredImage(_ image: UIImage?) -> UIImage? {
        var mirror: UIImage?
        if let CGImage = image?.cgImage {
            mirror = UIImage(cgImage: CGImage, scale: UIScreen.main.scale, orientation: .upMirrored)
        }
        return imageFromImageContext(withSourceImage: mirror, size: mirror?.size ?? .zero)
    }

    func mirroredInsets(_ insets: UIEdgeInsets) -> UIEdgeInsets {
        // Swap left and right insets for a mirrored image.
        return UIEdgeInsets(top: insets.top, left: insets.right, bottom: insets.bottom, right: insets.left)
    }

    func imageFromImageContext(withSourceImage image: UIImage?, size: CGSize) -> UIImage? {
        // Stretching/tiling only takes place when the image is drawn, so the mirrored or stretched image is first drawn into a context before applying additional stretching.
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image?.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    // MARK: - Image Generation
    
    func drawUpArrowPopoverImage(in path: CGMutablePath?, with transform: CGAffineTransform = .identity) {
        path?.move(to: CGPoint(x: 28, y: 0), transform: transform)
        path?.addLine(to: CGPoint(x: 43, y: 19), transform: transform)
        path?.addLine(to: CGPoint(x: 51, y: 19), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 57, y: 19), tangent2End: CGPoint(x: 57, y: 23), radius: 4, transform: transform)
        path?.addLine(to: CGPoint(x: 57, y: 45), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 57, y: 51), tangent2End: CGPoint(x: 51, y: 51), radius: 4, transform: transform)
        path?.addLine(to: CGPoint(x: 5, y: 51), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 0, y: 51), tangent2End: CGPoint(x: 0, y: 45), radius: 4, transform: transform)
        path?.addLine(to: CGPoint(x: 0, y: 23), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 0, y: 19), tangent2End: CGPoint(x: 5, y: 19), radius: 4, transform: transform)
        path?.addLine(to: CGPoint(x: 13, y: 19), transform: transform)
        path?.closeSubpath()

    }
    
    func drawUpRightArrowPopoverImage(in path: CGMutablePath?, with transform: CGAffineTransform = .identity) {
        path?.move(to: CGPoint(x: 28, y: 1), transform: transform)
        path?.addLine(to: CGPoint(x: 46, y: 19), transform: transform)
        path?.addCurve(to: CGPoint(x: 50, y: 26), control1: CGPoint(x: 49, y: 21), control2: CGPoint(x: 50, y: 23), transform: transform)
        path?.addLine(to: CGPoint(x: 50, y: 42), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 50, y: 49), tangent2End: CGPoint(x: 43, y: 49), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 8, y: 49), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 1, y: 49), tangent2End: CGPoint(x: 1, y: 42), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 1, y: 26), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 1, y: 19), tangent2End: CGPoint(x: 8, y: 19), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 10, y: 19), transform: transform)
        path?.closeSubpath()

    }
    
    func drawSideArrowPopoverImage(in path: CGMutablePath?, with transform: CGAffineTransform = .identity) {
        path?.move(to: CGPoint(x: 35, y: 43), transform: transform)
        path?.addLine(to: CGPoint(x: 17, y: 61), transform: transform)
        path?.addLine(to: CGPoint(x: 17, y: 63), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 17, y: 70), tangent2End: CGPoint(x: 10, y: 70), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 8, y: 70), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 1, y: 70), tangent2End: CGPoint(x: 1, y: 63), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 1, y: 8), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 1, y: 1), tangent2End: CGPoint(x: 8, y: 1), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 10, y: 1), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 17, y: 1), tangent2End: CGPoint(x: 17, y: 8), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 17, y: 25), transform: transform)
        path?.closeSubpath()

    }

    func drawSideBottomArrowPopoverImage(in path: CGMutablePath?, with transform: CGAffineTransform = .identity) {
        path?.move(to: CGPoint(x: 35, y: 43), transform: transform)
        path?.addLine(to: CGPoint(x: 17, y: 61), transform: transform)
        path?.addCurve(to: CGPoint(x: 10, y: 65), control1: CGPoint(x: 15, y: 64), control2: CGPoint(x: 13, y: 65), transform: transform)
        path?.addLine(to: CGPoint(x: 8, y: 65), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 1, y: 65), tangent2End: CGPoint(x: 1, y: 58), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 1, y: 8), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 1, y: 1), tangent2End: CGPoint(x: 8, y: 1), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 10, y: 1), transform: transform)
        path?.addArc(tangent1End: CGPoint(x: 17, y: 1), tangent2End: CGPoint(x: 17, y: 8), radius: 7, transform: transform)
        path?.addLine(to: CGPoint(x: 17, y: 25), transform: transform)
        path?.closeSubpath()
        
    }
    
    // Subclass can override these methods to provide custom artwork
    func arrowUpImage() -> UIImage? {
        let path = CGMutablePath()

        drawUpArrowPopoverImage(in: path)
        let image = self.image(for: path, with: CGSize(width: 57, height: 51))
        return image
    }

    func arrowUpRightImage() -> UIImage? {
        let path = CGMutablePath()

        drawUpRightArrowPopoverImage(in: path)
        let image = self.image(for: path, with: CGSize(width: 52, height: 51))
        return image
    }
    
    func arrowDownImage() -> UIImage? {
        let path = CGMutablePath()
        let flip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 51)

        drawUpArrowPopoverImage(in: path, with: flip)
        let image = self.image(for: path, with: CGSize(width: 57, height: 51))
        return image
    }

    func arrowDownRightImage() -> UIImage? {
        let path = CGMutablePath()
        let flip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 51)

        drawUpRightArrowPopoverImage(in: path, with: flip)
        let image = self.image(for: path, with: CGSize(width: 52, height: 51))
        return image
    }
    
    func arrowSideImage() -> UIImage? {
        let path = CGMutablePath()

        drawSideArrowPopoverImage(in: path)
        let image = self.image(for: path, with: CGSize(width: 37, height: 72))
        return image
    }

    func arrowSideTopImage() -> UIImage? {
        let path = CGMutablePath()
        let flip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 67)

        drawSideBottomArrowPopoverImage(in: path, with: flip)
        let image = self.image(for: path, with: CGSize(width: 37, height: 67))
        return image
    }
    
    func arrowSideBottomImage() -> UIImage? {
        let path = CGMutablePath()

        drawSideBottomArrowPopoverImage(in: path)
        let image = self.image(for: path, with: CGSize(width: 37, height: 67))
        return image
    }

    func image(for path: CGPath?, with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw a gradient
        if let path = path {
            context?.addPath(path)
        }
        context?.clip()
        
        // Draw the border
        popoverBorderColor()?.setStroke()
        context?.addPath(path!)
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillPath()
        context?.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    func popoverBorderColor() -> UIColor? {
        return UIColor.black
    }

}
