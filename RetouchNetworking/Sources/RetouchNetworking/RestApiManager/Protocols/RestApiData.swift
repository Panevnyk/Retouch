//
//  RestApiData.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 11/7/17.
//  Copyright © 2017 Panevnyk Vlad. All rights reserved.
//

import Foundation

/// RestApiData
public struct RestApiData {
    public let url: String
    public let httpMethod: HttpMethod
    public let headers: [String: String]?
    public let parameters: Any
    public let keyPath: String?
    
    public init(url: String,
                httpMethod: HttpMethod,
                headers: [String: String]? = nil,
                parameters: ParametersProtocol? = nil,
                keyPath: String? = nil) {
        self.url = url
        self.httpMethod = httpMethod
        self.headers = headers
        self.keyPath = keyPath
        self.parameters = parameters?.parametersValue ?? [:]
    }
}

// MARK: - url with parameters String for GET request
public extension RestApiData {
    var urlWithParametersString: String {
        guard let parameters = parameters as? [String: Any] else {
            return url
        }
        var parametersString = ""
        for (offset: i, element: (key: key, value: value)) in parameters.enumerated() {
            parametersString += "\(key)=\(value)"
            if i < parameters.count - 1 {
                parametersString += "&"
            }
        }
        parametersString = parametersString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        if !parametersString.isEmpty {
            parametersString = "?" + parametersString
        }
        return url + parametersString
    }
}
