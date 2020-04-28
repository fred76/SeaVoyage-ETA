//
//  SettingsView.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 22/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
	
	@FetchRequest(entity: SettingsData.entity(), sortDescriptors: [NSSortDescriptor(key: "now", ascending: true)])
	var settingsData: FetchedResults<SettingsData>
	
	@State var vslName : String = ""
	@State var vslLength : String = ""
	@State var vslBeam : String = ""
	@State var vslEmail : String = ""
	@State var vslType = 0
	var vslTypeList = [
		"Passenger Ship",
		"Bulk Carriers",
		"Container Vessels",
		"High-speed craft",
		"Ro-Ro Vessels",
		"Tanker",
		"Livestock Carriers",
		"Heavy-lift/Project Cargo Vessels",
		"Tugs",
		"Barge",
		"Yacht"]
	
	@State var isBunkerDetails = true
	
	let activityViewController = WrappedUIActivityViewController()
	
	@State var result: Result<MFMailComposeResult, Error>? = nil
	@State var isShowingMailView = false
	@State var isShowingAlertMail = false
	
	var isMac : Bool {
		#if targetEnvironment(macCatalyst)
		return true
		#else
		return false
		#endif
	}
	
	var body: some View {
		
		NavigationView {
			Form {
				Section(header: Text("Vessel Details")) {
					HStack {
						Text("Vessel Name")
						Spacer()
						WrappedTextField(text: self.$vslName,
										 placeHolder: "",
										 keyType: .default,
										 textAlignment: .right)
							
							.frame(width: 200)
					}
					HStack {
						Text("Length overall")
						Spacer()
						WrappedTextField(text: self.$vslLength,
										 placeHolder: "",
										 keyType: .decimalPad,
										 textAlignment: .right)
							
							.frame(width: 200)
					}
					HStack {
						Text("Beam")
						Spacer()
						WrappedTextField(text: self.$vslBeam,
										 placeHolder: "",
										 keyType: .decimalPad,
										 textAlignment: .right)
							
							.frame(width: 200)
					}
					HStack {
						Text("E-mail")
						Spacer()
						WrappedTextField(text: self.$vslEmail,
										 placeHolder: "",
										 keyType: .emailAddress,
										 textAlignment: .right)
							
							.frame(width: 200)
					}
					Picker(selection: $vslType, label: Text("Vessel type")) {
						ForEach(0 ..< vslTypeList.count) { index in
							Text(self.vslTypeList[index]).tag(index)
						}
					}
				}
				Section(header: Text("Export Option")) {
					HStack {
						Text("Export PDF")
						Spacer()
						Button(action: {
							
							if self.isMac {
								self.activityViewController.sharePDFforOSX(dataPDF: self.dataAsPDF())
							} else {
								self.activityViewController.sharePDFforIOS(dataPDF: self.dataAsPDF())
							}
						}) {
							ZStack {
								HStack {
									Spacer()
									Image(systemName: "square.and.arrow.up").font(.system(size: 24))
								}
								activityViewController
							}
						}
					}
					HStack {
						Text("Export CSV")
						Spacer()
						Button(action: {
							if self.isMac {
								self.activityViewController.shareCSVforOSX(dataCSV: self.dataAsCSV())
							} else {
								self.activityViewController.shareCSVforIOS(dataCSV: self.dataAsCSV())
							}
						}) {
							ZStack {
								HStack {
									Spacer()
									Image(systemName: "square.and.arrow.up").font(.system(size: 24))
								}
								activityViewController
							}
						}
					}
					Toggle(isOn: $isBunkerDetails) {
						Text("Include bunker report")
					}
				}
				Section(header: Text("About MyPortETA")) {
					HStack {
						Text("Rate MyPortETA")
						Spacer()
						Button(action: {
							self.writeReview()
						}) {
							Image(systemName: "heart").font(.system(size: 24))
						}
					}
					HStack {
						Text("Share")
						Spacer()
						Button(action: {
							self.activityViewController.shareApp(isMac: self.isMac)
						}) {
							ZStack {
								HStack {
									Spacer()
									Image("share").resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: 24, height: 24)
										.clipShape(Circle())
										.overlay(Circle() .stroke(Color.gray, lineWidth: 1) )
								}
								activityViewController
							}
							
						}
						
					}
					HStack {
						Text("Contact Us")
						Spacer()
						Button(action: {
							if MFMailComposeViewController.canSendMail() {
								
								self.isShowingMailView = true
							} else {
								self.isShowingAlertMail = true
							}
						}) {
							Image(systemName: "square.and.pencil").font(.system(size: 24))
						}
						.sheet(isPresented: $isShowingMailView) {
							WrappedMailView(isShowing: self.$isShowingMailView, result: self.$result)
						}
						.alert(isPresented: $isShowingAlertMail) {
							Alert(title: Text("Warning!"),
								  message: Text("No Email Access..."),
								  dismissButton: Alert.Button.default(Text("OK")))
						}
					}
				}
			}
			.onTapGesture {
				DataManager.shared.dismissKeyboard()
			}
			.onAppear(perform: {
				if self.settingsData.count > 0 {
					if let s = self.settingsData.last {
						self.vslName =  s.vslName ?? "No set"
						self.vslLength =  s.vslLength ?? "No set"
						self.vslBeam =  s.vslBeam ?? "No set"
						self.vslEmail =  s.vslEmail ?? "No set"
						self.vslType =  Int(s.vslType )
					}
				}
				
				DataManager.shared.activitiesClass = []
			})
				.onDisappear(perform: {
					if self.settingsData.count > 0 {
						if let s = self.settingsData.last {
							s.vslName = self.vslName
							s.vslLength = self.vslLength
							s.vslBeam = self.vslBeam
							s.vslEmail = self.vslEmail
							s.vslType = Int16(self.vslType)
							s.now = Date()
						}
					} else  {
						SettingsData.createSettingsData(
							vslName: self.vslName,
							vslLength: self.vslLength,
							vslBeam: self.vslBeam,
							vslEmail: self.vslEmail,
							vslType: self.vslType)
					}
					DataManager.shared.dismissKeyboard()
					CoreData.stack.save()
				})
				.listStyle(GroupedListStyle())
				.navigationBarTitle(Text("Settings"), displayMode: .inline)
			
			
		}
	}
}

struct SettingView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}

import UIKit

extension SettingsView {
	
	func textWidth(text: String, font: UIFont?) -> CGFloat {
		let attributes = font != nil ? [NSAttributedString.Key.font: font!] : [:]
		return text.size(withAttributes: attributes).width
	}
	
	func textHeight(text: String, font: UIFont?) -> CGFloat {
		let attributes = font != nil ? [NSAttributedString.Key.font: font!] : [:]
		return text.size(withAttributes: attributes).height
	}
	
	func retreiveDataForTable(isCSV : Bool) -> [[String]]{
		
		var arrayOfArry = [[String]]()
		var csvText : [String]!
		if isBunkerDetails {
			if isCSV {
				csvText = ["Port Of:","Activity","Extimated Time","ROB HFO","ROB MGO"]
			} else {
				csvText = ["Port Of:","Activity","Extimated Time","ROB HFO","ROB MGO"]}
		} else {
			if isCSV {
				csvText = ["Port Of:","Activity","Extimated Time"]
			} else {
				csvText = ["Port Of:","Activity","Extimated Time"]
			}
		}
		arrayOfArry.insert(csvText, at: 0)
		for (_,loc) in DataManager.shared.locationWithActivities().enumerated() {
			var array = [String]()
			let nameToPDF : String = loc.berth ?? "Pippo"
			if let evs = loc.activity {
				var fetchedEvents = evs.allObjects as! [Activity]
				fetchedEvents.sort { (first: Activity, second: Activity ) -> Bool in first.eventID < second.eventID }
				for (_, f) in fetchedEvents.enumerated() {
					array = []
					let t = timeForPDF(loc: loc, activity: f)
					let b = bunker(loc: loc, activity: f)
					array.append( nameToPDF)
					array.append( isKindOfCase(activityCaseLabel: Int(f.eventID)).shortText )
					array.append (t.ETA)
					if self.isBunkerDetails {
						array.append(b.HFO)
						array.append(b.MGO)
					}
					arrayOfArry.append(array)
				}
			}
		}
		return arrayOfArry
	}
	
	func dataAsCSV() -> String{ 
		let eventArray = retreiveDataForTable(isCSV: true)
		var csvText : String = String()
		
		for l in eventArray {
			var str = ""
			for (i,s) in l.enumerated()  {
				if i == 0 {
					str = s
				} else {
					str = str + " , " + s
				}
				
			}
			str = str + "\n"
			csvText.append(str)
			
		}
		return csvText
	}
	
	func dataAsPDF() -> Data{
		
		var vslName: String = "VSL no name"
		var vslEmail: String = "VSL no email"
		
		if let v = settingsData.first {
			vslName = v.vslName ?? ""
			vslEmail = v.vslEmail ?? ""
		}
		
		let a4PaperSize = CGSize(width: 595, height: 842)
		let pdf = SimplePDF(pageSize: a4PaperSize)
		let now = Date()
		let eventArray = retreiveDataForTable(isCSV: false)
		var columnSizeGirth = [CGFloat]()
		for t in eventArray[0] {
			let s = textWidth(text: t, font: UIFont.systemFont(ofSize: 10))+5
			
			columnSizeGirth.append(s)
		}
		
		var contentAlignment : [ContentAlignment]!
		
		if self.isBunkerDetails {
			contentAlignment = [.left, .left,.left, .center, .center, .center, .center]
		} else {
			contentAlignment = [.left, .left,.left]
		}
		
		let tableDefGirth = TableDefinition(alignments: contentAlignment,
											columnWidths: columnSizeGirth,
											fonts: [UIFont.systemFont(ofSize: 9),
													UIFont.systemFont(ofSize: 8),
													UIFont.systemFont(ofSize: 8),
													UIFont.systemFont(ofSize: 8),
													UIFont.systemFont(ofSize: 8),
													UIFont.systemFont(ofSize: 8),
													UIFont.systemFont(ofSize: 8)],
											textColors: [UIColor.black])
		pdf.setContentAlignment(.left)
		pdf.addLineSpace(3)
		pdf.addText("Vessel: " + (vslName), font: UIFont.systemFont(ofSize: 8), textColor: .black)
		pdf.addText("E-Mail: " + (vslEmail), font: UIFont.systemFont(ofSize: 8), textColor: .black)
		
		pdf.addLineSpace(3)
		pdf.addLineSeparator()
		pdf.addLineSpace(3)
		pdf.addText("Port rotation calculated on :" + StaticClass.dateFromString(value: now), font: UIFont.systemFont(ofSize: 6), textColor: .black)
		pdf.addLineSpace(3)
		pdf.addTable(
			eventArray.count,
			columnCount: eventArray[0].count ,
			rowHeight: 14,
			tableLineWidth: 1,
			tableDefinition: tableDefGirth,
			dataArray: eventArray)
		
		let heightData = 14 + textHeight(text: "XXXX", font: UIFont.systemFont(ofSize: 8))*3 + CGFloat(eventArray.count*14)
		
		
		pdf.addVerticalSpace(842 - heightData - 100)
		pdf.addLineSeparator()
		pdf.addVerticalSpace(5)
		let i = UIImage(named: "AppIcon")
		pdf.addImage(i!)
		pdf.addHorizontalSpace(30)
		pdf.addVerticalSpace(-10)
		pdf.addText("Rotation and Bunkers ROB calculated with  Sea Voyage & ETA", font: UIFont.systemFont(ofSize: 5), textColor: .black)
		pdf.addText("Contact Us: app.user.info@icloud.com", font: UIFont.systemFont(ofSize: 5), textColor: .black)
		
		return pdf.generatePDFdata()
	}
	
	func vslInitialData() -> (initialDateDouble: Double, initialMGO: String, initialHFO : String) {
		var initialDateDouble: Double = 0
		var initialMGO: String = "0"
		var initialHFO: String = "0"
		if let v = DataManager.shared.fetchVesselInitialSettings()  {
			initialDateDouble = StaticClass.dateFromStringSince1970(v.initialDate ?? "01/01/20 0000")
			initialMGO = v.initialMGO ?? "0"
			initialHFO = v.initialHFO ?? "0"
		}
		return (initialDateDouble: initialDateDouble, initialMGO: initialMGO, initialHFO : initialHFO)
	}
	
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
	
	func timeForPDF(loc : LocationAndEvents, activity : Activity )->(ETA: String, deltaTime : String,vslPercentage : String, cargoMT : String){
		
		var timePerHeaderString : String = ""
		var deltaTime : String = ""
		var vslPercentage : String = ""
		var cargoMT : String = ""
		if Int(loc.locationID) == 0  && loc.activitiesArray.count > 0   {
			let timePerEvents = DataManager.shared.fetchEventsTimePerLocation(fetchedEvents: loc.activitiesArray)
			let timePerEvent = timePerEvents.timePerEvents[0 ..< Int(activity.eventID)+1 ].reduce(0) { $0 + $1 }
			let deltaTimePerEvent =  timePerEvents.timePerEvents[Int(activity.eventID)]
			let timePerEventRounded = (timePerEvent/360).rounded(.down)*360
			let timeDouble = vslInitialData().initialDateDouble + timePerEventRounded
			deltaTime = String(format: "%.f", deltaTimePerEvent/3600)
			vslPercentage = timePerEvents.vslPercentage
			cargoMT = timePerEvents.cargoMT
			timePerHeaderString = StaticClass.dateFromDoubleSince1970(timeDouble)
			return (ETA: timePerHeaderString, deltaTime : deltaTime,vslPercentage : vslPercentage, cargoMT : cargoMT)
			
		} else if Int(loc.locationID) != 0  && loc.activitiesArray.count > 0  {
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
			let DoubleTime = timePerEventRounded + vslInitialData().initialDateDouble + timePerLocRounded
			let deltaTimePerEvent =  timePerEvents.timePerEvents[Int(activity.eventID)]
			deltaTime = String(format: "%.f", deltaTimePerEvent/3600)
			vslPercentage = timePerEvents.vslPercentage
			
			cargoMT = timePerEvents.cargoMT
			timePerHeaderString = StaticClass.dateFromDoubleSince1970(DoubleTime)
			return (ETA: timePerHeaderString, deltaTime : deltaTime,vslPercentage : vslPercentage, cargoMT : cargoMT)
		}
		return (ETA: timePerHeaderString, deltaTime : deltaTime,vslPercentage : vslPercentage, cargoMT : cargoMT)
	}
	
	func bunker(loc : LocationAndEvents, activity : Activity) ->(HFO : String, MGO : String, boilerMultiplier : String, ddggMultiplier : String, mgoPerEvent : String, hfoPerEvent : String, meLabel : String, ddggLabel : String, boilerLabel : String) {
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
	
	
	private func writeReview() {
		var productURL : URL!
		if isMac {
			productURL = URL(string: "macappstore://itunes.apple.com/app/id1510086811")!
		} else {
			productURL = URL(string: "https://itunes.apple.com/app/id1510086811")!
		}
		
		var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
		components?.queryItems = [
			URLQueryItem(name: "action", value: "write-review")
		]
		guard let writeReviewURL = components?.url else {
			return
		}
		UIApplication.shared.open(writeReviewURL)
	}
	
}

import UIKit

class ActivityViewController : UIViewController {
	
	var dataPDF:Data!
	var dataCSV:String!
	let fileNamePDF = "Port Rotation.pdf"
	let fileNameCSV = "Port Rotation.csv"
	
	#if os(iOS) || os(macOS)
	var isPad : Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}
	#endif
	
	@objc func shareApp(isMac : Bool) {
		var productURL : URL!
		if isMac {
			productURL = URL(string: "macappstore://itunes.apple.com/app/id1510086811")!
		} else {
			productURL = URL(string: "https://itunes.apple.com/app/id1510086811")!
		}
		let activityViewController = UIActivityViewController(
			activityItems: [productURL!],
			applicationActivities: nil)
		
		present(activityViewController, animated: true, completion: nil)
	}
	
	@objc func sharePDFforIOS() {
		let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileNamePDF)
		
		do {
			try dataPDF.write(to: path!, options: .atomic)
			let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
			vc.excludedActivityTypes =  [
				UIActivity.ActivityType.postToWeibo,
				UIActivity.ActivityType.assignToContact,
				UIActivity.ActivityType.addToReadingList,
				UIActivity.ActivityType.postToVimeo,
				UIActivity.ActivityType.postToTencentWeibo
			]
			present(vc, animated: true, completion: nil)
			if isPad {
				vc.popoverPresentationController?.sourceView = self.view
			}
			vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
				if completed == true {
					//	FileManager.default.clearTmpDirectory()
				}
			}
		} catch {
			print("Failed to create file")
			print("\(error)")
		}
	}
	
	@objc func shareCSVforIOS() {
		let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileNameCSV)
		
		do {
			try dataCSV.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
			let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
			vc.excludedActivityTypes =  [
				UIActivity.ActivityType.postToWeibo,
				UIActivity.ActivityType.assignToContact,
				UIActivity.ActivityType.addToReadingList,
				UIActivity.ActivityType.postToVimeo,
				UIActivity.ActivityType.postToTencentWeibo
			]
			present(vc, animated: true, completion: nil)
			if isPad {
				vc.popoverPresentationController?.sourceView = self.view
			}
			vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
				if completed == true {
					//	FileManager.default.clearTmpDirectory()
				}
			}
		} catch {
			print("Failed to create file")
			print("\(error)")
		}
	}
	
	func sharePDFforOSX() {
		guard let exportURL = FileManager.default
			.urls(for: .documentDirectory, in: .userDomainMask)
			.first?.appendingPathComponent(fileNamePDF) else { return }
		do {
			try dataPDF.write(to: exportURL)
			let controller = UIDocumentPickerViewController(url: exportURL, in: UIDocumentPickerMode.exportToService)
			present(controller, animated: true) {
				//  try? FileManager.default.removeItem(at: exportURL)
			}
		} catch {
			print("Failed to create file")
			print("\(error)")
		}
	}
	
	func shareCSVforOSX() {
		guard let exportURL = FileManager.default
			.urls(for: .documentDirectory, in: .userDomainMask)
			.first?.appendingPathComponent(fileNameCSV) else { return }
		do {
			try dataCSV.write(to: exportURL, atomically: true, encoding: String.Encoding.utf8)
			let controller = UIDocumentPickerViewController(url: exportURL, in: UIDocumentPickerMode.exportToService)
			present(controller, animated: true) {
				//  try? FileManager.default.removeItem(at: exportURL)
			}
		} catch {
			print("Failed to create file")
			print("\(error)")
		}
	}
}

