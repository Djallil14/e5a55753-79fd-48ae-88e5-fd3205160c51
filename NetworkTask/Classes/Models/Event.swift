
import Foundation

class EventModel: NSObject {
    
    var uuid: NSNumber!
    var name: String!
    var date: String!
    
    
    //MARK: Init
    
    override init() {
        super.init()
    }
    
    convenience init(data: Data) {
        self.init()
        do {
            let JSONDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            self.setValuesForKeys(JSONDictionary as! [String : Any])
        } catch let error {
            print(error)
        }
    }
}
