//
//  AlertView.swift
//  SwiftTrade
//
//  Created by Petr Homola on 25/12/2025.
//

import SwiftUI

struct AlertView: View {
    let error: Error?
    
    var body: some View {
        if let error = error {
            if let error = error as? ServiceError {
                Text(error.message)
            } else {
                Text(error.localizedDescription)
            }
        } else {
            Text("unknown_error")
        }
    }
}

enum ServiceError: Error {
    case other(message: String, statusCode: Int)
    
    var message: String {
        switch self {
        case let .other(message, _): message
        }
    }
}

#Preview {
    AlertView(error: nil)
}
