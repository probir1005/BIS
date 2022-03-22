//
//  View+AddOns.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addshadow (top: Bool, left: Bool, bottom: Bool, right: Bool, shadowRadius: CGFloat = 5, color: UIColor, hide: Bool) {

        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = hide ? 0.0 : 1.0
        self.layer.shadowColor = color.cgColor

        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if !top {
            y += (shadowRadius+1)
        }
        if !bottom {
            viewHeight -= (shadowRadius+1)
        }
        if !left {
            x += (shadowRadius+1)
        }
        if !right {
            viewWidth -= (shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }

    static var hasSafeArea: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        } else {
         return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }

    class var hasBottomSafeAreaInsets: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with home indicator: 34.0 on iPhone X, XS, XS Max, XR.
            // with home indicator: 20.0 on iPad Pro 12.9" 3rd generation.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }

    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    @discardableResult 
    func loadNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            // Shadow is not working because of this
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable
       var shadowRadius: CGFloat {
           get {
               return layer.shadowRadius
           }
           set {
               layer.shadowRadius = newValue
           }
       }

       @IBInspectable
       var shadowOpacity: Float {
           get {
               return layer.shadowOpacity
           }
           set {
               layer.shadowOpacity = newValue
           }
       }

       @IBInspectable
       var shadowOffset: CGSize {
           get {
               return layer.shadowOffset
           }
           set {
               layer.shadowOffset = newValue
           }
       }

       @IBInspectable
       var shadowColor: UIColor? {
           get {
               if let color = layer.shadowColor {
                   return UIColor(cgColor: color)
               }
               return nil
           }
           set {
               if let color = newValue {
                   layer.shadowColor = color.cgColor
               } else {
                   layer.shadowColor = nil
               }
           }
       }

    func addShadow() {
        layer.cornerRadius = 5.0

        layer.shadowColor = UIColor.shadow.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.clear.cgColor
    }

    func addShadow(location: VerticalLocation, color: UIColor = UIColor.shadow, opacity: Float = 0.2, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -5), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }

    func insertHorizontalGradient(_ color1: UIColor, _ color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [color1.cgColor, color1.cgColor, color2.cgColor]
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    var leadingConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .leading && $0.relation == .equal
            })
        }
        set { 
            setNeedsLayout() 
            _ = newValue
        }
    }

    var trailingConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .trailing && $0.relation == .equal
            })
        }
        set { 
            setNeedsLayout() 
            _ = newValue
        }
    }

    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { 
            setNeedsLayout() 
            _ = newValue
        }
    }

    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { 
            setNeedsLayout() 
            _ = newValue
        }
    }
    
    // Not in use
    func copyView<T: UIView>() -> T? {
        
        if let archived = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) {
            
            let records = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archived) as? T
            return records
        }

        return nil
    }

    var safeAreaHeight: CGFloat {
         if #available(iOS 11, *) {
          return safeAreaLayoutGuide.layoutFrame.size.height
         }
         return bounds.height
    }

    var safeAreaWidth: CGFloat {
         if #available(iOS 11, *) {
          return safeAreaLayoutGuide.layoutFrame.size.width
         }
         return bounds.width
    }
    
    static func getOverlay() -> UIView {
        let overlayView = UIView()
        overlayView.frame = UIScreen.main.bounds
        overlayView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        overlayView.clipsToBounds = true
        
        return overlayView
    } 
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}
