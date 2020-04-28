//
//  Extension.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import SwiftUI

extension Animation {
	static func ripple(index: Int, dismiss : Bool) -> Animation { 
		Animation.spring(dampingFraction: 1.9)
			.speed(1)
			.delay(dismiss ? 0.05 * Double(index) : 0) 
	}
	
	static func wave(index: Int ) -> Animation {
		Animation.linear(duration: 0.15 * Double(index)) 
			.speed(1)
			.delay( 0.15 * Double(index) )
	}
}

struct RoundedCorner: Shape {
	
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}
extension View {
	func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape( RoundedCorner(radius: radius, corners: corners) )
	}
}

extension String {
	var floatValue: Float {
		let nf = NumberFormatter()
		nf.decimalSeparator = "."
		if let result = nf.number(from: self) {
			return result.floatValue
		} else {
			nf.decimalSeparator = ","
			if let result = nf.number(from: self) {
				return result.floatValue
			}
		}
		return 0
	}
	
	var doubleValue:Double {
		let nf = NumberFormatter()
		nf.decimalSeparator = "."
		if let result = nf.number(from: self) {
			return result.doubleValue
		} else {
			nf.decimalSeparator = ","
			if let result = nf.number(from: self) {
				return result.doubleValue
			}
		}
		return 0
	}
}

extension Int {
	
	var bool: Bool {
		return self == 1 ? true : false
	}
}
extension Bool {
	
	var inte: Int {
		return self == true ? 1 : 0
	}
}

struct pippo {
	var locationID : String
	var locationAndEventsRequest : FetchRequest<LocationAndEvents>
	var locationAndEvents : FetchedResults<LocationAndEvents>{locationAndEventsRequest.wrappedValue }
	
	init(
		locationID:String
	){
		self.locationID = locationID
		self.locationAndEventsRequest = FetchRequest(entity: Ports.entity(), sortDescriptors: [], predicate:
			NSPredicate(format: "locationID == %@", locationID))
	}
}


func delay(_ delay:Double, closure:  @escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
