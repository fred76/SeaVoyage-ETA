//
//  Distances+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension Distances {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Distances> {
        return NSFetchRequest<Distances>(entityName: "Distances")
    }

    @NSManaged public var distances: Double
    @NSManaged public var idDistances: UUID?
    @NSManaged public var pilotStationComposit: String?
    @NSManaged public var voyNotes: String?

}
