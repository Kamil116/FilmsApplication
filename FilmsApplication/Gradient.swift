//
//  Gradient.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 04.08.2023.
//

import UIKit

class Gradient {

    let gradient = CAGradientLayer()

    init(colors: [UIColor]) {
        gradient.colors = colors
    }
    
    func setGgradient() -> CAGradientLayer {
        return gradient
    }
}

