//
//  ViewController.swift
//  SquareReposiOS
//
//  Created by Алеся Афанасенкова on 23.12.2025.
//

import UIKit
import SnapKit
import SkeletonView

class ReposTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func setupSkeleton() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        nameLabel.isSkeletonable = true
        descriptionLabel.isSkeletonable = true
        
        nameLabel.skeletonTextLineHeight = .fixed(20)
        nameLabel.skeletonTextNumberOfLines = 1
        nameLabel.linesCornerRadius = 4
        
        descriptionLabel.skeletonTextLineHeight = .fixed(18)
        descriptionLabel.skeletonTextNumberOfLines = 2
        descriptionLabel.linesCornerRadius = 4
    }
    
    func configure(with repo: Repository) {
        nameLabel.text = repo.name
        
        let description = repo.description ?? "No description"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .left
        
        descriptionLabel.attributedText = NSAttributedString(
            string: description,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.gray
            ]
        )
    }
}
