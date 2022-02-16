//
//  ViewController.swift
//  imageViewTiles
//
//  Created by Josh Quaid on 2/5/22.
//

import UIKit

class ViewController: UIViewController {

    // Set up an array to store the default state of the tiles
    var defaultTileCoords: [CGRect] = []
    // Set up an array to store the user state of the tiles
    var userTileCoords: [CGRect] = []
    
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
        
        // Initialize the holeIndex with index of hole
        holeIndex = tileCollection.firstIndex(of: hole)

        #warning("Testing 2d array")
        var twoDTileArray : [[UIImageView]] = [[]]
        
        // Create a copy of the default state of the tile frames
        // for restoration
        for i in tileCollection.indices {
            defaultTileCoords.append(tileCollection[i].frame)
        }

        // Shuffle the tiles to start the game
        shuffleTiles(numMoves: Int.random(in: 10...25))
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
    func swapTiles(tileToSwap: UIImageView) -> Bool{
        // Get the index in tileCollection of tileToSwap
        let indexOfTileToSwap = tileCollection.firstIndex(of: tileToSwap)!
        
        if isMoveLegal(tappedTile: tileToSwap.self) {
            // Set up a temporary variable to hold the frame
            let tappedFrame = tileToSwap.self.frame
            // Set the tapped tile's frame to the hole's frame
            tileToSwap.self.frame = hole.frame
            // Set the hole's frame to the tapped frame
            hole.frame = tappedFrame
            
            // Swap index positions of hole and tappedTile
            tileCollection.swapAt(holeIndex!, indexOfTileToSwap)

            // Update the index of the hole
            holeIndex = indexOfTileToSwap
            
            return true
        }
        // The tiles were not swapped due to an illegal move
        return false
    }
    
    func shuffleTiles(numMoves: Int) {
        // Base case to end recursion
        if numMoves == 0 {
            return
        }
        
        // Unwrap holeIndex for use in the below code
        guard let indexOfHole = holeIndex else { return }
        
        // Set up Bool for successful swap
        var didSwap : Bool = false
        
        //Get a random number to select the direction of move
        let dir = Int.random(in: 0...3)
        print("num moves is \(numMoves) and dir is \(dir)")
        
        
        if dir == 0 && indexOfHole - 4 > -1 {
            print("Moving up")
            didSwap = swapTiles(tileToSwap: tileCollection[indexOfHole - 4])
        } else if dir == 1 && indexOfHole - 1 > -1{
            print("moving left")
            didSwap = swapTiles(tileToSwap: tileCollection[indexOfHole - 1])
        } else if dir == 2 && indexOfHole + 1 < 20 {
            print("moving rght")
            didSwap = swapTiles(tileToSwap: tileCollection[indexOfHole + 1])
        } else if dir == 3 && indexOfHole + 4 < 20 {
            print("moving down")
            didSwap = swapTiles(tileToSwap: tileCollection[indexOfHole + 4])
        }
        
        // Call shuffleTiles recursively until done. If swap was good
        // call shuffleTiles with 1 less move, else try again
        if didSwap {
            shuffleTiles(numMoves: numMoves - 1)
        } else {
            shuffleTiles(numMoves: numMoves)
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
            shuffleTiles(numMoves: Int.random(in: 10...25))
        }
    }
    
    
    // Handler for the UIImageView tiles
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        // Create a tile variable for use in tapHandler to guard against
        // any nil senders
        guard let tile = sender.view as? UIImageView else { return }
        
        // Create a boolean to store the result of the call to swapTiles
        let tileDidMove : Bool = swapTiles(tileToSwap: tile)
        
        // If the tile was swapped, check if hole is in solved position,
        // if it isn't there is no need to check for the solution.
        if tileDidMove && holeIndex == 0 {
            print("Hole is in solved position add code to check for solution")
            for view in tileCollection {
                print(view.tag)
            }
            
            // Check for a solved puzzle
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

