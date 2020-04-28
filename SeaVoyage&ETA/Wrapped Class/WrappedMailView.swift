//
//  WrappedMailView.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 25/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI
import MobileCoreServices
import MessageUI

struct WrappedMailView: UIViewControllerRepresentable {
	
	@Binding var isShowing: Bool
	@Binding var result: Result<MFMailComposeResult, Error>?
	
	class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
		
		@Binding var isShowing: Bool
		@Binding var result: Result<MFMailComposeResult, Error>?
		
		init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
			_isShowing = isShowing
			_result = result
			
		}
		
		func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
			defer {
				isShowing = false
			}
			guard error == nil else {
				self.result = .failure(error!)
				return
			}
			
			self.result = .success(result)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(isShowing: $isShowing, result: $result)
	}
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<WrappedMailView>) -> MFMailComposeViewController {
		let vc = MFMailComposeViewController()
		vc.mailComposeDelegate = context.coordinator
		return vc
	}
	
	func updateUIViewController(_ uiViewController: MFMailComposeViewController,
								context: UIViewControllerRepresentableContext<WrappedMailView>) {
		
		uiViewController.setToRecipients(["app.user.info@icloud.com"])
		uiViewController.setSubject("About Sea Voyage & ETA:")
		uiViewController.setMessageBody("<b>Ask question:</b>", isHTML: true)
		
	}
}
