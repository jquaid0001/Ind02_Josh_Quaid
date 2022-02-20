//
//  ViewController.swift
//  imageViewTiles
//
//  Created by Josh Quaid on 2/5/22.
//

import UIKit

class ViewController: UIViewController {

    // Set up an array to store the default state of the tiles
    var solvedTilePositions: [CGRect] = []
    // Set up an array to store the user state of the tiles for backup
    var userTilePositions: [CGRect] = []
    
    // The array that contails all of the tiles
    @IBOutlet var tileCollection: [UIImageView]!
    // The outlet for the hole tile
    @IBOutlet weak var hole: UIImageView!
    
    // Set up a variable to store the index of the hole
    var holeIndex : Int?
    
    // Button outlets
    @IBOutlet weak var solutionButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set the shuffle button disabled style
        shuffleButton.setTitleColor(UIColor.gray, for: .disabled)
        // Initialize the holeIndex with index of hole
        holeIndex = tileCollection.firstIndex(of: hole)
        
        // Create a copy of the default state of the tile frames
        // for restoration
        for i in tileCollection.indices {
            solvedTilePositions.append(tileCollection[i].frame)
        }
    }

    // Function for checking if a move is legal (tapped tile is
    // adjacent to the hole)
    func isMoveLegal(tappedTile: UIImageView) -> Bool {
        print("hole tag = \(hole.tag) and tappedTag = \(tappedTile.tag)")
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
    func swapTiles(tileToSwap: UIImageView) -> Bool{
        print("Index of tileToSwap is \(tileCollection.firstIndex(of: tileToSwap))")
        if isMoveLegal(tappedTile: tileToSwap.self) {
            // Set up a temporary variable to hold the frame
            let tappedFrame = tileToSwap.self.frame
            // Set the tapped tile's frame to the hole's frame
            tileToSwap.self.frame = hole.frame
            // Set the hole's frame to the tapped frame
            hole.frame = tappedFrame
            // Set up a temporary variable to hold the tag
            let tappedTag = tileToSwap.self.tag
            // Set the tapped tile's tag to hole.tag
            tileToSwap.self.tag = hole.tag
            // Set the hole's tag to the tappedTag tag
            hole.tag = tappedTag
            
            print("after swap hole tag is \(hole.tag) and tapped tag is \(tileToSwap.tag)")
            for i in tileCollection.indices {
                print("Tile collection i tag is \(tileCollection[i].tag) and i = \(i)")
            }
            
            return true
        }
        // The tiles were not swapped due to an illegal move
        return false
    }
    
    // Shuffles tiles numMoves times
    func shuffleTiles(numMoves: Int) {
        // Set up a local numMoves variable
        var remainingMoves = numMoves
        // Set up Bools for successful swap, and direction flags
        var didSwap = false
        var canMoveUp = true, canMoveDown = true,
            canMoveLeft = true, canMoveRight = true
        // Set up an Int for random direction
        var dir = 0
        
        // While loop to continue moving until numMoves = 0
        while remainingMoves > 0 {
            dir = Int.random(in: 0...3)
            didSwap = false
            
            #warning("Clean this up by putting the second condition inside of the ifs")
            if dir == 0 && canMoveUp {
                if hole.frame.origin.y > 169 {
                    print("Moving up")
                    // Moving down after moving up is dumb, block it
                    canMoveDown = false
                    // Allow moving left and right if blocked
                    canMoveLeft = true; canMoveRight = true
                    didSwap = swapTiles(tileToSwap: tileCollection[
                        tileCollection.firstIndex(where: {$0.tag == hole.tag - 4})!
                        ])
                    //didSwap = swapTiles(tileToSwap: tileCollection[hole.tag - 4])
                }
            } else if dir == 1 && hole.frame.origin.x > 21 && canMoveLeft {
                print("moving left")
                // Moving right after moving left is dumb, block it
                canMoveRight = false
                // Allow moving up and down if blocked
                canMoveUp = true; canMoveDown = true
                didSwap = swapTiles(tileToSwap: tileCollection[
                    tileCollection.firstIndex(where: {$0.tag == hole.tag - 1})!
                    ])
                //didSwap = swapTiles(tileToSwap: tileCollection[hole.tag - 1])
            } else if dir == 2 && hole.frame.origin.x < 300 && canMoveRight{
                print("moving rght")
                // You get the picture from the previous
                canMoveLeft = false
                canMoveUp = true; canMoveDown = true
                didSwap = swapTiles(tileToSwap: tileCollection[
                    tileCollection.firstIndex(where: {$0.tag == hole.tag + 1})!
                    ])
                //didSwap = swapTiles(tileToSwap: tileCollection[hole.tag + 1])
            } else if dir == 3 && hole.frame.origin.y < 541 && canMoveDown {
                print("moving down")
                // See previous dumb statement...
                canMoveUp = false
                canMoveLeft = true; canMoveRight = true
                didSwap = swapTiles(tileToSwap: tileCollection[
                    tileCollection.firstIndex(where: {$0.tag == hole.tag + 4})!
                    ])
                //didSwap = swapTiles(tileToSwap: tileCollection[hole.tag + 4])
            }
            
            // Call shuffleTiles recursively until done. If swap was good
            // call shuffleTiles with 1 less move, else try again
            if didSwap {
                remainingMoves -= 1
            }
        }
    }
    
    // MARK: - Handlers
    
    // Handler for the shuffle and show answer buttons
    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender == solutionButton {
            guard let buttonText = sender.titleLabel?.text else { return }
            
            if buttonText == "Show Answer" {
                // If userTileCoords has an elements from
                // previous button taps, clear them out
                userTilePositions.removeAll()
                
                // Copy current tile frames to userTileCoords
                // for restoration
                for i in tileCollection.indices {
                    userTilePositions.append(tileCollection[i].frame)
                }
  
                // Restore the default state and show the solved
                // puzzle
                for i in tileCollection.indices {
                    tileCollection[i].frame = solvedTilePositions[i]
                }
                
                // Set the button's text to Hide Answer
                sender.setTitle("Hide Answer", for: .normal)
                // Disable the shuffle button
                shuffleButton.isEnabled = false
                
            } else {
                // Restore the userTileCoors array to restore
                // the user state
                for i in tileCollection.indices {
                    tileCollection[i].frame = userTilePositions[i]
                }
                // Set the buton's text to Show Answer
                sender.setTitle("Show Answer", for: .normal)
                // Enable the shuffle button
                shuffleButton.isEnabled = true
            }
        }
        // If sender is shuffleButton shuffle the tiles by
        // calling shuffleTiles()
        if sender == shuffleButton {
            // Call shuffleTiles with a random number between 10 and 25
            shuffleTiles(numMoves: Int.random(in: 10...25))
        }
    }
    
    
    // Handler for the UIImageView tiles
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        // Get the current state of the solution button
        let solutionButtonText = solutionButton.titleLabel?.text
        
        // If the show answer button is active, don't allow the user to
        // tap any tiles.
        if solutionButtonText == "Show Answer" {
            // Create a tile variable for use in tapHandler to guard against
            // any nil senders
            guard let tile = sender.view as? UIImageView else { return }
            
            // Create a boolean to store the result of the call to swapTiles
            let tileDidMove : Bool = swapTiles(tileToSwap: tile)
            
            // If the tile was swapped, check if hole is in solved position,
            // if it isn't there is no need to check for the solution.
            if tileDidMove && holeIndex == 0 {
                // Set up a boolean for solved
                var solved : Bool = true
                
                // Iterate through the tileCollection and compare the tag to the index.
                for i in tileCollection.indices {
                    // If tag == index, keep checking
                    if tileCollection[i].tag == i {
                        print("Tile collection i tag is \(tileCollection[i].tag) and i = \(i)")
                        continue
                    } else {
                        // Tag didn't match index so puzzle isn't solved. Stop checking.
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
}

