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
    private var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
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
                player = try AVAudioPlayer(contentsOf: url)
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
