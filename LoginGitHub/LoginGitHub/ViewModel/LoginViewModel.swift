//
//  LoginViewModel.swift
//  LoginGitHub
//
//  Created by Dinh Trac on 5/18/19.
//  Copyright © 2019 Dinh Trac. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    let userName = Variable<String>("")
    let password = Variable<String>("")
    
    var isValidUserName: Observable<Bool> {
        return self.userName.asObservable().map { name in
            name.count >= 6
        }
    }
    
    var isValidPassword: Observable<Bool> {
        return self.password.asObservable().map { pass in
            pass.count >= 6
        }
    }
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest( isValidUserName, isValidPassword) { $0 && $1 }
    }
}
