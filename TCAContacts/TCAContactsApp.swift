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
		return .init(initialState: .init(), reducer: ContactsFeature())
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView(store: TCAContactsApp.store)
		}
	}
}
