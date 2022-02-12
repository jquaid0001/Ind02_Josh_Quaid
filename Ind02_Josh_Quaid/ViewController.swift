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
    var defaultTileCoords: [CGRect] = []
    var userTileCoords: [CGRect] = []
    
    @IBOutlet var tileCollection: [UIImageView]!
    @IBOutlet weak var hole: UIImageView!
    
    @IBOutlet var holeTGR: UITapGestureRecognizer!
    
    var holeInitCenter: CGPoint?
    
    
    // Button outlets
    @IBOutlet weak var solutionButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        holeInitCenter = hole.center
        
        for i in tileCollection.indices {
            defaultTileCoords.append(tileCollection[i].frame)
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
            // Set up a temporary variable to hold the tag
            let tappedTag = tappedTile.self.tag
            // Set up a temporary variable to hold the frame
            let tappedFrame = tappedTile.self.frame
            // Set the tapped tile's frame to the hole's frame
            tappedTile.self.frame = hole.frame
            // Set the tapped tile's tag to the hole's tag
            tappedTile.self.tag = hole.tag
            // Set the hole's frame to the tapped frame
            hole.frame = tappedFrame
            // Set the hole's tag to the tapped tag
            hole.tag = tappedTag

            return true
        }
        // The tiles were not swapped due to an illegal move
        return false
    }
    
    // MARK: - Handlers
    
    // Handler for the shuffle and show answer buttons
    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender == solutionButton {
            guard let buttonText = sender.titleLabel?.text else { return }
            
            if buttonText == "Show Answer" {
                // If userTileCoords has an elements from
                // previous button taps, clear them out
                userTileCoords.removeAll()
                
                // Copy current tile frames to userTileCoords
                // for restoration
                for i in tileCollection.indices {
                    userTileCoords.append(tileCollection[i].frame)
                }
  
                // Restore the default state and show the solved
                // puzzle
                for i in tileCollection.indices {
                    tileCollection[i].frame = defaultTileCoords[i]
                }
                
                // Set the button's text to Hide Answer
                sender.setTitle("Hide Answer", for: .normal)
            } else {
                // Restore the userTileCoors array to restore
                // the user state
                for i in tileCollection.indices {
                    tileCollection[i].frame = userTileCoords[i]
                }
                // Set the buton's text to Show Answer
                sender.setTitle("Show Answer", for: .normal)
            }
        }
        
        // If sender is shuffleButton shuffle the tiles by
        // calling shuffleTiles()
        if sender == shuffleButton {
            print("shuffle tapped, add code to shuffle tiles")
        }
    }
    
    
    // Handler for the UIImageView tiles
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
            for view in tileCollection {
                print(view.tag)
            }
            
            var solved : Bool = true
            for i in tileCollection.indices {
                if tileCollection[i].tag == i {
                    print("Tile collection i tag is \(tileCollection[i].tag) and i = \(i)")
                    continue
                } else {
                    solved = false
                    break
                }
            }
            
            // if puzzle is solved congratulate user
            if solved {
                print("Game is solved, add code to show it")
            }
        }
    }
}

