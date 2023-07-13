import ComposableArchitecture
import SwiftUI

struct ContactDetailFeature: ReducerProtocol {
	struct State: Equatable {
		let contact: Contact
	}
	
	enum Action: Equatable {
	}
	
	var body: some ReducerProtocolOf<Self> {
		Reduce { state, action in
			switch action {
			}
		}
	}
}


struct ContactDetailView: View {
	let store: StoreOf<ContactDetailFeature>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			Form {
			}
			.navigationBarTitle(Text(viewStore.contact.name))
		}
	}
}

struct ContactDetailPreviews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ContactDetailView(
				store: Store(
					initialState: ContactDetailFeature.State(
						contact: Contact(id: UUID(), name: "Blob")
					)
				) {
					ContactDetailFeature()
				}
			)
		}
	}
}
