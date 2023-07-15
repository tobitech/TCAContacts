import ComposableArchitecture
import SwiftUI

struct ContentView: View {
	let store: StoreOf<ContactsFeature>

	var body: some View {
		NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
			WithViewStore(self.store, observe: \.contacts) { viewStore in
				List {
					ForEach(viewStore.state) { contact in
						NavigationLink(state: ContactDetailFeature.State(contact: contact)) {
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
						.buttonStyle(.borderless)
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
		} destination: { store in
			ContactDetailView(store: store)
		}
//		.sheet(
//			store: self.store.scope(state: \.$destination, action: { .destination($0) }),
//			state: /ContactsFeature.Destination.State.addContact,
//			action: ContactsFeature.Destination.Action.addContact,
//			content: { addContactStore in
//				NavigationStack {
//					AddContactView(store: addContactStore)
//				}
//			}
//		)
		.navigationDestination(
			store: self.store.scope(state: \.$destination, action: { .destination($0) }),
			state: /ContactsFeature.Destination.State.addContact,
			action: ContactsFeature.Destination.Action.addContact,
			destination: { addContactStore in
				AddContactView(store: addContactStore)
			}
		)
		.alert(
			store: self.store.scope(state: \.$destination, action: { .destination($0) }),
			state: /ContactsFeature.Destination.State.alert,
			action: ContactsFeature.Destination.Action.alert
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
