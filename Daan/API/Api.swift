//
//  Api.swift
//  Daan
//
//  Created by 郭東岳 on 2018/5/29.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

class Api{
    
    private var token:String
    private let baseUrl:URL
    
    public static let api = Api()
    
    private init() {
        let apiConfig = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "ApiConfig", ofType: "plist")!)
        let apiUrl = apiConfig?.object(forKey: "ApiUrl") as! String
        let apiVersion = apiConfig?.object(forKey: "ApiVersion") as! String
        guard let baseUrl = URL(string: "https://"+apiUrl+"/"+apiVersion+"/") else{
            fatalError("Cannot form baseUrl, possible config corruption")
        }
        self.token = ""
        self.baseUrl = baseUrl
    }
    
    func login(account:String, password:String, completion:@escaping (ApiResult<Token>)->Void) {
        let params:JSONDictionary = ["account":account,"password":password]
        ApiRequest2.request(url: baseUrl.appendingPathComponent("actmanage/login"), method: HTTPMethod.post, params: params, completion: {
            (apiResult:ApiResult<Token>) in
            if let token = apiResult.result?.token{
                self.token = token
            }
            completion(apiResult)
        })
    }
    
    func register(data:Register, completion:@escaping (ApiResult<Token>) -> Void){
        let params = try? JSONEncoder().encode(data)
        ApiRequest2.request(url: baseUrl.appendingPathComponent("actmanage/register"), method: .post, params: params, completion: {
            (apiResult:ApiResult<Token>) in
            
        })
    }
    
    
}

