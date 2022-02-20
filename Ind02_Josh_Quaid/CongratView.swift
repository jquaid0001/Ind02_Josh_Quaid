//
//  CongratView.swift
//  Ind02_Josh_Quaid
//
//  Created by Josh Quaid on 2/19/22.
//

import UIKit
import AVKit
import AVFoundation

class CongratView: UIViewController {

    @IBOutlet weak var playAgainButton: UIButton!


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
        let vidPlayer = AVPlayer(url: videoSourceURL)
        let videoLayer = AVPlayerLayer(player: vidPlayer)
        view.layer.addSublayer(videoLayer)
        videoLayer.frame = CGRect(x: 20.0, y: 154.0, width: 374.0, height: 544.0)
        vidPlayer.play()
        
    }
    
   /* override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: - Video Player
        
        guard let videoSourceURL = Bundle.main.url(forResource: "hercVid", withExtension: "MOV")
        else {
            print("Cannot find video file")
            return
        }
        
        // Video player setup and playback
        let vidPlayer = AVPlayer(url: videoSourceURL)
        let videoLayer = AVPlayerLayer(player: vidPlayer)
        view.layer.addSublayer(videoLayer)
        videoLayer.frame = CGRect(x: 20.0, y: 154.0, width: 374.0, height: 544.0)
        vidPlayer.play()
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let buttonPressed = sender as? UIButton {
            buttonText = (buttonPressed.titleLabel?.text)!
            print("button text is now \(buttonText)")
        }
    }
}
