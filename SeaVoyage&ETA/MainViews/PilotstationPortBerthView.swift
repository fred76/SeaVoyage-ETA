//
//  PilotstationPortBerthView.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI
struct PilotstationPortBerthView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(entity: PilotStations.entity(), sortDescriptors: [NSSortDescriptor(key: "pltName", ascending: true)])
	
	var pltStationFetched: FetchedResults<PilotStations>
	
	@State var isPLTSelected : Bool = false
	@State var isPortSelected : Bool = false
	@State var isBerthSelected : Bool = false
	
	@State var newPLTstation : String = ""
	@State var newPort : String = ""
	@State var newBerth : String = ""
	
	@State var showDistanceView : Bool = false
	@State var showMapView : Bool = false
	@State var showAddLocation : Bool = false
	@State var startRippleAnimation : Bool = false
	@State var showUserInfoPltPortBerth : Bool = false 
	@State var pilotStationSelected : String = ""
	@State var portSelected : String = ""
	@State var berthSelected : String = ""
	@State var dismissFlag : Bool = false
	@State var activityCase = ActivityCase.canal
	@State var timeZoneSet : Double = 0.0
	
	var body: some View {
		Group {
			if pltStationFetched.count == 0 {
				AddNewLocation(isPLTSelected: self.$isPLTSelected,
							   isPortSelected: self.$isPortSelected,
							   isBerthSelected: self.$isBerthSelected,
							   newPLTstation: self.$newPLTstation,
							   newPort: self.$newPort,
							   newBerth: self.$newBerth,
							   showAddLocation: self.$showAddLocation,
							   pilotStationSelected: self.$pilotStationSelected,
							   portSelected: self.$portSelected)
			} else {
				ZStack {
					Group {
						VStack {
							fakebar
							Spacer()
							GeometryReader { geom in
								HStack(spacing: 5) {
									PlitoStationList(isPLTSelected: self.$isPLTSelected,
													 showAddLocation: self.$showAddLocation,
													 pilotStationSelected: self.$pilotStationSelected,
													 geom: geom,
													 pltStationFetched: self.pltStationFetched)
										.frame(width: self.portWidth(Geom: geom).plt)
									
									if self.isPLTSelected{
										PortList(isPortSelected: self.$isPortSelected,
												 showAddLocation: self.$showAddLocation,
												 portSelected: self.$portSelected,
												 pilotStationSelected: self.pilotStationSelected,
												 geom: geom)
											.frame(width: self.portWidth(Geom: geom).port)
									}
									if self.isPortSelected {
										BerthList(isBerthSelected: self.$isBerthSelected,
												  showAddLocation: self.$showAddLocation,
												  berthSelected: self.$berthSelected,
												  portSelected: self.portSelected,
												  geom: geom  )
											.frame(width: self.portWidth(Geom: geom).berth)
									}
								}.onAppear {
									UITableView.appearance().separatorColor = .clear }
							}
							Spacer()
						}
						
					}
					.disabled(self.showDistanceView)
					.opacity(self.showDistanceView ? 0.5 : 1)
					BottomMenu(showDistanceView: self.$showDistanceView, showMapView: self.$showMapView)
					
					if showDistanceView {
						DistanceMenu(pltStationFetched: self.pltStationFetched)
					}
					
					if showAddLocation {
						AddNewLocation(isPLTSelected: self.$isPLTSelected,
									   isPortSelected: self.$isPortSelected,
									   isBerthSelected: self.$isBerthSelected,
									   newPLTstation: self.$newPLTstation,
									   newPort: self.$newPort,
									   newBerth: self.$newBerth,
									   showAddLocation: self.$showAddLocation,
									   pilotStationSelected: self.$pilotStationSelected,
									   portSelected: self.$portSelected)
					}
					
					if isBerthSelected {
						RippleMenu
					}
					
					if showMapView { 
						GeneralChart(showMap: self.$showMapView)
					}
				}.onDisappear {
					self.isPLTSelected = false
					self.isPortSelected = false
					self.isBerthSelected = false
					
					
					self.pilotStationSelected = ""
					self.portSelected = ""
					self.berthSelected = ""
					
					self.newPLTstation = ""
					self.newPort = ""
					self.newBerth = ""
				}
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
			VStack{
				Spacer()
				HStack {
					Spacer()
					Button(action: {
						withAnimation {
							self.showUserInfoPltPortBerth.toggle()
						}
					}) {
						Image(systemName: "info.circle.fill").padding()
							.font(.system(size: 30))
							.foregroundColor(.blue)
							.shadow(radius: 5)
					}
				}.padding()
			}
			if showUserInfoPltPortBerth {
				UserInfoPltPortBerth(showUserInfoPltPortBerth: self.$showUserInfoPltPortBerth)
			}
		}
	}
	
	// MARK: - fakebar
	var fakebar: some View {
		ZStack {
			HStack {
				if self.isPLTSelected {
					Button(action: {
						withAnimation {
							if self.isPLTSelected && !self.isPortSelected {
								self.isPLTSelected = false
							} else if self.isPLTSelected && self.isPortSelected {
								self.isPortSelected = false
								self.isPLTSelected = true
							}
						}
					}) {
						Image(systemName: "arrow.left.circle.fill")
							.font(.system(size: 36))
							.background( Circle()
								.fill(Color.blue) )
							.clipShape(Circle())
							.overlay(Circle()
								.stroke(Color(UIColor.systemBackground), lineWidth: 1.5))
							.font(.body)
							.foregroundColor(Color.white)
							.padding(.horizontal, 8)
					}
				}
				Spacer()
				Text("Destination")
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

struct PilotstationPortBerthView_Previews: PreviewProvider {
	static var previews: some View {
		PilotstationPortBerthView( ).environment(\.managedObjectContext, CoreData.stack.context)
	}
}

struct PlitoStationList: View {
	@Binding var isPLTSelected : Bool
	@Binding var showAddLocation : Bool
	@Binding var pilotStationSelected : String
	var geom : GeometryProxy
	var pltStationFetched: FetchedResults<PilotStations>
	
	var body: some View {
		List {
			Section(header: Header(isCellSelected: self.$isPLTSelected, txtHeader: "Add Pilot station", isBerthCell: false, showAddLocation: self.$showAddLocation)
			) {
				ForEach(self.pltStationFetched, id: \.self) {plt in
					
					Cell(txt: plt.pltName ?? "kkkkk", isCellSelected: self.$isPLTSelected, isBerthCell: false ).onTapGesture {
						withAnimation {
							self.isPLTSelected.toggle()
						}
						self.pilotStationSelected = plt.pltName ?? ""
					}
				}.onDelete(perform: self.removePltStn(at:))
			}
		}
		.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 1.5))
		
	}
	func removePltStn(at offsets: IndexSet) {
		for index in offsets {
			let language = pltStationFetched[index]
			CoreData.stack.context.delete(language)
			CoreData.stack.save()
		}
	}
}



struct PortList: View {
	@Binding var isPortSelected : Bool
	@Binding var showAddLocation : Bool
	@Binding var portSelected : String
	var pilotStationSelected : String
	var geom : GeometryProxy
	var portRequest : FetchRequest<Ports>
	var ports : FetchedResults<Ports>{portRequest.wrappedValue }
	
	init(isPortSelected: Binding<Bool>,
		 showAddLocation: Binding<Bool>,
		 portSelected: Binding<String>,
		 pilotStationSelected:String,
		 geom : GeometryProxy
	){
		self._isPortSelected = isPortSelected
		self._showAddLocation = showAddLocation
		self._portSelected = portSelected
		self.pilotStationSelected = pilotStationSelected
		self.geom = geom
		self.portRequest = FetchRequest(entity: Ports.entity(), sortDescriptors: [], predicate:
			NSPredicate(format: "pilotStations.pltName == %@", pilotStationSelected))
	}
	
	var body: some View {
		List {
			Section(header: Header(isCellSelected: self.$isPortSelected, txtHeader: "Add Port", isBerthCell: false, showAddLocation: self.$showAddLocation)
			) {
				ForEach(portRequest.wrappedValue, id: \.self) {port in
					Cell(txt: port.wrappedPort  , isCellSelected: self.$isPortSelected, isBerthCell: false ).onTapGesture {
						withAnimation {
							self.isPortSelected.toggle()
						}
						self.portSelected = port.portName ?? ""
					}
				}.onDelete(perform: self.removePort(at:))
				
			}
		}
		.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 1.5))
		
	}
	func removePort(at offsets: IndexSet) {
		for index in offsets {
			let language = ports[index]
			CoreData.stack.context.delete(language)
			CoreData.stack.save()
		}
	}
}

struct BerthList: View {
	@Binding var isBerthSelected : Bool
	@Binding var showAddLocation : Bool
	@Binding var berthSelected : String
	
	var portSelected : String
	var geom : GeometryProxy
	var berthRequest : FetchRequest<Berth>
	var berth : FetchedResults<Berth>{berthRequest.wrappedValue }
	init(isBerthSelected: Binding<Bool>,
		 showAddLocation: Binding<Bool>,
		 berthSelected : Binding<String>,
		 portSelected: String,
		 geom : GeometryProxy 
	){
		self._isBerthSelected = isBerthSelected
		self._showAddLocation = showAddLocation
		self._berthSelected = berthSelected
		self.portSelected = portSelected
		self.geom = geom
		self.berthRequest = FetchRequest(entity: Berth.entity(), sortDescriptors: [], predicate:
			NSPredicate(format: "port.portName == %@", portSelected))
	}
	
	var body: some View {
		List {
			Section(header: Header(isCellSelected: self.$isBerthSelected, txtHeader: "Add Berth", isBerthCell: true, showAddLocation: self.$showAddLocation)
			) {
				ForEach(berthRequest.wrappedValue, id: \.self) {berth in
					Cell(txt: berth.wrappedBerth, isCellSelected: self.$isBerthSelected, isBerthCell: true ).onTapGesture {
						withAnimation {
							self.isBerthSelected.toggle()
						} 
						self.berthSelected = berth.berthName ?? ""
					}
				}.onDelete(perform: self.removeBerth(at:))
			}
		}
		.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 1.5))
	}
	func removeBerth(at offsets: IndexSet) {
		for index in offsets {
			let language = berth[index]
			CoreData.stack.context.delete(language)
			CoreData.stack.save()
		}
	}
}

struct Header: View {
	@Binding var isCellSelected : Bool
	var txtHeader : String
	var isBerthCell : Bool
	@Binding var showAddLocation : Bool
	var body: some View {
		HStack {
			Button(action: {
				withAnimation {
					self.showAddLocation.toggle()
				}
			}) {
				Image(systemName: "plus.circle")
					.font(.system(size: 36))
					.background( Circle()
						.fill(Color.green) )
					.clipShape(Circle())
					.overlay(Circle()
						.stroke(Color(UIColor.systemBackground), lineWidth: 1.5))
					.font(.body)
					.foregroundColor(Color.white)
			}
			if !isBerthCell{
				Text(self.isCellSelected ?  "" : txtHeader).padding()
			} else {
				Text(txtHeader).padding()
			}
		}
	}
}

struct Cell: View {
	var txt : String
	@Binding var isCellSelected : Bool
	var isBerthCell : Bool
	var body: some View {
		HStack {
			if !isBerthCell {
				Text(self.isCellSelected ? String(txt.prefix(2)) :  txt)
					.font(self.isCellSelected ? .footnote : .none)
			} else {
				Text(txt)
			}
			Spacer()
			if !isCellSelected{
				Image(systemName: "chevron.right")
					.font(.system(size: 24))
					.foregroundColor(Color.blue)
					.padding(.horizontal, 8)
			}
		}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
			.background(Color(.systemGray2))
			.overlay(RoundedRectangle(cornerRadius: 4)
				.stroke(Color.gray, lineWidth: 1))
	}
}

struct BottomMenu: View {
	@Binding var showDistanceView : Bool
	@Binding var showMapView : Bool
	var body: some View {
		VStack{
			Spacer()
			HStack{
				Button(action: {
					withAnimation {
						self.showDistanceView.toggle()
					}
				}) {
					Image("divider")
						.resizable()
						.frame(width:44, height: 44 )
						.aspectRatio(contentMode: .fit)
						.background(Color.black.opacity(0.5))
						.clipShape(Circle())
						.padding()
						.shadow(radius: 5)
				}.buttonStyle(PlainButtonStyle())
				Spacer()
				Button(action: {
					withAnimation {
						self.showMapView.toggle()
					}
				}) {
					Image(systemName: "map")
						.font(.system(size: 24))
						.foregroundColor(.white).padding()
						.frame(width:44, height: 44 )
						.background(Color.black.opacity(0.5))
						.clipShape(Circle())
						.padding()
						.shadow(radius: 5)
				}
				.disabled(self.showDistanceView)
				.opacity(self.showDistanceView ? 0.5 : 1)
			}
		}
	}
}

struct DistanceMenu: View {
	var pltStationFetched: FetchedResults<PilotStations>
	@State private var selectedPLTSFrom : Int = 0
	@State private var selectedPLTSTo : Int = 0
	@State var edit : Bool = false
	@State var distancesTXT : String = ""
	var body: some View {
		VStack {
			VStack {
				Text("Distance From PilotStation to PilotStation")
					.foregroundColor(.white)
				GeometryReader { g in
					VStack {
						HStack {
							Picker(selection: self.$selectedPLTSFrom, label: Text("")) {
								ForEach(self.pltStationFetched.indices, id: \.self ) { p in
									Text(self.pltStationFetched[p].wrappedPlts).tag(p )
								}
							}
							.frame(maxWidth: (g.size.width / 2)-10)
							.clipped()
							.labelsHidden()
							.foregroundColor(.white)
								
							.overlay(
								RoundedRectangle(cornerRadius: 8)
									.stroke(Color.gray, lineWidth: 1))
							Picker(selection: self.$selectedPLTSTo, label: Text("")) {
								ForEach(self.pltStationFetched.indices, id: \.self ) { p in
									Text(self.pltStationFetched[p].wrappedPlts).tag(p )
								}
							}
							.frame(maxWidth: (g.size.width / 2)-10)
							.clipped()
							.labelsHidden()
							.foregroundColor(.white)
								
							.overlay(
								RoundedRectangle(cornerRadius: 8)
									.stroke(Color.gray, lineWidth: 1))
						}
						Divider()
						HStack {
							Text("From: ").font(.footnote)
								.foregroundColor(.white)
							Group { Text(self.pltStationFetched[self.selectedPLTSFrom].wrappedPlts).foregroundColor(.white)
							}.frame(maxWidth: (g.size.width / 2)-20)
							
							Image(systemName: "arrow.right")
								.foregroundColor(.white)
							Text("To: ").font(.footnote).foregroundColor(.white)
							Group { Text(self.pltStationFetched[self.selectedPLTSTo].wrappedPlts).foregroundColor(.white)
							}.frame(maxWidth: (g.size.width / 2)-20)
						}
						Divider()
						HStack {
							Group{
								if self.edit {
									WrappedTextField(text: self.$distancesTXT, placeHolder: "distance", keyType: .decimalPad, textAlignment: .left).foregroundColor(.white)
								} else {
									Text(self.retreiveDistance()).foregroundColor(.white)
								}
								Text(" NM").font(.footnote).foregroundColor(.white)
							}
							.frame(maxWidth: (g.size.width / 2)-10,maxHeight: 32)
							
							Button(action: {
								DataManager.shared.dismissKeyboard()
								withAnimation {
									self.edit.toggle()
								}
								let comp = self.pltStationFetched[self.selectedPLTSFrom].wrappedPlts + self.pltStationFetched[self.selectedPLTSTo].wrappedPlts
								let t = DataManager.shared.fetchDistances(pltSToPltS: comp)
								if let y = t {
									y.distances = self.distancesTXT.doubleValue
								} else {
									
									_ = Distances.createDistances(name: comp, distance: self.distancesTXT.doubleValue, note: "")
								}
								CoreData.stack.save()
								
								
							}) {
								Text(self.edit ? "Save" : "Edit" ).font(.footnote)
									.frame(width: (g.size.width / 2)-10, height: 34)
									.foregroundColor(.white)
									.background(RoundedRectangle(cornerRadius: 4)
										.fill(Color.green))
									.overlay(
										RoundedRectangle(cornerRadius: 4)
											.stroke(Color.white, lineWidth: 1) )
							}
						}
					}
				}.padding()
			}.background(Color(.systemTeal)) .frame(height: 350)
			Spacer()
		}.transition(.move(edge: .top))
	}
	
	func retreiveDistance() -> String{
		var s : String = "0"
		let t = DataManager.shared.fetchDistances(pltSToPltS: self.pltStationFetched[self.selectedPLTSFrom].wrappedPlts + self.pltStationFetched[self.selectedPLTSTo].wrappedPlts)
		if let y = t?.distances {
			s = String(format: "%.f", y)
			return s
		}
		return s
	}
	
	func isDistance() -> Bool{
		let t = DataManager.shared.fetchDistances(pltSToPltS: self.pltStationFetched[self.selectedPLTSFrom].wrappedPlts + self.pltStationFetched[self.selectedPLTSTo].wrappedPlts)
		if let _ = t?.distances {
			return true
		} else {
			return false
		}
	}
}

struct AddNewLocation: View {
	@Binding var isPLTSelected : Bool
	@Binding var isPortSelected : Bool
	@Binding var isBerthSelected : Bool
	@Binding var newPLTstation : String
	@Binding var newPort : String
	@Binding var newBerth : String
	@Binding var showAddLocation : Bool
	@Binding var pilotStationSelected : String
	@Binding var portSelected : String
	@State var showUserInfoPltPortBerth : Bool = false
	var body: some View {
		ZStack {
			VStack {
				Spacer()
				if !isPLTSelected{
					WrappedTextField(text: self.$newPLTstation, placeHolder: "add Pilotstation", keyType: .default).frame(height: 32)
						.padding()
					WrappedTextField(text: self.$newPort, placeHolder: "add Port", keyType: .default).frame(height: 32)
						.padding()
					WrappedTextField(text: self.$newBerth, placeHolder: "add Berth", keyType: .default).frame(height: 32)
						.padding()
				}
				if isPLTSelected && !isPortSelected{
					Text(pilotStationSelected)
					WrappedTextField(text: self.$newPort, placeHolder: "add Port", keyType: .default).frame(height: 32)
						.padding()
					WrappedTextField(text: self.$newBerth, placeHolder: "add Berth", keyType: .default).frame(height: 32)
						.padding()
				}
				if isPortSelected{
					Text(pilotStationSelected)
					Text(portSelected)
					WrappedTextField(text: self.$newBerth, placeHolder: "add Berth", keyType: .default).frame(height: 32)
						.padding()
				}
				Button(action: {
					DataManager.shared.dismissKeyboard()
					withAnimation {
						self.showAddLocation = false
						if !self.isPLTSelected{
							if !self.newPLTstation.isEmpty {
								let newPltStn = PilotStations.createPilotStations(name: self.newPLTstation)
								if !self.newPort.isEmpty {
									let newPort = Ports.createPortFor(item: newPltStn, name: self.newPort)
									if !self.newBerth.isEmpty {
										let b = Berth.createBerthFor(item: newPort, name: self.newBerth)
										_ = BerthDetail.createBerthFor(item: b)
									}
								}
							}
						}
						
						if self.isPLTSelected && !self.isPortSelected{
							if !self.newPort.isEmpty {
								let newPort = Ports.createPortFor(item: DataManager.shared.fetchPortFromPLTs(pltName: self.pilotStationSelected).plt, name: self.newPort)
								if !self.newBerth.isEmpty {
									let b = Berth.createBerthFor(item: newPort, name: self.newBerth)
									_ = BerthDetail.createBerthFor(item: b)
								}
							}
						}
						
						if self.isPortSelected{
							if !self.newBerth.isEmpty {
								let b = Berth.createBerthFor(item: DataManager.shared.fetchBerthFromPort(portName: self.portSelected).port, name: self.newBerth)
								_ = BerthDetail.createBerthFor(item: b)
							}
						}
						self.newPLTstation = ""
						self.newPort = ""
						self.newBerth = ""
					}
				}) {
					
					Text("Save")
						.foregroundColor(.white)
						.padding()
						.background(RoundedRectangle(cornerRadius: 4)
							.fill(Color.green))
					
				}
				Spacer()
				Spacer()
			}
			
			VStack{
				Spacer()
				HStack {
					Spacer()
					Button(action: {
						withAnimation {
							self.showUserInfoPltPortBerth.toggle()
						}
						
					}) {
						Image(systemName: "info.circle.fill").padding()
							.font(.system(size: 30))
							.foregroundColor(.blue)
							.shadow(radius: 5)
					}
					
				}.padding()
			}
			if showUserInfoPltPortBerth {
				UserInfoPltPortBerth(showUserInfoPltPortBerth: self.$showUserInfoPltPortBerth)
			}
		}
		.onTapGesture {
			DataManager.shared.dismissKeyboard()
		}
		.background(Color(.systemGray2))
		.transition(.move(edge: .top))
	}
}

struct UserInfoPltPortBerth: View  {
	@Binding var showUserInfoPltPortBerth : Bool
	
	var body: some View {
		VStack {
			HStack {
				Spacer()
				Button(action: {
					withAnimation {
						self.showUserInfoPltPortBerth = false
					}
				}) {
					Image(systemName: "xmark.circle")
						.foregroundColor(.white)
						.font(.system(size: 32))
						.padding()
				}.buttonStyle(PlainButtonStyle())
			}
			Text("How to use")
				.font(.callout)
				.foregroundColor(.white)
				.padding()
			Text("See Voyage & ETA")
				.font(.callout)
				.foregroundColor(.white)
			
			Divider()
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading) {
					Group {
						Image(systemName: "mappin.and.ellipse")
							.foregroundColor(.white)
							.font(.system(size: 32))
							.padding()
						
						Text("""
							  Destination Tab:
							  ----------------

							  1)  Add Pilot-station
							  2)  Add Port
							  3)  Add Berth
							   
							  4)  Select the berth
							  5)  Time zone notation
							  East of Greenwich negative time
							  West of Greenwich positive time
							  Eg: Rotterdam -1 hr
							  Eg: New York +4 hr

							  6)  From activities menu add all activites scheduled for selected pilot station/port/berth in the espected order

							  Eg:
							  - Sea Passage (Distance and speed)
							  - Pilotage inbound (Expected duration in hrs)
							  - Loading  (Expected duration in hrs)
							  - Shifting  (Expected duration in hrs and name of shifting berth)
							  - Layby Berth  (Expected duration in hrs)
							  - Discharging  (Expected duration in hrs)
							  - Bunkering  (Expected duration in hrs, bunker intake quantity)
							  - Pilotage Outbound (Expected duration in hrs)
							  - Anchoring (Expected duration in hrs)

							  - Canal Transit

							  Eg.: Kiel Canal
							  a) Add pilotage inbound (Elbe plt/S to Brusbuttel)
							  b) Add canal transit (Kiel canal)
							  c) Add Pilotage outbound (Holtenau to Kiel LH)

							  With Canal transit activity instead set up the fuel consumption for the activity you can set a fix consumption according your experience
							  
							  7)  Repeat from step 1) for next leg

							  8) Special use
							  - Use the app also to calculate ETA to special WP for example when vessel enter or exit from ECA Area and include the different bunker consumption

							  Eg:
							  - Pilot station > Sea waypoint
							  - Port > ECA area south
							  - Berth > Outbound
							  
							  Select Outbound and create a Sea Passage activity with MGO as Main engine fuel
							  Select a berth outside ECA area and create Sea Passage activity with HFO as Main engine fuel and all other activities if needed

							  9) Location tree
							  - Pilot station can hold many ports
							  - Port can hold many Berths
							  """).font(.callout)
							.foregroundColor(.white)
							.padding()
						
						Image("divider_white")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width:32, height: 32 )
							.clipShape(Circle())
							.overlay(Circle() .stroke(Color.white, lineWidth: 1) )
							
							.padding()
						Text("""
				Distance Table:
				---------------

				1)  Select the Divider icon in the tab "Destination"
				2)  Distance window will open
				3)  Select two pilot-station and save the distance in nautical miles
				""").font(.callout)
							.foregroundColor(.white)
							.padding()
						
						Image(systemName: "map")
							.foregroundColor(.white)
							.font(.system(size: 32))
							.padding()
						
						Text("""
                   Berths on the Map:
                   ------------------

                   1)  Select the map icon in the tab "Destination"
                   2)  A iOS map will appear with all your berths position
                   """).font(.callout)
							.foregroundColor(.white)
							.padding()
					}
					Group {
						Image(systemName: "calendar")
							.foregroundColor(.white)
							.font(.system(size: 32))
							.padding()
						
						Text("""
					ETA Tab:
					--------

					1)  Select Tab "ETA" to see all results
					2)  From top menu set initial local date and time
					3)  From top menu set initial ROB for fuel
					4)  The gray header hold all information about location
					5)  The white cells are all activity for that port
					6)  From within ETA tab you can:

					a)  Add activity for location
					b)  Edit existing activity
					c)  Change location order
					d)  Change activity order
					e)  Delete location
					f)  Delete Activity
					!Note: For bunker estimation You need to fill up the form at tab "Fuel"
					""").font(.callout)
							.foregroundColor(.white)
							.padding()
						
						Image(systemName: "doc.richtext")
							.foregroundColor(.white)
							.font(.system(size: 32))
							.padding()
						
						Text("""
					Port Log Tab:
					-------------
					
					1) Select the tab "Port log"
					2) Select a Berth and edit the information:
					   Tap any detail icon on the view and an option menu will pop up.
					   As well by tapping the map icon You can save the berth coordinate (Latitude & Longitude) and the photo of the map
					3) Add Cargo for selected Berth (Suitable only for tanker ship)
					""").font(.callout)
							.foregroundColor(.white)
							.padding()
						
						Image(systemName: "drop.triangle")
							.foregroundColor(.white)
							.font(.system(size: 32))
							.padding()
						
						Text("""
					Fuel Tab:
					---------
					
					This tab hold the information how your vessel will consume bunker.
					About the consumption of bunker against the sea speed the app use an interpolation between full cruise speed, speed with engine at 80%, speed with engine at 60%, speed with engine at 40% for ballast and full laden condition.

					""").font(.callout)
							.foregroundColor(.white)
							.padding()
						
						Image(systemName: "gear")
							.foregroundColor(.white)
							.font(.system(size: 32))
							.padding()
						
						Text("""
					Settings Tab:
					-------------fredtes

					Share Port Rotation as PDF or CSV:

					1) Select the tab "Settings"
					2) Set vessel information (Optional)
					3) Select Export PDF to share your rotation
					3) Select Export CSV to share your rotation
					4) Deselect "Include bunker report" to not include bunker report in the exported file
					""").font(.callout)
							.foregroundColor(.white)
							.padding()
						
						Text("""
						 
						-----------------------------
						""").font(.callout)
							.foregroundColor(.white)
							.padding()
						
						Text("""
						Legal:
						------

						See Voyage & ETA:

						1) Not use thirth party library
						2) Not save or share any user preferences
						3) Use iCloud to share data within user device logged with same Apple account
						4) Is vailable for iOS - iPad OS - MAC OS

						""").font(.callout)
							.foregroundColor(.white)
							.padding()
					}
				}			}
		}.background(RoundedRectangle(cornerRadius: 5).fill(Color.blue))
			.overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 1.5))
			.padding()
			.transition(.move(edge: .leading))
	}
}

struct RippleButton: View  {
	var rectCorner : UIRectCorner = []
	var radius : CGFloat = 0
	var txt : String = ""
	var color : Color = .red
	var geo : GeometryProxy
	
	var berthDetailsCaseImageName : String
	var body: some View {
		ZStack {
			Rectangle()
				.cornerRadius(10, corners: self.rectCorner)
				.foregroundColor(Color(UIColor.systemBackground)).frame(width: geo.size.width/(3/2), height: 44)
				.overlay(self.ppp(x: geo.size.width/(3/2), y: 20)
					.fill(self.color)
					.shadow(radius: 2, x: -geo.size.width/(3/2)+20, y: 3)
			)
			HStack {
				Text(self.txt)
					.font(.system(size: 10))
					.multilineTextAlignment(.leading)
					.frame(width:geo.size.width/(4))
				Divider()
					.padding(.vertical)
				ZStack {
					Image(berthDetailsCaseImageName)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width:40, height: 40 )
						.clipShape(Circle())
						.overlay(Circle() .stroke(self.color, lineWidth: 1) )
						.padding(.vertical)
				}.frame(width:geo.size.width/(4), height: 32 )
			}.frame(height : 44)
		}
	}
	func ppp (x: CGFloat, y : CGFloat) -> Path{
		let p = Path { path in
			path.move(to: CGPoint(x: x-y, y: 0))
			path.addArc(tangent1End: CGPoint(x: x, y: 0), tangent2End: CGPoint(x: x, y: 4), radius: 4)
			path.addLine(to: CGPoint(x: x, y: y))
			path.addLine(to: CGPoint(x: x-y, y: 0))
		}
		return p
	}
}

// MARK: - Function for UI

extension PilotstationPortBerthView {
	func portWidth(Geom : GeometryProxy)->(plt:CGFloat, port:CGFloat, berth : CGFloat){
		var plt:CGFloat = 0
		var port:CGFloat = 0
		var berth:CGFloat = 0
		if !isPLTSelected && !isPortSelected || !isPLTSelected{
			plt = Geom.size.width - 5
			port = 0
			berth = 0
		}
		if isPLTSelected && !isPortSelected {
			plt = Geom.size.width/6 - 5
			port = Geom.size.width-Geom.size.width/6 - 5
			berth = 0
		}
		if isPLTSelected && isPortSelected {
			plt = 0
			port = Geom.size.width/6 - 5
			berth = Geom.size.width-((Geom.size.width)/6) - 10
			
		}
		return (plt:plt, port:port, berth: berth)
	}
}
