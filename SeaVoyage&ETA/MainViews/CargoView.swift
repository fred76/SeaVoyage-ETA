//
//  CargoView.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 19/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI

struct CargoView: View {
	
	var berthDetail : BerthDetail!
	var cargo : CargoesForBerth!
	@Binding var showCargoFlag : Bool
	
	@State var cargoName : String = ""
	
	@State var analysesTime : Double = 0
	@State var connectionSize : Double = 0
	@State var pumpingRate : Double = 0
	
	@State var tankInspection: Int16 = 0
	@State var analysesInt: Int16 = 0
	@State var connectionArrangement: Int16 = 0
	@State var wallWashInt: Int16 = 0
	
	@State var cargoNote : String = ""
	
	var body: some View {
		VStack {
			HStack {
				Button(action: {
					withAnimation {
						self.showCargoFlag = false
					}
				}) {
					Image(systemName: "xmark.circle")
						.foregroundColor(.black)
						.font(.system(size: 24))
						.padding()
				}
				
				Spacer()
				Button(action: {
					withAnimation {
						self.showCargoFlag = false
					}
					DataManager.shared.dismissKeyboard()
					
					if let c = self.cargo {
						c.analysesTime = self.analysesTime
						c.connectionSize = self.connectionSize
						c.pumpingRate = self.pumpingRate
						c.connectionArrangement = self.connectionArrangement
						c.cargoNote = self.cargoNote
						c.analyses = self.analysesInt
						c.wallWash = self.wallWashInt
						c.cargoName = self.cargoName
						c.tankInspection = self.tankInspection  
					} else {
						_ = CargoesForBerth.createBerthFor(
							item: self.berthDetail,
							cargoName: self.cargoName,
							pumpingRate: self.pumpingRate,
							tankInspection: self.tankInspection,
							analyses: self.analysesInt,
							connectionArrangement: self.connectionArrangement,
							connectionSize: self.connectionSize,
							analysesTime: self.analysesTime,
							wallWash: self.wallWashInt,
							noteTxt: self.cargoNote
						)
						
					}
					CoreData.stack.save() 
				}) {
					
					
					Text("Save cargo")
						.foregroundColor(.white).padding(5)
						.background(RoundedRectangle(cornerRadius: 4)
							.fill(Color.gray))
						.overlay(
							RoundedRectangle(cornerRadius: 4)
								.stroke(Color.white, lineWidth: 1) )
						.padding()
				}
			}
			Divider()
			WrappedTextField(text: self.$cargoName, placeHolder: "Name of the cargo", keyType: .default, textAlignment: .left).frame(height : 32).padding()
			Divider()
			ScrollView (showsIndicators: false){
				VStack {
					tanksInspection(tankInspection: self.$tankInspection)
					Analyses(analysesInt: self.$analysesInt, analysesTime: self.$analysesTime)
					WallWash(wallWashInt: self.$wallWashInt )
					Connection(connectionInt: self.$connectionArrangement, pumpingRate: self.$pumpingRate, connectionSize: self.$connectionSize)
					TextViewCargo(txt: self.$cargoNote)
				}
			}
			
		}.background(Color(UIColor.systemBackground)).transition(.move(edge: .bottom))
			.onAppear {
				if let c = self.cargo {
					self.tankInspection = c.tankInspection
					self.analysesTime = c.analysesTime
					self.connectionSize = c.connectionSize
					self.pumpingRate = c.pumpingRate
					self.connectionArrangement = c.connectionArrangement
					self.cargoNote = c.cargoNote ?? ""
					self.analysesInt = c.analyses
					self.wallWashInt = c.wallWash
					self.cargoName = c.cargoName ?? ""
				}
		}
	}
}

struct tanksInspection: View {
	var bgColor : Color = .green
	@State var tankCase : TankInspectionCase = TankInspectionCase.tankNoSet
	@Binding var tankInspection: Int16
	var body: some View {
		VStack {
			Text("Tanks inspection").font(.footnote).foregroundColor(.gray)
			VStack(spacing: 5){
				HStack {
					Button(action: {
						withAnimation
							{self.tankInspection = 0
								self.tankCase = TankInspectionCase.tankNoSet}
					}) {
						Image("tank.noset")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.tankInspection == 0 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
					
					Button(action: {
						withAnimation
							{self.tankInspection = 1
								self.tankCase = TankInspectionCase.fromTopLevel}
					}) {
						Image("tank.insp.top")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.tankInspection == 1 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
						.padding(.horizontal)
					Button(action: {
						withAnimation
							{self.tankInspection = 2
								self.tankCase = TankInspectionCase.insideTheTanks}
					}) {
						Image("tank.insp")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.tankInspection == 2 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
				}.padding(.horizontal)
				HStack{
					Button(action: {
						withAnimation
							{self.tankInspection = 3
								self.tankCase = TankInspectionCase.insideTheTanksAccurated}
					}) {
						Image("tank.insp.+")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.tankInspection == 3 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
					
					Button(action: {
						withAnimation{
							self.tankInspection = 4
							self.tankCase = TankInspectionCase.fromTopLevelWithCargoRicirculation}
					}) {
						Image("fromTopLevelWithCargoRicirculation")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.tankInspection == 4 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
						.padding(.horizontal)
					Button(action: {
						withAnimation {
							self.tankInspection = 5
							self.tankCase = TankInspectionCase.insideTheTanksWithCargoRicirculation
						}
					}) {
						Image("insideTheTanksWithCargoRicirculation")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.tankInspection == 5 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
				}.padding(.horizontal)
				Text(tankCase.text)
					.font(.footnote)
					.fontWeight(.light).padding([.leading, .trailing] )
			}
			
		}
		.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5)).padding()
	}
}

struct Analyses: View {
	var bgColor : Color = .green
	@State var analysesCase : AnalysesCase = AnalysesCase.noAnalyses
	@Binding var analysesInt: Int16
	@Binding var analysesTime : Double
	var body: some View {
		VStack {
			Text("Analyses").font(.footnote).foregroundColor(.gray)
			VStack(spacing: 5){
				HStack {
					Button(action: {
						withAnimation
							{self.analysesInt = 0
								self.analysesCase = AnalysesCase.noAnalyses}
					}) {
						Image("analyses.no")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.analysesInt == 0 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
					
					Button(action: {
						withAnimation
							{self.analysesInt = 1
								self.analysesCase = AnalysesCase.visualAnalyses}
					}) {
						Image("analyses.visual")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.analysesInt == 1 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle()).padding(.horizontal)
					
					Button(action: {
						withAnimation
							{self.analysesInt = 2
								self.analysesCase = AnalysesCase.labAnalyses}
					}) {
						Image("analyses.lab")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.analysesInt == 2 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
				}.padding(.horizontal)
				
				VStack {
					Text(analysesCase.text)
						.font(.footnote)
						.fontWeight(.light)
						.padding(.vertical)
					
					HStack {
						HStack{
							Text("Time for Analyses")
								.font(.footnote)
								.fontWeight(.light)
						}
					}
					
					HStack {
						Text("\(self.analysesTime, specifier: "%.1f") hrs")
							.font(.footnote)
							.fontWeight(.light).padding()
						Stepper("", onIncrement: {
							if self.analysesTime <= 30{
								self.analysesTime += (0.5)
							}
						}, onDecrement: {
							if self.analysesTime >= 0.5 {
								self.analysesTime -= (0.5)
							}
						}).labelsHidden()
					}
				} 
			}
		}
		.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5)).padding()
	}
}

struct WallWash: View {
	var bgColor : Color = .green
	@State var wallWashCase : WallWashCase = WallWashCase.noWallWash
	@Binding var wallWashInt: Int16
	var body: some View {
		VStack {
			Text("Wallwash").font(.footnote).foregroundColor(.gray)
			VStack(spacing: 5){
				HStack {
					Button(action: {
						withAnimation
							{self.wallWashInt = 0
								self.wallWashCase = WallWashCase.wallWash}
					}) {
						Image("wallwash")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.wallWashInt == 0 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
					
					Circle().foregroundColor(Color(UIColor.systemBackground)).frame(width: 65, height: 65).padding(.horizontal)
					
					Button(action: {
						withAnimation
							{self.wallWashInt = 1
								self.wallWashCase = WallWashCase.noWallWash}
					}) {
						Image("wallwash.no")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.wallWashInt == 1 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
					
				}.padding(.horizontal)
				
				Text(wallWashCase.text)
					.font(.footnote)
					.fontWeight(.light)
					.padding(.vertical)
			}
		}
		.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5)).padding()
	}
}

struct Connection: View {
	var bgColor : Color = .green
	@State var connectionArrangementCase : ConnectionArrangementCase = ConnectionArrangementCase.byHose
	@Binding var connectionInt: Int16
	@Binding var pumpingRate : Double
	@Binding var connectionSize : Double
	var body: some View {
		VStack {
			Text("Connection").font(.footnote).foregroundColor(.gray)
			VStack(spacing: 5){
				HStack {
					Button(action: {
						withAnimation
							{self.connectionInt = 0
								self.connectionArrangementCase = ConnectionArrangementCase.byHose}
					}) {
						Image("hose")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.connectionInt == 0 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
					
					Circle().foregroundColor(Color(UIColor.systemBackground)).frame(width: 65, height: 65).padding(.horizontal)
					
					Button(action: {
						withAnimation
							{self.connectionInt = 1
								self.connectionArrangementCase = ConnectionArrangementCase.byArm}
					}) {
						Image("arm")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
							.background(self.connectionInt == 1 ? StaticClass.pltInColor : Color(UIColor.systemBackground))
							.frame(width: 65, height: 65)
							.clipShape(Circle())
							.overlay(Circle().stroke(Color.secondary, lineWidth: 1.5))
					}.buttonStyle(PlainButtonStyle())
					
					
				}.padding(.horizontal)
				
				VStack {
					Text(connectionArrangementCase.text)
						.font(.footnote)
						.fontWeight(.light)
						.padding(.vertical)
					
					HStack {
						HStack{
							Text("Size")
								.font(.footnote)
								.fontWeight(.light)
							Text(" - ")
								.font(.footnote)
								.fontWeight(.light)
							Text("Pumping rate")
								.font(.footnote)
								.fontWeight(.light)
						}
					}
					HStack{
						VStack {
							Text("\(self.connectionSize, specifier: "%.1f") \"")
								.font(.footnote)
								.fontWeight(.light).padding()
							Text("\(self.pumpingRate, specifier: "%.1f") MT/hrs")
								.font(.footnote)
								.fontWeight(.light).padding()
							
						}
						VStack {
							Stepper("", onIncrement: {
								if self.connectionSize <= 30{
									self.connectionSize += (0.5)
								}
							}, onDecrement: {
								if self.connectionSize >= 0.5 {
									self.connectionSize -= (0.5)
								}
							}).labelsHidden()
							Stepper("", onIncrement: {
								if self.pumpingRate <= 30000{
									self.pumpingRate += (10)
								}
							}, onDecrement: {
								if self.pumpingRate >= 10 {
									self.pumpingRate -= (10)
								}
							}).labelsHidden()
						} 
					}
				}
			}
		}
		.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5)).padding()
	}
}

struct TextViewCargo: View {
	@Binding var txt : String
	var body: some View {
		VStack {
			Text("Notes for cargo")
				.font(.footnote)
				.fontWeight(.light)
			TextView(berthDetail: self.$txt, keyType: .default).frame(width: 210, height: 200).padding().overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5)).padding().KeyboardAwarePadding()
		}
		.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5)).padding()
	}
}
