//
//  ContentView.swift
//  TCAContacts
//
//  Created by Oluwatobi Omotayo on 12/07/2023.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
	let store: StoreOf<ContactsFeature>

	var body: some View {
		NavigationStack {
			WithViewStore(self.store, observe: \.contacts) { viewStore in
				List {
					ForEach(viewStore.state) { contact in
						Text(contact.name)
					}
				}
				.navigationTitle("Contacts")
				.toolbar {
					ToolbarItem {
						Button {
							viewStore.send(.addButtonTapped)
						} label: {
							Image(systemName: "plus")
						}
					}
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(
			store: Store(
				initialState: ContactsFeature.State(
					contacts: [
						Contact(id: UUID(), name: "Blob"),
						Contact(id: UUID(), name: "Blob Jr"),
						Contact(id: UUID(), name: "Blob Sr"),
					]
				),
				reducer: ContactsFeature()
			)
		)
	}
}
