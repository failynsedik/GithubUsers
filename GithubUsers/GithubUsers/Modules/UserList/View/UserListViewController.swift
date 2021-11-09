//
//  UserListViewController.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import NotificationBannerSwift
import SnapKit

private enum GetUserOrigin {
    case onLoad
    case onRefresh
    case onEndOfList
}

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

        getUsers(.onLoad)
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

        let refreshBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshData)
        )
        refreshBarButtonItem.tintColor = .systemBackground
        navigationItem.rightBarButtonItem = refreshBarButtonItem
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

// MARK: - Refresh

extension UserListViewController {
    @objc private func refreshData() {
        getUsers(.onRefresh)
    }

    private func getUsers(_ origin: GetUserOrigin) {
        // Do not proceed if currently fetching data
        guard !viewModel.isLoading else { return }
        viewModel.isLoading = true

        switch origin {
        case .onLoad, .onRefresh:
            // Should start from the first
            viewModel.clearUsers()
        case .onEndOfList:
            // Do nothing...
            break
        }

        // NOTE: Planning to Lottie for the loading animation, but currently running out of time. ⏰
        viewModel.getUsers()
            .ensure {
                self.viewModel.isLoading = false
            }
            .done { [weak self] _ in
                // Setting the last fetched user since this will be the basis
                // for the pagination. The reason why this is called here, instead
                // of inside `viewModel.getUsers` is to avoid coupling the code.
                self?.viewModel.setLastFetchedUser()
                self?.reloadTableView()
            }
            .catch { error in
                let banner = NotificationBanner(subtitle: error.localizedDescription, style: .danger)
                banner.show()
            }
    }

    private func reloadTableView() {
        let contentOffset: CGPoint = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
}

// MARK: - UIScrollViewDelegate

extension UserListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        if scrollView == tableView {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                if !viewModel.isLoading {
                    getUsers(.onEndOfList)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension UserListViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        // Do nothing for now...
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

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
