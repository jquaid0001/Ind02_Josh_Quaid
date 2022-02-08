//
//  ViewController.swift
//  imageViewTiles
//
//  Created by Josh Quaid on 2/5/22.
//

import UIKit

class ViewController: UIViewController {

    struct TileCoord{
        var x: CGFloat
        var y: CGFloat
        
        init(x: CGFloat, y: CGFloat) {
            self.x = x
            self.y = y
        }
    }
    var defaultTileCoords: [TileCoord] = []
    var userTileCoords: [TileCoord] = []
    
    @IBOutlet var tileCollection: [UIImageView]!
    
    @IBOutlet var holeTGR: UITapGestureRecognizer!
    @IBOutlet weak var hole: UIImageView!
    
    var holeInitCenter: CGPoint?
    
    
    // Button outlets
    @IBOutlet weak var solutionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        holeInitCenter = hole.center
        
        for i in tileCollection.indices {
            let tileLoc = TileCoord(
                x: tileCollection[i].frame.origin.x,
                y: tileCollection[i].frame.origin.y)
            defaultTileCoords.append(tileLoc)
        }
    }

    // Function for checking if a move is legal (tapped tile is
    // adjacent to the hole)
    func isMoveLegal(tappedTile: UIImageView) -> Bool {
        let originX = tappedTile.frame.origin.x
        let originY = tappedTile.frame.origin.y
        let holeX = hole.frame.origin.x
        let holeY = hole.frame.origin.y

        // Tiles are on the same column, check up and down
        if originX == holeX {
            if originY - 93 == holeY {
                return true
            } else if originY + 93 == holeY {
                return true
            }
        }
        
        // Tiles are on the same row, check left and right
        if originY == holeY {
            if originX - 93 == holeX {
                return true
            } else if originX + 93 == holeX {
                return true
            }
        }
        return false
    }
    
    // Function to swap tiles. Calls isMoveLegal to verify before
    // proceeding
    func swapTiles(tappedTile: UIImageView) -> Bool{
        if isMoveLegal(tappedTile: tappedTile.self) {
            let tappedFrame = tappedTile.self.frame
            tappedTile.self.frame = hole.frame
            hole.frame = tappedFrame
            return true
        }
        return false
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender == solutionButton {
            guard let buttonText = sender.titleLabel?.text else { return }
            
            if buttonText == "Show Answer" {
                userTileCoords.removeAll()
                for i in tileCollection.indices {
                    let tileLoc = TileCoord(
                        x: tileCollection[i].frame.origin.x,
                        y: tileCollection[i].frame.origin.y)
                    userTileCoords.append(tileLoc)
                }
                
                for i in tileCollection.indices {
                    tileCollection[i].frame.origin.x = defaultTileCoords[i].x
                    tileCollection[i].frame.origin.y = defaultTileCoords[i].y
                }
                sender.setTitle("Hide Answer", for: .normal)
            } else {
                for i in tileCollection.indices {
                    tileCollection[i].frame.origin.x = userTileCoords[i].x
                    tileCollection[i].frame.origin.y = userTileCoords[i].y
                }
                sender.setTitle("Show Answer", for: .normal)
            }
        }
    }
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        // Create a tile variable for use in tapHandler to guard against
        // any nil senders
        guard let tile = sender.view as? UIImageView else { return }
        
        // Create a boolean to store the result of the call to swapTiles
        let tileDidMove : Bool = swapTiles(tappedTile: tile)
        
        // If the tile was swapped, check if hole is in solved position,
        // if it isn't there is no need to check for the solution.
        if tileDidMove && hole.center == holeInitCenter {
            print("Hole is in solved position add code to check for solution")
        }
    }
}

