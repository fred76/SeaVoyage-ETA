//
//  Ext DM MapKit.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 09/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import MapKit
import CoreData
extension DataManager {
	
	func annotationArray() -> [MKPointAnnotation] {
		var pin : [MKPointAnnotation] = []
		let request = NSFetchRequest<BerthDetail>(entityName: "BerthDetail")
		
		do {
			let berthDetailsArray = try CoreData.stack.context.fetch(request) as [BerthDetail]
			for b in berthDetailsArray {
				if b.latitude != 0 {
					let annotation = MKPointAnnotation()
					annotation.coordinate = CLLocationCoordinate2D(latitude: b.latitude, longitude: b.longitude)
					annotation.title = b.berth?.berthName ?? ""
					pin.append(annotation)
				}
			}
			
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		
		return pin
	}
}
