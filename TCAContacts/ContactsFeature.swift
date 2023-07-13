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

extension ContactsFeature {
	struct Destination: ReducerProtocol {
		enum State: Equatable {
			case addContact(AddContactFeature.State)
			case alert(AlertState<ContactsFeature.Action.Alert>)
		}
		
		enum Action: Equatable {
			case addContact(AddContactFeature.Action)
			case alert(ContactsFeature.Action.Alert)
		}
		
		var body: some ReducerProtocolOf<Self> {
			Scope(state: /State.addContact, action: /Action.addContact) {
				AddContactFeature()
			}
		}
	}
}

struct ContactsFeature: ReducerProtocol {
	struct State: Equatable {
		var contacts: IdentifiedArrayOf<Contact> = []
//		@PresentationState var addContact: AddContactFeature.State?
//		@PresentationState var alert: AlertState<Action.Alert>?
		@PresentationState var destination: Destination.State?
		var path = StackState<ContactDetailFeature.State>()
	}
	enum Action: Equatable {
		case addButtonTapped
//		case addContact(PresentationAction<AddContactFeature.Action>)
//		case alert(PresentationAction<Alert>)
		case deleteButtonTapped(id: Contact.ID)
		case destination(PresentationAction<Destination.Action>)
		case path(StackAction<ContactDetailFeature.State, ContactDetailFeature.Action>)
		
		enum Alert: Equatable {
			case confirmDeletion(id: Contact.ID)
		}
	}
	var body: some ReducerProtocolOf<Self> {
		Reduce { state, action in
			switch action {
			case .addButtonTapped:
				state.destination = .addContact(
					AddContactFeature.State(
						contact: Contact(
							id: UUID(),
							name: ""
						)
					)
				)
				return .none
				
//			case .addContact(.presented(.cancelButtonTapped)):
//				state.addContact = nil
//				return .none
				
			case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
				state.contacts.append(contact)
//				state.addContact = nil
				return .none
				
			case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
				state.contacts.remove(id: id)
				return .none
				
			case let .deleteButtonTapped(id: id):
				state.destination = .alert(
					AlertState {
						TextState("Are you sure?")
					} actions: {
						ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
							TextState("Delete")
						}
					}
				)
				return .none

			case .destination:
				return .none
				
			case let .path(.element(id: id, action: .delegate(.confirmDeletion))):
				guard let detailState = state.path[id: id]
				else { return .none }
				state.contacts.remove(id: detailState.contact.id)
				return .none
				
			case .path:
				return .none
			}
		}
		.ifLet(\.$destination, action: /Action.destination) {
			Destination()
		}
		.forEach(\.path, action: /Action.path) {
			ContactDetailFeature()
		}
//		.ifLet(\.$addContact, action: /Action.addContact) {
//			AddContactFeature()
//		}
//		.ifLet(\.$alert, action: /Action.alert)
	}
}
