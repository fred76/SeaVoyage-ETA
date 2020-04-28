//
//  WrappedTextField.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 06/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation

import SwiftUI

struct WrappedTextField: UIViewRepresentable {
	@Binding var text: String
	var placeHolder: String
	var keyType: UIKeyboardType
	var textAlignment : NSTextAlignment = .right
	func makeUIView(context: Context) -> UITextField {
		let view = UITextField()
		view.delegate = context.coordinator
		view.isUserInteractionEnabled = true
		view.keyboardType = keyType
		view.borderStyle = .roundedRect
		view.textAlignment = textAlignment
		view.clearButtonMode = .always
		view.placeholder = placeHolder 
		let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
		let doneButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .done, target: self, action: #selector(view.doneButtonTappedTXTField(button:)))
		let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		toolBar.setItems([flex,doneButton], animated: false)
		view.inputAccessoryView = toolBar
		
		return view
	}
	
	func updateUIView(_ uiView: UITextField, context: Context) {
		uiView.text = text
	}
	
	func makeCoordinator() -> WrappedTextField.Coordinator {
		Coordinator(self)
	}
	class Coordinator: NSObject, UITextFieldDelegate {
		var control: WrappedTextField
		
		init(_ control: WrappedTextField) {
			self.control = control
		}
		
		func textFieldDidEndEditing(_ textView: UITextField) {
			control.text = textView.text ?? ""
		}
		
	}
}

extension  UITextField{
	
	
	@objc func doneButtonTappedTXTField(button:UIBarButtonItem ) -> Void {
		self.resignFirstResponder()
		
		CoreData.stack.save()
	}
	
}


