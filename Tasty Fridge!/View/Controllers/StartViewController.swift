//
//  StartViewController.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {
    private let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "openFridgeDoorSegue", sender: self)
            self.playSound()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationViewController = segue.destination as? UINavigationController else { return }
        navigationViewController.transitioningDelegate = transitionManager
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "refrigerator_door_open", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.play()
            }
            catch let error {
                print(error)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

