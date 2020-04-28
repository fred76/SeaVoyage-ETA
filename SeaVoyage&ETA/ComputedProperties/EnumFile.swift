//
//  EnumFile.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation 
import SwiftUI

@objc enum ActivityCase: Int, CaseIterable {
	case seaPassage = 0
	case pltIn = 1
	case pltOut = 2
	case loading = 3
	case discharging = 4
	case shifting = 5
	case layby = 6
	case bunkering = 7
	case anchoring = 8
	case canal = 9
	
	
	init(type : Int) {
		switch type {
		case 0: self = .seaPassage
		case 1: self = .pltIn
		case 2: self = .pltOut
		case 3: self = .loading
		case 4: self = .discharging
		case 5: self = .shifting
		case 6: self = .layby
		case 7: self = .bunkering
		case 8: self = .anchoring
		case 9: self = .canal
		default: self = .seaPassage
		}
	}
	
	var text : String{
		switch self {
		case .seaPassage: return "Sea Passage"
		case .pltIn: return "Pilotage Inbound"
		case .pltOut: return "Pilotage Outbound"
		case .loading: return "Loading Cargo"
		case .discharging: return "Discharging Cargo"
		case .shifting: return "Shifting"
		case .layby: return "Layby Berth"
		case .bunkering: return "Bunkering"
		case .anchoring: return "Anchoring"
		case .canal: return "Canal Transit"
			
		}
	}
	
	var shortText : String{
		switch self {
		case .seaPassage: return "ETA"
		case .pltIn: return "ETB"
		case .pltOut: return "SoSP"
		case .loading: return "ETC"
		case .discharging: return "ETC"
		case .shifting: return "ETB"
		case .layby: return "ETC"
		case .bunkering: return "ETC"
		case .anchoring: return "ETC"
		case .canal: return "ETC"
			
		}
	}
	
	var imageName : String{
		switch self {
		case .seaPassage: return "seapassage"
		case .pltIn: return "pltin"
		case .pltOut: return "pltout"
		case .loading: return "loading"
		case .discharging: return "discharging"
		case .shifting: return "shifting"
		case .layby: return "laybay"
		case .bunkering: return "bunkerong"
		case .anchoring: return "anchor"
		case .canal: return "canal"
			
		}
	}
	
	var color : Color{
		switch self {
		case .seaPassage: return StaticClass.seaPassageColor
		case .pltIn: return StaticClass.pltInColor
		case .pltOut: return StaticClass.pltOutColor
		case .loading: return StaticClass.loadingColor
		case .discharging: return StaticClass.dischargingColor
		case .shifting: return StaticClass.shiftingColor
		case .layby: return StaticClass.laybyColor
		case .bunkering: return StaticClass.bunkeringColor
		case .anchoring: return StaticClass.anchoringColor
		case .canal: return StaticClass.canalColor
			
		}
	}
	
	
	var label : Int{
		switch self {
		case .seaPassage: return 0
		case .pltIn: return 1
		case .pltOut: return 2
		case .loading: return 3
		case .discharging: return 4
		case .shifting: return 5
		case .layby: return 6
		case .bunkering: return 7
		case .anchoring: return 8
		case .canal: return 9
			
		}
	}
	
	var radious : CGFloat{
		switch self {
		case .seaPassage: return 10
		case .pltIn: return 10
		case .pltOut: return 10
		case .loading: return 10
		case .discharging: return 10
		case .shifting: return 10
		case .layby: return 10
		case .bunkering: return 10
		case .anchoring: return 10
		case .canal: return 10
			
		}
	}
	
	var rectCorner : UIRectCorner{
		switch self {
		case .seaPassage: return [.topLeft, .topRight]
		case .pltIn: return [.topRight]
		case .pltOut: return [.topRight]
		case .loading: return [.topRight]
		case .discharging: return [.topRight]
		case .shifting: return [.topRight]
		case .layby: return [.topRight]
		case .bunkering: return [.topRight]
		case .anchoring: return [.topRight]
		case .canal: return [.bottomLeft, .bottomRight, .topRight]
			
		}
	}
}

@objc enum MapCase: Int, CaseIterable {
	case mapNotSet = 0
	case map = 1
	
	
	init(type : Int) {
		switch type {
		case 0: self = .mapNotSet
		case 1: self = .map
		default: self = .mapNotSet
		}
	}
	var text : String{
		switch self {
		case .mapNotSet: return "Select berth location"
		case .map: return "Berth Location"
		}
	}
	var label : Int{
		switch self {
		case .mapNotSet: return 0
		case .map: return 1
		}
	}
	
	var imageName : String{
		switch self {
		case .mapNotSet: return "map"
		case .map: return "map"
		}
	}
}

@objc enum DraftCase: Int, CaseIterable{
	case draftNotSet = 0
	case draft = 1
	
	
	init(type : Int) {
		switch type {
		case 0: self = .draftNotSet
		case 1: self = .draft
		default: self = .draftNotSet
		}
	}
	var text : String{
		switch self {
		case .draftNotSet: return "Minimum draft to the berth"
		case .draft: return "Draft:"
		}
	}
	var label : Int{
		switch self {
		case .draftNotSet: return 0
		case .draft: return 1
		}
	}
	
	var imageName : String{
		switch self {
		case .draftNotSet: return "draft"
		case .draft: return "draft"
		}
	}
	
	var title : String{
		switch self {
		case .draftNotSet: return "Draft"
		case .draft: return "Draft"
		}
	}
}

@objc enum MooringSideCase: Int, CaseIterable {
	case mooringNotSet = 0
	case mooringSTBDSide = 1
	case mooringPortSide = 2
	case mooringByAft = 3
	case mooringAtBuoy = 4
	
	
	init(type : Int) {
		switch type {
		case 0: self = .mooringNotSet
		case 1: self = .mooringSTBDSide
		case 2: self = .mooringPortSide
		case 3: self = .mooringByAft
		case 4: self = .mooringAtBuoy
		default: self = .mooringNotSet
		}
		
	}
	
	var text : String{
		switch self {
		case .mooringNotSet: return "Mooring side:"
		case .mooringSTBDSide: return "Mooring starboard side"
		case .mooringPortSide: return "Mooring port side"
		case .mooringByAft: return "Mooring by aft"
		case .mooringAtBuoy: return "Mooring at buoy"
		}
	}
	var label : Int{
		switch self {
		case .mooringNotSet: return 0
		case .mooringSTBDSide: return 1
		case .mooringPortSide: return 2
		case .mooringByAft: return 3
		case .mooringAtBuoy: return 4
		}
	}
	
	var imageName : String{
		switch self {
		case .mooringNotSet: return "mooring"
		case .mooringSTBDSide: return "moored.sbds"
		case .mooringPortSide: return "moored.port"
		case .mooringByAft: return "moored.aft"
		case .mooringAtBuoy: return "moored.buoy"
		}
	}
	
	var title : String{
		switch self {
		case .mooringNotSet: return "Mooring"
		case .mooringSTBDSide: return "Mooring"
		case .mooringPortSide: return "Mooring"
		case .mooringByAft: return "Mooring"
		case .mooringAtBuoy: return "Mooring"
		}
	}
}

@objc enum TugsBerthinCase: Int, CaseIterable {
	case tugForBerthingNotSet = 0
	case tugCompulsoryForBerthing = 1
	case tugAsPerMasterForBerthing = 2
	
	init(type : Int) {
		switch type {
		case 0: self = .tugForBerthingNotSet
		case 1: self = .tugCompulsoryForBerthing
		case 2: self = .tugAsPerMasterForBerthing
		default: self = .tugForBerthingNotSet
		}
	}
	
	var text : String{
		switch self {
		case .tugForBerthingNotSet: return "Tugs for berthing:"
		case .tugCompulsoryForBerthing: return "Tug compulsory for berthing"
		case .tugAsPerMasterForBerthing: return "Tug not compulsory for berthing"
		}
	}
	
	
	var label : Int{
		switch self {
		case .tugForBerthingNotSet: return 0
		case .tugCompulsoryForBerthing: return 1
		case .tugAsPerMasterForBerthing: return 2
		}
	}
	
	var imageName : String{
		switch self {
		case .tugForBerthingNotSet: return "tugs.b"
		case .tugCompulsoryForBerthing: return "tug.compulsory"
		case .tugAsPerMasterForBerthing: return "tug.optional"
		}
	}
	
	var title : String{
		switch self {
		case .tugForBerthingNotSet: return "Berthing"
		case .tugCompulsoryForBerthing: return "Berthing"
		case .tugAsPerMasterForBerthing: return "Berthing"
		}
	}
}

@objc enum TugsUnberthinCase: Int, CaseIterable {
	
	case tugForBerthingNotSet = 0
	case tugCompulsoryForUnberthing = 1
	case tugAsPerMasterForUnberthing = 2
	
	init(type : Int) {
		switch type {
		case 0: self = .tugForBerthingNotSet
		case 1: self = .tugCompulsoryForUnberthing
		case 2: self = .tugAsPerMasterForUnberthing
		default: self = .tugForBerthingNotSet
		}
	}
	
	var text : String{
		switch self {
			
		case .tugForBerthingNotSet: return "Tugs for unberthing:"
		case .tugCompulsoryForUnberthing: return "Tug compulsory for unberthing"
		case .tugAsPerMasterForUnberthing: return "Tug not compulsory for unberthing"
		}
	}
	
	
	
	
	var label : Int{
		switch self {
		case .tugForBerthingNotSet: return 0
		case .tugCompulsoryForUnberthing: return 1
		case .tugAsPerMasterForUnberthing: return 2
		}
	}
	var imageName : String{
		switch self {
		case .tugForBerthingNotSet: return "tugs.u"
		case .tugCompulsoryForUnberthing: return "tug.compulsory"
		case .tugAsPerMasterForUnberthing: return "tug.optional"
		}
	}
	
	var title : String{
		switch self {
		case .tugForBerthingNotSet: return "Unerthing"
		case .tugCompulsoryForUnberthing: return "Unerthing"
		case .tugAsPerMasterForUnberthing: return "Unerthing"
		}
	}
}

@objc enum FreshWaterCase: Int, CaseIterable {
	case freshWaterNotSet = 0
	case freshWaterByShore = 1
	case freshWaterByBarge = 2
	
	init(type : Int) {
		switch type {
		case 0: self = .freshWaterNotSet
		case 1: self = .freshWaterByShore
		case 2: self = .freshWaterByBarge
		default: self = .freshWaterNotSet
		}
	}
	
	var text : String{
		switch self {
		case .freshWaterNotSet: return "Freshwater supply by:"
		case .freshWaterByShore: return "Freshwater by shore"
		case .freshWaterByBarge: return "Freshwater by barge"
		}
	}
	
	
	
	var label : Int{
		switch self {
		case .freshWaterNotSet: return 0
		case .freshWaterByShore: return 1
		case .freshWaterByBarge: return 2
		}
	}
	
	var imageName : String{
		switch self {
		case .freshWaterNotSet: return "freshwater"
		case .freshWaterByShore: return "truck"
		case .freshWaterByBarge: return "barge"
		}
	}
	var title : String{
		switch self {
		case .freshWaterNotSet: return "Freshwater"
		case .freshWaterByShore: return "Freshwater"
		case .freshWaterByBarge: return "Freshwater"
		}
	}
}

@objc enum BunkerCase: Int, CaseIterable {
	case bunkerNotSet = 0
	case bunkerByShore = 1
	case bunkerByBarge = 2
	
	init(type : Int) {
		switch type {
		case 0: self = .bunkerNotSet
		case 1: self = .bunkerByShore
		case 2: self = .bunkerByBarge
		default: self = .bunkerNotSet
		}
	}
	
	var text : String{
		switch self {
			
		case .bunkerNotSet: return "Bunker supply by:"
		case .bunkerByShore: return "Bunker by shore"
		case .bunkerByBarge: return "Bunker By barge"
		}
	}
	
	
	var label : Int{
		switch self {
		case .bunkerNotSet: return 0
		case .bunkerByShore: return 1
		case .bunkerByBarge: return 2
		}
	}
	
	var imageName : String{
		switch self {
		case .bunkerNotSet: return "bunker"
		case .bunkerByShore: return "truck"
		case .bunkerByBarge: return "barge"
		}
	}
	var title : String{
		switch self {
		case .bunkerNotSet: return "Bunker"
		case .bunkerByShore: return "Bunker"
		case .bunkerByBarge: return "Bunker"
		}
	}
}

@objc enum SludgeCase: Int, CaseIterable {
	case sludgeNotSet = 0
	case sludgeByShore = 1
	case sludgeByBarge = 2
	
	init(type : Int) {
		switch type {
		case 0: self = .sludgeNotSet
		case 1: self = .sludgeByShore
		case 2: self = .sludgeByBarge
		default: self = .sludgeNotSet
		}
	}
	
	var text : String{
		switch self {
		case .sludgeNotSet: return "Sludge delivered:"
		case .sludgeByShore: return "Sludge by shore"
		case .sludgeByBarge: return "Sludge by barge"
		}
	}
	
	
	var label : Int{
		switch self {
		case .sludgeNotSet: return 0
		case .sludgeByShore: return 1
		case .sludgeByBarge: return 2
		}
	}
	
	var imageName : String{
		switch self {
		case .sludgeNotSet: return "sludge"
		case .sludgeByShore: return "truck"
		case .sludgeByBarge: return "barge"
		}
	}
	var title : String{
		switch self {
		case .sludgeNotSet: return "Sludge"
		case .sludgeByShore: return "Sludge"
		case .sludgeByBarge: return "Sludge"
		}
	}
}

@objc enum StoresCase: Int, CaseIterable {
	case storeNotSet = 0
	case storesByShore = 1
	case storesByBarge = 2
	
	init(type : Int) {
		switch type {
		case 0: self = .storeNotSet
		case 1: self = .storesByShore
		case 2: self = .storesByBarge
		default: self = .storeNotSet
		}
	}
	
	var text : String{
		switch self {
		case .storeNotSet: return "Stores supplied By:"
		case .storesByShore: return "Stores by shore"
		case .storesByBarge: return "Stores by barge"
		}
	}
	
	
	var label : Int{
		switch self {
		case .storeNotSet: return 0
		case .storesByShore: return 1
		case .storesByBarge: return 2
		}
	}
	
	var imageName : String{
		switch self {
		case .storeNotSet: return "stores"
		case .storesByShore: return "truck"
		case .storesByBarge: return "barge"
		}
	}
	
	var title : String{
		switch self {
		case .storeNotSet: return "Stores"
		case .storesByShore: return "Stores"
		case .storesByBarge: return "Stores"
		}
	}
}

@objc enum GarbageCase: Int, CaseIterable {
	case garbageNotSet = 0
	case garbageByShore = 1
	case garbageByBarge = 2
	
	init(type : Int) {
		switch type {
		case 0: self = .garbageNotSet
		case 1: self = .garbageByShore
		case 2: self = .garbageByBarge
		default: self = .garbageNotSet
		}
	}
	
	var text : String{
		switch self {
		case .garbageNotSet: return "Garbage delivered"
		case .garbageByShore: return "Garbage by shore"
		case .garbageByBarge: return "Garbage by barge"
		}
	}
	
	
	
	var label : Int{
		switch self {
		case .garbageNotSet: return 0
		case .garbageByShore: return 1
		case .garbageByBarge: return 2
		}
	}
	
	var imageName : String{
		switch self {
		case .garbageNotSet: return "garbage"
		case .garbageByShore: return "truck"
		case .garbageByBarge: return "barge"
		}
	}
	
	var title : String{
		switch self {
		case .garbageNotSet: return "Garbage"
		case .garbageByShore: return "Garbage"
		case .garbageByBarge: return "Garbage"
		}
	}
}

//Cargo details

@objc enum TankInspectionCase: Int, CaseIterable {
	case tankNoSet = 0
	case fromTopLevel = 1
	case insideTheTanks = 2
	case insideTheTanksAccurated = 3
	case fromTopLevelWithCargoRicirculation = 4
	case insideTheTanksWithCargoRicirculation = 5
	
	init(type : Int) {
		switch type {
		case 0: self = .tankNoSet
		case 1: self = .fromTopLevel
		case 2: self = .insideTheTanks
		case 3: self = .insideTheTanksAccurated
		case 4: self = .fromTopLevelWithCargoRicirculation
		case 5: self = .insideTheTanksWithCargoRicirculation
		default: self = .fromTopLevel
		}
	}
	
	var text : String{
		switch self {
		case .tankNoSet: return "No set"
		case .fromTopLevel: return "From top level"
		case .insideTheTanks: return "From inside the tanks"
		case .insideTheTanksAccurated: return "Inside the tanks accurated"
		case .fromTopLevelWithCargoRicirculation: return "From top level with cargo ricirculation"
		case .insideTheTanksWithCargoRicirculation: return "From inside the tanks with cargo ricirculation"
		}
	}
	
	var label : Int{
		switch self {
		case .tankNoSet: return 0
		case .fromTopLevel: return 1
		case .insideTheTanks: return 2
		case .insideTheTanksAccurated: return 3
		case .fromTopLevelWithCargoRicirculation: return 4
		case .insideTheTanksWithCargoRicirculation: return 5
		}
	}
	
	var imageName : String{
		switch self {
		case .tankNoSet: return "tank.noset"
		case .fromTopLevel: return "tank.insp.top"
		case .insideTheTanks: return "tank.insp"
		case .insideTheTanksAccurated: return "tank.insp.+"
		case .fromTopLevelWithCargoRicirculation: return "fromTopLevelWithCargoRicirculation"
		case .insideTheTanksWithCargoRicirculation: return "insideTheTanksWithCargoRicirculation"
		}
	}
}

@objc enum AnalysesCase : Int, CaseIterable {
	case noAnalyses = 0
	case visualAnalyses = 1
	case labAnalyses = 2
	
	init(type : Int) {
		switch type {
		case 0: self = .noAnalyses
		case 1: self = .visualAnalyses
		case 2: self = .labAnalyses
		default: self = .noAnalyses
		}
	}
	
	var text : String{
		switch self {
		case .noAnalyses: return "No Analyses"
		case .visualAnalyses: return "Visual analyses after first foot"
		case .labAnalyses: return "Lab analyses after first foot"
		}
	}
	
	var label : Int{
		switch self {
		case .noAnalyses: return 0
		case .visualAnalyses: return 1
		case .labAnalyses: return 2
		}
	}
	
	var imageName : String{
		switch self {
		case .noAnalyses: return "analyses.no"
		case .visualAnalyses: return "analyses.visual"
		case .labAnalyses: return "analyses.lab"
		}
	}
}

@objc enum ConnectionArrangementCase: Int, CaseIterable {
	case byHose = 0
	case byArm = 1
	
	init(type : Int) {
		switch type {
		case 0: self = .byHose
		case 1: self = .byArm
		default: self = .byHose
		}
	}
	
	var text : String{
		switch self {
		case .byHose: return "By hose"
		case .byArm: return "By arm"
		}
	}
	
	
	
	var label : Int{
		switch self {
		case .byHose: return 0
		case .byArm: return 1
		}
	}
	var imageName : String{
		switch self {
		case .byHose: return "hose"
		case .byArm: return "arm"
		}
	}
}

@objc enum WallWashCase: Int, CaseIterable {
	case noWallWash = 0
	case wallWash = 1
	
	init(type : Int) {
		switch type {
		case 0: self = .noWallWash
		case 1: self = .wallWash
		default: self = .noWallWash
		}
	}
	
	var text : String{
		switch self {
		case .noWallWash: return "No wall wash"
		case .wallWash: return "Wall wash"
		}
	}
	
	
	
	var label : Int{
		switch self {
		case .noWallWash: return 0
		case .wallWash: return 1
		}
	}
	var imageName : String{
		switch self {
		case .noWallWash: return "wallwash.no"
		case .wallWash: return "wallwash"
		}
	}
}
