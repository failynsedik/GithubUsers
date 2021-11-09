//
//  UserListViewController.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import UIKit

class UserListViewController: UIViewController {
    // MARK: - Initializer

    private let viewModel: UserListViewModel

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getUsers()
            .done { _ in
                print("✅ Call Successful")
            }
            .catch { _ in
                print("❌ Call Failed")
            }
    }
}
