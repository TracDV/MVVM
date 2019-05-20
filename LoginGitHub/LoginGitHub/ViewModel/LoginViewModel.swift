//
//  LoginViewModel.swift
//  LoginGitHub
//
//  Created by Dinh Trac on 5/18/19.
//  Copyright © 2019 Dinh Trac. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    let userName = Variable<String>("")
    let password = Variable<String>("")
    //User
    lazy var userLogin: Driver<User?> = {
        return self.userName.asObservable()
        .throttle(0.3, scheduler: MainScheduler.instance)
        .flatMapLatest(LoginViewModel.loginGithub)
        .asDriver(onErrorJustReturn: nil)
    }()
    //
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
    
    static func loginGithub(_ userName: String) -> Observable<User?> {
        guard !userName.isEmpty, let url = URL(string: "https://api.github.com/users/\(userName)") else { return Observable.just(nil)}
        return URLSession.shared.rx.json(url: url).retry(3).map(parseUser)
    }
    
    static func parseUser( json:Any) -> User? {
        guard let items = json as? [String: Any] else { return nil}
        return User(name: (items["name"] as? String)!, id: (items["id"] as? Int)!, login: (items["login"] as? String)!)
    }
}
