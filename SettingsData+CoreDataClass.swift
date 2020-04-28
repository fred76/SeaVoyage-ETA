//
//  SettingsData+CoreDataClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 23/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SettingsData)
public class SettingsData: NSManagedObject {
	
	class func newSettingsData() -> SettingsData { 
		return SettingsData(context: CoreData.stack.context)
	}
	class func createSettingsData(
		vslName : String,
		vslLength : String,
		vslBeam : String,
		vslEmail : String,
		vslType : Int) {
		
		let vesselSettingsData = SettingsData.newSettingsData()
		
		vesselSettingsData.vslName = vslName
		vesselSettingsData.vslLength = vslLength
		vesselSettingsData.vslBeam = vslBeam
		vesselSettingsData.vslEmail = vslEmail
		vesselSettingsData.vslType = Int16(vslType)
		vesselSettingsData.now = Date()
		CoreData.stack.save()
		
	}
}
