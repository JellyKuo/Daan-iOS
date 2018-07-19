//
//  ApiRequest2.swift
//  Daan
//
//  Created by 郭東岳 on 2018/5/30.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation
import Alamofire
typealias JSONDictionary = [String: Any]
struct ApiRequest2 {
    
    static func request<T:Codable>(url:URL,method:HTTPMethod,params:JSONDictionary,completion:@escaping(ApiResult<T>)->Void){
        print("Perform ApiRequest to \(url)")
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default).responseData {
            response in
            if let error = response.error{
                print("Network error \(error)")
                let apiRes = ApiResult<T>(false,netError: error)
                completion(apiRes)
            }
            else if let data = response.data{
                print("Got data from server \(String(data: data, encoding: String.Encoding.utf8)!)")
                
                guard let result = try? JSONDecoder().decode(T.self, from: data) else{
                    guard let apiErr = try? JSONDecoder().decode(ApiError.self, from: data) else{
                        //#if DEBUG
                        fatalError("Data cannot be parsed to result nor error")
                        //#else
                        //TODO:
                        //return someSortOfErrorDueToUnableToParse
                        //#endif
                    }
                    print("Api reported error \(apiErr)")
                    let apiRes = ApiResult<T>(false,apiError:apiErr)
                    completion(apiRes)
                    return
                }
                print("Serialization successful \(result)")
                let apiRes = ApiResult<T>(true,result)
                completion(apiRes)
            }
            
        }
        
    }
    
    /*
     static func sessionRequest<T:Codable>(request:URLRequest,completion:@escaping(ApiResult<T>)->Void){
     let task = URLSession.shared.dataTask(with: request, completionHandler: {
     (data,response,error) in
     if let error = error{
     let apiRes = ApiResult<T>(false,netError: error)
     completion(apiRes)
     }
     else if let data = data{
     let response = response as? HTTPURLResponse
     debugPrint(response?.statusCode as Any)
     do{
     let result = try T.decode(data: data)
     let apiRes = ApiResult<T>(true,result)
     completion(apiRes)
     }
     catch{
     do{
     let apiErr = try ApiError.decode(data: data)
     let apiRes = ApiResult<T>(false,apiError:apiErr)
     completion(apiRes)
     }
     catch{
     fatalError("Data cannot be parsed to result nor error")
     }
     }
     }
     })
     task.resume()
     }
     */
}
