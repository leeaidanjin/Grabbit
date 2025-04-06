//
//  ViewRouter.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/5/25.
//

import Foundation

class ViewRouter: ObservableObject {
    @Published var currentScreen: Screen = .map

    enum Screen: Equatable {
        case map
        case home(id: UUID = UUID())
        case confirmation
    }
}
