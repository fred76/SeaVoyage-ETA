//
//  WrappedMapWithCenterPoint.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 16/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI
import MapKit

struct WrappedMapWithCenterPoint: UIViewRepresentable {
	@Binding var centerCoordinate: CLLocationCoordinate2D
	@Binding var mapView: MKMapView
	@Binding var mapStyle : Int
	@Binding var showMapAlert : Bool
	@Binding var locationManager: CLLocationManager!
	var berthDetail: BerthDetail!
	func makeUIView(context: Context) -> MKMapView {
		locationManager.delegate = context.coordinator
		mapView.delegate = context.coordinator
		return mapView
	}
	
	func updateUIView(_ view: MKMapView, context: Context) {
		let pin = DataManager.shared.annotationArray()
		
		switch mapStyle {
		case 0: view.mapType = .standard
		case 1: view.mapType = .hybrid
		case 2: view.mapType = .satellite
		default: break
		}
		
		if pin.count != view.annotations.count {
			view.removeAnnotations(view.annotations)
			view.addAnnotations(pin)
		}
		mapView.showsUserLocation = true
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
		var parent: WrappedMapWithCenterPoint
		
		init(_ parent: WrappedMapWithCenterPoint) {
			self.parent = parent
		}
		
		func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
			parent.centerCoordinate = mapView.centerCoordinate
			
		}
		
		func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
			switch status {
			case .restricted:
				break
			case .denied:
				parent.showMapAlert.toggle()
				return
			case .notDetermined:
				manager.requestWhenInUseAuthorization()
				return
			case .authorizedWhenInUse: manager.startUpdatingLocation()
				return
			case .authorizedAlways:
				manager.allowsBackgroundLocationUpdates = true
				manager.pausesLocationUpdatesAutomatically = false
				return
			@unknown default:
				break
			}
		}
		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
			let location = locations.first!
			var coordinateRegion : MKCoordinateRegion!
			manager.startUpdatingLocation()
			if let p = parent.berthDetail {
				if p.latitude != 0 {
					let demoCenter = CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude)
					coordinateRegion = MKCoordinateRegion(
						center: demoCenter,
						span: MKCoordinateSpan(
							latitudeDelta: p.latitudeDelta,
							longitudeDelta: p.longitudeDelta))
				}else {
					coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
				}
			}
			parent.mapView.setRegion(coordinateRegion, animated: true)
			manager.stopUpdatingLocation()
			parent.locationManager = nil
		}
	}
} 
