//
//  CongratView.swift
//  Ind02_Josh_Quaid
//
//  Created by Josh Quaid on 2/19/22.
//

import UIKit

// Import needed AV for playing a video
import AVKit
import AVFoundation

class CongratView: UIViewController {

    @IBOutlet weak var playAgainButton: UIButton!

    // Setup a var for holding the button label for unwinding
    var buttonText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // MARK: - Video Player
        
        guard let videoSourceURL = Bundle.main.url(forResource: "hercVid", withExtension: "MOV")
        else {
            print("Cannot find video file")
            return
        }
        
        // Video player setup and playback
        // Create an AVPlayer with the URL created previously
        let vidPlayer = AVPlayer(url: videoSourceURL)
        // Create an AVPlayerLayer to display the video
        let videoLayer = AVPlayerLayer(player: vidPlayer)
        // Add the videoLay to the view
        view.layer.addSublayer(videoLayer)
        // Set the videoLayer's frame size and position
        videoLayer.frame = CGRect(x: 20.0, y: 154.0, width: 374.0, height: 544.0)
        
        // Play the video automatically
        vidPlayer.play()
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set buttonText to the label of the pressed button
        if let buttonPressed = sender as? UIButton {
            buttonText = (buttonPressed.titleLabel?.text)!
        }
    }
}
