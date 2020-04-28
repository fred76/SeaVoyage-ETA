//
//  BerthDetail+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BerthDetail)
public class BerthDetail: NSManagedObject {
	
	class func newBerthDetails() -> BerthDetail {
		return BerthDetail(context: CoreData.stack.context)
	}
	
	class func createBerthFor(item: Berth) -> BerthDetail {
		let berthDetail = BerthDetail.newBerthDetails()
		item.berthDetails = berthDetail
		berthDetail.berth = item
		berthDetail.bunker = 0
		berthDetail.draft = 0
		berthDetail.freshWater = 0
		berthDetail.garbage = 0
		berthDetail.map = 0
		berthDetail.mooringSide = 0
		berthDetail.note = 0
		berthDetail.sludge = 0
		berthDetail.stores = 0
		berthDetail.tugsForMooring = 0
		berthDetail.tugsForUnmooring = 0 
		CoreData.stack.save()
		return berthDetail
	}
	
	
	public var CargoesForBerthArray : [CargoesForBerth] {
		let set = cargoesForBerths as? Set<CargoesForBerth> ?? []
		return set.sorted {
			$0.wrappedCargoName < $1.wrappedCargoName
		}
	}

}
