//
//  ViewController.swift
//  CathayBank
//
//  Created by wistronits on 2023/8/11.
//

import Foundation

struct FavoriteResponse: Codable {
    let msgCode: String
    let msgContent: String
    let result: FavoriteResultData
    
    init(msgCode: String, msgContent: String, result: FavoriteResultData) {
        self.msgCode = msgCode
        self.msgContent = msgContent
        self.result = result
    }
}

struct FavoriteResultData: Codable {
    let favoriteList: [FavoriteModel]
}

struct FavoriteModel: Codable {
    let nickname: String
    let transType: String
    
    init(nickname: String, transType: String) {
        self.nickname = nickname
        self.transType = transType
    }
}
