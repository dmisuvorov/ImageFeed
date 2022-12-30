//
//  VerticalGradientView.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 29.12.2022.
//

import UIKit

@IBDesignable class VerticalGradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var finishColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    private func updateView() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        layer.colors = [startColor, finishColor].map { $0.cgColor }
        
    }
}
