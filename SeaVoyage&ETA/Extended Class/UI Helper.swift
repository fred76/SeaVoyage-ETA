//
//  UI Helper.swift
//  SeaVoyage&ETA
//
//  Created by Alberto Lunardini on 08/04/2020.
//  Copyright © 2020 Alberto Lunardini. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct KeyboardAwareModifier: ViewModifier {
	@State private var keyboardHeight: CGFloat = 0
	
	private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
		Publishers.Merge(
			NotificationCenter.default
				.publisher(for: UIResponder.keyboardWillShowNotification)
				.compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
				.map { $0.cgRectValue.height },
			NotificationCenter.default
				.publisher(for: UIResponder.keyboardWillHideNotification)
				.map { _ in CGFloat(0) }
		).eraseToAnyPublisher()
	}
	
	func body(content: Content) -> some View {
		content
			.padding(.bottom, keyboardHeight)
			.edgesIgnoringSafeArea(keyboardHeight==0 ? [] :.bottom)
			.onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
	}
}

extension View {
	func KeyboardAwarePadding() -> some View {
		ModifiedContent(content: self, modifier: KeyboardAwareModifier())
	}
}

struct MultiPicker: View  {
	
	typealias Label = String
	typealias Entry = String
	
	let data: [ (Label, [Entry]) ]
	@Binding var selection: [Entry]
	
	var body: some View {
		GeometryReader { geometry in
			HStack {
				ForEach(0..<self.data.count) { column in
					Picker(self.data[column].0, selection: self.$selection[column]) {
						ForEach(0..<self.data[column].1.count) { row in
							Text(verbatim: self.data[column].1[row])
								.tag(self.data[column].1[row])
						}
					}
					.pickerStyle(WheelPickerStyle())
					.frame(width: geometry.size.width / CGFloat(self.data.count+3), height: geometry.size.height)
					.clipped()
				}
			}
		}
	}
}

struct FindViewFrameAndAddOverlayShape: View {
	var colorTriangle : Color
	var body: some View {
		GeometryReader { proxy in
			self.ppp(x: proxy.size.width,
					 y: 50)
				.fill(self.colorTriangle)
				.shadow(radius: 2, x: -proxy.size.width+50, y: 3)
				.overlay(
					RoundedRectangle(cornerRadius: 4)
						.stroke(Color.gray, lineWidth: 1)
						.shadow(radius: 3))
			
		}
	}
	func ppp (x: CGFloat, y : CGFloat) -> Path{
		let p = Path { path in
			path.move(to: CGPoint(x: x-y, y: 0))
			path.addArc(tangent1End: CGPoint(x: x, y: 0), tangent2End: CGPoint(x: x, y: 4), radius: 4)
			path.addLine(to: CGPoint(x: x, y: y))
			path.addLine(to: CGPoint(x: x-y, y: 0))
		}
		return p
	}
}

struct FillHeaderBackground: View {
	let color: Color
	var body: some View {
		GeometryReader { proxy in
			self.color.frame(width: proxy.size.width * 1.3,height: proxy.size.height ).fixedSize()
		}
	}
}

struct CollectionView<Content, T, C, S>: View where Content: View {
	var columns: Int
	var items: [T]
	var label: [C]
	var txt: [S]
	let content: (T,C,S) -> Content
	init(columns: Int, items: [T], label: [C], txt: [S], @ViewBuilder content: @escaping (T,C,S) -> Content) {
		self.columns = columns
		self.items = items
		self.label = label
		self.txt = txt
		self.content = content
	}
	var numberRows: Int {
		(items.count - 1) / columns
	}
	func elementFor(row: Int, column: Int) -> Int? {
		let index = row * self.columns + column
		return index < items.count ? index : nil
	}
	private var axes: Axis.Set { return [] }
	var body: some View {
		VStack(spacing:2){
			ForEach(0...self.numberRows, id: \.self) { row in
				HStack (spacing:1){
					ForEach(0..<self.columns, id: \.self) { column in
						Group {
							if self.elementFor(row: row, column: column) != nil {
								self.content(self.items[self.elementFor(row: row, column: column)!],
											 self.label[self.elementFor(row: row, column: column)!],
											 self.txt[self.elementFor(row: row, column: column)!])
								
							} else { Spacer() }
						}
					}
				}
			}
		} .frame(width: 280, height: 150 * CGFloat(self.numberRows+1))
	}
}
