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
        
        init() {
            x = 0
            y = 0
        }
    }
    var defaultTileCoords: [TileCoord] = []
    var userTileCoords: [TileCoord] = []
    
    @IBOutlet var tileCollection: [UIImageView]!
    
    @IBOutlet var holeTGR: UITapGestureRecognizer!
    @IBOutlet weak var hole: UIImageView!
    
    // Button outlets
    @IBOutlet weak var solutionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        for i in tileCollection.indices {
            var tileLoc = TileCoord()
            tileLoc.x = tileCollection[i].frame.origin.x
            tileLoc.y = tileCollection[i].frame.origin.y
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
                print ("I am below the hole, good move")
                return true
            } else if originY + 93 == holeY {
                print ("I am above the hole, good move")
                return true
            }
        }
        
        // Tiles are on the same row, check left and right
        if originY == holeY {
            if originX - 93 == holeX {
                print ("I am to the right of the hole, good move")
                return true
            } else if originX + 93 == holeX {
                print ("I am to the left of the hole, good move")
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
            print("button text is \(buttonText)")
            
            if buttonText == "Show Answer" {
                userTileCoords.removeAll()
                for i in tileCollection.indices {
                    var tileLoc = TileCoord()
                    tileLoc.x = tileCollection[i].frame.origin.x
                    tileLoc.y = tileCollection[i].frame.origin.y
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
        
        guard sender.view != nil else { return }
        
        guard let tile = sender.view as? UIImageView else { return }
        
        print ("Tile tag that was tapped is \(sender.view!.tag)")
        
        if sender == holeTGR {
            print("hole was tapped")
        } else {
            print("Tile \(sender.view!.tag) was tapped")
            print("x coord = \(tile.frame.origin.x) and y coord = \(tile.frame.origin.y)")
        }
        
        
        let tileDidMove : Bool = swapTiles(tappedTile: tile)
        
        if tileDidMove {
            print("Tile moved, add some code here for checking solved")
        }
    }
}

