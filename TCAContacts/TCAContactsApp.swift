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
			ContactsView(store: TCAContactsApp.store)
		}
	}
}
