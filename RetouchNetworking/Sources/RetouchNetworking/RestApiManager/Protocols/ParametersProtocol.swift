//
//  ParametersProtocol.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 10/18/17.
//  Copyright © 2017 RestApiManager. All rights reserved.
//

import Foundation

/// ParametersProtocol
public protocol ParametersProtocol {
    typealias Parameters = Any
    
    var parametersValue: Parameters { get }
}
