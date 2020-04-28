//
//  BunkerVslDetails+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension BunkerVslDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BunkerVslDetails> {
        return NSFetchRequest<BunkerVslDetails>(entityName: "BunkerVslDetails")
    }

    @NSManaged public var boilerConsuptionMax: Double
    @NSManaged public var boilerConsuptionMin: Double
    @NSManaged public var ddggConsuption: Double
    @NSManaged public var eightyBallast: Double
    @NSManaged public var eightyLadden: Double
    @NSManaged public var eightySpeed: Double
    @NSManaged public var forthyBallast: Double
    @NSManaged public var forthyLadden: Double
    @NSManaged public var forthySpeed: Double
    @NSManaged public var fullBallast: Double
    @NSManaged public var fullLadden: Double
    @NSManaged public var fullSpeed: Double
    @NSManaged public var hfoCapacity: Double
    @NSManaged public var mgoCapacity: Double
    @NSManaged public var now: Date?
    @NSManaged public var sixtyBallast: Double
    @NSManaged public var sixtyLadden: Double
    @NSManaged public var sixtySpeed: Double

}
