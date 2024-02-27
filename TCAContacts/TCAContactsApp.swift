//
//  TCAContactsApp.swift
//  TCAContacts
//
//  Created by Oluwatobi Omotayo on 12/07/2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCAContactsApp: App {
	static var store: StoreOf<ContactsFeature> {
		return .init(
			initialState: .init(
				contacts: .init(
					uniqueElements: [
						Contact(id: UUID(), name: "Blob"),
						Contact(id: UUID(), name: "Blob Jr"),
						Contact(id: UUID(), name: "Blob Sr"),
					]
				)
			),
			reducer: { ContactsFeature() }
		)
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView(store: TCAContactsApp.store)
		}
	}
}
