//
//  Request.swift
//
//  Created by ysjjchh on 16/12/14.
//  Copyright © 2016年 ysjjchh. All rights reserved.
//

import Foundation
import Alamofire

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    
    associatedtype Response: Responsable, Codable
}

protocol Responsable {
    init(code: Int, msg: String)
}

class BaseResponse<T: Codable>: Codable, Responsable {
    var code: Int? = 0
    var msg: String? = ""
    var data: T?
    
    var isSuccess: Bool {
        get {
            return 0 == code
        }
    }
    
    required init(code: Int, msg: String) {
        self.code = code
        self.msg = msg
    }
    
    private enum CodingKeys : String, CodingKey {
        case data
        case code
        case msg
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try? container.decode(T.self, forKey: .data)
        code = try? container.decode(Int.self, forKey: .code)
        msg = try? container.decode(String.self, forKey: .msg)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(code, forKey: .code)
        try container.encode(msg, forKey: .msg)
    }
}








