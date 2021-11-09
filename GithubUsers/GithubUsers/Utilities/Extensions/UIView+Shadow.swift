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
        // Set corner radius
        layer.cornerRadius = cornerRadius

        // Set shadow
        let holderView = UIView(frame: frame)
        holderView.backgroundColor = .clear
        superview?.addSubview(holderView)
        holderView.center = center
        holderView.addSubview(self)
        center = CGPoint(x: holderView.frame.size.width / 2.0, y: holderView.frame.size.height / 2.0)

        layer.masksToBounds = true
        holderView.layer.masksToBounds = false

        holderView.layer.shadowColor = shadowColor.cgColor
        holderView.layer.shadowOpacity = shadowOpacity
        holderView.layer.shadowRadius = shadowRadius
        holderView.layer.shadowOffset = CGSize(width: width, height: height)
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
