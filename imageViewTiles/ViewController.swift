//
//  ViewController.swift
//  imageViewTiles
//
//  Created by Josh Quaid on 2/5/22.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tile00: UIImageView!
    
    @IBOutlet weak var tile01: UIImageView!
    
    @IBOutlet weak var tile05: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        guard let view = sender.view else { return }
        
        if view.tag == 11 {
            print ("blank view was tapped")
            var fromFrame = view.center
            guard let moveToView = tile01 else { return }
            var toFrame = moveToView.center
            
            view.center = toFrame
            moveToView.center = fromFrame
        }
        
        print ("Tile tag that was tapped is \(sender.view!.tag)")
        
        if sender.view!.tag == 11 {
            print("Tile 1,1 was tapped" )
            
        }
    }
    
    

}

