//
//  Keychain.swift
//  Daan
//
//  Created by 郭東岳 on 2018/7/26.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import Foundation
import KeychainSwift

class Keychain{
    static let sharedInstance = Keychain()
    
    private let keychain = KeychainSwift()
    
    private init() {
        print("[Keychain] Initialize")
    }

    var loginExists:Bool {
        get{
            print("[Keychain] Check key")
            return chkKeyExist()
        }
    }

    var login:Login?{
        get{
            print("[Keychain] Get login data")
            return getLogin()
        }
        set(login){
            print("[Keychain] Setting login data")
            if let login = login {
                setLogin(login: login)
            }
        }
    }
    
    private func chkKeyExist() -> Bool {
        if let _ = keychain.get("account"),let _ = keychain.get("password") {
            return true
        }
        else {
            return false
        }
    }

    private func getLogin() -> Login?{
        if let account = keychain.get("account"),let password = keychain.get("password") {
            return Login(account: account, password: password)
        }
        else {
            return nil
        }
    }
    
    private func setLogin(login:Login){
        keychain.set(login.account, forKey: "account")
        keychain.set(login.password, forKey: "password")
    }

    func clear(){
        print("[Keychain] Clear Keychain")
        keychain.clear()
    }
}
