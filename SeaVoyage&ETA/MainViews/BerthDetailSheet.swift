//
//  BerthDetailSheet.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 09/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI
import MapKit

struct BerthDetailSheet: View {
	var imageSize : CGFloat = 180
	@State var labelValue : String = "15 mt"
	var berthDetail : BerthDetail
	@State var shwoMapView : Bool = false
	@State var shwoDraftView : Bool = false
	@State var showCollectionView : Bool = false
	@State var intSelection : Int = 0
	@Binding var dismissFlag: Bool
	@State var showCargoFlag : Bool = false
	@State var showCargoFlagEdit : Bool = false
	@State var showBerthNote : Bool = false
	@State var c : CargoesForBerth!
	@State var berthNote : String = ""
	
	var cargoesForBerthRequest : FetchRequest<CargoesForBerth>
	var cargoesForBerth : FetchedResults<CargoesForBerth>{cargoesForBerthRequest.wrappedValue }
	
	init(
		berthDetail : BerthDetail,
		dismissFlag : Binding<Bool>
	) {
		self.berthDetail = berthDetail
		self._dismissFlag = dismissFlag
		self.cargoesForBerthRequest = FetchRequest(entity: CargoesForBerth.entity(),
												   sortDescriptors: [],
												   predicate:
			NSPredicate(format:
				"berthDetails.berth.port.pilotStations.pltName == %@ && berthDetails.berth.port.portName == %@ && berthDetails.berth.berthName  == %@",
						berthDetail.berth?.port?.pilotStations?.pltName ?? "",
						berthDetail.berth?.port?.portName ?? "",
						berthDetail.berth?.berthName ?? ""))
	}
	var body: some View { 
		ZStack {
			ZStack {
				VStack {
					Rectangle()
						.foregroundColor(StaticClass.seaPassageColor )
						.edgesIgnoringSafeArea(.horizontal)
						.frame(height: (imageSize/2)+54)
					Spacer()
				}
				VStack {
					fakebar
					Button(action: {
						withAnimation {
							self.shwoMapView = true
						}
					}) {
						self.imageToShow()
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.frame(width: imageSize, height: imageSize)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 3))
					}.buttonStyle(PlainButtonStyle())
					Spacer()
				}
			}
			.disabled(self.showCollectionView)
			.opacity(self.showCollectionView ? 0.3 : 1)
			.disabled(self.shwoDraftView)
			.opacity(self.shwoDraftView ? 0.3 : 1)
			.disabled(self.shwoMapView)
			.opacity(self.shwoMapView ? 0.3 : 1)
			.disabled(self.showBerthNote)
			.opacity(self.showBerthNote ? 0.3 : 1)
			VStack {
				Spacer(minLength: (imageSize/2)+64)
				
				berthingMenu
				Divider()
				facilityMenu
				Divider()
				HStack {
					Button(action: {
						withAnimation {
							self.showCargoFlag = true
						}
					}) {
						Image(systemName: "plus.circle")
							.font(.system(size: 42))
							.background( Circle()
								.fill(Color.green) )
							.clipShape(Circle())
							.overlay(Circle()
								.stroke(Color(UIColor.systemBackground), lineWidth: 1.5))
							.font(.body)
							.foregroundColor(Color.white)
					}.padding(.horizontal)
					Text("Add cargo")
					Spacer()
				}.padding().background(Color(UIColor.systemBackground)).shadow(radius: 3, x: 1, y: 3)
				List  {
					ForEach(self.cargoesForBerthRequest.wrappedValue, id: \.self) { cargo in
						Button(action: {
							self.c = cargo
							withAnimation {
								self.showCargoFlagEdit.toggle()
							}
						}) {
							CargoCell(cargo: cargo)
						}
					}.onDelete(perform: self.removeCargo(at:))
						.buttonStyle(PlainButtonStyle())
				}
				.onAppear {
					UITableView.appearance().separatorColor = .clear }
				Spacer()
				
			}
			.disabled(self.showCollectionView)
			.opacity(self.showCollectionView ? 0.3 : 1)
			.disabled(self.shwoDraftView)
			.opacity(self.shwoDraftView ? 0.3 : 1)
			.disabled(self.shwoMapView)
			.opacity(self.shwoMapView ? 0.3 : 1)
			.disabled(self.showBerthNote)
			.opacity(self.showBerthNote ? 0.3 : 1)
			
			if shwoMapView {
				MapView( berthDetail: self.berthDetail , showMap: self.$shwoMapView)
			}
			if shwoDraftView {
				DraftView(shwoDraftView: self.$shwoDraftView, berthDetail: self.berthDetail)
			}
			if showCollectionView {
				CollectionViewForBerthDetail(intToCase: self.intSelection,
											 showCollectionView: self.$showCollectionView,
											 berthDetail: self.berthDetail)
			}
			if showCargoFlag {
				CargoView(berthDetail: self.berthDetail, showCargoFlag: self.$showCargoFlag)
			}
			if showCargoFlagEdit {
				CargoView(cargo: self.c ,showCargoFlag: self.$showCargoFlagEdit)
			}
			
			if showBerthNote {
				TextViewBarth(txt: self.$berthNote, berthDetail: self.berthDetail, showBerthNote: self.$showBerthNote)
			}
		}
		
	}
	// MARK: - fakebar
	var fakebar: some View {
		ZStack {
			VStack {
				Text(berthDetail.berth?.berthName ?? "")
					.fontWeight(.bold)
					.foregroundColor(.white)
					.padding(.horizontal, 40)
			}
			HStack { 
				Spacer()
				Button(action: {
					self.dismissFlag = false
				}) {
					Text("Close")
						.fontWeight(.bold)
						.foregroundColor(.white)
						.padding(.horizontal, 20)
				}
			}
			.frame(height: 44)
			.background(Color.clear.padding(.top, -44))
			.edgesIgnoringSafeArea(.horizontal)
			.padding(.bottom, -8)
		}
	}
	// MARK: - berthingMenu
	var berthingMenu: some View {
		GeometryReader { g in
			HStack {
				Button(action: {
					withAnimation {
						self.shwoDraftView = true
					}
				}) {
					LargeIcon(g: g,
							  txt: "Draft",
							  imageName: "draft", labelValue: String(format: "%.1f",self.berthDetail.maxDraft ) + " mtr" )
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.showCollectionView = true
					}
					self.intSelection = 2
				}) {
					LargeIconWithValue(g: g,
									   txt: "Mooring",
									   imageName: self.isKindOfCase(activityCaseLabel: self.berthDetail.mooringSide).MooringSideCase.imageName)
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.showCollectionView = true
					}
					self.intSelection = 3
					
				}) {
					LargeIcon(g: g,
							  txt: "Berthing",
							  imageName: self.isKindOfCase(activityCaseLabel: self.berthDetail.tugsForMooring).TugsBerthinCase.imageName,
							  labelValue: ("\(self.berthDetail.tugsForMooringNumber)"))
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.showCollectionView = true
					}
					self.intSelection = 4
				}) {
					LargeIcon(g: g,
							  txt: "Unberthing",
							  imageName: self.isKindOfCase(activityCaseLabel: self.berthDetail.tugsForUnmooring).TugsUnberthinCase.imageName,
							  labelValue: ("\(self.berthDetail.tugsForUnmooringNumber)"))
				}
			}.buttonStyle(PlainButtonStyle())
			
		}.frame(height: 100)
		
	}
	// MARK: - facilityMenu
	var facilityMenu: some View {
		HStack {
			Group {
				Spacer()
				Button(action: {
					withAnimation {
						self.showCollectionView = true
					}
					self.intSelection = 5
				}) {
					SmallIcon(txt: "Freshwater",
							  imageName: self.isKindOfCase(activityCaseLabel: self.berthDetail.freshWater).FreshWaterCase.imageName)
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.showCollectionView = true
					}
					self.intSelection = 6
				}) {
					SmallIcon(txt: "Bunker",
							  imageName: self.isKindOfCase(activityCaseLabel: self.berthDetail.bunker).BunkerCase.imageName)
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.showCollectionView = true
					}
					self.intSelection = 7
				}) {
					SmallIcon(txt: "Sludge",
							  imageName: self.isKindOfCase(activityCaseLabel: self.berthDetail.sludge).SludgeCase.imageName)
				}
			}
			Group {
				Spacer()
				Button(action: {
					withAnimation {
						self.showCollectionView = true
					}
					self.intSelection = 8
				}) {
					SmallIcon(txt: "Stores",
							  imageName: self.isKindOfCase(activityCaseLabel: self.berthDetail.stores).StoresCase.imageName)
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.showCollectionView = true
					}
					self.intSelection = 9
				}) {
					SmallIcon(txt: "Garbage",
							  imageName: self.isKindOfCase(activityCaseLabel: self.berthDetail.garbage).GarbageCase.imageName)
				}
				
				Spacer()
				Button(action: {
					withAnimation {
						self.showBerthNote = true
					}
					self.intSelection = 10
				}) {
					SmallIcon(txt: "Notes",
							  imageName: noteIcon())
				}
				Spacer()
			}
		}.buttonStyle(PlainButtonStyle())
	}
}

// MARK: - DraftView
struct DraftView: View {
	@State var maxDraft : Double = 0
	@Binding var shwoDraftView : Bool
	@State var rotate : Bool = false
	var berthDetail: BerthDetail!
	var body: some View {
		VStack {
			Button(action: {
				self.shwoDraftView = false
				self.rotate = false
				self.berthDetail.maxDraft = self.maxDraft
				self.berthDetail.now = Date()
				CoreData.stack.save()
			}) {
				Image(systemName: "xmark.circle")
					.foregroundColor(.black)
					.font(.system(size: 24))
					.padding()
			}
			
			VStack {
				Image("draft")
					.resizable()
					.aspectRatio(1, contentMode: .fit)
					.frame(width: 140, height: 140)
					.padding()
					.clipShape(RoundedRectangle(cornerRadius: 8))
					.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5))
					.background(Color(UIColor.systemBackground))
					.rotation3DEffect(self.rotate ? .degrees(0) : .degrees(90), axis: (x: 0, y: 1, z: 0) )
					.scaleEffect(self.rotate ? 1 : 0)
					.onAppear {
						withAnimation(Animation.easeOut(duration: 0.5).delay(0.3)) {
							self.rotate.toggle()
						}
				}
				HStack {
					Text("\(self.maxDraft, specifier: "%.1f")").font(.footnote)
					Stepper("", onIncrement: {
						if self.maxDraft <= 30  {
							self.maxDraft += (0.5)
						}
					}, onDecrement: {
						if self.maxDraft >= 1 {
							self.maxDraft -= (0.5)
						}
					}).labelsHidden()
				}.onAppear(perform: {
					self.maxDraft =  self.berthDetail.maxDraft
				})
			}.padding()
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5))
				.background(Color(UIColor.systemBackground))
			
		}.transition(.move(edge: .bottom))
	}
}

// MARK: - DetailButton
struct DetailButton: View {
	var txt : String
	var imageName : String
	var body: some View {
		VStack {
			Text (txt)
				.font(.system(size: 10))
				.fontWeight(.light)
				.foregroundColor(Color.gray)
			Image(imageName)
				.resizable()
				.aspectRatio(1, contentMode: .fit)
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5))
		}.frame(width: 140, height: 140)
	}
}

// MARK: - CollectionViewForBerthDetail
struct CollectionViewForBerthDetail: View {
	var intToCase : Int = 5
	@State var showStepper : Bool = false
	@State var tugBerthingNumber : Int = 0
	@State var tugUnberthingNumber : Int = 0
	@Binding var showCollectionView : Bool
	@State var rotate : Bool = false
	var berthDetail: BerthDetail!
	func selectDetaiCase() -> (imageName:[String], label : [Int], txt : [String]) {
		var imageName : [String] = []
		var label : [Int] = []
		var txt : [String] = []
		
		switch intToCase {
		case 2: for t in MooringSideCase.allCases {
			imageName.append(t.imageName); label.append(t.label); txt.append(t.text)
			}
		case 3: for t in TugsBerthinCase.allCases {
			imageName.append(t.imageName); label.append(t.label); txt.append(t.text)
			}
		case 4: for t in TugsUnberthinCase.allCases {
			imageName.append(t.imageName); label.append(t.label); txt.append(t.text)
			}
		case 5: for t in FreshWaterCase.allCases {
			imageName.append(t.imageName); label.append(t.label); txt.append(t.text)
			}
		case 6: for t in BunkerCase.allCases {
			imageName.append(t.imageName); label.append(t.label); txt.append(t.text)
			}
		case 7: for t in SludgeCase.allCases {
			imageName.append(t.imageName); label.append(t.label); txt.append(t.text)
			}
		case 8: for t in StoresCase.allCases {
			imageName.append(t.imageName); label.append(t.label); txt.append(t.text)
			}
		case 9: for t in GarbageCase.allCases {
			imageName.append(t.imageName); label.append(t.label); txt.append(t.text)
			}
			
			
		default: break
		}
		return (imageName, label, txt)
	}
	
	var body: some View {
		
		VStack {
			Button(action: {
				self.showCollectionView = false
				self.showStepper = false
				self.rotate = false
				self.berthDetail.tugsForMooringNumber = Int32(self.tugBerthingNumber)
				self.berthDetail.tugsForUnmooringNumber = Int32(self.tugUnberthingNumber)
				self.berthDetail.now = Date()
				CoreData.stack.save()
			}) {
				Image(systemName: "xmark.circle")
					.foregroundColor(.black)
					.font(.system(size: 24))
					.padding()
			}
			VStack(spacing: 1) {
				
				selectedDetailOptionForBerth
				
				if intToCase == 3 {
					
					HStack {
						Text("\(self.tugBerthingNumber) Tugs").font(.footnote)
						Stepper("", onIncrement: {
							if self.tugBerthingNumber <= 9  {
								self.tugBerthingNumber += (1) }
						}, onDecrement: {
							if self.tugBerthingNumber >= 1 {
								
								self.tugBerthingNumber -= (1)
							}
						}).labelsHidden()
					}
				}
				if intToCase == 4  {
					
					HStack {
						Text("\(self.tugUnberthingNumber) Tugs").font(.footnote)
						Stepper("", onIncrement: {
							if self.tugUnberthingNumber <= 9  {
								self.tugUnberthingNumber += (1) }
						}, onDecrement: {
							if self.tugUnberthingNumber >= 1 {
								
								self.tugUnberthingNumber -= (1)
							}
						}).labelsHidden()
					}
				}
				
				
			}
			.onAppear(perform: {
				self.tugBerthingNumber = Int(self.berthDetail.tugsForMooringNumber)
				self.tugUnberthingNumber = Int(self.berthDetail.tugsForUnmooringNumber)
			})
				.padding()
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5))
				.background(Color(UIColor.systemBackground))
			
		}.transition(.move(edge: .bottom))
	}
	
	var selectedDetailOptionForBerth : some View {
		
		CollectionView(columns: 2, items: selectDetaiCase().imageName, label: selectDetaiCase().label, txt: selectDetaiCase().txt) { (item, lab, txtt)   in
			VStack(spacing:1) {
				Button(action: {
					switch self.intToCase {
					case 2: self.berthDetail.mooringSide = Int16(lab)
					case 3: self.berthDetail.tugsForMooring = Int16(lab)
					case 4: self.berthDetail.tugsForUnmooring = Int16(lab)
					case 5: self.berthDetail.freshWater = Int16(lab)
					case 6: self.berthDetail.bunker = Int16(lab)
					case 7: self.berthDetail.sludge = Int16(lab)
					case 8: self.berthDetail.stores = Int16(lab)
					case 9: self.berthDetail.garbage = Int16(lab)
					default: break
					}
					self.berthDetail.now = Date()
					CoreData.stack.save()
				}) {
					DetailButton(txt: txtt, imageName: item) 
				}.buttonStyle(PlainButtonStyle())
					.rotation3DEffect(self.rotate ? .degrees(0) : .degrees(90), axis: (x: 0, y: 1, z: 0) )
					.scaleEffect(self.rotate ? 1 : 0)
				
			}.onAppear {
				withAnimation(Animation.easeOut(duration: 0.5).delay(0.3)) {
					self.rotate.toggle()
				}
			}
		}
	}
}

// MARK: - MapView
struct MapView: View {
	@State private var centerCoordinate = CLLocationCoordinate2D()
	var berthDetail: BerthDetail!
	@State var mapView = MKMapView()
	@State var selectedElement : Int = 0
	@State var showMapAlert : Bool = false
	@State var locationManager : CLLocationManager! = CLLocationManager()
	@Binding var showMap : Bool
	var body: some View {
		VStack {
			Button(action: {
				self.showMap = false
			}) {
				Image(systemName: "xmark.circle")
					.foregroundColor(.black)
					.font(.system(size: 24))
					.padding()
			}
			VStack {
				VStack {
					WrappedMapWithCenterPoint(
						centerCoordinate: self.$centerCoordinate,
						mapView: self.$mapView,
						mapStyle: self.$selectedElement,
						showMapAlert: self.$showMapAlert,
						locationManager: self.$locationManager,
						berthDetail: self.berthDetail)
				}
				.clipShape(Circle())
				.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
				.frame(width: 300, height: 300)
				Button(action: {
					self.berthDetail.latitude = self.centerCoordinate.latitude
					self.berthDetail.longitude = self.centerCoordinate.longitude
					self.berthDetail.latitudeDelta = self.mapView.region.span.latitudeDelta
					self.berthDetail.longitudeDelta = self.mapView.region.span.longitudeDelta
					self.mapView.showsUserLocation = false
					let render = UIGraphicsImageRenderer(size: self.mapView.bounds.size)
					let image = render.image { ctx in
						self.mapView.drawHierarchy(in: self.mapView.bounds, afterScreenUpdates: true)
					}
					guard let imageData = image.jpegData(compressionQuality: 1) else {
						print("jpg error")
						return
					}
					self.berthDetail.mapScreenshot = imageData
					self.berthDetail.now = Date()
					CoreData.stack.save()
					self.mapView.showsUserLocation = true
				}) {
					Text("Save map")
						.foregroundColor(.white).padding(5)
						.background(RoundedRectangle(cornerRadius: 4)
							.fill(Color.gray))
						.overlay(
							RoundedRectangle(cornerRadius: 4)
								.stroke(Color.white, lineWidth: 1) )
						.padding()
				}
				SegmentedControllerForMap(self.$selectedElement)
					.frame(width: 250 )
				
			}.padding()
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5))
				.background(Color(UIColor.systemBackground))
			
			
			
		}.transition(.move(edge: .bottom))
	}
}

extension MapView {
	func goToDeviceSettings() {
		guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
}

// MARK: - LargeIcon
struct LargeIcon: View {
	var g : GeometryProxy
	var txt : String
	var imageName : String
	var labelValue : String
	var body: some View {
		ZStack {
			VStack {
				Text(txt)
					.font(.caption)
					.fontWeight(.light)
					.padding(.vertical , 2)
					.padding(.horizontal , 5)
					.background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemBackground)))
				Image(imageName)
					.resizable()
					.aspectRatio(1, contentMode: .fit)
					.frame(width: 60, height: 60)
					.background(Color(UIColor.systemBackground))
					.clipShape(Circle())
					.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
				
			}
			VStack {
				Spacer()
				HStack {
					Spacer()
					Text(labelValue)
						.foregroundColor(Color.white)
						.font(.caption)
						.fontWeight(.light).padding(.horizontal, 8)
						.background(RoundedRectangle(cornerRadius: 8).fill(StaticClass.seaPassageColor))
				}
			}
		}.frame(width: g.size.width/5)
	}
}

// MARK: - LargeIconWithValue
struct LargeIconWithValue: View {
	var g : GeometryProxy
	var txt : String
	var imageName : String
	var body: some View {
		VStack {
			Text(txt)
				.font(.caption)
				.fontWeight(.light)
				.padding(.vertical , 2)
				.padding(.horizontal , 5)
				.background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemBackground)))
			Image(imageName)
				.resizable()
				.aspectRatio(1, contentMode: .fit)
				.frame(width: 60, height: 60)
				.background(Color(UIColor.systemBackground))
				.clipShape(Circle())
				.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
			
		}.frame(width: g.size.width/5)
	}
}

// MARK: - SmallIcon
struct SmallIcon: View {
	var txt : String
	var imageName : String
	var body: some View {
		
		VStack {
			Text(txt)
				.font(.caption)
				.fontWeight(.light)
			Image(imageName)
				.resizable()
				.aspectRatio(1, contentMode: .fit)
				.frame(width: 32, height: 32)
				.clipShape(Circle())
				.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
		}
	}
}

// MARK: - SmallIconCargo
struct SmallIconCargo: View {
	var txt : String
	var imageName : String
	var body: some View {
		
		VStack {
			Image(imageName)
				.resizable()
				.aspectRatio(1, contentMode: .fit)
				.frame(width: 32, height: 32)
				.clipShape(Circle())
				.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
			Text(txt)
				.font(.caption)
				.fontWeight(.light)
			
		}
	}
}

// MARK: - extension BerthDetailSheet

extension BerthDetailSheet {
	
	func noteIcon() -> String{
		if let c = berthDetail.notetxt {
			if c.isEmpty {
				return "note.no"
			} else {
				return "note"
			}
		}
		return "note.no"
	}
	
	func removeCargo(at offsets: IndexSet) {
		for index in offsets {
			let language = cargoesForBerth[index]
			CoreData.stack.context.delete(language)
			CoreData.stack.save()
		}
	}
	func imageToShow() -> Image{
		let berthImage : Image = Image("map")
		if let berthMap = self.berthDetail.mapScreenshot {
			let image = UIImage(data: berthMap as Data)
			if let im = image {
				return Image(uiImage: im)
			}
		}
		return berthImage
	}
	
	func isKindOfCase(activityCaseLabel: Int16) -> (MooringSideCase : MooringSideCase,
		TugsBerthinCase : TugsBerthinCase,
		TugsUnberthinCase : TugsUnberthinCase,
		FreshWaterCase : FreshWaterCase,
		BunkerCase : BunkerCase,
		SludgeCase : SludgeCase,
		StoresCase : StoresCase,
		GarbageCase : GarbageCase)
		
	{
		var selectedCaseMooring : MooringSideCase = MooringSideCase.mooringNotSet
		switch activityCaseLabel {
		case 0: selectedCaseMooring = .mooringNotSet
		case 1: selectedCaseMooring = .mooringSTBDSide
		case 2: selectedCaseMooring = .mooringPortSide
		case 3: selectedCaseMooring = .mooringByAft
		case 4: selectedCaseMooring = .mooringAtBuoy
		default: break
		}
		var selectedCaseTugsBert : TugsBerthinCase = TugsBerthinCase.tugForBerthingNotSet
		switch activityCaseLabel {
		case 0: selectedCaseTugsBert = .tugForBerthingNotSet
		case 1: selectedCaseTugsBert = .tugCompulsoryForBerthing
		case 2: selectedCaseTugsBert = .tugAsPerMasterForBerthing
			
		default: break
		}
		var selectedCaseTugsUnb : TugsUnberthinCase = TugsUnberthinCase.tugForBerthingNotSet
		switch activityCaseLabel {
		case 0: selectedCaseTugsUnb = .tugForBerthingNotSet
		case 1: selectedCaseTugsUnb = .tugCompulsoryForUnberthing
		case 2: selectedCaseTugsUnb = .tugAsPerMasterForUnberthing
		default: break
		}
		var selectedCaseFW : FreshWaterCase = FreshWaterCase.freshWaterNotSet
		switch activityCaseLabel {
		case 0: selectedCaseFW = .freshWaterNotSet
		case 1: selectedCaseFW = .freshWaterByShore
		case 2: selectedCaseFW = .freshWaterByBarge
			
		default: break
		}
		var selectedCaseBunker : BunkerCase = BunkerCase.bunkerNotSet
		switch activityCaseLabel {
		case 0: selectedCaseBunker = .bunkerNotSet
		case 1: selectedCaseBunker = .bunkerByShore
		case 2: selectedCaseBunker = .bunkerByBarge
			
		default: break
		}
		
		var selectedCaseSludge : SludgeCase = SludgeCase.sludgeNotSet
		switch activityCaseLabel {
		case 0: selectedCaseSludge = .sludgeNotSet
		case 1: selectedCaseSludge = .sludgeByShore
		case 2: selectedCaseSludge = .sludgeByBarge
			
		default: break
		}
		var selectedCaseStores : StoresCase = StoresCase.storeNotSet
		switch activityCaseLabel {
		case 0: selectedCaseStores = .storeNotSet
		case 1: selectedCaseStores = .storesByShore
		case 2: selectedCaseStores = .storesByBarge
			
		default: break
		}
		var selectedCaseGarbage : GarbageCase = GarbageCase.garbageNotSet
		switch activityCaseLabel {
		case 0: selectedCaseGarbage = .garbageNotSet
		case 1: selectedCaseGarbage = .garbageByShore
		case 2: selectedCaseGarbage = .garbageByBarge
			
		default: break
		}
		
		return (MooringSideCase : selectedCaseMooring,
				TugsBerthinCase : selectedCaseTugsBert,
				TugsUnberthinCase : selectedCaseTugsUnb,
				FreshWaterCase : selectedCaseFW,
				BunkerCase : selectedCaseBunker,
				SludgeCase : selectedCaseSludge,
				StoresCase : selectedCaseStores,
				GarbageCase : selectedCaseGarbage )
	}
	
	
}

// MARK: - CargoCell

struct CargoCell: View {
	
	
	
	@ObservedObject var cargo : CargoesForBerth = CargoesForBerth()
	func noteIcon() -> String{
		if let c = cargo.cargoNote {
			if c.isEmpty {
				return "note.no"
			} else {
				return "note"
			}
		}
		return "note.no"
	}
	
	
	var body: some View {
		ZStack {
			VStack {
				HStack {
					Text(cargo.cargoName ?? "").font(.footnote).foregroundColor(.gray).padding(.horizontal)
					Spacer()
				}
				HStack {
					Group {
						Spacer()
						SmallIconCargo(txt: "Inspection",
									   imageName: isKindOfCaseForCargo(activityCaseLabel: cargo.tankInspection).TankInspectionCase.imageName)
						
						Spacer()
						SmallIconCargo(txt: "Connection",
									   imageName: isKindOfCaseForCargo(activityCaseLabel: cargo.connectionArrangement).ConnectionArrangementCase.imageName)
						
						Spacer()
						SmallIconCargo(txt: "Analyses",
									   imageName: isKindOfCaseForCargo(activityCaseLabel: cargo.analyses).AnalysesCase.imageName )
					}
					Group {
						Spacer()
						
						SmallIconCargo(txt: "Wallwash",
									   imageName: isKindOfCaseForCargo(activityCaseLabel: cargo.wallWash).WallWashCase.imageName)
						Spacer()
						
						SmallIconCargo(txt: "Notes",
									   imageName: noteIcon())
						Spacer()
					}
				}
				
				HStack {
					VStack{Text("Analyses:")
						.foregroundColor(Color.gray)
						.font(.footnote)
						.fontWeight(.light).padding(.horizontal, 8)
						Text(String(format: "%.1f", cargo.analysesTime) + " hrs")
							.foregroundColor(Color.white)
							.font(.footnote)
							.fontWeight(.light).padding(.horizontal, 8)
							.background(RoundedRectangle(cornerRadius: 8).fill(StaticClass.seaPassageColor))}
					Divider()
					VStack{
						Text("Connection size:")
							.foregroundColor(Color.gray)
							.font(.footnote)
							.fontWeight(.light).padding(.horizontal, 8)
						Text(String(format: "%.1f", cargo.connectionSize) + "  \"")
							.foregroundColor(Color.white)
							.font(.footnote)
							.fontWeight(.light).padding(.horizontal, 8)
							.background(RoundedRectangle(cornerRadius: 8).fill(StaticClass.seaPassageColor))}
					Divider()
					VStack{
						Text("Pumping rate:")
							.foregroundColor(Color.gray)
							.font(.footnote)
							.fontWeight(.light).padding(.horizontal, 8)
						Text(String(format: "%.0f", cargo.pumpingRate) + " MT/hrs")
							.foregroundColor(Color.white)
							.font(.footnote)
							.fontWeight(.light).padding(.horizontal, 8)
							.background(RoundedRectangle(cornerRadius: 8).fill(StaticClass.seaPassageColor))}
				}
				
				Divider()
			}
		}
	}
	
	func isKindOfCaseForCargo(activityCaseLabel: Int16) -> (
		TankInspectionCase : TankInspectionCase,
		AnalysesCase : AnalysesCase,
		ConnectionArrangementCase : ConnectionArrangementCase,
		WallWashCase : WallWashCase )
		
	{
		var selectedTankInspectionCase : TankInspectionCase = TankInspectionCase.tankNoSet
		switch activityCaseLabel {
		case 0: selectedTankInspectionCase = .tankNoSet
		case 1: selectedTankInspectionCase = .fromTopLevel
		case 2: selectedTankInspectionCase = .insideTheTanks
		case 3: selectedTankInspectionCase = .insideTheTanksAccurated
		case 4: selectedTankInspectionCase = .fromTopLevelWithCargoRicirculation
		case 5: selectedTankInspectionCase = .insideTheTanksWithCargoRicirculation
		case 6: selectedTankInspectionCase = .fromTopLevel
		default: break
		}
		var selectedAnalysesCase : AnalysesCase = AnalysesCase.noAnalyses
		switch activityCaseLabel {
		case 0: selectedAnalysesCase = .noAnalyses
		case 1: selectedAnalysesCase = .visualAnalyses
		case 2: selectedAnalysesCase = .labAnalyses
			
		default: break
		}
		var selectedConnectionArrangementCase : ConnectionArrangementCase = ConnectionArrangementCase.byArm
		switch activityCaseLabel {
		case 0: selectedConnectionArrangementCase = .byHose
		case 1: selectedConnectionArrangementCase = .byArm
		default: break
		}
		var selectedWallWashCase : WallWashCase = WallWashCase.noWallWash
		switch activityCaseLabel {
		case 0: selectedWallWashCase = .noWallWash
		case 1: selectedWallWashCase = .wallWash
			
		default: break
		}
		
		return (TankInspectionCase : selectedTankInspectionCase,
				AnalysesCase : selectedAnalysesCase,
				ConnectionArrangementCase : selectedConnectionArrangementCase,
				WallWashCase : selectedWallWashCase)
	}
}



struct TextViewBarth: View {
	@Binding var txt : String
	var berthDetail: BerthDetail!
	@Binding var showBerthNote : Bool
	var body: some View {
		VStack {
			Button(action: {
				DataManager.shared.dismissKeyboard()
				self.berthDetail.now = Date()
				self.berthDetail.notetxt = self.txt
				print("self.txt - \(self.txt)")
				CoreData.stack.save()
				withAnimation {
					self.showBerthNote = false
				}
			}) {
				Image(systemName: "xmark.circle")
					.foregroundColor(.black)
					.font(.system(size: 24))
					.padding()
			}
			Text("Notes for berth")
				.font(.footnote)
				.fontWeight(.light)
			TextView(berthDetail: self.$txt, keyType: .default).frame(width: 210, height: 200).padding().overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5)).padding().KeyboardAwarePadding()
		}
		.onAppear(perform: {
			if let n = self.berthDetail.notetxt {
				self.txt = n
			}
		})
			.background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemBackground)))
			.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5)).padding()
	}
}
