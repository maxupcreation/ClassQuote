//
//  FakeResponseData.swift
//  ClassQuoteTests
//
//  Created by Maxime on 14/09/2020.
//  Copyright © 2020 Maxime. All rights reserved.
//

import Foundation

class FakeResponseData {
    // MARK: - Data
    static var quoteCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Quote", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static let quoteIncorrectData = "erreur".data(using: .utf8)!

    static let imageData = "image".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    // MARK: - Error
    class QuoteError: Error {}
    static let error = QuoteError()
}

func testGetQuoteShouldPostFailedCallbackIfError() {
    // Given
    let quoteService = QuoteService()
        quoteSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error),
        imageSession: URLSessionFake(data: nil, response: nil, error: nil))

    // When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    quoteService.getQuote { (success, quote) in
        // Then
        XCTAssertFalse(success)
        XCTAssertNil(quote)
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.01)
}

