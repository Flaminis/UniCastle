
//  Guide.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 11/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import Foundation
import Parse

class Course: PFObject {
    
    @NSManaged var courseName: String
    @NSManaged var ucasCode: String
    @NSManaged var imageUrl: String
    @NSManaged var moduleCodes : [String]
    @NSManaged var modules : [String]
    

}

extension Course: PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : Int = 0;
        }
        
    }
    static func parseClassName() -> String {
        return ParseClass.Course
    }
}

extension Course {
//    class func fetchCourses(_ skip: Int = 0, limit: Int = 10, closure: @escaping ([Course]?, NSError?) -> Void) {
//        let query = PFQuery(className: ParseClass.Course)
//        query.skip = skip
//        query.limit = limit
//        query.order(byDescending: "code")
//        query.findObjectsInBackground { (courses, error) in
//            guard let courses = Course as? [Course] else {return}
//            closure(courses, error as NSError?)
//        }
//    }
}
