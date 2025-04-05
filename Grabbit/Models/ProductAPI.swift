import Foundation

func fetchProductInfo(for barcode: String, completion: @escaping (Product?) -> Void) {
    let urlString = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(barcode)"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let items = json["items"] as? [[String: Any]],
           let first = items.first {
            let title = first["title"] as? String ?? "Unknown"
            let image = first["images"] as? [String] ?? []
            let product = Product(name: title, barcode: barcode, price: Double.random(in: 1.0...10.0), imageURL: image.first)
            DispatchQueue.main.async { completion(product) }
        } else {
            DispatchQueue.main.async { completion(nil) }
        }
    }.resume()
}
