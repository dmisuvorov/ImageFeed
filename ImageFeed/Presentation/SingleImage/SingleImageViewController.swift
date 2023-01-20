//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 16.01.2023.
//

import Foundation
import UIKit

class SingleImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
