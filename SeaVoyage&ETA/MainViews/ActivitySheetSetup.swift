//
//  ActivitySheetSetup.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 07/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI

import SwiftUI

struct ActivitySetupSheet: View {
	
	@Binding var dismissFlag: Bool
	@State var activityCase = ActivityCase.canal
	@Binding var pilotstationSelected : String
	@Binding var portSelected : String
	@Binding var berthSelected : String
	@State var durationTextField : String = ""
	@State var speedTextField : String = ""
	@State var mlsTextField : String = ""
	@State var laddenTextField : String = ""
	@State var mgoToBunkerTextField : String = ""
	@State var hfoToBunkerTextField : String = ""
	@State var meSegment: Int = 1
	@State var ddggSegment: Int = 1
	@State var boilerSegment: Int = 1
	@State var fixedMGO: String = ""
	@State var fixedHFO: String = ""
	@State var isDDGGOne: Bool = true
	@State var isDDGGTwo: Bool = true
	@State var isDDGGThree: Bool = true
	@State var isBoilerOne: Bool = true
	@State var isBoilerTwo: Bool = true
	@State var isBoilerThree: Bool = true
	@State var boilerActualValue: Double = 0
	@State var eventID: Int16 = 0
	@State var isShowBerthList: Bool = false
	@State var showAddLocation: Bool = false
	@State var newPLTstation : String = ""
	@State var newPort : String = ""
	@State var newBerth : String = ""
	@State var activityToEdit : Activity?
	@State var cargoMoved : String = ""
	@State var  berthOfShifting : String = ""
	
	
	var body: some View {
		ZStack {
			VStack {
				fakebar
				if isShowBerthList {
					Spacer()
					BerthsListForShifting(isShowBerthList : $isShowBerthList, showAddLocation : $showAddLocation, portSelected : portSelected, berthSelected: $berthOfShifting).environment(\.managedObjectContext, CoreData.stack.context)
				}
				
				ScrollView {
					VStack{
						Group {
							if activityCase == ActivityCase.shifting {
								ShiftingBerthMenu(activityCase : $activityCase,isShowBerthList: $isShowBerthList)
							}
							TextFieldsListMenu(activityCase : $activityCase,
											   placeHolderTop : returnTextForLabel().placeHolderTop,
											   placeHolderMiddle : returnTextForLabel().placeHolderMiddle,
											   placeHolderMiddle2 : returnTextForLabel().placeHolderMiddle2,
											   placeHolderBottom : returnTextForLabel().placeHolderBottom,
											   durationTextField : $durationTextField,
											   speedTextField : $speedTextField,
											   mlsTextField : $mlsTextField,
											   laddenTextField : $laddenTextField,
											   mgoToBunkerTextField : $mgoToBunkerTextField,
											   hfoToBunkerTextField : $hfoToBunkerTextField,
											   cargoMoved: $cargoMoved
							)
						}
						if activityCase == ActivityCase.bunkering {
							AddBunkerMenu(
								mgoToBunkerTextField : $mgoToBunkerTextField,
								hfoToBunkerTextField : $hfoToBunkerTextField)
						}
						HfoMgoMenu(
							activityCase : $activityCase,
							meSegment: $meSegment,
							ddggSegment: $ddggSegment,
							boilerSegment: $boilerSegment
						)
						
						if activityCase == ActivityCase.canal {
							FixedConsumptionMenu(
								fixedMGO: $fixedMGO,
								fixedHFO: $fixedHFO
							)
						}
						
						Group {
							DDGGMenu(
								isDDGGOne: $isDDGGOne,
								isDDGGTwo: $isDDGGTwo,
								isDDGGThree: $isDDGGThree
							)
							
							BoilesMenu(
								isBoilerOne: $isBoilerOne,
								isBoilerTwo: $isBoilerTwo,
								isBoilerThree: $isBoilerThree
							)
							BoilerConsumptionMenu(
								boilerActualValue: $boilerActualValue,
								boilerMin : bunkerBoilerMinMax().boilerMin,
								boilerMax: bunkerBoilerMinMax().boilerMax
							)}.onAppear {
								if self.activityToEdit == nil {
									self.boilerActualValue = self.bunkerBoilerMinMax().boilerAvarage
								}
								
						}
					}.padding()
				}
			}
			if showAddLocation {
				AddNewLocation(isPLTSelected: .constant(true),
							   isPortSelected: .constant(true),
							   isBerthSelected: .constant(true),
							   newPLTstation: self.$newPLTstation,
							   newPort: self.$newPort,
							   newBerth: self.$newBerth,
							   showAddLocation: self.$showAddLocation,
							   pilotStationSelected: self.$pilotstationSelected,
							   portSelected: self.$portSelected)
			}
		}
		.gesture(DragGesture().onChanged({ (_) in
			DataManager.shared.dismissKeyboard()
		}))
		.onAppear {
			self.isEditingMode()
		}
		.onDisappear {
			self.activityToEdit = nil
		}
		
	}
	
	// MARK: - fakebar
	var fakebar: some View {
		ZStack {
			// logo
			HStack {
				Spacer()
				Text(activityCase.text)
					.font(.headline)
					.foregroundColor(Color.white)
				Spacer()
			}
			// pulsanti
			HStack {
				Button(action: {
					self.dismissFlag = false
				}) {
					Text("Exit")
						.fontWeight(.bold)
						.foregroundColor(.white)
						.padding(.horizontal, 20)
				}
				Spacer()
				Button(action: {
					DataManager.shared.dismissKeyboard()
					if let a = self.activityToEdit {
						self.saveEditedActivity(a: a)
					} else {
						self.addActivityToArray()
					}
					
					self.dismissFlag = false
				}) {
					Text("save")
						.fontWeight(.bold)
						.foregroundColor(.white)
						.padding(.horizontal, 20)
				}
			}
		}
		.frame(height: 44)
		.background(activityCase.color.padding(.top, -44))
		.edgesIgnoringSafeArea(.horizontal)
		.padding(.bottom, -8)
	}
}

struct ActivitySetupSheet_Previews: PreviewProvider {
	static var previews: some View {
		ActivitySetupSheet(dismissFlag: .constant(false), pilotstationSelected: .constant(""), portSelected: .constant(""), berthSelected: .constant("") )
	}
}

struct ShiftingBerthMenu: View {
	@Binding var activityCase : ActivityCase
	@Binding var isShowBerthList : Bool
	var body: some View {
		VStack{
			if activityCase == ActivityCase.shifting {
				Button(action: {
					withAnimation {
						self.isShowBerthList.toggle()
					}
				}) {
					VStack{
						HStack{
							Text("Next Berth")
								.fontWeight(.light)
								.foregroundColor(Color.gray)
								.multilineTextAlignment(.center)
							Spacer()
							Image(systemName: isShowBerthList ? "chevron.up.circle" : "chevron.down.circle")
								.foregroundColor(Color.gray)
						}.padding().overlay(
							RoundedRectangle(cornerRadius: 10)
								.stroke(Color.gray, lineWidth: 1))
					}
				}
			}
		}
	}
}

struct BerthsListForShifting: View {
	
	@Binding var isShowBerthList : Bool
	@Binding var showAddLocation : Bool
	@State var isCellSelected : Bool = false 
	var portSelected : String
	@Binding var berthSelectedForShiftin : String
	var berthRequest : FetchRequest<Berth>
	var berth : FetchedResults<Berth>{berthRequest.wrappedValue}
	init(isShowBerthList: Binding<Bool>,
		 showAddLocation: Binding<Bool>,
		 portSelected: String,
		 berthSelected: Binding<String>
		
	){
		
		self._isShowBerthList = isShowBerthList
		self._showAddLocation = showAddLocation
		self.portSelected = portSelected
		self._berthSelectedForShiftin = berthSelected
		self.berthRequest = FetchRequest(entity: Berth.entity(), sortDescriptors: [], predicate:
			NSPredicate(format: "port.portName == %@", portSelected ))
	}
	var body: some View {
		List {
			Section(header: Header(isCellSelected: self.$isCellSelected, txtHeader: "Add Berth", isBerthCell: true, showAddLocation: self.$showAddLocation)
			) {
				ForEach(berthRequest.wrappedValue, id: \.self) {berthWrap in
					Cell(txt: berthWrap.berthName ?? "", isCellSelected: self.$isCellSelected, isBerthCell: true).onTapGesture {
						self.berthSelectedForShiftin = berthWrap.berthName ?? ""
					}
				}
			}
		}.frame(height: isShowBerthList ? 150 : 0)
			.padding()
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.gray, lineWidth: 1))
			.padding()
	}
}

struct TextFieldsListMenu: View {
	@Binding var activityCase : ActivityCase
	var placeHolderTop : String = ""
	var placeHolderMiddle : String = ""
	var placeHolderMiddle2 : String = ""
	var placeHolderBottom : String = ""
	@Binding var durationTextField : String
	@Binding var speedTextField : String
	@Binding var mlsTextField : String
	@Binding var laddenTextField : String
	@Binding var mgoToBunkerTextField : String
	@Binding var hfoToBunkerTextField : String
	@Binding var cargoMoved : String
	var body: some View {
		VStack {
			if activityCase == ActivityCase.seaPassage {
				WrappedTextField(text: self.$mlsTextField, placeHolder: placeHolderTop, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				WrappedTextField(text: self.$speedTextField, placeHolder: placeHolderMiddle, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				WrappedTextField(text: self.$cargoMoved, placeHolder: placeHolderMiddle2, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				WrappedTextField(text: self.$laddenTextField, placeHolder: placeHolderBottom, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				
			} else if activityCase == ActivityCase.pltIn ||
				activityCase == ActivityCase.pltOut ||
				activityCase == ActivityCase.canal ||
				activityCase == ActivityCase.shifting {
				WrappedTextField(text: self.$durationTextField, placeHolder: placeHolderTop, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				WrappedTextField(text: self.$cargoMoved, placeHolder: placeHolderMiddle2, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				WrappedTextField(text: self.$laddenTextField, placeHolder: placeHolderBottom, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
			} else if activityCase == ActivityCase.loading ||
				activityCase == ActivityCase.discharging  {
				WrappedTextField(text: self.$durationTextField, placeHolder: placeHolderTop, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				
				WrappedTextField(text: self.$cargoMoved, placeHolder: placeHolderMiddle, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				
				WrappedTextField(text: self.$laddenTextField, placeHolder: placeHolderBottom, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				
			} else {
				WrappedTextField(text: self.$durationTextField, placeHolder: placeHolderTop, keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				
			}
		}.padding().overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.gray, lineWidth: 1))
		
	}
}

struct AddBunkerMenu: View {
	@Binding var mgoToBunkerTextField : String
	@Binding var hfoToBunkerTextField : String
	var body: some View {
		VStack {
			HStack {
				Text("MGO:")
					.fontWeight(.light)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
				WrappedTextField(text: self.$mgoToBunkerTextField, placeHolder: "MGO to Bunker in MT", keyType: .decimalPad, textAlignment: .left).frame(height: 32)
				
			}
			HStack {
				Text("HFO:")
					.fontWeight(.light)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
				WrappedTextField(text: self.$hfoToBunkerTextField, placeHolder: "HFO to Bunker in MT", keyType: .decimalPad, textAlignment: .left).frame(height: 32)
			}
			
			
			
		}.padding().overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.gray, lineWidth: 1))
	}
}

struct HfoMgoMenu: View {
	
	@Binding var activityCase : ActivityCase
	
	@Binding var meSegment: Int
	@Binding var ddggSegment: Int
	@Binding var boilerSegment: Int
	
	var body: some View {
		HStack {
			Spacer()
			if activityCase == ActivityCase.seaPassage ||
				activityCase == ActivityCase.pltIn ||
				activityCase == ActivityCase.pltOut ||
				activityCase == ActivityCase.canal ||
				activityCase == ActivityCase.shifting {
				VStack{
					Text("Main Engine")
						.fontWeight(.light)
						.foregroundColor(Color.gray)
						.multilineTextAlignment(.center)
					
					SegmentedController($meSegment)
				}
			}
			VStack{
				Text("DDGG")
					.fontWeight(.light)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
				SegmentedController($ddggSegment)
			}
			VStack{
				Text("Boilers")
					.fontWeight(.light)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
				SegmentedController($boilerSegment)
			}
			Spacer()
		}.padding().overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.gray, lineWidth: 1))
	}
}

struct FixedConsumptionMenu: View {
	
	@Binding var fixedMGO: String
	@Binding var fixedHFO: String
	var body: some View {
		VStack{
			HStack {
				Text("Fixed HFO Consumption")
					.font(.footnote)
					.fontWeight(.light)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
					.padding(.horizontal)
				WrappedTextField(text: self.$fixedHFO, placeHolder: "", keyType: .decimalPad,textAlignment: .left).frame(height: 32)
					.padding([.leading, .trailing])
			}
			HStack {
				Text("Fixed MGO Consumption")
					.font(.footnote)
					.fontWeight(.light)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
					.padding(.horizontal)
				WrappedTextField(text: self.$fixedMGO, placeHolder: "", keyType: .decimalPad,textAlignment: .left).frame(height: 32)
					.padding([.leading, .trailing])
			}
			
		}.padding().overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.gray, lineWidth: 1))
	}
}

struct DDGGMenu: View {
	
	@Binding var isDDGGOne: Bool
	@Binding var isDDGGTwo: Bool
	@Binding var isDDGGThree: Bool
	
	var body: some View {
		HStack{
			Spacer()
			SwitchWithLabel($isDDGGOne, label: "DDGG 1")
			Spacer()
			SwitchWithLabel($isDDGGTwo, label: "DDGG 2")
			Spacer()
			SwitchWithLabel($isDDGGThree, label: "DDGG 3")
			Spacer()
		}.padding().overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.gray, lineWidth: 1))
	}
}

struct BoilesMenu: View {
	
	@Binding var isBoilerOne: Bool
	@Binding var isBoilerTwo: Bool
	@Binding var isBoilerThree: Bool
	
	var body: some View {
		HStack{
			Spacer()
			SwitchWithLabel($isBoilerOne, label: "Boiler 1")
			Spacer()
			SwitchWithLabel($isBoilerTwo, label: "Boiler 2")
			Spacer()
			SwitchWithLabel($isBoilerThree, label: "Boiler 3")
			Spacer()
		}.padding().overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.gray, lineWidth: 1))
	}
}

struct BoilerConsumptionMenu: View {
	@Binding var boilerActualValue: Double
	var boilerMin : Double
	var boilerMax :Double
	
	var body: some View {
		HStack{
			Spacer()
			VStack {
				HStack{
					Text("Min: \(boilerMin, specifier: "%.1f") MT/Day")
						.font(.footnote)
						.fontWeight(.light)
						.foregroundColor(Color.gray)
					Divider()
					
					Stepper("", onIncrement: {
						if self.boilerMin <= (self.boilerActualValue+1) &&
							self.boilerActualValue <= (self.boilerMax ){
							self.boilerActualValue += 0.1 }
					}, onDecrement: {
						if self.boilerActualValue <= (self.boilerMax+1  ) &&
							self.boilerMin <= (self.boilerActualValue ) {
							self.boilerActualValue -= 0.1 }
					}).labelsHidden()
					Divider()
					Text("Max: \(boilerMax, specifier: "%.1f") MT/Day")
						.font(.footnote)
						.fontWeight(.light)
						.foregroundColor(Color.gray)
				}
				Text("Daily boilers Consumption: \((boilerActualValue), specifier: "%.1f")")
					.fontWeight(.light)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
				
			}
			Spacer()
		}.padding().overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.gray, lineWidth: 1))
	}
}

// MARK: - Function For UI

extension ActivitySetupSheet {
	
	func bunkerBoilerMinMax() -> (boilerMin : Double, boilerMax : Double, boilerAvarage : Double) {
		var boilerMin : Double = 0
		var boilerMax : Double = 0
		var boilerAvarage : Double = 0
		if let b = DataManager.shared.fetchBunkerConsumption() {
			boilerMin = b.boilerConsuptionMin
			boilerMax = b.boilerConsuptionMax
			boilerAvarage = (boilerMin+boilerMax)/2
		}
		return (boilerMin : boilerMin, boilerMax : boilerMax, boilerAvarage : boilerAvarage)
	}
	
	func returnTextForLabel() -> (placeHolderTop :String, placeHolderBottom :String, placeHolderMiddle :String,  placeHolderMiddle2 :String) {
		var top = ""
		var middle = ""
		var bottom = ""
		var middle2 = ""
		switch activityCase {
		case .seaPassage: top = "Miles to: " + pilotstationSelected; bottom = "Ladden Condition in %"; middle = "Sea going speed"; middle2 = "Cargo on board"
		case .pltIn: top = "Pilotage hours to : " + berthSelected; bottom = "Ladden Condition in %"; middle2 = "Cargo on board"
		case .pltOut: top = "Pilotage hours to : " + berthSelected; bottom = "Ladden Condition in %"; middle2 = "Cargo on board"
		case .loading: top = "Duration of loading"; middle = "Cargo on board"; bottom = "Vessel ladden percentage"
		case .discharging: top = "Duration of discharging"; middle = "Cargo on board"; bottom = "Vessel ladden percentage"
		case .shifting: top = "shifting hours to "; middle2 = "Cargo on board"; bottom = "Vessel ladden percentage"
		case .layby: top = "Waiting time"; bottom = ""
		case .bunkering: top = "Duration of bunkering"; bottom = ""
		case .anchoring: top = "Duration at ancorage"; bottom = ""
		case .canal: top = "Duration of canal crossing"; middle2 = "Cargo on board"; bottom = "Vessel ladden percentage"
		default: break
			
		}
		
		return (top, bottom, middle, middle2)
	}
}

// MARK: - Function For Manage Data

extension ActivitySetupSheet {
	
	func addActivityToArray(){
		
		var isMERunning = false
		if activityCase == ActivityCase.shifting { 
			
		}
		
		
		if activityCase == ActivityCase.seaPassage || activityCase == ActivityCase.pltIn || activityCase == ActivityCase.pltOut || activityCase == ActivityCase.shifting || activityCase == ActivityCase.canal {
			isMERunning = true
		} else {
			isMERunning = false
		}
		let act = ActivityClass(addHFO: hfoToBunkerTextField.doubleValue,
								addMGO: mgoToBunkerTextField.doubleValue,
								boilerConsuptionPerDay: boilerActualValue,
								cargoMoved: cargoMoved.doubleValue,
								distance: mlsTextField.doubleValue,
								duration: durationTextField.doubleValue * 3600,
								eventID: 1,
								fixedHFO: fixedHFO.doubleValue,
								fixedMGO: fixedMGO.doubleValue,
								isBoilerHFO: boilerSegment.bool,
								isBoilerOne: isBoilerOne,
								isBolierThree: isBoilerThree,
								isBolierTwo: isBoilerTwo,
								isDDGG_Hfo: ddggSegment.bool,
								isDDGG_One: isDDGGOne,
								isDDGG_Three: isDDGGThree,
								isDDGG_Two: isDDGGTwo,
								isMaineEngine: isMERunning,
								isMeHFO: meSegment.bool,
								speed: speedTextField.doubleValue,
								vslLaddenPercentage: laddenTextField.doubleValue,
								isKindOf: Int16(activityCase.label),
								berthOfShifting: berthOfShifting) 
		DataManager.shared.activitiesClass.append(act)
	}
	
	func saveEditedActivity( a : Activity) {
		
		var isMERunning = false
		if self.activityCase == ActivityCase.seaPassage || self.activityCase == ActivityCase.pltIn || self.activityCase == ActivityCase.pltOut || self.activityCase == ActivityCase.shifting || self.activityCase == ActivityCase.canal {
			isMERunning = true
		} else {
			isMERunning = false
		}
		a.addHFO = self.hfoToBunkerTextField.doubleValue
		a.addMGO = self.mgoToBunkerTextField.doubleValue
		a.boilerConsuptionPerDay = self.boilerActualValue
		a.cargoMoved = self.cargoMoved.doubleValue
		a.distance = self.mlsTextField.doubleValue
		a.duration = self.durationTextField.doubleValue * 3600
		a.fixedHFO = self.fixedHFO.doubleValue
		a.fixedMGO = self.fixedMGO.doubleValue
		a.isBoilerHFO = self.boilerSegment.bool
		a.isBoilerOne = self.isBoilerOne
		a.isBolierThree = self.isBoilerThree
		a.isBolierTwo = self.isBoilerTwo
		a.isDDGG_Hfo = self.ddggSegment.bool
		a.isDDGG_One = self.isDDGGOne
		a.isDDGG_Three = self.isDDGGThree
		a.isDDGG_Two = self.isDDGGTwo
		a.isMaineEngine = isMERunning
		a.isMeHFO = self.meSegment.bool
		a.speed = self.speedTextField.doubleValue
		a.vslLaddenPercentage = self.laddenTextField.doubleValue
		a.berthOfActivity = self.berthOfShifting
		CoreData.stack.save()
		
	}
	
	func isEditingMode() {
		
		if DataManager.shared.activitiesClass.count > 0 {
			for i in DataManager.shared.activitiesClass {
				let vslLaddenPercentage = String(format: "%.1f", i.vslLaddenPercentage)
				if vslLaddenPercentage == "0.0" {
					laddenTextField = ""
				} else {
					laddenTextField = String(format: "%.1f", i.vslLaddenPercentage)
					
				}
				let cargoMove = String(format: "%.1f", i.cargoMoved)
				if cargoMove  == "0.0" {
					cargoMoved = ""
				} else {
					cargoMoved = String(format: "%.1f", i.cargoMoved)
					
				}
			}
		}
		
		if let a = activityToEdit {
			hfoToBunkerTextField = String(format: "%.1f", a.addHFO)
			mgoToBunkerTextField = String(format: "%.1f", a.addMGO)
			boilerActualValue = a.boilerConsuptionPerDay
			
			mlsTextField = String(format: "%.1f", a.distance)
			durationTextField = String(format: "%.1f", a.duration/3600)
			eventID = a.eventID
			fixedHFO = String(format: "%.1f", a.fixedHFO)
			fixedMGO = String(format: "%.1f", a.fixedMGO)
			
			isBoilerOne = a.isBoilerOne
			isBoilerTwo = a.isBolierTwo
			isBoilerThree = a.isBolierThree
			
			isDDGGOne = a.isDDGG_One
			isDDGGTwo = a.isDDGG_Two
			isDDGGThree = a.isDDGG_Three
			
			laddenTextField = String(format: "%.1f", a.vslLaddenPercentage)
			cargoMoved = String(format: "%.1f", a.cargoMoved)
			
			meSegment = a.isMeHFO.inte
			boilerSegment = a.isBoilerHFO.inte
			ddggSegment = a.isDDGG_Hfo.inte
			
			speedTextField = String(format: "%.1f", a.speed)
			laddenTextField = String(format: "%.1f", a.vslLaddenPercentage)
			activityCase = ActivityCase(rawValue: Int(a.isKindOf)) ?? activityCase
			
		} else {
			return
		}
	}
}
