//
//  UIView+Shadow+Corner.swift
//  UIViewExtension
//
//  Created by Prince Mathew on 07/05/20.
//  Copyright © 2020 Prince Mathew. All rights reserved.
//

import UIKit

extension UIView {
    
    enum ShadowPosition: Int {
        case topBottom
        case leftRight
        case topLeftRight
        case bottomLeftRight
        case all
    }
    
    func addShadowWith(shadowColor: UIColor,
                   offSet: CGSize,
                   opacity: Float,
                   shadowRadius: CGFloat,
                   shadowSides: ShadowPosition,
                   fillColor: UIColor = .white,
                   radius: CGFloat = 0,
                   corners: UIRectCorner = [.bottomRight,.bottomLeft]) {
        DispatchQueue.main.async {
            self.addCornersWith(radius: radius,
                            corners: corners)
            
            if let sublayer = self.layer.sublayers?.first(where: {$0.name == "SHADOW_LAYER"}) {
                sublayer.removeFromSuperlayer()
            }
            let shadowLayer = self.getShadowLayer(shadowColor: shadowColor,
                                                  offSet: offSet,
                                                  opacity: opacity,
                                                  shadowradius: shadowRadius,
                                                  shadowSides: shadowSides,
                                                  fillColor: fillColor,
                                                  radius: radius,
                                                  corners: corners)
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func addRoundedCorner(with radius: CGFloat,at corners: UIRectCorner) {
        DispatchQueue.main.async {
            self.addCornersWith(radius: radius,
            corners: corners)
        }
    }
    
    fileprivate func addCornersWith(radius: CGFloat,
                        corners:UIRectCorner) {
        self.cornerRadius = radius
        guard radius > 0 else {
            self.layer.maskedCorners = []
            return
        }
        var maskedCorners = CACornerMask()
        if corners.contains(.allCorners) {
            maskedCorners = [.layerMinXMinYCorner,
                             .layerMaxXMinYCorner,
                             .layerMinXMaxYCorner,
                             .layerMaxXMaxYCorner]
        } else {
            if corners.contains(.topLeft){
                maskedCorners.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.topRight){
                maskedCorners.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.bottomLeft){
                maskedCorners.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight){
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
        }
        self.layer.maskedCorners = maskedCorners
    }
    
    fileprivate func getShadowLayer(shadowColor: UIColor,
                                offSet: CGSize,
                                opacity: Float,
                                shadowradius: CGFloat,
                                shadowSides: ShadowPosition,
                                fillColor: UIColor = .white,
                                radius: CGFloat = 0,
                                corners: UIRectCorner = [.bottomRight,.bottomLeft]) -> CALayer {
        let shadowLayer: CAShapeLayer = CAShapeLayer()
        let size: CGSize = CGSize(width: radius, height: radius)
        let layerPath: UIBezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        shadowLayer.path = layerPath.cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.name = "SHADOW_LAYER"
        
        let _offset: CGFloat = radius
        let maxX: CGFloat = self.frame.width
        let maxY: CGFloat = self.frame.height
        let minX: CGFloat = 0 + _offset
        let minY: CGFloat = 0 + _offset
        let shadowPath: UIBezierPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: minX, y: 0))
        switch shadowSides {
        case .topBottom:
            shadowPath.move(to: CGPoint(x: 0, y: 0))
            shadowPath.addLine(to: CGPoint(x: maxX, y: 0))
            shadowPath.addLine(to: CGPoint(x: 0, y: maxY))
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY))
            shadowPath.addLine(to: CGPoint(x: 0, y: 0))
        case .leftRight:
            shadowPath.move(to: CGPoint(x: 0, y: 0))
            shadowPath.addLine(to: CGPoint(x: 0, y: maxY))
            shadowPath.addLine(to: CGPoint(x: shadowradius, y: maxY - shadowradius))
            shadowPath.addLine(to: CGPoint(x: maxX - shadowradius, y: maxY - shadowradius))
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY))
            shadowPath.addLine(to: CGPoint(x: maxX, y: 0))
            shadowPath.addLine(to: CGPoint(x: maxX - shadowradius, y: shadowradius))
            shadowPath.addLine(to: CGPoint(x: shadowradius, y: shadowradius))
            shadowPath.addLine(to: CGPoint(x: 0, y: 0))
        case .all:
            shadowPath.addLine(to: CGPoint(x: maxX - _offset, y: 0))
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY - _offset))
            shadowPath.addLine(to: CGPoint(x: minX, y: maxY))
            shadowPath.addLine(to: CGPoint(x: 0, y: minY))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: maxX - _offset, y: minY), radius: _offset, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
                shadowPath.addArc(withCenter: CGPoint(x: maxX - _offset, y: maxY - _offset), radius: _offset, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
                shadowPath.addArc(withCenter: CGPoint(x: minX, y: maxY - _offset), radius: _offset, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
                shadowPath.addArc(withCenter: CGPoint(x: minX, y: minY), radius: _offset, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3*Double.pi / 2), clockwise: true)
            }
        case .topLeftRight:
            shadowPath.addLine(to: CGPoint(x: maxX - _offset, y: 0))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: maxX - _offset, y: minY), radius: _offset, startAngle: CGFloat((3 * Double.pi) / 2), endAngle: 0, clockwise: true)
            }
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY))
            shadowPath.addLine(to: CGPoint(x: maxX - 10, y: maxY/2))
            shadowPath.addLine(to: CGPoint(x: 10, y: maxY/2))
            shadowPath.addLine(to: CGPoint(x: 0, y: maxY))
            shadowPath.addLine(to: CGPoint(x: 0, y: minY))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: minX, y: minY), radius: _offset, startAngle: CGFloat(Double.pi), endAngle: CGFloat((3 * Double.pi) / 2), clockwise: true)
            }
        case .bottomLeftRight:
            shadowPath.move(to: CGPoint(x: maxX, y: 0))
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY - _offset))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: maxX - _offset, y: maxY - _offset), radius: _offset, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
            }
            shadowPath.addLine(to: CGPoint(x: minX, y: maxY))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: minX, y: maxY - _offset), radius: _offset, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
            }
            shadowPath.addLine(to: CGPoint(x: 0, y: 0))
            shadowPath.addLine(to: CGPoint(x: 10, y: maxY/2))
            shadowPath.addLine(to: CGPoint(x: maxX - 10, y: maxY/2))
            shadowPath.addLine(to: CGPoint(x: maxX, y: 0))
        }
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowOffset = offSet
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowradius
        return shadowLayer
    }
    
}
