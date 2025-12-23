//
//  SquareReposiOSTests.swift
//  SquareReposiOSTests
//
//  Created by Алеся Афанасенкова on 23.12.2025.
//

import XCTest
@testable import SquareReposiOS

final class GitHubServiceTests: XCTestCase {
    var service: GitHubService!
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        
        service = GitHubService(session: session)
    }
    
    func testFetchReposSuccess() {
        let json = """
        [
          { "id": 1, "name": "Repo1", "description": "Test repo" }
        ]
        """
        MockURLProtocol.responseData = json.data(using: .utf8)
        MockURLProtocol.responseError = nil
        
        let expectation = self.expectation(description: "FetchReposSuccess")
        
        service.fetchRepos { result in
            switch result {
            case .success(let repos):
                XCTAssertEqual(repos.count, 1)
                XCTAssertEqual(repos.first?.name, "Repo1")
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testFetchReposNetworkError() {
        MockURLProtocol.responseData = nil
        MockURLProtocol.responseError = NSError(domain: "Test", code: -1, userInfo: nil)
        
        let expectation = self.expectation(description: "FetchReposNetworkError")
        
        service.fetchRepos { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testFetchReposDecodingError() {
        let invalidJson = "{ invalid }"
        MockURLProtocol.responseData = invalidJson.data(using: .utf8)
        MockURLProtocol.responseError = nil
        
        let expectation = self.expectation(description: "FetchReposDecodingError")
        
        service.fetchRepos { result in
            switch result {
            case .success:
                XCTFail("Expected decoding failure")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}

class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var responseError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.responseError {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = MockURLProtocol.responseData {
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
