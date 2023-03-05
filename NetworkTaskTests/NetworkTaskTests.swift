
import XCTest
@testable import NetworkTask


class NetworkTaskTests: XCTestCase {
    
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        MSSwizzlingModule.setupSwizzling()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetAllEvents() {
        if MSSwizzlingModule.responds(to: Selector(("getAllEvents"))) {
            let event: Unmanaged<AnyObject> = MSSwizzlingModule.perform(Selector(("getAllEvents")))
            let eventsArray: [[String: Any?]] = event.takeUnretainedValue() as! [[String : Any?]]
            XCTAssertTrue(eventsArray.count > 0)
        }
    }
    
    func testUserRegistrationMethod() {
        let expectation: XCTestExpectation = self.expectation(description: "user registration")
        
        let login: String = "3333"
        let password: String = "123123"
        
        NetworkService.sharedService.registerUserWith(login: login, password: password, success: { (responseData) in
            expectation.fulfill()
            XCTAssertNotNil(responseData, "Data is nil") //response data is not nil
            do {
                let json: [String: Any?] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any?]
                let authToken: String = ((json["response"] as! [String: Any])["user"] as! [String: Any])["authToken"] as! String
                XCTAssertNotNil(authToken, "AuthToken is nil") // authToken is not nil
                
                let predicate: NSPredicate = NSPredicate(format: "SELF.authToken contains[cd] %@", authToken)
                var usersArray: [[String: Any?]]?
                if MSSwizzlingModule.responds(to: Selector(("getAllUsers"))) {
                    let users: Unmanaged<AnyObject> = MSSwizzlingModule.perform(Selector(("getAllUsers")))
                    usersArray = users.takeUnretainedValue() as? [[String : Any?]]
                }
                let result: NSArray = (usersArray! as NSArray).filtered(using: predicate) as NSArray
                XCTAssertTrue(result.count == 1) //user exist in the global users array
            } catch let error {
                print(error)
            }
        }) { (error) in
            expectation.fulfill()
            XCTFail()
        }
        
        waitForExpectations(timeout: 4) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func testGetAllEventsMethod() {
        self.testUserRegistrationMethod() //creating user with authToken
        
        let expectation: XCTestExpectation = self.expectation(description: "get events")
        
        NetworkService.sharedService.getAllEvents(success: { (responseData) in
            expectation.fulfill()
            XCTAssertNotNil(responseData, "Data is nil") //response data is not nil
            do {
                let json: [String: Any?] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any?]
                
                var eventsArray: [[String: Any?]]?
                if MSSwizzlingModule.responds(to: Selector(("getAllEvents"))) {
                    let events: Unmanaged<AnyObject> = MSSwizzlingModule.perform(Selector(("getAllEvents")))
                    eventsArray = events.takeUnretainedValue() as? [[String : Any?]]
                }
                
                XCTAssertTrue(((json["response"] as! [String: Any?])["events"] as! [[String: Any?]]).count == eventsArray!.count) //user exist in the global users array
            } catch let error {
                print(error)
            }
        }) { (error) in
            expectation.fulfill()
            XCTFail()
        }
        
        waitForExpectations(timeout: 4) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func testSubscribeOnEventMethod() {
        
        self.testUserRegistrationMethod() //creating user with authToken
        
        let expectation: XCTestExpectation = self.expectation(description: "subscribe")
        let eventUUID: Int = 11
        NetworkService.sharedService.subscribeOnEvent(eventUUID: eventUUID, success: { (responseData) in
            expectation.fulfill()
            XCTAssertNotNil(responseData, "Data is nil") //response data is not nil
            do {
                let json: [String: Any?] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any?]
                XCTAssertNotNil(((json["response"] as! [String: Any?])["user"] as! [String: Any])["events"], "Events array is nil"); // events array is not nil
                
                let events: [[String: Any?]] = ((json["response"] as! [String: Any?])["user"] as! [String: Any])["events"] as! [[String : Any?]]
                let predicate: NSPredicate = NSPredicate(format: "SELF.uuid == %ld", eventUUID)
                let result: NSArray = (events as NSArray).filtered(using: predicate) as NSArray
                XCTAssertTrue(result.count == 1) //user exist in the global users array
            } catch let error {
                print(error)
            }
            
        }) { (error) in
            expectation.fulfill()
            XCTFail()
        }
        
        waitForExpectations(timeout: 4) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
}
