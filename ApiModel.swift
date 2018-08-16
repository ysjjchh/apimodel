//
//  ApiModel.swift
//
//  Created by ysjjchh on 16/12/9.
//  Copyright © 2016年 ysjjchh. All rights reserved.
//

import Foundation
import Alamofire

protocol Client {
    func send<T: Request>(_ r: T, handler: @escaping (T.Response) -> Void)
    
    var host: String { get }
}

class ApiModel: Client {
    internal var host: String {
        get{
            return "https://yourserver"
        }
    }
    
    internal let network: SessionManager = {
        
        let manager = SessionManager()
        manager.session.configuration.timeoutIntervalForRequest = 20
        
        return manager
        
    }()
    
    private var headers: [String : String] {
        get {
            var map = [String : String]()
            return map
        }
    }
    
    open func send<T: Request>(_ r: T, handler: @escaping (T.Response) -> Void) {
        let hostPath:String = host.appending(r.path)
        
        var encoding: ParameterEncoding
        if r.method == .post {
            encoding = JSONEncoding.default
        } else {
            encoding = URLEncoding.methodDependent
        }
        self.network.request(hostPath, method: r.method, parameters: r.parameter,
                             encoding: encoding, headers: self.headers)
            .responseData { response in
                
                switch response.result {
                case .success:
                    if let data = response.result.value {
                        let decoder = JSONDecoder()
                        print("\n>>>>>>>>>>>>  URL:  " + hostPath)
                        if let j = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                            print(j)
                        }else{
                            print("数据解析错误")
                            print(data)
                        }
                        if let res = try? decoder.decode(T.Response.self, from: data) {
                            DispatchQueue.main.async { handler(res) }
                        } else {
                            DispatchQueue.main.async { handler(T.Response.self.init(code: -1, msg: "协议解析错误!")) }
                        }
                    } else {
                        DispatchQueue.main.async { handler(T.Response.self.init(code: -1, msg: "网络不给力哦!")) }
                    }
                case .failure(_):
                    print("\n>>>>>>>>>>>> URL:  " + hostPath)
                    print("网络不给力哦!")
                    DispatchQueue.main.async { handler(T.Response.self.init(code: -1, msg: "网络不给力哦!")) }
                }
        }
    }
    
}














