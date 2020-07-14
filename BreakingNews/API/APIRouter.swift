//
//  APIRequest.swift
//  BreakingNews
//
//  Created by Julian Astrada on 07/07/2020.
//  Copyright © 2020 Julian Astrada. All rights reserved.
//

import Foundation
import Alamofire

struct APIConstants {
    //The API's base URL
    static let baseUrl = "https://newsapi.org"
    
    //The API Key
    static let API_KEY = "f9ad6fe86c6b42ccac8b8cf4b2a6cb6e"
    
    //The header fields
    enum HttpHeaderField: String {
        case apiKey = "X-Api-Key"
    }
}

enum ApiRouter: URLRequestConvertible {
    //MARK: - Requests
    case getTopHeadlines(country: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try APIConstants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(APIConstants.API_KEY, forHTTPHeaderField: APIConstants.HttpHeaderField.apiKey.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getTopHeadlines:
            return .get
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getTopHeadlines:
            return "/v2/top-headlines"
        }
    }
    
    //MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case let .getTopHeadlines(country):
            return ["country": country]
        }
    }
}
