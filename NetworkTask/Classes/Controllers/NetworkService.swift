
import Foundation

class NetworkService: NSObject {
    
    //base url
    static let kBASE_URL = "http://example.com/api/v1/"
    
    //token for requests
    var authToken: String?
    
    
    //MARK: Singleton
    
    static var sharedService: NetworkService = NetworkService()
    
    
    //MARK: Requests
    
    func registerUserWith(login: String?, password: String?, success: @escaping (Data)->(), failure: @escaping (Error?) -> ()) {
        
        // POST http://example.com/api/v1/user
        
        //register user method
    }
    
    func getAllEvents(success: @escaping (Data)->(), failure: @escaping (Error?) -> ()) {
        // GET http://example.com/api/v1/events
        //get all events method
    }
    
    func subscribeOnEvent(eventUUID: Int, success: @escaping (Data)->(), failure: @escaping (Error?) -> ()) {
        // GET http://example.com/api/v1/event/{uuid}/join
        //subscribe method
    }
    
    func unsubscribeFromEvent(eventUUID: Int, success: @escaping (Data)->(), failure: @escaping (Error?) -> ()) {
        // GET http://example.com/api/v1/event/{uuid}/leave
        
        //unsubscribe method
    }
    
    func logout() {
        // logout user. Clear any user-related resources
    }
}
