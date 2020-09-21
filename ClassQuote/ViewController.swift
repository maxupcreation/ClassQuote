//
//  ViewController.swift
//  ClassQuote
//
//  Created by Maxime on 04/09/2020.
//  Copyright © 2020 Maxime. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var newQuoteButton: UIButton!
    
    var quoteService = QuoteService()
    
    
    @IBAction func quoteActionButton() {
        /* quoteService.getQuote{(success, quote) in
         self.toggleActivityIndicator(shown: false)
         DispatchQueue.main.async {
         if success, let quote = quote {
         self.update(quote: quote)
         } else {
         self.presentAlert()
         }
         }
         } */
        quoteService.getQuote { result in
            switch result {
            case .success(let quote) :
                DispatchQueue.main.async {
                    self.update(quote:quote)
                }
            case .failure(_) :
                self.presentAlert()
                
            }
        }
        
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !shown
            self.newQuoteButton.isHidden = shown
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func update(quote: Quote) {
        quoteLabel.text = quote.text
        authorLabel.text = quote.author
        imageView.image = UIImage(data: quote.imageData)
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The quote download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
}

