//
//  ViewRouter.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/5/25.
//

import Foundation

class ViewRouter: ObservableObject {
    @Published var currentScreen: Screen = .login

    enum Screen: Equatable {
        case login
        case map
        case home(id: UUID = UUID())
        case confirmation
        case cvs
        case traderJoes
        case target
    }
}
