//
//  BerthDetailList.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 09/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI
import CoreData
struct BerthDetailList: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(entity: Ports.entity(), sortDescriptors: []) var portFetched: FetchedResults<Ports>
	@State var dismissFlag : Bool = false
	
	@State var pltStn : String = ""
	@State var port : String = ""
	@State var berth : String = ""
	
	var body: some View {
		
		VStack{
			fakebar
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
								self.pltStn = berth.port!.pilotStations!.pltName ?? ""
								self.port = berth.port!.portName ?? ""
								self.berth = berth.wrappedBerth
								self.dismissFlag = true
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
			}.sheet(isPresented: self.$dismissFlag) {
				self.SetupBerthDetailSheet()
			}
			.background(Color.secondary)
		}.onAppear {
			DataManager.shared.activitiesClass = []
		}
	}
	var fakebar: some View {
		ZStack {
			// logo
			HStack {
				Spacer()
				Text("Berth details")
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
	
	func SetupBerthDetailSheet( ) -> some View {
		let fetch = NSFetchRequest<BerthDetail>(entityName: "BerthDetail") 
		fetch.predicate = NSPredicate(format: "berth.port.pilotStations.pltName == %@ && berth.port.portName == %@ && berth.berthName == %@", self.pltStn, self.port, self.berth)
		
		do {
			let pltS = try CoreData.stack.context.fetch(fetch) as [BerthDetail]
			let plt = pltS.first
			if let t = plt { 
				return BerthDetailSheet(
					berthDetail: t,
					dismissFlag: self.$dismissFlag ).environment(\.managedObjectContext, self.managedObjectContext)
			}
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		return BerthDetailSheet( 
			berthDetail: BerthDetail(),
			dismissFlag: .constant(true) )
			.environment(\.managedObjectContext, self.managedObjectContext)
	}
}

struct BerthDetailList_Previews: PreviewProvider {
	static var previews: some View {
		BerthDetailList().environment(\.managedObjectContext, CoreData.stack.context)
	}
}
