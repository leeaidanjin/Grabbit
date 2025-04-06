//
//  PaymentConfig.swift
//  Grabbit
//
//  Created by Aidan Lee on 4/5/25.
//

import Foundation

class PaymentConfig {
    var paymentIntentClientSecret: String?
    static var shared: PaymentConfig = PaymentConfig()
    
    private init() {
        
    }
}
