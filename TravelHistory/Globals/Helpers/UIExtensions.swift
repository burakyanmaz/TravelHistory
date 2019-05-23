//
//  UIExtensions.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 23.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit

extension UIView {
    func shake(duration: CFTimeInterval) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            (degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
}

extension UIImage {
    func filled(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static let pin = UIImage(named: "pin")?.filled(with: .green)
    static let pin2 = UIImage(named: "pin2")?.filled(with: .green)
    static let me = UIImage(named: "me")?.filled(with: .blue)
}

extension UIColor {
    class var green: UIColor { return UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1) }
    class var blue: UIColor { return UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1) }
}
