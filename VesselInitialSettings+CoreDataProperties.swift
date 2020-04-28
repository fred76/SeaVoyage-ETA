//
//  VesselInitialSettings+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension VesselInitialSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VesselInitialSettings> {
        return NSFetchRequest<VesselInitialSettings>(entityName: "VesselInitialSettings")
    }

    @NSManaged public var initialDate: String?
    @NSManaged public var initialHFO: String?
    @NSManaged public var initialMGO: String?
    @NSManaged public var timeZoneFromSetting: Double
    @NSManaged public var now: Date?

}
