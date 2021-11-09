//
//  UserListViewController.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import SnapKit

class UserListViewController: UIViewController {
    // MARK: - Subviews

    private let tableView: BaseTableView = {
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        return tableView
    }()

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

        setupNav()
        setupViews()

        viewModel.getUsers()
            .done { [weak self] _ in
                self?.reloadTableView()
            }
            .catch { _ in
                print("❌ Call Failed")
                // TODO: Add pod notificationbannerswift
            }
    }
}

// MARK: - UI Setup

extension UserListViewController {
    private func setupNav() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        appearance.backgroundColor = .systemPurple
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        title = "Github DM"
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground

        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UI Update

extension UserListViewController {
    private func reloadTableView() {
        let contentOffset: CGPoint = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
}

// MARK: - Delegates

// MARK: UITableViewDelegate

extension UserListViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        // Do nothing for now...
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: UITableViewDataSource

extension UserListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell,
           let content = viewModel.getUserCellContent(for: indexPath.row)
        {
            cell.setup(content: content)
            return cell
        }

        return UITableViewCell()
    }
}
