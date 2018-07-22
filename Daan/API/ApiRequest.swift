//
//  ApiRequest.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/11.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import Alamofire
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
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = apiUrl
        urlComponent.path = "/v1" + path  //FIX ON PROD
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
        print("API Request to \(String(describing: request.url))")
        task.resume()
    }
}


// TODO: Replace ApiRequest with ApiRequest 2
class ApiRequest{
    typealias JSONDictionary = [String: Any]
    typealias JSONArray = [JSONDictionary]
    let baseUrl:String
    let requestUrl:String
    let method:HTTPMethod
    let token:Token?
    let params:JSONDictionary
    
    init(path:String,method:HTTPMethod,token:Token? = nil,params:JSONDictionary? = nil) {
        let apiConfig = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "ApiConfig", ofType: "plist")!)
        let apiUrl = apiConfig?.object(forKey: "ApiUrl") as! String
        let apiVersion = apiConfig?.object(forKey: "ApiVersion") as! String
        self.baseUrl = "https://"+apiUrl+"/"+apiVersion+"/"
        //Check if the start part of path already contains baseUrl due to recursive call
        if path.starts(with: self.baseUrl){
            self.requestUrl = path
        }
        else{
            self.requestUrl = baseUrl+path
        }
        self.method = method
        self.token = token
        if let parameters:JSONDictionary = params{
            self.params = parameters
        }
        else{
            self.params = [:]
        }
        
    }
    
    func request(result : @escaping (JSONDictionary?,ApiError?,Error?) -> Void) {
        print("Running ApiRequest towards url: \(self.requestUrl)")
        let headers:HTTPHeaders?
        if let tk = token{
            headers = ["Authorization":tk.token]
        }
        else{
            headers = [:]
        }
        
        Alamofire.request(requestUrl, method: self.method, parameters: params, encoding: JSONEncoding.default,headers: headers)
            .responseJSON {
                response in
                switch response.result{
                case .success(let val):
                    let value = val as! JSONDictionary
                    if value["code"] == nil{
                        result(value,nil,nil)
                    }
                    else{
                        let apiError = ApiError(JSON: value)
                        print("Api reported error!\n  Code: \(apiError?.code ?? -1)\n  Error:\(apiError?.error ?? "")")
                        
                        //Auto reobtain token
                        //This entire api part needs to be rewritten
                        if apiError?.code == 103 || apiError?.error == "token過期"{
                            let keychain = KeychainSwift()
                            guard let account = keychain.get("account"),let password = keychain.get("password") else{
                                print("Got token expired but was unable to find login in keychain, returning err")
                                //Returns the failed apierr without processing
                                result(nil,apiError,nil)
                                return
                            }
                            //Try to login and obtain token
                            print("Token is expired, attempting to get a new one")
                            let loginReq = ApiRequest(path: "actmanage/login", method: .post, params: ["account":account,"password":password])
                            loginReq.request {(loginRes,loginApiErr,loginAlaErr) in
                                if let loginResult = loginRes {
                                    //Got new token
                                    let token = Token(JSON: loginResult)
                                    print("Got new token by ApiRequest, \(token?.token ?? "nil")")
                                    print("Performing original request")
                                    let origReq = ApiRequest(path: self.requestUrl, method: self.method, token: token, params: self.params)
                                    origReq.request {(origRes,origApiErr,origAlaErr) in
                                        if let origResult = origRes{
                                            print("Original request successed, passing that back")
                                            result(origResult,nil,nil)
                                        }
                                        else if let origApiErr = origApiErr{
                                            print("Original request throw an api err, passing that back")
                                            result(nil,origApiErr,nil)
                                        }
                                        else if let origAlaError = origAlaErr{
                                            print("Original request throw an alamofire err, passing that back")
                                            result(nil,nil,origAlaError)
                                        }
                                    }
                                }
                                else if let loginApiError = loginApiErr{
                                    //ApiErr during login process
                                    print("Token refresh throw api err, passing that back")
                                    result(nil,loginApiError,nil)
                                }
                                else if let loginAlaError = loginAlaErr{
                                    //Alamofire error during login process
                                    print("Token refresh throw alamofire err, passing that back")
                                    result(nil,nil,loginAlaError)
                                }
                            }
                        }
                        else{
                            result(nil,apiError,nil)
                        }
                    }
                    
                case .failure(let error):
                    print("Alamofire Error\n  \(error)")
                    result(nil,nil,error)
                }
        }
    }
    
    //TODO: Create a better implementation when data is sent as array
    
    func requestArr(result : @escaping (JSONArray?,ApiError?,Error?) -> Void) {
        print("Running ARRAY ApiRequest towards url: \(self.requestUrl)")
        let headers:HTTPHeaders?
        if let tk = token{
            headers = ["Authorization":tk.token]
        }
        else{
            headers = [:]
        }
        
        Alamofire.request(requestUrl, method: self.method, parameters: params, encoding: JSONEncoding.default,headers: headers)
            .responseJSON {
                response in
                switch response.result{
                case .success(let val):
                    if let value = val as? JSONDictionary{
                        let apiError = ApiError(JSON: value)
                        print("(Array) Api reported error!\n  Code: \(apiError?.code ?? -1)\n  Error:\(apiError?.error ?? "")")
                        
                        //Auto reobtain token
                        //This entire api part needs to be rewritten
                        if apiError?.code == 103 || apiError?.error == "token過期"{
                            let keychain = KeychainSwift()
                            guard let account = keychain.get("account"),let password = keychain.get("password") else{
                                print("Got token expired but was unable to find login in keychain, returning err")
                                //Returns the failed apierr without processing
                                result(nil,apiError,nil)
                                return
                            }
                            //Try to login and obtain token
                            print("Token is expired, attempting to get a new one")
                            let loginReq = ApiRequest(path: "actmanage/login", method: .post, params: ["account":account,"password":password])
                            loginReq.request {(loginRes,loginApiErr,loginAlaErr) in
                                if let loginResult = loginRes {
                                    //Got new token
                                    let token = Token(JSON: loginResult)
                                    print("Got new token by ApiRequest, \(token?.token ?? "nil")")
                                    print("Performing original request")
                                    let origReq = ApiRequest(path: self.requestUrl, method: self.method, token: token, params: self.params)
                                    origReq.requestArr {(origRes,origApiErr,origAlaErr) in
                                        if let origResult = origRes{
                                            print("Original request successed, passing that back")
                                            result(origResult,nil,nil)
                                        }
                                        else if let origApiErr = origApiErr{
                                            print("Original request throw an api err, passing that back")
                                            result(nil,origApiErr,nil)
                                        }
                                        else if let origAlaError = origAlaErr{
                                            print("Original request throw an alamofire err, passing that back")
                                            result(nil,nil,origAlaError)
                                        }
                                    }
                                }
                                else if let loginApiError = loginApiErr{
                                    //ApiErr during login process
                                    print("Token refresh throw api err, passing that back")
                                    result(nil,loginApiError,nil)
                                }
                                else if let loginAlaError = loginAlaErr{
                                    //Alamofire error during login process
                                    print("Token refresh throw alamofire err, passing that back")
                                    result(nil,nil,loginAlaError)
                                }
                            }
                        }
                        else{
                            result(nil,apiError,nil)
                        }
                    }
                    else{
                        let value = val as! JSONArray
                        result(value,nil,nil)
                    }
                case .failure(let error):
                    print("Alamofire Error (ARRAY)\n  \(error)")
                    result(nil,nil,error)
                }
        }
    }
    
}

