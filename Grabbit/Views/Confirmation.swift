import SwiftUI

struct Confirmation: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cart: CartModel
    @EnvironmentObject var storeModel: StoreModel

    var body: some View {
        VStack(spacing: 30) {
            Text("🎉 Payment Completed!")
                .font(.largeTitle)
                .bold()

            Text("Thank you for using Grabbit.")
                .font(.title3)
                .foregroundColor(.gray)

            Button(action: {
                cart.clear()              
                storeModel.selectedStore = nil
                dismiss()
            }) {
                Text("Return Home")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
