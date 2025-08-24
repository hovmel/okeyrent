//
//  UIView+extension.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.06.2022.
//

import Foundation
import UIKit
import AudioToolbox

extension UIView {
    func roundedCorners(top: Bool){
           let corners:UIRectCorner = (top ? [.topLeft , .topRight] : [.bottomRight , .bottomLeft])
           let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners: corners,
                                        cornerRadii:CGSize(width:20, height:20))
           let maskLayer1 = CAShapeLayer()
           maskLayer1.frame = self.bounds
           maskLayer1.path = maskPAth1.cgPath
           self.layer.mask = maskLayer1
       }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        layer.add(animation, forKey: "shake")
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func makeLightShadow() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1.0
    }

    func makeShadow() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
    }
    
    func makeCenterShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        self.clipsToBounds = false
    }
    
    func makeBotShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
        self.clipsToBounds = false
    }
    
}

func shortVibro() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

extension UIView {
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()

        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

        layer.addSublayer(borderLayer)
        return borderLayer
    }
}
