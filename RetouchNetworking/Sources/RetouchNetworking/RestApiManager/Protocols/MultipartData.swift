//
//  MultipartData.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 10/27/17.
//  Copyright © 2017 RestApiManager. All rights reserved.
//

import Foundation

/// MultipartData
public protocol MultipartData {
    var boundary: String { get }
    var parameters: [String: String]? { get }
    var multipartObjects: [MultipartObject]? { get }
}

/// MultipartObject
public struct MultipartObject: Sendable {
    public let key: String
    public let data: Data
    public let mimeType: String
    public let filename: String
    
    public init(key: String,
                data: Data,
                mimeType: String,
                filename: String) {
        self.key = key
        self.data = data
        self.mimeType = mimeType
        self.filename = filename
    }
}

/// MultipartData extension for generate final data
public extension MultipartData {
    var data: Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let multipartObjects = multipartObjects {
            for multipartObject in multipartObjects {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(multipartObject.key)\"; filename=\"\(multipartObject.filename)\"\(lineBreak)")
                body.append("Content-Type: \(multipartObject.mimeType + lineBreak + lineBreak)")
                body.append(multipartObject.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

/// Data extension for append string
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
