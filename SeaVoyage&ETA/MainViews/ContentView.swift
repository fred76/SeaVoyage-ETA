//
//  ContentView.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//, berthSelectedForShifting: self.$berthSelected

import SwiftUI

struct ContentView: View {
	@State private var selection = 0
	var body: some View {
		
		TabView(selection: $selection){
			PilotstationPortBerthView( )
				.tabItem {
					VStack {
						Image(systemName: "mappin.and.ellipse")
						Text("Destination")
					}
			}
			.tag(0)
			
			HStack {
				ResultForETAandBunker( ).environment(\.managedObjectContext, CoreData.stack.context)
				
			}
			.tabItem {
				VStack {
					Image(systemName: "calendar")
					Text("ETA")
				}
			}
			.tag(1)
			
			HStack {
				BerthDetailList()
			}
			.tabItem {
				VStack {
					Image(systemName: "doc.richtext")
					Text("Port Log")
				}
			}
			.tag(2)
			HStack {
				BunkerSetupForm()
			}
			.tabItem {
				VStack {
					Image(systemName: "drop.triangle")
					Text("Fuel")
				}
			}
			.tag(3)
			
			HStack {
				SettingsView()
			}
			.tabItem {
				VStack {
					Image(systemName: "gear")
					Text("Settings")
				}
			}
			.tag(4)
			
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, CoreData.stack.context)
	}
}
