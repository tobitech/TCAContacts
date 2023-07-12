//
//  ContactsFeature.swift
//  TCAContacts
//
//  Created by Oluwatobi Omotayo on 12/07/2023.
//

import Foundation
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
	let id: UUID
	var name: String
}

struct ContactsFeature: ReducerProtocol {
	struct State: Equatable {
		@PresentationState var addContact: AddContactFeature.State?
		var contacts: IdentifiedArrayOf<Contact> = []
	}
	enum Action: Equatable {
		case addButtonTapped
		case addContact(PresentationAction<AddContactFeature.Action>)
	}
	var body: some ReducerProtocolOf<Self> {
		Reduce { state, action in
			switch action {
			case .addButtonTapped:
				state.addContact = AddContactFeature.State(
					contact: Contact(
						id: UUID(),
						name: ""
					)
				)
				return .none
				
			case .addContact(.presented(.cancelButtonTapped)):
				state.addContact = nil
				return .none
				
			case .addContact(.presented(.saveButtonTapped)):
				guard let contact = state.addContact?.contact else { return .none }
				state.contacts.append(contact)
				state.addContact = nil
				return .none

			case .addContact:
				return .none
			}
		}
		.ifLet(\.$addContact, action: /Action.addContact) {
			AddContactFeature()
		}
	}
}
