//
//  ReposViewModel.swift
//  SquareTestiOS
//
//  Created by Алеся Афанасенкова on 23.12.2025.
//

import UIKit

class ReposViewModel {
    private let service = GitHubService()
    var repos: [Repository] = []
    var onStateChange: ((ViewState) -> Void)?
    private(set) var state: ViewState = .idle

    func loadRepos() {
        state = .loading
        onStateChange?(.loading)
        service.fetchRepos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let repos):
                    self?.repos = repos
                    self?.state = .loaded
                    self?.onStateChange?(.loaded)
                case .failure:
                    self?.repos = []
                    self?.state = .error
                    self?.onStateChange?(.error)
                }
            }
        }
    }

    func repo(at index: Int) -> Repository {
        repos[index]
    }

    var count: Int {
        repos.count
    }
}

enum ViewState {
    case idle
    case loading
    case loaded
    case error
}
