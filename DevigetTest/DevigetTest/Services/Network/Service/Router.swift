//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

protocol NetworkRouter: class {
    func request<T: Request>(from request: T, completion: @escaping (T.Response?, Result) -> () )
    func cancel()
}

enum Result {
    case success
    case failure(String)
}

fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result {
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failure("Need to be authenticated first.")
    case 501...599: return .failure("Bad request")
    case 600: return .failure("The url you requested is outdated.")
    default: return .failure("Network request failed.")
    }
}

class Router: NetworkRouter {
    
    var task: URLSessionTask?
    
    func request<T: Request>(from request: T, completion: @escaping (T.Response?, Result) -> () ) {
        guard let url = request.urlComponents.url else {
            fatalError("Fail to generate urlRequest from: \(request.urlComponents)")
        }
        
        NetworkLogger.log(request: URLRequest(url: url))
        
        task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            let parsedData = try? request.responseType.decode(data)
            
            var result: Result
            if let httpURLResponse = response as? HTTPURLResponse {
                result = handleNetworkResponse(httpURLResponse)
            } else {
                result = .failure("Network request failed.")
            }
            
            completion(parsedData, result)
        })
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}
