//
//  LoginView.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/6/25.
//
import SwiftUI
import Auth0

struct LoginView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to Grabbit")
                .font(.largeTitle)

            Button("Log In") {
                Auth0
                    .webAuth()
                    .start { result in
                        switch result {
                        case .success(let credentials):
                            print("✅ Logged in: \(credentials)")
                            DispatchQueue.main.async {
                                viewRouter.currentScreen = .map
                            }
                        case .failure(let error):
                            print("❌ Login failed: \(error)")
                        }
                    }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
