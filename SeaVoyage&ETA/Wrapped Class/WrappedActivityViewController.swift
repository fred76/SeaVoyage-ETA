//
//  WrappedActivityViewController.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 24/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import UIKit
import SwiftUI

struct WrappedUIActivityViewController : UIViewControllerRepresentable {
	
	let activityViewController = ActivityViewController()
	
	func makeUIViewController(context: Context) -> ActivityViewController {
		activityViewController
	}
	func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {
		//
	}
	func sharePDFforIOS(dataPDF: Data) {
		activityViewController.dataPDF = dataPDF
		activityViewController.sharePDFforIOS()
	}
	
	func sharePDFforOSX(dataPDF: Data) {
		activityViewController.dataPDF = dataPDF
		activityViewController.sharePDFforOSX()
	}
	
	func shareCSVforIOS(dataCSV: String) {
		activityViewController.dataCSV = dataCSV
		activityViewController.shareCSVforIOS()
	}
	
	func shareCSVforOSX(dataCSV: String) {
		activityViewController.dataCSV = dataCSV
		activityViewController.shareCSVforOSX()
	}
	
	func shareApp(isMac: Bool) {
		activityViewController.shareApp(isMac: isMac)
	}
}

