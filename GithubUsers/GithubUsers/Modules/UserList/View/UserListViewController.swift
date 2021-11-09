//
//  UserListViewController.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import NotificationBannerSwift
import SnapKit

/// The trigger point for calling getUsers
private enum GetUserListTriggerPoint {
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

        // TODO: Find better way for the refresh since this approach does not look good on large title nav bar
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

    private func getUsers(_ triggerPoint: GetUserListTriggerPoint) {
        // Do not proceed if currently fetching data
        guard !viewModel.isLoading else { return }
        viewModel.isLoading = true

        switch triggerPoint {
        case .onLoad, .onRefresh:
            // Should start from the first
            viewModel.clearUsers()
            viewModel.resetLastFetchedUser()

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
                self?.reloadTableView(triggerPoint)
            }
            .catch { error in
                // NOTE: Wasn't able to check the rate limit since `x-ratelimit-remaining` always returns 59
                let banner = NotificationBanner(subtitle: error.localizedDescription, style: .danger)
                banner.show()
            }
    }

    private func reloadTableView(_ triggerPoint: GetUserListTriggerPoint) {
        switch triggerPoint {
        case .onLoad, .onRefresh:
            // Scroll to top
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

        case .onEndOfList:
            // Reload from the last cell
            let contentOffset: CGPoint = tableView.contentOffset
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableView.setContentOffset(contentOffset, animated: false)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension UserListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        if scrollView == tableView {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                if !viewModel.isLoading {
                    // Fetch the next user list if already reached
                    // the end of the current list
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

        // TODO: Add a **similar** behavior as Slack -> "You're up to date! 🎉"

        return UITableViewCell()
    }
}
