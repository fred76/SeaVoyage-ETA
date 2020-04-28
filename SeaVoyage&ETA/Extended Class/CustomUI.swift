//
//
//  CustomUI.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 07/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import SwiftUI

struct SegmentedController : View {
	var selector = ["MGO","HFO"]
	@Binding var selectedElement: Int
	
	
	@inlinable init(_ selectedElement: Binding<Int>) {
		self._selectedElement = selectedElement
	}
	var label : String = ""
	
	var body: some View {
		VStack {
			Text(label)
				.font(.footnote)
				.fontWeight(.light)
				.foregroundColor(Color.gray)
				.multilineTextAlignment(.center)
				.padding(.horizontal)
			Picker("Numbers", selection: $selectedElement) {
				ForEach(0 ..< selector.count) { index in
					Text(self.selector[index]).tag(index)
					
				}
			}
			.pickerStyle(SegmentedPickerStyle())
		}
	}
}

struct SwitchWithLabel: View {
	
	@Binding var isToggleOn: Bool
	var label : String = ""
	
	@inlinable init(_ isToggleOn: Binding<Bool>, label : String) {
		self._isToggleOn = isToggleOn
		self.label = label
	}
	
	var body: some View {
		HStack {
			VStack {
				Text(label)
					.font(.footnote)
					.fontWeight(.light)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
					.padding(.horizontal)
				Toggle(isOn: $isToggleOn) {
					Text("")
				}.labelsHidden()
			}
		}
	}
}

struct DatePickerInput: View {
	@State var actualDate = Date()
	@Binding var showDatePickerInput : Bool
	@ObservedObject var vesselInitialSettings : VesselInitialSettings
	var body: some View {
		VStack {
			Spacer()
			VStack {
				
				HStack{
					Button(action: {
						withAnimation {
							self.showDatePickerInput = false
						}
					}) {
						Text("Cancel").padding(.horizontal)
					}
					Spacer()
					Button(action: {
						withAnimation {
							self.showDatePickerInput = false
							self.tapDone(self.actualDate)
						}
						
						
					}) {
						Text("Done").padding(.horizontal)
					}
				}.frame(height: 44)
					.background(Color.gray)
				Divider()
				DatePicker("", selection: $actualDate, displayedComponents: [.date, .hourAndMinute]) .environment(\.locale, .init(identifier: "en_GB"))
					
					.colorScheme(.dark)
					.labelsHidden()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.gray)
							.padding(.horizontal, 10)
				)
				
			}.background(StaticClass.lightGrey)
		}.transition(.move(edge: .bottom))
		
	}
	func tapDone(_ date:Date)   {
		var mgo: String = "0"
		var hfo: String = "0"
		var timeZone = 0.0
		if let v = DataManager.shared.fetchVesselInitialSettings() {
			mgo = v.initialMGO ?? "0"
			hfo = v.initialHFO ?? "0"
			timeZone = v.timeZoneFromSetting
		}
		let dateformatter = StaticClass.dateFormatterLongLong
		let dateToString = dateformatter.string(from: date)
		let v = DataManager.shared.RefreshVesselInitialSettings()
		v.now = Date()
		v.initialDate = dateToString
		v.initialMGO = mgo
		v.initialHFO = hfo
		v.timeZoneFromSetting = timeZone
		CoreData.stack.save()
	}
}

struct BunkerPickerInputHFO: View {
	@State var data: [(String, [String])] = [
		("One", Array(0...9).map { "\($0)" }),
		("Two", Array(0...9).map { "\($0)" }),
		("Three", Array(0...9).map { "\($0)" }),
		("four", Array(0...9).map { "\($0)" }),
		("five", Array(0...9).map { "\($0)" }),
		("six", ["."].map { "\($0)" }),
		("seven", Array(0...9).map { "\($0)" })
	]
	@State var selection: [String] = [0,0,0,0,0,".",0].map { "\($0)" }
	@Binding var showBunkerPickerInputHFO : Bool
	@ObservedObject var vesselInitialSettings : VesselInitialSettings
	var body: some View {
		VStack {
			Spacer()
			VStack {
				
				HStack{
					Button(action: {
						withAnimation {
							self.showBunkerPickerInputHFO = false
						}
					}) {
						Text("Cancel").padding(.horizontal)
					}
					Spacer()
					Button(action: {
						withAnimation {
							self.showBunkerPickerInputHFO = false
							self.tapDone()
						}
						
						
					}) {
						Text("Done").padding(.horizontal)
					}
				}.frame(height: 44)
					.background(Color.gray)
				Divider()
				
				MultiPicker(data: data, selection: $selection).frame(height: 300)
					.colorScheme(.dark)
					.labelsHidden()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.gray)
							.padding(.horizontal, 10)
				)
				
			}.background(StaticClass.lightGrey)
		}.transition(.move(edge: .bottom))
		
		
	}
	
	func initialHFO ()-> String{
		var joined = selection.joined(separator: "")
		
		joined = joined.replacingOccurrences(of: "0", with: "", options: [.anchored], range: nil)
		
		return joined
	}
	
	func tapDone() {
		var date: String = "01/01/20 0000"
		var mgo: String = "0"
		var timeZone = 0.0
		if let v = DataManager.shared.fetchVesselInitialSettings() {
			date = v.initialDate ?? "01/01/20 0000"
			mgo = v.initialMGO ?? "0"
			timeZone = v.timeZoneFromSetting
		}
		
		
		let v = DataManager.shared.RefreshVesselInitialSettings()
		v.now = Date()
		v.initialDate = date
		v.initialMGO = mgo
		v.initialHFO = initialHFO()
		v.timeZoneFromSetting = timeZone
		CoreData.stack.save()
	}
}

struct BunkerPickerInputMGO: View {
	@State var data: [(String, [String])] = [
		("One", Array(0...9).map { "\($0)" }),
		("Two", Array(0...9).map { "\($0)" }),
		("Three", Array(0...9).map { "\($0)" }),
		("four", Array(0...9).map { "\($0)" }),
		("five", Array(0...9).map { "\($0)" }),
		("six", ["."].map { "\($0)" }),
		("seven", Array(0...9).map { "\($0)" })
	]
	@State var selection: [String] = [0,0,0,0,0,".",0].map { "\($0)" }
	@Binding var showBunkerPickerInputMGO : Bool
	@ObservedObject var vesselInitialSettings : VesselInitialSettings
	var body: some View {
		VStack {
			Spacer()
			VStack {
				HStack{
					Button(action: {
						withAnimation {
							self.showBunkerPickerInputMGO = false
						}
					}) {
						Text("Cancel").padding(.horizontal)
					}
					Spacer()
					Button(action: {
						withAnimation {
							self.showBunkerPickerInputMGO = false
							self.tapDone()
						}
						
						
					}) {
						Text("Done").padding(.horizontal)
					}
				}.frame(height: 44)
					.background(Color.gray)
				Divider()
				
				MultiPicker(data: data, selection: $selection).frame(height: 300)
					.colorScheme(.dark)
					.labelsHidden()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.gray)
							.padding(.horizontal, 10)
				)
				
			}.background(StaticClass.lightGrey)
		}.transition(.move(edge: .bottom))
	}
	
	func initialMGO ()-> String{
		var joined = selection.joined(separator: "")
		
		joined = joined.replacingOccurrences(of: "0", with: "", options: [.anchored], range: nil)
		
		return joined
	}
	
	func tapDone() {
		var date: String = "01/01/20 0000"
		var hfo: String = "0"
		var timeZone = 0.0
		if let v = DataManager.shared.fetchVesselInitialSettings() {
			date = v.initialDate ?? "01/01/20 0000"
			hfo = v.initialHFO ?? "0"
			timeZone = v.timeZoneFromSetting
			
		}
		
		let v = DataManager.shared.RefreshVesselInitialSettings()
		v.now = Date()
		v.initialDate = date
		v.initialHFO = hfo
		v.initialMGO = initialMGO()
		v.timeZoneFromSetting = timeZone
		CoreData.stack.save()
	}
}

struct TimeZoneStepper: View {
	@Binding var showTimeZoneStepper : Bool
	@State var timeZoneSet : Double = 0.0
	@ObservedObject var loc : LocationAndEvents
	var body: some View {
		VStack {
			HStack{
				Button(action: {
					withAnimation {
						self.showTimeZoneStepper = false
					}
				}) {
					Text("Cancel").padding(.horizontal)
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.showTimeZoneStepper = false
						self.tapDone()
					}
				}) {
					Text("Done").padding(.horizontal)
				}
			}.frame(height: 44)
				.background(Color.gray)
			Divider()
			HStack {
				Text("\(self.timeZoneSet, specifier: "%.1f")").font(.footnote)
				Stepper("", onIncrement: {
					if self.timeZoneSet <= 11.5  {
						self.timeZoneSet += (0.5)
					}
				}, onDecrement: {
					if self.timeZoneSet >= -11.5 {
						self.timeZoneSet -= (0.5)
					}
				}).labelsHidden()
			}.padding()
				.onAppear(perform: {
					self.timeZoneSet =  self.loc.timeZoneForLocation
				})
		}.background(StaticClass.lightGrey) .transition(.move(edge: .bottom))
	}
	func tapDone() {
		self.loc.timeZoneForLocation = self.timeZoneSet
		CoreData.stack.save()
	}
}
struct TimeZoneStepperInitialMenu: View {
	@Binding var showTimeZoneStepper : Bool
	@State var timeZoneSet : Double = 0.0
	@ObservedObject var vesselInitialSettings : VesselInitialSettings
	var body: some View {
		
		VStack {
			Spacer()
			HStack{
				Button(action: {
					withAnimation {
						self.showTimeZoneStepper = false
					}
				}) {
					Text("Cancel").padding(.horizontal)
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.showTimeZoneStepper = false
						self.tapDone()
					}
				}) {
					Text("Done").padding(.horizontal)
				}
			}.frame(height: 44)
				.background(Color.gray)
			Divider()
			HStack {
				Text("\(self.timeZoneSet, specifier: "%.1f")").font(.footnote)
				Stepper("", onIncrement: {
					if self.timeZoneSet <= 11.5  {
						self.timeZoneSet += (0.5)
					}
				}, onDecrement: {
					if self.timeZoneSet >= -11.5 {
						self.timeZoneSet -= (0.5)
					}
				}).labelsHidden()
			}.padding()
				.onAppear(perform: {
					if let v = DataManager.shared.fetchVesselInitialSettings() {
						self.timeZoneSet =  v.timeZoneFromSetting
					}
				})
		}.background(StaticClass.lightGrey) .transition(.move(edge: .bottom))
	}
	func tapDone() {
		var date: String = "01/01/20 0000"
		var hfo: String = "0"
		var mgo: String = "0"
		if let v = DataManager.shared.fetchVesselInitialSettings() {
			date = v.initialDate ?? "01/01/20 0000"
			hfo = v.initialHFO ?? "0"
			mgo = v.initialMGO ?? "0"
			
		}
		
		let v = DataManager.shared.RefreshVesselInitialSettings()
		v.now = Date()
		v.initialDate = date
		v.initialHFO = hfo
		v.initialMGO = mgo
		v.timeZoneFromSetting = timeZoneSet
		CoreData.stack.save()
	}
}

struct SegmentedControllerForMap : View {
	
	var selector = ["Standard","Hybrid","Satelite"]
	@Binding var selectedElement: Int
	
	
	@inlinable init(_ selectedElement: Binding<Int>) {
		self._selectedElement = selectedElement
	}
	var label : String = ""
	
	var body: some View {
		VStack {
			Text(label)
				.font(.footnote)
				.fontWeight(.light)
				.foregroundColor(Color.gray)
				.multilineTextAlignment(.center)
				.padding(.horizontal)
			Picker("Numbers", selection: $selectedElement) {
				ForEach(0 ..< selector.count) { index in
					Text(self.selector[index]).tag(index)
					
				}
			}
			.pickerStyle(SegmentedPickerStyle())
		}
	}
}
