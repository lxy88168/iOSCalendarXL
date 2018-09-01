//
//  Models.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/24.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import Foundation

protocol MediaCellDelegate {
    func onDelete(sender: MediaCollectionViewCell)
}

class Media : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(filePath, forKey: "filePath")
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = MediaType(rawValue: aDecoder.decodeInteger(forKey: "type"))!
        filePath = aDecoder.decodeObject(forKey: "filePath") as! String
    }
    
    enum MediaType : Int {
        case Audio
        case Image
        case None
    }
    
    var type: MediaType!
    var filePath: String!
    
    init(mediaType: MediaType, filePath: String) {
        self.type = mediaType
        self.filePath = filePath
    }
    
}

enum RemindRepeatType : Int {
    case Norepeat
    case RepeatPerYear
    case RepeatPerMonth
    case RepeatPerWeek
    case RepeatPerDay
}

class Remind: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(filePath, forKey: "filePath")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(repeatType.rawValue, forKey: "repeatType")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(remarks, forKey: "remarks")
        aCoder.encode(medias, forKey: "medias")
    }
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        filePath = aDecoder.decodeObject(forKey: "filePath") as! String
        content = aDecoder.decodeObject(forKey: "content") as! String
        date = aDecoder.decodeObject(of: Date.ReferenceType.self, forKey: "date")! as Date
        repeatType = RemindRepeatType(rawValue: aDecoder.decodeInteger(forKey: "repeatType"))!
        location = aDecoder.decodeObject(forKey: "location") as? String
        remarks = aDecoder.decodeObject(forKey: "remarks") as? String
        medias = aDecoder.decodeObject(forKey: "medias") as! [Media]
    }
    
    var filePath: String?
    var content = ""
    var date = Date()
    var repeatType: RemindRepeatType = .Norepeat
    var location: String?
    var remarks: String?
    var medias: [Media] = []
}
