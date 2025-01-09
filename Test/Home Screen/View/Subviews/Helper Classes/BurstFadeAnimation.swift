//
//  BurstFadeAnimation.swift
//  Test
//
//  Created by Jatin Gupta on 09/01/25.
//

import SwiftUI

struct BurstFadeAnimation: View {
    @State private var particles: [Particle] = []
    @State private var startAnimation = false

    let particleCount = 30
    let animationDuration: Double = 2.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.startPosition)
                        .scaleEffect(startAnimation ? 1.5 : 0.5)
                        .offset(x: startAnimation ? particle.offsetX : 0,
                                y: startAnimation ? particle.offsetY : 0)
                        .opacity(startAnimation ? 0 : 1)
                        .animation(
                            .easeOut(duration: animationDuration),
                            value: startAnimation
                        )
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        startAnimation = true
                    }
                }
            }
        }
    }

    private func createParticles(in size: CGSize) {
        for _ in 0..<particleCount {
            let particleSize = CGFloat.random(in: 10...25)
            let startX = size.width / 2
            let startY = size.height / 2
            let offsetX = CGFloat.random(in: -150...150)
            let offsetY = CGFloat.random(in: -150...150)
            let color = Color(
                red: Double.random(in: 0.6...1),
                green: Double.random(in: 0.6...1),
                blue: Double.random(in: 0.6...1),
                opacity: 1
            )
            
            let particle = Particle(
                id: UUID(),
                size: particleSize,
                startPosition: CGPoint(x: startX, y: startY),
                offsetX: offsetX,
                offsetY: offsetY,
                color: color
            )
            particles.append(particle)
        }
    }
}

struct Particle: Identifiable {
    let id: UUID
    let size: CGFloat
    let startPosition: CGPoint
    let offsetX: CGFloat
    let offsetY: CGFloat
    let color: Color
}
