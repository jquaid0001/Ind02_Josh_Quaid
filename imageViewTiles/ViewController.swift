//
//  ViewController.swift
//  imageViewTiles
//
//  Created by Josh Quaid on 2/5/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var holeTGR: UITapGestureRecognizer!
    
    @IBOutlet weak var hole: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        
        guard sender.view != nil else { return }
        
        guard let view = sender.view as? UIImageView else { return }
        
        print ("Tile tag that was tapped is \(sender.view!.tag)")
        
        if sender == holeTGR {
            print("hole was tapped")
        } else {
            print("Tile \(sender.view!.tag) was tapped")
            print("x coord = \(view.frame.origin.x) and y coord = \(view.frame.origin.y)")
        }
        
        let originX = view.frame.origin.x
        let originY = view.frame.origin.y
        
        let holeX = hole.frame.origin.x
        let holeY = hole.frame.origin.y
        
        #warning("Move this code to a move func!")
        if originX - 93 == holeX {
            print ("I am to the right of the hole, good move")
            // Swap function starts here
            view.frame.origin.x = holeX
            view.frame.origin.y = holeY
            hole.frame.origin.x = originX
            hole.frame.origin.y = originY
        } else if originX + 93 == holeX {
            print ("I am to the left of the hole, good move")
            // Swap function starts here
            view.frame.origin.x = holeX
            view.frame.origin.y = holeY
            hole.frame.origin.x = originX
            hole.frame.origin.y = originY
        } else if originY - 93 == holeY {
            print ("I am below the hole, good move")
            // Swap function starts here
            view.frame.origin.x = holeX
            view.frame.origin.y = holeY
            hole.frame.origin.x = originX
            hole.frame.origin.y = originY
        } else if originY + 93 == holeY {
            print ("I am above the hole, good move")
            // Swap function starts here
            view.frame.origin.x = holeX
            view.frame.origin.y = holeY
            hole.frame.origin.x = originX
            hole.frame.origin.y = originY
        }
        
        
    }
    
    

}

