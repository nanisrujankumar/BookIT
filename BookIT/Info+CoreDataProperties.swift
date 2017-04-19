//
//  Info+CoreDataProperties.swift
//  MotionAngel
//
//  Created by Sagar Babber on 10/4/16.
//  Copyright © 2016 snyxius. All rights reserved.
//

import Foundation
import CoreData


extension Info {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Info> {
        return NSFetchRequest<Info>(entityName: "Jobs");
    }

    @NSManaged public var data: NSData
    

}
