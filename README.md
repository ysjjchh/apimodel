# apimodel
RESTful api client model for swift

### example:

```
class UserInfo : Codable {
    var userId: String?
    var truename: String?
    var token: String?
}
```

```
class LoginReq: Request {
    typealias Response = BaseResponse<UserInfo>
    
    internal var path: String = "sign-in"
    internal var method: HTTPMethod = .post
    
    var mobile: String!
    var authCode: String!
    
    var parameter: [String : Any] {
        get {
            return ["mobile":mobile, "authCode":authCode]
        }
    }
    
    init(mobile: String, authCode: String) {
        self.mobile = mobile
        self.authCode = authCode
    }
}
```
```
lazy var apiModel: ApiModel = ApiModel()
let req = LoginReq(mobile: "", authCode: "")
apiModel.send(req) {(resp) in
                if resp.isSuccess {

                } else {
      
                }
            }
        }
```