
//  Guide.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 11/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import Foundation
import Parse

class Module: PFObject {
   
    @NSManaged var code: String
    @NSManaged var fullDescription: String
    @NSManaged var courseName: String
    @NSManaged var userCount : Int
    
}

extension Module: PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : Int = 0;
        }
        
    }
    static func parseClassName() -> String {
        return ParseClass.Module
    }
}

extension Module {
    class func fetchModules(_ skip: Int = 0, limit: Int = 10, closure: @escaping ([Module]?, NSError?) -> Void) {
        let query = PFQuery(className: ParseClass.Module)
        query.skip = skip
        query.limit = limit
        query.order(byDescending: "code")
        query.findObjectsInBackground { (modules, error) in
        guard let modules = modules as? [Module] else {return}
        closure(modules, error as NSError?)
        }
    }
}
