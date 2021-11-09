//
//  Reusable.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
