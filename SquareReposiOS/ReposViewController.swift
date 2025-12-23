//
//  ViewController.swift
//  SquareTestiOS
//
//  Created by Алеся Афанасенкова on 23.12.2025.
//

import UIKit
import SkeletonView

class ReposViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = ReposViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Square Repos"
        view.backgroundColor = .white
        setupTableView()
        bindViewModel()
        viewModel.loadRepos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.showAnimatedGradientSkeleton()
        }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tableView.register(ReposTableViewCell.self, forCellReuseIdentifier: "RepoCell")
        
        view.addSubview(tableView)
        
        view.isSkeletonable = true
        tableView.isSkeletonable = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90

    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch state {
                case .loading:
                    break
                case .loaded:
                    self.tableView.hideSkeleton()
                    self.tableView.reloadData()
                case .error:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.tableView.hideSkeleton()
                        self.tableView.reloadData()
                        self.showError()
                    }
                case .idle:
                    break
                }
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Error", message: "Failed to load repos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ReposViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.state == .error { return 0 }
        return viewModel.count == 0 ? 10 : viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as? ReposTableViewCell else {
            return UITableViewCell()
        }
        
        if viewModel.state == .loaded && viewModel.count > 0 {
            let repo = viewModel.repo(at: indexPath.row)
            cell.configure(with: repo)
        }
        
        return cell
    }
}

// MARK: - SkeletonTableViewDataSource
extension ReposViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "RepoCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as? ReposTableViewCell
        
        cell?.nameLabel.text = "Placeholder Name"
        cell?.descriptionLabel.text = "Placeholder description text that spans two lines"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ReposViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
