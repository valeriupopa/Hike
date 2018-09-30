//
//  ViewController.swift
//  Hike
//
//  Created by Valeriu POPA on 9/30/18.
//  Copyright © 2018 Valeriu Popa. All rights reserved.
//

import UIKit

class HikeViewController: UIViewController {

    @IBOutlet fileprivate weak var altitudeLabel: UILabel!
    @IBOutlet fileprivate weak var climbedAltitudeLabel: UILabel!
    @IBOutlet fileprivate weak var altitudeAccuracy: UILabel!
    
    @objc
    fileprivate let viewModel = HikeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupViewModel()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        
        switch keyPath {
        case #keyPath(viewModel.altitude):
            altitudeLabel.text = viewModel.altitude
        case #keyPath(viewModel.altitudeClimbed):
            climbedAltitudeLabel.text = viewModel.altitudeClimbed
        case #keyPath(viewModel.altitudeAccuracy):
            altitudeAccuracy.text = viewModel.altitudeAccuracy
        case #keyPath(viewModel.errorMessage):
            showError(message: viewModel.errorMessage)
        default: break
        }
    }
}

fileprivate extension HikeViewController {
    func setupViewModel() {
        addObserver(self, forKeyPath: #keyPath(viewModel.altitude), options: [.new], context: nil)
        addObserver(self, forKeyPath: #keyPath(viewModel.altitudeClimbed), options: [.new], context: nil)
        addObserver(self, forKeyPath: #keyPath(viewModel.altitudeAccuracy), options: [.new], context: nil)
        addObserver(self, forKeyPath: #keyPath(viewModel.errorMessage), options: [.new], context: nil)
    }
    
    func showError(message: String?) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}

