//
//  Ext DM Berth.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 08/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
	
	func fetchBerthPerActivity (fetchedEvents : LocationAndEvents, act : ActivityCase) -> [String] {
		var berths : [String] = []
		guard let events = fetchedEvents.activity else {
			return []
		}
		var e = events.allObjects as! [Activity]
		e.sort { (first: Activity, second: Activity ) -> Bool in first.eventID < second.eventID }
		
		for t in e {
			berths.append(t.berthOfActivity ?? "") 
			
		}
		return berths
	}
}
