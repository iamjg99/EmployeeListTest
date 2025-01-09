//
//  ToastView.swift
//  Test
//
//  Created by Jatin Gupta on 09/01/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let onScrollToBottom: (() -> Void)?
    
    @State private var bounceEffect: CGFloat = 1.0
    
    var body: some View {
        HStack {
            if message.contains("Deleted") {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.title3)
            }
            
            Text(message)
                .font(.headline)
                .foregroundColor(.white)
            
            if let onScrollToBottom = onScrollToBottom {
                Spacer()
                Button(action: onScrollToBottom) {
                    Image(systemName: "arrow.down.circle")
                        .font(.title3)
                        .foregroundColor(.white)
                        .scaleEffect(bounceEffect)
                }
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                    ) {
                        bounceEffect = 1.2
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}
