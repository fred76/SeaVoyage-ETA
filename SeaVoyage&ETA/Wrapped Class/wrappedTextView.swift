//
//  wrappedTextView.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 14/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
	@Binding var berthDetail: String
	var keyType: UIKeyboardType
	func makeUIView(context: Context) -> UITextView {
		let view = UITextView()
		view.delegate = context.coordinator
		view.isScrollEnabled = true
		view.isEditable = true
		view.isUserInteractionEnabled = true
		view.contentInset = UIEdgeInsets(top: 5,
										 left: 10, bottom: 5, right: 5)
		view.keyboardType = keyType
		let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(view.doneButtonTapped(button:)))
		let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		toolBar.setItems([flex,doneButton], animated: false)
		view.inputAccessoryView = toolBar
		
		return view
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		uiView.text = berthDetail
	}
	
	func makeCoordinator() -> TextView.Coordinator {
		Coordinator(self)
	}
	class Coordinator: NSObject, UITextViewDelegate {
		var control: TextView
		
		init(_ control: TextView) {
			self.control = control
		}
		
		func textViewDidChange(_ textView: UITextView) {
			control.berthDetail = textView.text
		}
	}
	
}

extension  UITextView{
	@objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
		self.resignFirstResponder()
		CoreData.stack.save()
	}
	
}

struct WrappedTextViewForNote: View {
	@Binding var berthDetail : String
	var geo : GeometryProxy
	var body: some View {
		VStack {
			TextView(berthDetail: self.$berthDetail, keyType: .default)
				.frame(width:geo.size.width-100 ,height: geo.size.height/3)
				.padding()
				.overlay(RoundedRectangle(cornerRadius: 4)
					.stroke(lineWidth: 0.5) )
			Button(action: {
				CoreData.stack.save()
				//self.berthDetail.note = 1
			}) {
				Text("Save note")
					.foregroundColor(.white).padding(5)
					.background(RoundedRectangle(cornerRadius: 4)
						.fill(Color.gray))
					.overlay(
						RoundedRectangle(cornerRadius: 4)
							.stroke(Color.white, lineWidth: 1) )
			}.padding()
			
			Spacer()
		}
	}
}

