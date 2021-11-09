//
//  UIView+Shadow.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import UIKit

extension UIView {
    func addCornerRadiusWithShadow(
        _ cornerRadius: CGFloat,
        x width: CGFloat,
        y height: CGFloat,
        blur shadowRadius: CGFloat,
        shadowColor: UIColor = .black,
        shadowOpacity: Float
    ) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowRadius = shadowRadius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    func addShadow(
        x width: CGFloat,
        y height: CGFloat,
        blur shadowRadius: CGFloat,
        shadowColor: UIColor = .black,
        shadowOpacity: Float
    ) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: width, height: height)
    }
}
