import ComposableArchitecture
import SwiftUI

@Reducer
struct AddContactFeature {
	@ObservableState
	struct State: Equatable {
		var contact: Contact
	}
	enum Action: Equatable {
		case cancelButtonTapped
		case delegate(Delegate)
		case saveButtonTapped
		case setName(String)
		
		enum Delegate: Equatable {
			case saveContact(Contact)
		}
	}
	
	@Dependency(\.dismiss) var dismiss
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .cancelButtonTapped:
				return .run { _ in await self.dismiss() }
				
			case .delegate:
				return .none
				
			case .saveButtonTapped:
				return .run { [contact = state.contact] send in
					await send(.delegate(.saveContact(contact)))
					await self.dismiss()
				}
				
			case let .setName(name):
				state.contact.name = name
				return .none
			}
		}
	}
}

struct AddContactView: View {
	@Perception.Bindable var store: StoreOf<AddContactFeature>

	var body: some View {
		WithPerceptionTracking {
			Form {
				// We can use the dynamic member lookup on $store to describe what piece of state you want to drive the binding, and then you can use the sending method to describe which action you want to send when the binding is written to.
				TextField("Name", text: $store.contact.name.sending(\.setName))
				Button("Save") {
					store.send(.saveButtonTapped)
				}
			}
			.toolbar {
				ToolbarItem {
					Button("Cancel") {
						store.send(.cancelButtonTapped)
					}
				}
			}
		}
	}
}

struct AddContactPreviews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			AddContactView(
				store: Store(
					initialState: AddContactFeature.State(
						contact: Contact(
							id: UUID(),
							name: "Blob"
						)
					),
					reducer: { AddContactFeature() }
				)
			)
		}
	}
}
