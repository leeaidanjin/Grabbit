//
//  CheckoutView.swift
//  Grabbit
//
//  Created by Aidan Lee on 4/5/25.
//
import SwiftUI
import Stripe

struct CheckoutView: View {
    
    @EnvironmentObject private var cart: CartModel
    @State private var message: String = ""
    @State private var isSuccess: Bool = false
    @State private var paymentMethodParams: STPPaymentMethodParams?
    let paymentGatewayController = PaymentGatewayController()
        
    private func pay() {
        guard let clientSecret = PaymentConfig.shared.paymentIntentClientSecret else {
            print("❌ Missing client secret")
            return
        }

        guard let paymentMethodParams = paymentMethodParams else {
            print("❌ No payment method entered")
            return
        }

        print("✅ Submitting payment")

        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

        paymentGatewayController.submitPayment(intent: paymentIntentParams) { status, intent, error in
            DispatchQueue.main.async {
                switch status {
                case .failed:
                    message = "Payment failed"
                case .canceled:
                    message = "Payment cancelled"
                case .succeeded:
                    message = "Payment successful!"
                    isSuccess = true
                @unknown default:
                    message = "Unknown status"
                }
            }
        }
    }


    var body: some View {
        VStack {
            List {
                
                ForEach(cart.items) { item in
                    HStack {
                        if let urlString = item.imageURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                case .failure(_):
                                    Color.gray.frame(height: 60)
                                case .empty:
                                    ProgressView().frame(height: 60)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Color.gray.frame(height: 60)
                        }

                        Spacer()
                        Text(formatPrice(item.price) ?? "")
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Total \(formatPrice(cart.total) ?? "")")
                    Spacer()
                }
                
                Section {
                    STPPaymentCardTextField.Representable.init(paymentMethodParams: $paymentMethodParams)
                } header: {
                    Text("Payment Information")
                }
                
                HStack {
                    Spacer()
                    InteractiveButton(action: pay) {
                        Text("Pay")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)


                    Spacer()
                }
                
                Text(message)
                    .font(.headline)
                
                
            }
            
            .navigationTitle("Checkout")
            .navigationDestination(isPresented: $isSuccess) {
                Confirmation()
            }

            
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView().environmentObject(CartModel())
        }
    }
}

struct InteractiveButton<Content: View>: View {
    let action: () -> Void
    let content: () -> Content

    @GestureState private var isPressed = false

    var body: some View {
        content()
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isPressed ? 0.7 : 1.0)
            .animation(.easeOut(duration: 0.2), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
                    .onEnded { _ in
                        action()
                    }
            )
    }
}
