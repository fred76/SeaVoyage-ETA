//
//  WrappedGeneralChart.swift
//  MyPortETA
//
//  Created by Alberto Lunardini on 30/03/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI
import MapKit
struct MapViewGeneralChart: UIViewRepresentable {
	@Binding var centerCoordinate: CLLocationCoordinate2D
	//var annotations: [MKPointAnnotation]
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		return mapView
	}
	
	func updateUIView(_ view: MKMapView, context: Context) {
		let pin = DataManager.shared.annotationArray()
		
		if pin.count != view.annotations.count {
			view.removeAnnotations(view.annotations)
			view.addAnnotations(pin)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, MKMapViewDelegate {
		var parent: MapViewGeneralChart
		
		init(_ parent: MapViewGeneralChart) {
			self.parent = parent
		}
		
		func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
			parent.centerCoordinate = mapView.centerCoordinate
		}
	}
}

extension MKPointAnnotation {
	static var example: MKPointAnnotation {
		let annotation = MKPointAnnotation()
		annotation.title = "London"
		annotation.subtitle = "Home to the 2012 Summer Olympics."
		annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
		return annotation
	}
}

struct GeneralChart: View {
	@State private var centerCoordinate = CLLocationCoordinate2D()
	@Binding var showMap : Bool 
	var body: some View {
		ZStack {
			MapViewGeneralChart(centerCoordinate: $centerCoordinate)
				.edgesIgnoringSafeArea(.all)
			VStack {
				Spacer()
				HStack{
					Spacer()
					Button(action: {
						withAnimation {
							self.showMap.toggle()
						}
					}) {
						Image(systemName: "xmark")
							.font(.system(size: 24))
							.foregroundColor(.white).padding()
							.frame(width:44, height: 44 )
							.background(Color.black.opacity(0.5))
							.clipShape(Circle())
							.padding()
					}
				}
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 8))
		.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.5))
		.transition(.move(edge: .top))
		.padding()
	}
}

