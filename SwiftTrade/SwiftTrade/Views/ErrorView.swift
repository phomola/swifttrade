//
//  ErrorView.swift
//  SwiftTrade
//
//  Created by Petr Homola on 02/11/2025.
//

import SwiftUI

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String
    
    init(id: UUID = UUID(), error: Error, guidance: String) {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
}

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("an_error_has_occurred")
                    .font(.title)
                    .padding(.bottom)
                Text(errorWrapper.error.localizedDescription)
                    .font(.headline)
                Text(errorWrapper.guidance)
                    //.font(.caption)
                    .padding(.top)
                Spacer()
            }
            .padding()
            //.background(.ultraThinMaterial)
            .cornerRadius(16)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private enum SampleError: Error {
    case errorRequired
}

#Preview {
    ErrorView(errorWrapper: ErrorWrapper(error: SampleError.errorRequired, guidance: "You can safely ignore this error."))
}
