//
//  GitHubService.swift
//  SquareTestiOS
//
//  Created by Алеся Афанасенкова on 23.12.2025.
//
import UIKit

class GitHubService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRepos(completion: @escaping (Result<[Repository], Error>) -> Void) {
        let url = URL(string: "https://api.github.com/orgs/square/repos")!
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let repos = try JSONDecoder().decode([Repository].self, from: data)
                completion(.success(repos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
