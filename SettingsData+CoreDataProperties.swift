//
//  SettingsData+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 23/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension SettingsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsData> {
        return NSFetchRequest<SettingsData>(entityName: "SettingsData")
    }

    @NSManaged public var vslName: String?
    @NSManaged public var vslLength: String?
    @NSManaged public var vslBeam: String?
    @NSManaged public var vslEmail: String?
    @NSManaged public var vslType: Int16
    @NSManaged public var now: Date?
}
