//
//  ApiRequest.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/11.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import KeychainSwift

enum RequestResponse {
    case success(Data)
    case failure(Error)
}

class ApiRequest2 {
    private var request:URLRequest
    
    init(_ path:String,method:String) {
        let apiConfig = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "ApiConfig", ofType: "plist")!)
        let apiUrl = apiConfig?.object(forKey: "ApiUrl") as! String
        let apiVer = apiConfig?.object(forKey: "ApiVersion") as! String
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = apiUrl
        urlComponent.path = "/" + apiVer + path
        guard let url = urlComponent.url else{fatalError("Cannot generate url fron configured urlComponent")}
        
        request = URLRequest(url: url)
        request.httpMethod = method
    }
    
    convenience init(_ path:String,method:String,token:Token) {
        self.init(path, method: method)
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
    }
    
    convenience init(_ path:String,method:String,data:Data){
        self.init(path, method: method)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
    }
    
    convenience init(_ path:String,method:String,token:Token,data:Data){
        self.init(path, method: method,data:data)
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
    }
    
    func send(completion:@escaping ((RequestResponse)->Void)) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request){ (responseData,response,responeError) in
            if let error = responeError{
                completion(.failure(error))
            }
            else if let data = responseData{
                completion(.success(data))
            }
            else{
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No data was retrieved from the request"])
                completion(.failure(error))
            }
        }
        print("API Request to \(request.url?.absoluteString ?? "nil")")
        task.resume()
    }
}
