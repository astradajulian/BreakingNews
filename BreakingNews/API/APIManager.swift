//
//  APIManager.swift
//  BreakingNews
//
//  Created by Julian Astrada on 07/07/2020.
//  Copyright © 2020 Julian Astrada. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
    case unknown
}

class APIManager {
    
    // Singleton
    static let shared = APIManager()
    
    static func getTopHeadlines(country: String) -> Observable<TopHeadlinesData> {
        return request(ApiRouter.getTopHeadlines(country: country))
    }
    
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        //Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<T>.create { observer in
            //Trigger the HttpRequest using AlamoFire (AF)
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                //Check the result from Alamofire's response and check if it's a success or a failure
                switch response.result {
                case .success(let value):
                    //Everything is fine, return the value in onNext
                    observer.onNext(value)
                    observer.onCompleted()
                case let .failure(error):
                    //Something went wrong, switch on the status code and return the error
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }

}
