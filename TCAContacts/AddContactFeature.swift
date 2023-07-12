import ComposableArchitecture
import SwiftUI

struct AddContactFeature: ReducerProtocol {
	struct State: Equatable {
		var contact: Contact
	}
	enum Action: Equatable {
		case cancelButtonTapped
		case delegate(Delegate)
		case saveButtonTapped
		case setName(String)
		
		enum Delegate: Equatable {
			// case cancel
			case saveContact(Contact)
		}
	}
	
	@Dependency(\.dismiss) var dismiss
	
	func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
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

struct AddContactView: View {
	let store: StoreOf<AddContactFeature>

	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			Form {
				TextField("Name", text: viewStore.binding(get: \.contact.name, send: { .setName($0) }))
				Button("Save") {
					viewStore.send(.saveButtonTapped)
				}
			}
			.toolbar {
				ToolbarItem {
					Button("Cancel") {
						viewStore.send(.cancelButtonTapped)
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
					reducer: AddContactFeature()
				)
			)
		}
	}
}
