//
//  BunkerVesselConsuption.swift
//  MyPortETA
//
//  Created by Alberto Lunardini on 21/03/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI

struct BunkerSetupForm: View {
	
	@State var speedCruise: String = ""
	@State var ballastCruise : String = ""
	@State var laddenCruise : String = ""
	@State var Speed80 : String = ""
	@State var ballast80 : String = ""
	@State var ladden80 : String = ""
	@State var speed60 : String = ""
	@State var ballast60 : String = ""
	@State var ladden60 : String = ""
	@State var speed40 : String = ""
	@State var ballast40 : String = ""
	@State var ladden40 : String = ""
	@State var DDGG : String = ""
	@State var minBoiler : String = ""
	@State var maxBoiler : String = ""
	@State var HFOCapacity : String = ""
	@State var MGOCapacity : String = ""
	
	@FetchRequest( entity: BunkerVslDetails.entity(),  sortDescriptors: [NSSortDescriptor(key: "now", ascending: true)])
	var bunkerConsumption: FetchedResults<BunkerVslDetails>
	var body: some View {
		
		VStack{
			fakebar
			Form {
				Section(header: Text("Main Engine Consumption")) {
					GeometryReader { g in
						HStack{
							Text("Speed").font(.footnote)
								.frame(minWidth: g.size.width/3 )
							Divider()
							Text("Consumption").font(.footnote).frame(minWidth: g.size.width/(3/2) )
						}
					}
					GeometryReader { g in
						VStack {
							HStack{
								Text("Cruise Speed").font(.footnote).frame(minWidth: g.size.width/3 )
								Divider()
								Text("Ballast").font(.footnote).frame(minWidth: g.size.width/3 )
								Text("Ladden").font(.footnote).frame(minWidth: g.size.width/3 )
							}
							HStack{
								
								WrappedTextField(text: self.$speedCruise, placeHolder: "Kts", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								Divider()
								
								WrappedTextField(text: self.$ballastCruise, placeHolder: "Tons/day", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								
								WrappedTextField(text: self.$laddenCruise, placeHolder: "Tons/day", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
							}
						}
					}.frame(height: 36).padding()
					GeometryReader { g in
						VStack {
							HStack{
								Text("80% Speed").font(.footnote).frame(minWidth: g.size.width/3 )
								Divider()
								Text("80% Ballast").font(.footnote).frame(minWidth: g.size.width/3 )
								Text("80% Ladden").font(.footnote).frame(minWidth: g.size.width/3 )
							}
							HStack{
								WrappedTextField(text: self.$Speed80, placeHolder: "Kts", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								Divider()
								WrappedTextField(text: self.$ballast80, placeHolder: "Tons/day", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								WrappedTextField(text: self.$ladden80, placeHolder: "Tons/day", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
							}
						}
					}.frame(height: 36).padding()
					GeometryReader { g in
						VStack {
							HStack{
								Text("60% Speed").font(.footnote).frame(minWidth: g.size.width/3 )
								Divider()
								Text("60% Ballast").font(.footnote).frame(minWidth: g.size.width/3 )
								Text("60% Ladden").font(.footnote).frame(minWidth: g.size.width/3 )
							}
							HStack{
								WrappedTextField(text: self.$speed60, placeHolder: "Kts", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								Divider()
								WrappedTextField(text: self.$ballast60, placeHolder: "Tons/day", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								WrappedTextField(text: self.$ladden60, placeHolder: "Tons/day", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								
							}
						}
					}.frame(height: 36).padding()
					GeometryReader { g in
						VStack {
							HStack{
								Text("40% Speed").font(.footnote).frame(minWidth: g.size.width/3 )
								Divider()
								Text("40% Ballast").font(.footnote).frame(minWidth: g.size.width/3 )
								Text("40% Ladden").font(.footnote).frame(minWidth: g.size.width/3 )
							}
							HStack{
								WrappedTextField(text: self.$speed40, placeHolder: "Kts", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								Divider()
								WrappedTextField(text: self.$ballast40, placeHolder: "Tons/day", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								WrappedTextField(text: self.$ladden40, placeHolder: "Tons/day", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
								
							}
						}
					}.frame(height: 36).padding()
					
				}
				Section(header: Text("Auxiliary System Consumption")) {
					HStack{
						Text("DDGG Max consumption").font(.footnote)
						
						WrappedTextField(text: self.$DDGG, placeHolder: "MT", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
						Text("Tons/day").font(.footnote)
						Spacer()
					}
					
					HStack{
						Text("Boiler Min consumption").font(.footnote)
						WrappedTextField(text: self.$minBoiler, placeHolder: "MT", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
						Text("Tons/day").font(.footnote)
					}
					
					HStack{
						Text("Boiler Max consumption").font(.footnote)
						WrappedTextField(text: self.$maxBoiler, placeHolder: "MT", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
						
						Text("Tons/day").font(.footnote)
					} 
				}
				Section(header: Text("Bunker Tanks Capacity")) {
					HStack{
						Text("HFO Tanks").font(.footnote)
						Spacer()
						WrappedTextField(text: self.$HFOCapacity, placeHolder: "MT", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
						
						Spacer()
					}
					HStack{
						Text("MGO Tanks").font(.footnote)
						Spacer()
						WrappedTextField(text: self.$MGOCapacity, placeHolder: "MT", keyType: .decimalPad, textAlignment: .right).frame(height: 32)
						Spacer()
					}
				}
			} 
				
			.listStyle(GroupedListStyle())
		}.gesture(DragGesture().onChanged({ (_) in
			DataManager.shared.dismissKeyboard()
		}))
		 
		.KeyboardAwarePadding()
		.onAppear {
			DataManager.shared.activitiesClass = []
			if let b = self.bunkerConsumption.last {
				self.speedCruise = String(format: "%.f", b.fullSpeed)
				self.ballastCruise = String(format: "%.f", b.fullBallast)
				self.laddenCruise = String(format: "%.f", b.fullLadden)
				self.Speed80 = String(format: "%.f", b.eightySpeed)
				self.ballast80 = String(format: "%.f", b.eightyBallast)
				self.ladden80 = String(format: "%.f", b.eightyLadden)
				self.speed60 = String(format: "%.f", b.sixtySpeed)
				self.ballast60 = String(format: "%.f", b.sixtyBallast)
				self.ladden60 = String(format: "%.f", b.sixtyLadden)
				self.speed40 = String(format: "%.f", b.forthySpeed)
				self.ballast40 = String(format: "%.f", b.forthyBallast)
				self.ladden40 = String(format: "%.f", b.forthyLadden)
				self.DDGG = String(format: "%.f", b.ddggConsuption)
				self.minBoiler = String(format: "%.f", b.boilerConsuptionMin)
				self.maxBoiler = String(format: "%.f", b.boilerConsuptionMax)
				self.HFOCapacity = String(format: "%.f", b.hfoCapacity)
				self.MGOCapacity = String(format: "%.f", b.mgoCapacity)
			}
		}
	}
	var fakebar: some View {
		ZStack {
			// logo
			HStack {
				Spacer()
				Text("Bunker Consumption")
					.font(.headline)
					.foregroundColor(Color.white)
				Spacer()
			}
			// pulsanti
			HStack {
				
				Spacer()
				Button(action: {
					DataManager.shared.dismissKeyboard()
					let b = DataManager.shared.RefreshBunkerConsumption()
					b.fullSpeed = self.speedCruise.doubleValue
					b.fullBallast = self.ballastCruise.doubleValue
					b.fullLadden = self.laddenCruise.doubleValue
					b.eightySpeed = self.Speed80.doubleValue
					b.eightyBallast = self.ballast80.doubleValue
					b.eightyLadden = self.ladden80.doubleValue
					b.sixtySpeed = self.speed60.doubleValue
					b.sixtyBallast = self.ballast60.doubleValue
					b.sixtyLadden = self.ladden60.doubleValue
					b.forthySpeed = self.speed40.doubleValue
					b.forthyBallast = self.ballast40.doubleValue
					b.forthyLadden = self.ladden40.doubleValue
					b.ddggConsuption = self.DDGG.doubleValue
					b.boilerConsuptionMin = self.minBoiler.doubleValue
					b.boilerConsuptionMax = self.maxBoiler.doubleValue
					b.hfoCapacity = self.HFOCapacity.doubleValue
					b.mgoCapacity = self.MGOCapacity.doubleValue
					b.now = Date()
					CoreData.stack.save()
				}) {
					Text("Save")
						.fontWeight(.bold)
						.foregroundColor(.white)
						.padding(.horizontal, 20)
				}
			}
		}
		.frame(height: 44)
		.background(StaticClass.bunkeringColor.padding(.top, -44))
		.edgesIgnoringSafeArea(.horizontal)
		.padding(.bottom, -8)
	}
}

struct BunkerVesselConsuption_Previews: PreviewProvider {
	static var previews: some View { 
		return BunkerSetupForm().environment(\.managedObjectContext, CoreData.stack.context)
	}
}


