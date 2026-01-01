//
//  SplashViewController.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0 // Start invisible for fade-in animation
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
    }
    
    private func setupUI() {
        view.backgroundColor = .white // Change to match your brand color if needed
        
        // Set the logo image
        logoImageView.image = UIImage(named: "NBN-Logo")
        
        view.addSubview(logoImageView)
        
        // Center the logo with appropriate size
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func animateLogo() {
        // Slide in from left with fade
        logoImageView.transform = CGAffineTransform(translationX: -view.bounds.width * 0.3, y: 0)
        
        UIView.animate(withDuration: 0.8,
                       delay: 0.2,
                       options: .curveEaseOut) {
            self.logoImageView.alpha = 1.0
            self.logoImageView.transform = .identity
        } completion: { _ in
            // Wait a bit before transitioning to main app
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.transitionToMainApp()
            }
        }
        
        // Alternative options (uncomment to try):
        
        // Option 2: Slide in from right
//        logoImageView.transform = CGAffineTransform(translationX: view.bounds.width * 0.3, y: 0)
//
//        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseOut) {
//            self.logoImageView.alpha = 1.0
//            self.logoImageView.transform = .identity
//        } completion: { _ in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.transitionToMainApp()
//            }
//        }
        
        // Option 3: Simple fade only (no slide)
//        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseIn) {
//            self.logoImageView.alpha = 1.0
//        } completion: { _ in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.transitionToMainApp()
//            }
//        }
    }
    
    private func transitionToMainApp() {
        // Get the window
        guard let window = view.window else { return }
        
        // Get your main view controller (adjust this to match your app)
        // Option A: If using Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateInitialViewController()
        
        // Option B: If using SwiftUI
        // import SwiftUI
        // let mainViewController = UIHostingController(rootView: ContentView())
        
        // Option C: If you have a specific view controller
        // let mainViewController = YourMainViewController()
        
        // Animate the transition
        UIView.transition(with: window,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
            window.rootViewController = mainViewController
        })
    }
}
