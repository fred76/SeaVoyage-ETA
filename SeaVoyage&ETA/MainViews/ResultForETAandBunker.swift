//
//  ResultForETAandBunker.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 08/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI

struct ResultForETAandBunker: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@FetchRequest(entity: LocationAndEvents.entity(), sortDescriptors: [NSSortDescriptor(key: "locationID", ascending: true)])
	var locationAndEventsFetched: FetchedResults<LocationAndEvents>
	@FetchRequest(entity: VesselInitialSettings.entity(), sortDescriptors: [NSSortDescriptor(key: "now",  ascending: true)])
	var vesselInitialSettings: FetchedResults<VesselInitialSettings>
	@FetchRequest(entity: BunkerVslDetails.entity(), sortDescriptors: [NSSortDescriptor(key: "now", ascending: true)])
	var bunkerConsumption: FetchedResults<BunkerVslDetails>
	
	@State var dismissFlag: Bool = false
	@State var activityToEdit : Activity!
	@State var activityUp : Activity!
	@State var activityDown : Activity!
	@State var locationUp : LocationAndEvents!
	@State var locationDown : LocationAndEvents!
	@State var locationTimeZone : LocationAndEvents!
	@State var isAddActivityToLocAndEvents: Bool = false
	@State var startRippleAnimation : Bool = false
	@State var isEditMode: Bool = false
	@State var showPortActivity : Bool = false
	@State var refresh : Bool = false 
	@State var activityCase = ActivityCase.canal
	@State var headerETAtoActivity : Double = 0
	@State var sectionSelected : Int = 0
	@State var showDatePickerInput : Bool = false
	@State var showBunkerPickerInputHFO : Bool = false
	@State var showBunkerPickerInputMGO : Bool = false
	@State var showTimeZoneStepper : Bool = false
	@State var showTimeZoneStepperInitialMenu : Bool = false
	@State var txtMGO : String = ""
	@State var txtHFO : String = ""
	@State var txtDate : String = "" 
	@State var pilotStationSelected : String = ""
	@State var portSelected : String = ""
	@State var berthSelected : String = ""
	@State var locationID : Int16 = 0
	@State var timeZoneLoc : Double = 0.0
	@State var dismissFlagForBerthListForQuickAdd : Bool = false
	
	@State var count : Int = 0
	var body: some View {
		ZStack {
			VStack {
				if locationAndEventsFetched.count == 0 {
					VStack{
						Spacer()
						Text("""
							Select "Destination Tab" and add:
							Pilotstation > Port > Berth
							Select Berth and add all activites:
						""")
							.foregroundColor(.blue)
							.padding()
							.background( RoundedRectangle(cornerRadius: 8)
								.stroke(Color.gray, lineWidth: 1))
						
						HStack{
							Image("seapassage")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width:200, height: 200 )
								.clipShape(Circle())
								.overlay(Circle() .stroke(Color.gray, lineWidth: 1) )
							
						}
						Spacer()
					}
				}
				else {
					VStack {
						fakebar
						VSLInitialDataMenu(showDatePickerInput: self.$showDatePickerInput,
										   showBunkerPickerInputHFO: self.$showBunkerPickerInputHFO,
										   showBunkerPickerInputMGO: self.$showBunkerPickerInputMGO,
										   showTimeZoneStepperInitialMenu: self.$showTimeZoneStepperInitialMenu,
										   vesselInitialSettings: self.vesselInitialSettings)
						
						
						List {
							ForEach(self.locationAndEventsFetched, id: \.locationID) { section in
								Section(header:
									HeaderForETA(
										activities: section.activitiesArray,
										loc: section,
										activity: self.activityCase,
										deleteFunction: {
											CoreData.stack.context.performAndWait {
												CoreData.stack.context.delete(section)
												CoreData.stack.save()
											}
											let tu = self.locationAndEventsFetched
											for (i,t) in tu.enumerated() {
												t.locationID = Int16(i)
											}
											self.refresh.toggle()
											CoreData.stack.save()},
										moveUPFunction: {
											DataManager.shared.locationWithActivitiesMoveUp(section: Int(section.locationID))
											self.refresh.toggle()
									},
										moveDownFunction: {
											DataManager.shared.locationWithActivitiesMoveDown(section: Int(section.locationID))
											self.refresh.toggle()
									},
										addFunction: {
											self.pilotStationSelected = section.pltStn ?? ""
											self.portSelected = section.port ?? ""
											self.berthSelected = section.berth ?? ""
											self.locationID = section.locationID
											withAnimation {
												self.isAddActivityToLocAndEvents.toggle()
												self.refresh.toggle()
											}
									},
										editTimeZone: {
											self.locationTimeZone = section
											withAnimation {
												self.showTimeZoneStepper = true
											}
									} )
								) {
									ForEach(section.activitiesArray , id: \.self ) { row in
										CellForETA(
											loc: section,
											activity: row,
											deleteFunction: {
												if section.activitiesArray.count == 1 {
													CoreData.stack.context.delete(row)
													CoreData.stack.context.delete(section)
													DataManager.shared.setIDforLocationAndEvents()
													CoreData.stack.save()
													return
												}
												self.count = section.activitiesArray.count
												self.activityDown = section.activitiesArray[Int(row.eventID)]
												self.activityDown!.eventID = Int16(self.count)
												for (i,t) in section.activitiesArray.enumerated() {
													t.eventID = Int16(i)
												}
												CoreData.stack.context.delete(section.activitiesArray[self.count-1])
												CoreData.stack.save()
												
												
										},
											moveUPFunction :{
												if row.eventID > 0{
													self.activityUp = section.activitiesArray[Int(row.eventID)]
													self.activityDown = section.activitiesArray[Int(row.eventID)-1]
													self.activityUp?.eventID = row.eventID-1
													self.activityDown?.eventID = row.eventID + 1
													section.addToActivity(self.activityUp!)
													section.addToActivity(self.activityDown!)
													CoreData.stack.save()
													self.activityUp = Activity()
													self.activityUp = Activity()
													self.refresh.toggle()
												}
										},
											moveDownFunction :{
												self.activityDown = section.activitiesArray[Int(row.eventID)]
												self.activityUp = section.activitiesArray[Int(row.eventID)+1]
												self.activityDown!.eventID = row.eventID+1
												self.activityUp!.eventID = row.eventID-1
												section.addToActivity(self.activityUp!)
												section.addToActivity(self.activityDown!)
												CoreData.stack.save()
												self.activityUp = Activity()
												self.activityUp = Activity()
												self.refresh.toggle()
										},
											editFunction :{
												self.isEditMode.toggle()
												self.pilotStationSelected = section.pltStn ?? ""
												self.portSelected = section.port ?? ""
												self.berthSelected = section.berth ?? ""
												self.locationID = section.locationID
												self.activityToEdit = section.activitiesArray[Int(row.eventID)]
												self.refresh.toggle()
										}
										)
									}
								}
							}
						}
							
						.padding()
						.background(self.refresh ? Color(UIColor.systemBackground) : Color(UIColor.systemBackground))
						if showDatePickerInput{
							DatePickerInput(
								showDatePickerInput: self.$showDatePickerInput,
								vesselInitialSettings: self.vesselInitialSettings.first ?? VesselInitialSettings())
						}
						if showBunkerPickerInputHFO{
							BunkerPickerInputHFO(
								showBunkerPickerInputHFO: self.$showBunkerPickerInputHFO,
								vesselInitialSettings: self.vesselInitialSettings.first ?? VesselInitialSettings())
						}
						if showBunkerPickerInputMGO{
							BunkerPickerInputMGO(
								showBunkerPickerInputMGO: self.$showBunkerPickerInputMGO,
								vesselInitialSettings: self.vesselInitialSettings.first ?? VesselInitialSettings())
						}
						if showTimeZoneStepper{
							TimeZoneStepper(showTimeZoneStepper: self.$showTimeZoneStepper, loc: self.locationTimeZone)
						}
						if showTimeZoneStepperInitialMenu{
							TimeZoneStepperInitialMenu(showTimeZoneStepper: self.$showTimeZoneStepperInitialMenu,  vesselInitialSettings: self.vesselInitialSettings.first ?? VesselInitialSettings())
						}
					}
				}
				
			}
			
			
			if isAddActivityToLocAndEvents{ 
				RippleMenuAddActivityToExistingLocation(dismissFlag: self.$dismissFlag,
														isAddActivityToLocAndEvents: self.$isAddActivityToLocAndEvents,
														activityCase: self.$activityCase,
														pilotStationSelected: self.$pilotStationSelected,
														portSelected: self.$portSelected,
														berthSelected: self.$berthSelected,
														locationID: self.locationID)
			}
			
			if dismissFlagForBerthListForQuickAdd {
				BerthListForQuickAdd(dismissFlagForBerthListForQuickAdd: self.$dismissFlagForBerthListForQuickAdd)
				
			}
			VStack {
				Spacer()
				HStack {
					Button(action: {
						withAnimation {
							self.dismissFlagForBerthListForQuickAdd.toggle()
						}
					}) {
						Image(systemName: "plus.circle" ) .rotationEffect(self.dismissFlagForBerthListForQuickAdd ? .degrees(45) : .degrees(0))
							.font(.system(size: 48))
							.background( Circle()
								.fill(Color.blue) )
							.clipShape(Circle())
							.overlay(Circle()
								.stroke(Color(UIColor.systemBackground), lineWidth: 1.5))
							.font(.body)
							.foregroundColor(Color.white)
							.shadow(radius: 5)
							.padding(8)
					}
					Spacer()
				}
			}
		}
		.background(EmptyView()
		.sheet(isPresented: self.$isEditMode) {
			ActivitySetupSheet(dismissFlag: self.$isEditMode,
							   activityCase: self.activityCase,
							   pilotstationSelected: self.$pilotStationSelected,
							   portSelected: self.$portSelected,
							   berthSelected: self.$berthSelected ,
							   activityToEdit:self.activityToEdit  )
			}
		)
			.background(EmptyView()
				.sheet(isPresented: self.$dismissFlag){
					ActivitySetupSheet(dismissFlag: self.$dismissFlag, activityCase: self.activityCase, pilotstationSelected: self.$pilotStationSelected, portSelected: self.$portSelected, berthSelected: self.$berthSelected)
			})
	}
	
	var fakebar: some View {
		ZStack {
			// logo
			HStack {
				Spacer()
				Text("Rotation")
					.font(.headline)
					.foregroundColor(Color.white)
				Spacer()
			} 
		}
		.frame(height: 44)
		.background(StaticClass.seaPassageColor.padding(.top, -44))
		.edgesIgnoringSafeArea(.horizontal)
		.padding(.bottom, -8)
	}
}

struct CellForETA:View {
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(entity: VesselInitialSettings.entity(), sortDescriptors: [NSSortDescriptor(key: "now", ascending: true)])
	
	var vesselInitialSettingsForCell: FetchedResults<VesselInitialSettings>
	
	@State var select : Bool = false
	@ObservedObject var loc : LocationAndEvents
	@ObservedObject var  activity : Activity
	//@ObservedObject var vesselInitialSettings : VesselInitialSettings
	var deleteFunction: () -> Void
	var moveUPFunction: () -> Void
	var moveDownFunction: () -> Void
	var editFunction: () -> Void
	var size : CGFloat = 24
	var actCase : (ActivityCase) {
		isKindOfCase(activityCaseLabel: activity.isKindOf)
	}
	
	var body: some View {
		
		ZStack {
			HStack {
				Spacer()
				VStack {
					HStack {
						Button(action: {
							withAnimation {
								self.moveUPFunction()
							}
							self.select = false
						}) {
							Image(systemName: "chevron.up.circle").font(.system(size: 30))
								.foregroundColor(.gray).padding(10)
						}
						Divider()
						Button(action: {
							withAnimation {
								self.editFunction()
							}
							self.select = false
						}) {
							Image(systemName: "square.and.pencil").font(.system(size: 30))
								.foregroundColor(.gray).padding(10)
						}
					}
					HStack {
						Button(action: {
							withAnimation {
								self.moveDownFunction()
							}
							self.select = false
						}) {
							Image(systemName: "chevron.down.circle").font(.system(size: 30))
								.foregroundColor(.gray).padding(10)
						}
						Divider()
						Button(action: {
							withAnimation {
								self.deleteFunction()
							}
							self.select = false
						}) {
							Image(systemName: "trash").font(.system(size: 30))
								.foregroundColor(.gray).padding(10)
						}
					}
				}
			}
			ZStack {
				Color(UIColor.systemBackground).background( RoundedRectangle(cornerRadius: 5)
					.fill(Color.white) )
				FindViewFrameAndAddOverlayShape(colorTriangle: actCase.color)
				VStack{
					VStack() {
						VStack(alignment: .leading){
							VStack {
								HStack {
									Text(actCase.shortText + " " +  (time().ETA )).font(.callout).fontWeight(.semibold)
									Spacer()
								}
								if actCase.text == "Shifting" {
									HStack {
										Text(activity.berthOfActivity ?? "").font(.footnote).fontWeight(.regular)
										Spacer()
									}
								}
							}.padding(.top, 6.0)
							Divider()
							HStack {
								Text(actCase.text + " " +  (time().deltaTime ) +  " hrs").font(.footnote).padding([.top, .bottom, .trailing], 3.0)
								Divider()
								HStack {
									Text(String(format: "%.f", self.activity.cargoMoved)  + " MT" +  " @ " + String(format: "%.f", self.activity.vslLaddenPercentage)  + " %").font(.footnote)
								}.padding([.top, .bottom, .trailing], 3.0)
							}
							HStack {
								HStack {
									Text("∆: ").font(.footnote)
									VStack(alignment: .leading) {
										Text("HFO: " +  bunker().hfoPerEvent ).font(.footnote)
										Text("MGO: " + bunker().mgoPerEvent).font(.footnote)
									}
								}
								Divider()
								HStack {
									Text("ROB: ").font(.footnote)
									VStack(alignment: .leading) {
										Text("HFO: " + bunker().HFO).font(.footnote)
										Text("MGO: " + bunker().MGO).font(.footnote)
									}
								}
							}
						}.padding([.top, .bottom, .trailing], 3.0)
						Divider()
						HStack {
							if actCase.label == 0 || actCase.label == 1 || actCase.label == 2 || actCase.label == 5 || actCase.label == 9 {
								HStack {
									HStack {
										Image("propeller.black")
											.resizable()
											.frame(width: size, height: size)
											.shadow(radius: 1, x: 1, y: 1)
										Text(bunker().meLabel).font(.system(size: 8))
									}
								}
								Divider().padding()}
							Group {
								HStack {
									Text(bunker().ddggMultiplier).font(.footnote)
									Image("ddgg.black").resizable()
										.frame(width: size, height: size)
										.shadow(radius: 1, x: 1, y: 1)
									Text(bunker().ddggLabel).font(.system(size: 8))
								}
							}
							Divider().padding()
							Group {
								HStack {
									Text(bunker().boilerMultiplier).font(.footnote)
									Image("boiler.black").resizable()
										.frame(width: size, height: size)
										.shadow(radius: 1, x: 1, y: 1)
									Text(bunker().boilerLabel).font(.system(size: 8))
								}
							}
						}
					}
				}
				.frame(minWidth: 0, maxWidth: .infinity)
				.padding(.horizontal)
				.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
			}
			.offset(x: select ? -120 : 0)
			.onTapGesture {
				withAnimation {
					self.select.toggle()
				}
			}
		}.buttonStyle(PlainButtonStyle())
	}
}

struct HeaderForETA: View {
	@State var showTimeZoneStepper : Bool = false
	var activities : [Activity] = []
	@ObservedObject var loc : LocationAndEvents
	var pltName : String = ""
	var portName : String = ""
	var eta : String = "11/11/2000"
	var  activity : ActivityCase
	@State var isMenu : Bool = false
	@State var select : Bool = false
	var size : CGFloat = 24
	var deleteFunction: () -> Void
	var moveUPFunction: () -> Void
	var moveDownFunction: () -> Void
	var addFunction: () -> Void
	var editTimeZone: () -> Void
	var body: some View {
		
		ZStack {
			Group {
				HStack {
					Spacer()
					VStack {
						HStack {
							Button(action: {
								withAnimation {
									self.moveUPFunction()
								}
								self.select = false
							}) {
								Image(systemName: "chevron.up.circle").font(.system(size: 30))
									.foregroundColor(.gray).padding(10)
							}
							Divider()
							Button(action: {
								withAnimation {
									self.addFunction()
								}
								self.select = false
							}) {
								Image(systemName: "plus.circle").font(.system(size: 30))
									.foregroundColor(.gray).padding(10)
							}
						}
						HStack{
							Button(action: {
								withAnimation {
									self.moveDownFunction()
								}
								self.select = false
							}) {
								Image(systemName: "chevron.down.circle").font(.system(size: 30))
									.foregroundColor(.gray).padding(10)
							}
							Divider()
							Button(action: {
								withAnimation {
									self.deleteFunction()
								}
								self.select = false
							}) {
								Image(systemName: "trash").font(.system(size: 30))
									.foregroundColor(.gray).padding(10)
							}
						}
					}
				}
			}
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.fill(Color(.systemGray4))
					.shadow(radius: 3)
				VStack{
					VStack() {
						VStack(){
							VStack{
								Group {
									HStack {
										Text(loc.pltStn ?? "").font(.callout).fontWeight(.semibold)
											.lineLimit(1)
											.minimumScaleFactor(4)
										Spacer()
										Divider()
										Text(loc.port ?? "").font(.callout).fontWeight(.semibold)
											.lineLimit(1)
											.minimumScaleFactor(4)
										Spacer()
										Button(action: {
											withAnimation {
												self.showTimeZoneStepper.toggle()
											}
											self.editTimeZone()
											self.showTimeZoneStepper.toggle()
										}) {
											Text("\(loc.timeZoneForLocation, specifier: "%.1f") hrs" ).font(.footnote).fontWeight(.semibold).padding(4)
												.lineLimit(1)
												.minimumScaleFactor(4)
												.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 1.5))
										}
										
										
										
										
									}.padding(.top, 6.0).frame(height: 30 )
								}
								Divider()
								Group {
									HStack{
										Text(loc.berth ?? "").font(.callout).fontWeight(.semibold)
											.lineLimit(1)
											.minimumScaleFactor(4)
										Divider()
										ScrollView (.horizontal){
											HStack {
												ForEach(DataManager.shared.fetchBerthPerActivity(fetchedEvents: loc, act: activity), id: \.self) { berth  in
													Text(berth).font(.callout).fontWeight(.semibold)
														.lineLimit(1)
														.minimumScaleFactor(4)
												}
											}
										}
									}.frame(height: 30)
								}
							}
							Divider()
							Group {
								VStack(alignment: .leading) {
									HStack {
										Text("Call Time: " + time()).font(.footnote).padding([.top, .bottom, .trailing], 3.0)
										Divider()
										HStack {
											Text("HFO: " + bunker().HFO).font(.footnote)
											Text("MGO: " + bunker().MGO).font(.footnote)
										}.padding([.top, .bottom, .trailing], 3.0)
									}
								}.frame(height: 30 ) }
							Divider()
						}
					}
				} .padding(.horizontal)
			}
			.offset(x: select ? -120 : 0)
			.onTapGesture {
				withAnimation {
					self.select.toggle()
				}
			}
		} .background(FillHeaderBackground(color:  Color(UIColor.systemBackground)))
	}
}

struct VSLInitialDataMenu: View {
	@Binding var showDatePickerInput : Bool
	@Binding var showBunkerPickerInputHFO : Bool
	@Binding var showBunkerPickerInputMGO : Bool
	@Binding var showTimeZoneStepperInitialMenu : Bool
	var vesselInitialSettings: FetchedResults<VesselInitialSettings>
	var body: some View {
		HStack() {
			Button(action: {
				withAnimation {
					self.showDatePickerInput.toggle()
				}
			}) {
				VStack {
					Text("Date & local time")
						.font(.system(size: 10))
						.foregroundColor(Color.white)
					Text(self.vesselInitialSettings.last?.initialDate ?? "01/07/2020").padding(6)
						.font(.footnote)
						.background( RoundedRectangle(cornerRadius: 4)
							.fill((Color(UIColor.systemBackground))))
						.padding(.leading, 8)
					
				}
			}.buttonStyle(PlainButtonStyle())
			Spacer()
			Button(action: {
				withAnimation {
					self.showTimeZoneStepperInitialMenu.toggle()
				}
			}) {
				VStack {
					Text("Time zone")
						.font(.system(size: 10))
						.foregroundColor(Color.white)
					Text("\(self.vesselInitialSettings.last?.timeZoneFromSetting ?? 0, specifier: "%.1f") hrs" ).padding(6)
						.font(.footnote)
						.background( RoundedRectangle(cornerRadius: 4)
							.fill((Color(UIColor.systemBackground))))
						.padding(.leading, 8)
					
				}
			}.buttonStyle(PlainButtonStyle())
			Spacer()
			Button(action: {
				withAnimation {
					self .showBunkerPickerInputHFO.toggle()
				}
			}) {
				VStack {
					Text("ROB HFO")
						.font(.system(size: 10))
						.foregroundColor(Color.white)
					Text((self.vesselInitialSettings.last?.initialHFO ?? "0") + " MT").padding(6)
						.font(.footnote)
						.background( RoundedRectangle(cornerRadius: 4)
							.fill((Color(UIColor.systemBackground))))
				}
			}.buttonStyle(PlainButtonStyle())
			Spacer()
			Button(action: {
				withAnimation {
					self .showBunkerPickerInputMGO.toggle()
				}
			}) {
				VStack {
					Text("ROB MGO")
						.font(.system(size: 10))
						.foregroundColor(Color.white)
					Text((self.vesselInitialSettings.last?.initialMGO ?? "0") + " MT").padding(6)
						.font(.footnote)
						.background( RoundedRectangle(cornerRadius: 4)
							.fill((Color(UIColor.systemBackground))))
						.padding(.trailing, 8)
				}
			}.buttonStyle(PlainButtonStyle())
		}
			
			.frame( height: 44).background(StaticClass.seaPassageColor)  //InitialParameterMenu
	}
}

struct RippleMenuAddActivityToExistingLocation: View {
	@Binding var dismissFlag: Bool
	@Binding var isAddActivityToLocAndEvents: Bool
	@State var startRippleAnimation : Bool = false
	@Binding var activityCase : ActivityCase
	@Binding var pilotStationSelected : String
	@Binding var portSelected : String  
	@Binding var berthSelected : String
	var locationID : Int16
	var locationAndEventsRequest : FetchRequest<LocationAndEvents>
	var locationAndEvents : FetchedResults<LocationAndEvents>{locationAndEventsRequest.wrappedValue }
	
	init(dismissFlag: Binding<Bool>,
		 isAddActivityToLocAndEvents: Binding<Bool>,
		 activityCase : Binding<ActivityCase>,
		 pilotStationSelected : Binding<String>,
		 portSelected : Binding<String>,
		 berthSelected : Binding<String>,
		 locationID:Int16
	){
		
		self._dismissFlag = dismissFlag
		self._isAddActivityToLocAndEvents = isAddActivityToLocAndEvents
		self._activityCase = activityCase
		self._pilotStationSelected = pilotStationSelected
		self._portSelected = portSelected
		self._berthSelected = berthSelected
		self.locationID = locationID
		self.locationAndEventsRequest = FetchRequest(entity: LocationAndEvents.entity(), sortDescriptors: [], predicate:
			NSPredicate(format: "locationID == %i", locationID))
	}
	
	var body: some View {
		GeometryReader { geo in
			VStack {
				HStack {
					Button(action: {
						withAnimation {
							self.isAddActivityToLocAndEvents = false
							self.startRippleAnimation = false
						}
					}) {
						Image(systemName: "xmark.circle")
							.foregroundColor(.white)
							.font(.system(size: 32))
							.padding()
					}.buttonStyle(PlainButtonStyle())
					Spacer()
					Button(action: {
						withAnimation { 
							if !DataManager.shared.activitiesClass.isEmpty {
								let t = self.locationAndEventsRequest.wrappedValue
								let c = t.first
								LocationAndEvents.addActivityToExsitingLocation(locationAndEvents: c ?? LocationAndEvents())
								DataManager.shared.activitiesClass = []
								self.isAddActivityToLocAndEvents = false
							}
						}
					}) {
						Text("Add Activities").font(.footnote)
							.foregroundColor(.white)
							.padding()
							.background(RoundedRectangle(cornerRadius: 4).fill(Color.green))
							.padding()
					}.buttonStyle(PlainButtonStyle())
				}
				VStack(spacing: 1) {
					ForEach(ActivityCase.allCases, id: \.self) {
						activitySelected in
						Button(action: {
							self.dismissFlag.toggle()
							self.activityCase = activitySelected
						}) {
							RippleButton(rectCorner: activitySelected.rectCorner,
										 radius: activitySelected.radious,
										 txt: activitySelected.text,
										 color: activitySelected.color,
										 geo: geo,
										 berthDetailsCaseImageName: activitySelected.imageName)
						}
						.offset(y: self.startRippleAnimation ? 0 : 1000)
						.animation(.ripple(index: activitySelected.label,
										   dismiss: self.startRippleAnimation))
							.buttonStyle(PlainButtonStyle())
					}
				}
				Spacer()
			}.background(Color(.systemGray2))
				
				.onAppear {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
						self.startRippleAnimation = true
					}
			}
		}.transition(.move(edge: .bottom))
	}
}

struct BerthListForQuickAdd : View{
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(entity: Ports.entity(), sortDescriptors: []) var portFetched: FetchedResults<Ports>
	@Binding var dismissFlagForBerthListForQuickAdd : Bool
	@State var isBerthSelected : Bool = false
	@State var startRippleAnimation : Bool = false
	@State var timeZoneSet : Double = 0.0
	@State var dismissFlag : Bool = false
	@State var activityCase = ActivityCase.canal
	@State var pilotStationSelected : String = ""
	@State var portSelected : String = ""
	@State var berthSelected : String = ""
	
	var body: some View {
		ZStack {
			VStack{
				List {
					ForEach(self.portFetched, id: \.self) { port in
						Section(header:
							HStack {
								Text(port.pilotStations?.pltName ?? "")
								Text(" - ")
								Text(port.wrappedPort)
							}
						) {
							ForEach(port.berthsArray, id: \.self) { berth in
								Button(action: {
									self.pilotStationSelected = berth.port!.pilotStations!.pltName ?? ""
									self.portSelected = berth.port!.portName ?? ""
									self.berthSelected = berth.wrappedBerth
									withAnimation {
										self.isBerthSelected.toggle()
									}
								}) {
									HStack {
										Text(berth.wrappedBerth).padding(.horizontal)
										Spacer()
									}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
										.background(Color(.systemGray2))
										.overlay(RoundedRectangle(cornerRadius: 4)
											.stroke(Color.gray, lineWidth: 1))
									
									
								}
							}
						}
					}
				} .background(Color.secondary)
			}.transition(.move(edge: .top))
			if isBerthSelected {
				RippleMenu
			}
			
		}
	}
	// MARK: - RippleMenu
	var RippleMenu: some View {
		ZStack{
			GeometryReader { geo in
				VStack {
					HStack {
						Button(action: {
							withAnimation {
								self.isBerthSelected = false
								self.startRippleAnimation = false
							}
						}) {
							Image(systemName: "xmark.circle")
								.foregroundColor(.white)
								.font(.system(size: 32))
								.padding()
						}.buttonStyle(PlainButtonStyle())
						Spacer()
						Button(action: {
							withAnimation {
								if !DataManager.shared.activitiesClass.isEmpty {
									_ = LocationAndEvents.createLocationAndEvents(pltStn: self.pilotStationSelected, port: self.portSelected, berth: self.berthSelected, timeZoneForLocation: self.timeZoneSet)
									DataManager.shared.activitiesClass = []
									self.isBerthSelected = false
									self.startRippleAnimation = false
									self.dismissFlagForBerthListForQuickAdd = false
								}
							}
						}) {
							Text("Add Activities").font(.footnote)
								.foregroundColor(.white)
								.padding()
								.background(RoundedRectangle(cornerRadius: 4).fill(Color.blue))
								.padding()
								.shadow(radius: 5)
						}.buttonStyle(PlainButtonStyle())
					}
					VStack {
						Text("Time Zone").font(.footnote)
							.foregroundColor(.white)
							.padding(5)
						HStack {
							Text("\(self.timeZoneSet, specifier: "%.1f") hrs" ).font(.footnote)
							Stepper("", onIncrement: {
								if self.timeZoneSet <= 11.5  {
									self.timeZoneSet += (0.5)
								}
							}, onDecrement: {
								if self.timeZoneSet >= -11.5 {
									self.timeZoneSet -= (0.5)
								}
							}).labelsHidden()
						}.padding(5)
					} .frame(width:geo.size.width/(3/2))
						.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(UIColor.systemBackground), lineWidth: 1.5))
					VStack(spacing: 1) {
						ForEach(ActivityCase.allCases, id: \.self) {
							activitySelected in
							Button(action: {
								self.dismissFlag.toggle()
								self.activityCase = activitySelected
							}) {
								RippleButton(rectCorner: activitySelected.rectCorner,
											 radius: activitySelected.radious,
											 txt: activitySelected.text,
											 color: activitySelected.color,
											 geo: geo,
											 berthDetailsCaseImageName: activitySelected.imageName)
							}	.sheet(isPresented: self.$dismissFlag){
								ActivitySetupSheet(dismissFlag: self.$dismissFlag,
												   activityCase: self.activityCase,
												   pilotstationSelected: self.$pilotStationSelected,
												   portSelected: self.$portSelected,
												   berthSelected: self.$berthSelected )
							}
							.offset(y: self.startRippleAnimation ? 0 : 1000)
							.animation(.ripple(index: activitySelected.label,
											   dismiss: self.startRippleAnimation))
								.buttonStyle(PlainButtonStyle())
						}
					}
					Spacer()
				}.background(Color(.systemGray2))
					.transition(.move(edge: .bottom))
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
							self.startRippleAnimation = true
						}
				}
			}
			
		}
	}
}

// MARK: - Function

extension ResultForETAandBunker {
	
	func isKindOfCase(activityCaseLabel: Int) -> ActivityCase{
		var activityCase : ActivityCase = ActivityCase.canal
		switch activityCaseLabel {
		case 0: activityCase = ActivityCase.seaPassage
		case 1: activityCase = ActivityCase.pltIn
		case 2: activityCase = ActivityCase.pltOut
		case 3: activityCase = ActivityCase.loading
		case 4: activityCase = ActivityCase.discharging
		case 5: activityCase = ActivityCase.shifting
		case 6: activityCase = ActivityCase.layby
		case 7: activityCase = ActivityCase.bunkering
		case 8: activityCase = ActivityCase.anchoring
		case 9: activityCase = ActivityCase.canal
		default: break
		}
		return activityCase
	}
}

extension CellForETA {
	
	func vslInitialData() -> (initialDateDouble: Double, initialMGO: String, initialHFO : String, timeZoneForInitialSettings: Double) {
		var initialDateDouble: Double = 0
		var initialMGO: String = "0"
		var initialHFO: String = "0"
		var timeZoneForInitialSettings: Double = 0.0
		if let v = vesselInitialSettingsForCell.last {
			initialDateDouble = StaticClass.dateFromStringSince1970(v.initialDate ?? "01/01/20 0000")
			initialMGO = v.initialMGO ?? "0"
			initialHFO = v.initialHFO ?? "0"
			timeZoneForInitialSettings = v.timeZoneFromSetting
		}
		return (initialDateDouble: initialDateDouble, initialMGO: initialMGO, initialHFO : initialHFO, timeZoneForInitialSettings: timeZoneForInitialSettings)
	}
	
	func time()->(ETA: String, deltaTime : String,vslPercentage : String, cargoMT : String){
		
		var timePerHeaderString : String = ""
		var deltaTime : String = ""
		var vslPercentage : String = ""
		var cargoMT : String = ""
		var timeZoneInitial : Double = 0
		if let v = vesselInitialSettingsForCell.last {
			timeZoneInitial = v.timeZoneFromSetting
		}
		if Int(loc.locationID) == 0  && loc.activitiesArray.count > 0   {
			let timeZoneForLoc = loc.timeZoneForLocation * 3600
			let timePerEvents = DataManager.shared.fetchEventsTimePerLocation(fetchedEvents: loc.activitiesArray)
			let timePerEvent = timePerEvents.timePerEvents[0 ..< Int(activity.eventID) + 1].reduce(0) { $0 + $1 }
			let deltaTimePerEvent =  timePerEvents.timePerEvents[Int(activity.eventID)]
			let timePerEventRounded = (timePerEvent/360).rounded(.down)*360
			let timeDouble = vslInitialData().initialDateDouble + timePerEventRounded - (timeZoneForLoc) + (timeZoneInitial * 3600)
			deltaTime = String(format: "%.f", deltaTimePerEvent/3600)
			vslPercentage = timePerEvents.vslPercentage
			cargoMT = timePerEvents.cargoMT
			timePerHeaderString = StaticClass.dateFromDoubleSince1970(timeDouble)
			return (ETA: timePerHeaderString, deltaTime : deltaTime,vslPercentage : vslPercentage, cargoMT : cargoMT)
			
		} else if Int(loc.locationID) != 0  && loc.activitiesArray.count > 0  { 
			let timeZoneForLoc = loc.timeZoneForLocation * 3600
			let timePerPreviousSection = DataManager.shared.deltaTimeCalculatonPerLocations()
			// Return Array [Double] with total time per loaction
			let timePerEvents = DataManager.shared.fetchEventsTimePerLocation(fetchedEvents: loc.activitiesArray)
			// Return Array [Double] with all time per activity
			let timePerEvent = timePerEvents.timePerEvents[0 ..< Int(activity.eventID)+1].reduce(0) { $0 + $1 }
			// Summ the previous all value of above array untill specified Index
			let timePerEventRounded = (timePerEvent/360).rounded(.down)*360
			let timePerLoc = timePerPreviousSection[0 ..< Int(loc.locationID)].reduce(0) { $0 + $1 }
			// Summ the previous all value of above array untill specified Index
			let timePerLocRounded = (timePerLoc/360).rounded(.down)*360
			let DoubleTime = timePerEventRounded + vslInitialData().initialDateDouble + timePerLocRounded - (timeZoneForLoc) + (timeZoneInitial * 3600)
			let deltaTimePerEvent =  timePerEvents.timePerEvents[Int(activity.eventID)]
			deltaTime = String(format: "%.f", deltaTimePerEvent/3600)
			vslPercentage = timePerEvents.vslPercentage
			
			cargoMT = timePerEvents.cargoMT
			timePerHeaderString = StaticClass.dateFromDoubleSince1970(DoubleTime)
			return (ETA: timePerHeaderString, deltaTime : deltaTime,vslPercentage : vslPercentage, cargoMT : cargoMT)
		}
		return (ETA: timePerHeaderString, deltaTime : deltaTime,vslPercentage : vslPercentage, cargoMT : cargoMT)
	}
	
	func bunker() ->(HFO : String, MGO : String, boilerMultiplier : String, ddggMultiplier : String, mgoPerEvent : String, hfoPerEvent : String, meLabel : String, ddggLabel : String, boilerLabel : String) {
		var deltaHFO : String = ""
		var deltaMGO :String = ""
		
		if Int(loc.locationID) == 0  && loc.activitiesArray.count > 0  {
			if DataManager.shared.fetchBunkerConsumption() != nil   {
				let hfoPerEvents = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).hfoConsumption
				let hfoPerEventsAbs = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).hfoConsumptionAbsolute
				let mgoPerEvents = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).mgoConsumption
				let mgoPerEventsAbs = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).mgoConsumptionAbsolute
				let boilerMultiplierLabel = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).boilerMultiplier
				let ddggMultiplierLabel = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).ddggMultiplier
				let boilerMultiplier = String(format: "%.f", boilerMultiplierLabel)
				let ddggMultiplier = String(format: "%.f", ddggMultiplierLabel)
				let mgoPerEvent = mgoPerEvents[0 ..< Int(activity.eventID)+1].reduce(0) { $0 + $1 }
				let hfoPerEvent = hfoPerEvents[0 ..< Int(activity.eventID)+1].reduce(0) { $0 + $1 }
				
				let delatamgoPerEvent = mgoPerEventsAbs[Int(activity.eventID)]
				let deltahfoPerEvent = hfoPerEventsAbs[Int(activity.eventID)]
				let initialHFOUnwrap = Double(vslInitialData().initialHFO)
				let initialMGOUnwrap = Double(vslInitialData().initialMGO)
				guard let HFOUnwrap = initialHFOUnwrap else {
					return (HFO : "Set HFO Counsumption" , MGO :"Set HFO Counsumption", boilerMultiplier : "0", ddggMultiplier : "0", mgoPerEvent : "", hfoPerEvent : "", meLabel : "", ddggLabel : "", boilerLabel : "")
				}
				let hfo =  HFOUnwrap - hfoPerEvent
				guard let MGOUnwrap = initialMGOUnwrap else {
					return (HFO : "Set HFO Counsumption" , MGO :"Set HFO Counsumption", boilerMultiplier : "0", ddggMultiplier : "0", mgoPerEvent : "", hfoPerEvent : "", meLabel : "", ddggLabel : "", boilerLabel : "")
				}
				
				let mgo = MGOUnwrap - mgoPerEvent
				deltaHFO = String(format: "%.1f", hfo)
				deltaMGO = String(format: "%.1f", mgo)
				let meLabel : String = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).meLabel
				let ddggLabel : String = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).ddggLabel
				let boilerLabel : String = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).boilerLabel
				return (HFO : deltaHFO , MGO :deltaMGO, boilerMultiplier : boilerMultiplier, ddggMultiplier : ddggMultiplier, mgoPerEvent : String(format: "%.1f", delatamgoPerEvent), hfoPerEvent : String(format: "%.1f", deltahfoPerEvent), meLabel : meLabel, ddggLabel : ddggLabel, boilerLabel : boilerLabel)
				
			} else {
				return (HFO : "Set HFO Counsumption" , MGO :"Set HFO Counsumption", boilerMultiplier : "0", ddggMultiplier : "0", mgoPerEvent : "", hfoPerEvent : "", meLabel : "", ddggLabel : "", boilerLabel : "")
			}
		} else if Int(loc.locationID) != 0  && loc.activitiesArray.count > 0 {
			if DataManager.shared.fetchBunkerConsumption() != nil   {
				let hfoPerPreviousSection = DataManager.shared.deltaBunkerCalculatonPerLocations().hfoConsumptionPerLoc
				let mgoPerPreviousSection = DataManager.shared.deltaBunkerCalculatonPerLocations().mgoConsumptionPerLoc
				let hfoPerLoc = hfoPerPreviousSection[0 ..< Int(loc.locationID)].reduce(0) { $0 + $1 }
				let mgoPerLoc = mgoPerPreviousSection[0 ..< Int(loc.locationID)].reduce(0) { $0 + $1 }
				let hfoPerEvents = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).hfoConsumption
				let hfoPerEventsAbs = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).hfoConsumptionAbsolute
				let hfoPerEvent = hfoPerEvents[0 ..< Int(activity.eventID)+1].reduce(0) { $0 + $1 }
				let mgoPerEvents = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).mgoConsumption
				
				let mgoPerEventsAbs = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).mgoConsumptionAbsolute
				let mgoPerEvent = mgoPerEvents[0 ..< Int(activity.eventID)+1].reduce(0) { $0 + $1 }
				
				let delatamgoPerEvent = mgoPerEventsAbs[Int(activity.eventID)]
				let deltahfoPerEvent = hfoPerEventsAbs[Int(activity.eventID)]
				let boilerMultiplierLabel = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).boilerMultiplier
				let ddggMultiplierLabel = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).ddggMultiplier
				let boilerMultiplier = String(format: "%.f", boilerMultiplierLabel)
				let ddggMultiplier = String(format: "%.f", ddggMultiplierLabel)
				
				let initialHFOUnwrap = Double(vslInitialData().initialHFO)
				let initialMGOUnwrap = Double(vslInitialData().initialMGO)
				
				guard let HFOUnwrap = initialHFOUnwrap else {
					return (HFO : "Set HFO Counsumption" , MGO :"Set HFO Counsumption", boilerMultiplier : "0", ddggMultiplier : "0", mgoPerEvent : "", hfoPerEvent : "", meLabel : "", ddggLabel : "", boilerLabel : "")
				}
				let hfo =  HFOUnwrap - hfoPerEvent - hfoPerLoc
				
				guard let MGOUnwrap = initialMGOUnwrap else {
					return (HFO : "Set HFO Counsumption" , MGO :"Set HFO Counsumption", boilerMultiplier : "0", ddggMultiplier : "0", mgoPerEvent : "", hfoPerEvent : "", meLabel : "", ddggLabel : "", boilerLabel : "")
				}
				
				let mgo = MGOUnwrap - mgoPerEvent - mgoPerLoc
				
				deltaHFO = String(format: "%.1f", hfo)
				deltaMGO = String(format: "%.1f", mgo)
				let meLabel : String = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).meLabel
				let ddggLabel : String = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).ddggLabel
				let boilerLabel : String = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: loc.activitiesArray).boilerLabel
				return (HFO : deltaHFO , MGO :deltaMGO, boilerMultiplier : boilerMultiplier, ddggMultiplier : ddggMultiplier, mgoPerEvent : String(format: "%.1f", delatamgoPerEvent), hfoPerEvent : String(format: "%.1f", deltahfoPerEvent), meLabel : meLabel, ddggLabel : ddggLabel, boilerLabel : boilerLabel)
			} else {
				return (HFO : "Set HFO Counsumption" , MGO :"Set HFO Counsumption", boilerMultiplier : "0", ddggMultiplier : "0", mgoPerEvent : "", hfoPerEvent : "", meLabel : "", ddggLabel : "", boilerLabel : "")
			}
		}
		return (HFO : "Set HFO Counsumption" , MGO :"Set HFO Counsumption", boilerMultiplier : "0", ddggMultiplier : "0", mgoPerEvent : "", hfoPerEvent : "", meLabel : "", ddggLabel : "", boilerLabel : "")
	}
	
	func isKindOfCase(activityCaseLabel: Int16) -> (ActivityCase){
		var activityCase : ActivityCase = ActivityCase.canal
		switch activityCaseLabel {
		case 0: activityCase = ActivityCase.seaPassage
		case 1: activityCase = ActivityCase.pltIn
		case 2: activityCase = ActivityCase.pltOut
		case 3: activityCase = ActivityCase.loading
		case 4: activityCase = ActivityCase.discharging
		case 5: activityCase = ActivityCase.shifting
		case 6: activityCase = ActivityCase.layby
		case 7: activityCase = ActivityCase.bunkering
		case 8: activityCase = ActivityCase.anchoring
		case 9: activityCase = ActivityCase.canal
		default: break
		}
		return (activityCase)
	}
}

extension HeaderForETA {
	
	func time( )->(String){
		
		var deltaTime : String = ""
		let timePerEvents = DataManager.shared.fetchDeltaEventsTimePerLocation(fetchedEvents: loc)
		deltaTime = String(format: "%.f", timePerEvents/3600)
		
		return deltaTime
	}
	func bunker() ->(HFO : String, MGO : String) {
		var deltaHFO : String = ""
		var deltaMGO :String = ""
		
		if DataManager.shared.fetchBunkerConsumption() != nil   {
			let hfoPerEvents = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: activities).hfoConsumptionForHeader
			let mgoPerEvents = DataManager.shared.fetchEventsBunkerPerLocation(fetchedEvents: activities).mgoConsumptionForHeader
			let mgoPerEvent = mgoPerEvents.reduce(0,+)
			let hfoPerEvent = hfoPerEvents.reduce(0,+)
			
			deltaHFO = String(format: "%.1f", hfoPerEvent)
			deltaMGO = String(format: "%.1f", mgoPerEvent)
			return (HFO : deltaHFO , MGO :deltaMGO )
		} else {
			return (HFO : "Set HFO Counsumption" , MGO :"Set HFO Counsumption")
		}
	}
}
