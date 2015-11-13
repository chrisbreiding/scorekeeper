import Foundation

class Data {
    class func deserialize(dataString: String) -> [BoardModel] {
        guard let data = dataString.dataUsingEncoding(NSUTF8StringEncoding) else { return [] }
        
        let json = JSON(data: data)
        let boards = json["boards"].arrayValue
        return BoardModel.deserialize(boards)
    }

    class func serialize(boards: [BoardModel]) -> String {
        guard let jsonString = (["boards": BoardModel.serialize(boards)] as JSON).rawString() else { return "" }
        return jsonString
    }
    
    class func load() -> [BoardModel] {
        guard let dataString = localStorage.stringForKey(DATA_KEY) else { return [] }
        return deserialize(dataString)
    }

    class func save(boards: [BoardModel]) {
        localStorage.setObject(serialize(boards), forKey: DATA_KEY)
    }
}
