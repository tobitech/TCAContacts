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
						HStack {
							Text(contact.name)
							Spacer()
							Button {
								viewStore.send(.deleteButtonTapped(id: contact.id))
							} label: {
								Image(systemName: "trash")
									.foregroundStyle(.red)
							}
						}
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
		.sheet(
			store: self.store.scope(
				state: \.$addContact,
				action: { .addContact($0) }
			),
			content: { addContactStore in
				NavigationStack {
					AddContactView(store: addContactStore)
				}
			}
		)
		.alert(
			store: self.store.scope(
				state: \.$alert,
				action: { .alert($0) }
			)
		)
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
