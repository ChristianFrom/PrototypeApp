//
//  LottieView.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 15/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    var filename: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimationView()
        //Animation filens navn
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        //Set constraints
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        //Meget kode bare for at lave constraints, i SwiftUI bruger man bare stacks og spacere
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
    
    
    
}
