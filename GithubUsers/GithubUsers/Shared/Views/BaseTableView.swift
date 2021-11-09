//
//  BaseTableView.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import UIKit

class BaseTableView: UITableView {
    // MARK: - Overrides

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        showsVerticalScrollIndicator = false

        let clearView = UIView()
        clearView.backgroundColor = .clear
        tableHeaderView = clearView
        tableFooterView = clearView

        keyboardDismissMode = .interactive
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
