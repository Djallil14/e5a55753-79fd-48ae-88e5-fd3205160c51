
import Foundation

struct AuthentificationRequest: Encodable {
    let username: String
    let password: String
}

class NetworkService: NSObject {
    
    //base url
    static let kBASE_URL = "http://example.com/api/v1/"
    
    //token for requests
    private var authToken: String?
    
    private(set) var user: User?
    //MARK: Singleton
    
    static var sharedService: NetworkService = NetworkService()
    
    enum NetworkError: Error {
        case wrongURL
        case missingCredential
        case encodingError
        case decodingError
    }
    
    enum HTTPMethods: String {
        case post = "POST"
        case get = "GET"
        case delete = "DELETE"
    }
    
    //MARK: Requests
    
    func registerUserWith(login: String?, password: String?, success: @escaping (UserResponse)->(), failure: @escaping (Error?) -> ()) {
        
        // POST http://example.com/api/v1/user
        guard let url = URL(string: "https://example.com/api/v1/user") else {
            failure(NetworkError.wrongURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        
        guard let username = login, let password = password else {
            // Could do more checking like for empty fields and other specified rules by the api
            failure(NetworkError.missingCredential)
            return
        }
        let authRequest = AuthentificationRequest(username: username, password: password)
        guard let httpBody = try? JSONEncoder().encode(authRequest) else {
            failure(NetworkError.encodingError)
            return
        }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                failure(error)
                return
            } else {
                if let userData = data, let userResponse = try? JSONDecoder().decode(UserResponse.self, from: userData) {
                    self.user = User(userResponse: userResponse)
                    self.authToken = userResponse.authToken
                    success(userResponse)
                }
            }
        }
        task.resume()
    }
    
    func getAllEvents(success: @escaping ([Event])->(), failure: @escaping (Error?) -> ()) {
        // GET http://example.com/api/v1/events
        guard let url = URL(string: "http://example.com/api/v1/events") else {
            failure(NetworkError.wrongURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                failure(error)
                return
            } else {
                if let eventData = data, let events = try? JSONDecoder().decode([Event].self, from: eventData) {
                    success(events)
                } else {
                    failure(NetworkError.decodingError)
                }
            }
        }
        task.resume()
    }
    
    func subscribeOnEvent(eventUUID: Int, success: @escaping (Event)->(), failure: @escaping (Error?) -> ()) {
        // GET http://example.com/api/v1/event/{uuid}/join
        guard let url = URL(string: "http://example.com/api/v1/event/\(eventUUID)/join") else {
            failure(NetworkError.wrongURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                failure(error)
                return
            } else {
                if let eventData = data, let event = try? JSONDecoder().decode(Event.self, from: eventData) {
                    self.user?.events.append(event)
                    success(event)
                } else {
                    failure(NetworkError.decodingError)
                }
            }
        }
        task.resume()
    }
    
    func unsubscribeFromEvent(eventUUID: Int, success: @escaping (Event)->(), failure: @escaping (Error?) -> ()) {
        // GET http://example.com/api/v1/event/{uuid}/leave
        guard let url = URL(string: "http://example.com/api/v1/event/\(eventUUID)/join") else {
            failure(NetworkError.wrongURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                failure(error)
                return
            } else {
                if let eventData = data, let event = try? JSONDecoder().decode(Event.self, from: eventData) {
                    self.user?.events.removeAll(where: {$0.uuid == event.uuid})
                    success(event)
                } else {
                    failure(NetworkError.decodingError)
                }
            }
        }
        task.resume()
    }
    
    func logout() {
        user = nil
        authToken = nil
    }
}
