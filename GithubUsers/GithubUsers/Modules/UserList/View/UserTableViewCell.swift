//
//  UserTableViewCell.swift
//  GithubUsers
//
//  Created by Failyn Kaye Sedik on 11/10/21.
//

import Kingfisher
import SnapKit
import UIKit

class UserTableViewCell: UITableViewCell {
    // MARK: - Subviews

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()

    private let receiverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemPurple
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Override

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        receiverImageView.addCornerRadiusWithShadow(30, x: 0, y: 5, blur: 7, shadowOpacity: 0.2)
        containerView.addCornerRadiusWithShadow(3, x: 0, y: 2, blur: 3, shadowOpacity: 0.16)
    }

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(receiverImageView)
        containerView.addSubview(usernameLabel)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        receiverImageView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.top.leading.bottom.equalToSuperview().inset(16)
        }

        usernameLabel.snp.makeConstraints {
            $0.centerY.equalTo(receiverImageView)
            $0.leading.equalTo(receiverImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension UserTableViewCell {
    func setup(content: UserTableViewCellContent) {
        usernameLabel.text = content.username

        receiverImageView.kf.indicatorType = .activity
        receiverImageView.kf.setImage(
            with: content.avatarURL,
            placeholder: UIImage(named: "ic_user_placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage,
            ],
            completionHandler: nil
        )
    }
}