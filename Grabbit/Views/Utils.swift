import Foundation


func formatPrice(_ price: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(value: price))
}
