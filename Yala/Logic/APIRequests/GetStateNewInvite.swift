//

import Foundation
import Alamofire

enum GetStateNewInviteAPIEndpoint {
    case setUser(User)
}

class GetStateNewInviteAPIRequests: APIBaseRequest {
    
    private var requestType: GetStateNewInviteAPIEndpoint
    
    init(requestType: GetStateNewInviteAPIEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "get_new_invite_state"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .setUser(let user):
            return ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                    // "limit": user.firstName as AnyObject,
                // "offset": user.lastName as AnyObject
            ]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
