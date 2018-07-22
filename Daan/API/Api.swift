//
//  Api.swift
//  Daan
//
//  Created by 郭東岳 on 2018/7/21.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation

enum ApiResult<Value>{
    case success(Value)
    case networkError(Error)
    case apiError(ApiError)
}

class Api{
    func decodeResponse<T:Codable>(response:RequestResponse,completion:@escaping((ApiResult<T>)->Void)){
        switch response{
        case .success(let data):
            let decoder = JSONDecoder()
            do{
                let token = try decoder.decode(T.self, from: data)
                completion(.success(token))
            }
            catch{
                // Try to parse to see if its an ApiError
                do{
                    let apiErr = try decoder.decode(ApiError.self, from: data)
                    completion(.apiError(apiErr))
                }
                catch{
                    var apiErr = ApiError()
                    apiErr.code = 0
                    apiErr.error = "Unable to decode server's response"
                    completion(.apiError(apiErr))
                }
            }
        case .failure(let error):
            completion(.networkError(error))
        }
    }
    
    func login(_ login:Login,completion:@escaping ((ApiResult<Token>)->Void)){
        let encoder = JSONEncoder()
        do{
            let jsonData = try encoder.encode(login)
            let request = ApiRequest2("/actmanage/login", method: "POST", data: jsonData)
            request.send(completion: { (response) in
                self.decodeResponse(response: response, completion: {(result:ApiResult<Token>) in
                    completion(result)
                })
            })
        }
        catch{
            // Probably not a network error though
            completion(.networkError(error))
        }
    }
    
    func register(_ register:Register,completion:@escaping ((ApiResult<Token>)->Void)){
        let encoder = JSONEncoder()
        do{
            let jsonData = try encoder.encode(register)
            let request = ApiRequest2("/actmanage/login", method: "POST", data: jsonData)
            request.send(completion: {response in
                self.decodeResponse(response: response, completion: completion)
            })
        }
        catch{
            // Probably not a network error though
            completion(.networkError(error))
        }
    }
    
    func updateInfo(_token:Token,updateInfo:UpdateInfo,completion:@escaping ((ApiResult<UserInfo>)->Void)){
        let encoder = JSONEncoder()
        do{
            let jsonData = try encoder.encode(updateInfo)
            let request = ApiRequest2("/actmanage/updateinfo", method: "PUT", data: jsonData)
            request.send(completion: {response in
                self.decodeResponse(response: response, completion: completion)
            })
        }
        catch{
            // Probably not a network error though
            completion(.networkError(error))
        }
    }
    
    func  getUserInfo(_ token:Token,completion:@escaping ((ApiResult<UserInfo>)->Void)) {
        let request = ApiRequest2( "/actmanage/getUserInfo", method: "GET", token: token)
        request.send(completion: { response in
            self.decodeResponse(response: response, completion: completion)
        })
    }
    
    func getHistoryScore(_ token:Token, grade:Int,semester:Int,completion:@escaping ((ApiResult<HistoryScore>)->Void)) {
        let request = ApiRequest2("/scorequery/historyscore/\(grade)/\(semester)",method:"GET",token:token)
        request.send(completion: { response in
            self.decodeResponse(response: response, completion: completion)
        })
    }
    
    func getSectionalExam(_ token:Token,semester:Int,completion:@escaping((ApiResult<SectionalScore>)->Void)) {
        let request = ApiRequest2("/scorequery/sectionalexamscore/\(semester)",method:"GET",token:token)
        request.send(completion: { response in
            self.decodeResponse(response: response, completion: completion)
        })
    }
    
    func  getAttitudeStatus(_ token:Token,completion:@escaping ((ApiResult<AttitudeStatus>)->Void)) {
        let request = ApiRequest2( "/attitudestatus", method: "GET", token: token)
        request.send(completion: { response in
            self.decodeResponse(response: response, completion: completion)
        })
    }
    
    func getAbsent(_ token:Token,completion:@escaping ((ApiResult<[AbsentState]>)->Void)) {
        let request = ApiRequest2( "/absentstate", method: "GET", token: token)
        request.send(completion: { response in
            self.decodeResponse(response: response, completion: completion)
        })
    }
    
    func getCalendar(completion:@escaping ((ApiResult<[CalendarEvent]>)->Void)) {
        let request = ApiRequest2("/calendar", method: "GET")
        request.send(completion: { response in
            self.decodeResponse(response: response, completion: completion)
        })
    }
    
    func getCurriculum(_ token:Token,completion:@escaping ((ApiResult<CurriculumWeek>)->Void)) {
        let request = ApiRequest2("/curriculum", method: "GET")
        request.send(completion: { response in
            self.decodeResponse(response: response, completion: completion)
        })
    }
    
    func getQandA(completion:@escaping ((ApiResult<CurriculumWeek>)->Void)) {
        let request = ApiRequest2("/QandA", method: "GET")
        request.send(completion: { response in
            self.decodeResponse(response: response, completion: completion)
        })
    }
}
