//
//  CargoesForBerth+CoreDataProperties.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension CargoesForBerth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CargoesForBerth> {
        return NSFetchRequest<CargoesForBerth>(entityName: "CargoesForBerth")
    }

    @NSManaged public var analyses: Int16
    @NSManaged public var analysesTime: Double
    @NSManaged public var cargoName: String?
    @NSManaged public var connectionArrangement: Int16
    @NSManaged public var connectionSize: Double
    @NSManaged public var pumpingRate: Double
    @NSManaged public var tankInspection: Int16
    @NSManaged public var wallWash: Int16
    @NSManaged public var berthDetails: BerthDetail?
	@NSManaged public var cargoNote: String?
	 

}
