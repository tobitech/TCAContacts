import ComposableArchitecture
import SwiftUI

struct ContactDetailFeature: ReducerProtocol {
	struct State: Equatable {
		@PresentationState var alert: AlertState<Action.Alert>?
		let contact: Contact
	}
	
	enum Action: Equatable {
		case alert(PresentationAction<Alert>)
		case delegate(Delegate)
		case deleteButtonTapped
		enum Alert {
			case confirmDeletion
		}
		enum Delegate {
			case confirmDeletion
		}
	}
	
	@Dependency(\.dismiss) var dismiss
	
	var body: some ReducerProtocolOf<Self> {
		Reduce { state, action in
			switch action {
			case .alert(.presented(.confirmDeletion)):
				return .run { send in
					await send(.delegate(.confirmDeletion))
					await self.dismiss()
				}
			case .alert:
				return .none

			case .delegate:
				return .none

			case .deleteButtonTapped:
				state.alert = .confirmDeletion
				return .none
			}
		}
	}
}

extension AlertState where Action == ContactDetailFeature.Action.Alert {
	static let confirmDeletion = Self {
		TextState("Are you sure?")
	} actions: {
		ButtonState(role: .destructive, action: .confirmDeletion) {
			TextState("Delete")
		}
	}
}


struct ContactDetailView: View {
	let store: StoreOf<ContactDetailFeature>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			Form {
				Button("Delete") {
					viewStore.send(.deleteButtonTapped)
				}
			}
			.navigationBarTitle(Text(viewStore.contact.name))
		}
		.alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
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
