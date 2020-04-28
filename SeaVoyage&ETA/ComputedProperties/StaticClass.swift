//
//  StaticClass.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI 
struct StaticClass {
	static let seaPassageColorMY : Color =  Color.init(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
	static let pltInColorMY : Color = Color.init(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))
	static let pltOutColorMY : Color = Color.init(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
	static let loadingColorMY : Color = Color.init(#colorLiteral(red: 0.466843307, green: 0.5564181209, blue: 0.7721902132, alpha: 1))
	static let dischargingColorMY : Color = Color.init(#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
	static let shiftingColorMY : Color = Color.init(#colorLiteral(red: 0.8917668233, green: 0.7751950418, blue: 1, alpha: 1))
	static let laybyColorMY : Color = Color.init(#colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1))
	static let bunkeringColorMY : Color = Color.init(#colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1))
	static let anchoringColorMY : Color = Color.init(#colorLiteral(red: 0.5216948349, green: 1, blue: 0.3349141961, alpha: 1))
	static let canalColorMY : Color = Color.init(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
	static let lightGreyMY : Color = Color.init(#colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1))
	
	static let seaPassageColor : Color =  Color(UIColor.systemBlue)
	static let pltInColor : Color = Color(UIColor.systemGreen)
	static let pltOutColor : Color = Color(UIColor.systemRed)
	static let loadingColor : Color = Color(UIColor.systemOrange)
	static let dischargingColor : Color = Color(UIColor.systemPink)
	static let shiftingColor : Color = Color(UIColor.systemPurple)
	static let laybyColor : Color = Color(UIColor.systemTeal)
	static let bunkeringColor : Color = Color(UIColor.systemGray6)
	static let anchoringColor : Color = Color(UIColor.systemYellow)
	static let canalColor : Color = Color(UIColor.systemIndigo)
	static let lightGrey : Color = Color(UIColor.systemGray)
	
	static func dateFromDoubleSince1970(_ value: Double) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy HHmm"
		let date = Date(timeIntervalSince1970: value)
		let valueX = dateFormatter.string(from: date)
		return valueX
	}
	
	static func dateFromStringSince1970(_ value: String) -> Double {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy HHmm"
		let valueX = dateFormatter.date(from: value)
		let date = valueX?.timeIntervalSince1970
		return date!
	}
	
	static var dateFormatterLongLong: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy HHmm"
		return dateFormatter
	}()
	
	static var systemGray: Color {
		return Color(UIColor.systemGray)
	}
	
	static func dateFromString(value: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy HHmm"
		let valueX = dateFormatter.string(from: value) 
		return valueX
	}
}

