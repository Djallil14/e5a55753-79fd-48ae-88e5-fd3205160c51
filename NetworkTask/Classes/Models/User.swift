
import Foundation

class UserModel: NSObject {
    
    var name: String!
    var uuid: NSNumber!
    var password: String!
    var date: String!
    var authToken: String!
    var events: [Any]!
    
    
    //MARK: Init
    
    override init() {
        super.init()
    }
    
    convenience init(data: Data) {
        self.init()
        do {
            let JSONDictionary = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            self.setValuesForKeys(JSONDictionary as! [String : AnyObject])
            
            var nEvents: [EventModel] = []
            
            for event in events {
                do {
                    let eventsData: Data = try JSONSerialization.data(withJSONObject: event, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let eventModel: EventModel = EventModel(data: eventsData)
                    nEvents.append(eventModel)                   
                } catch let error {
                    print(error)
                }
                
            }
            events = nEvents
        }
    }
}
