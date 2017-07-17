//
//  GameScene.swift
//  Tennis Travel
//
//  Created by David Kirson on 6/29/17.
//  Copyright © 2017 David Kirson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
   //Declaring the variables for the game
    var tennisBall = SKShapeNode()
    var tennisRacket1 = SKSpriteNode()
    var tennisRacket2 = SKSpriteNode()
    var loseZone = SKSpriteNode()
    var loseZone2 = SKSpriteNode()
    var scoreBoard = SKLabelNode(fontNamed: "Arial")
    var scoreBoard2 = SKLabelNode(fontNamed: "Arial")
    var topPlayerScore = 0
    var bottomPlayerScore = 0
    var bottomPlayerScoreText = "0"
    var topPlayerScoreText = "0"
    var game = 1
    var topPlayerScoreBoard = SKLabelNode(fontNamed: "Arial")
    var bottomPlayerScoreBoard = SKLabelNode(fontNamed: "Arial")
    var topPlayerGamesWon = 0
    var bottomPlayerGamesWon = 0
    var startOver = false
    var player1Named = ""
    var player2Named = ""
    var randomIndex: UInt32 = 0
    
    //Setting up the game board (the ball, the players, etc.)
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        createBackground()
        makeTennisBall()
        makeRacket1()
        makeRacket2()
        makeLoseZone()
        makeLoseZone2()
        makeScoreBoard()
        makeScoreBoard2()
        makeTopPlayerScoreBoard()
        makeBottomPlayerScoreBoard()
        self.view?.isPaused = true
    }
    
    //Checks if the screen has been touched, and when screen is touched the game starts and the players move to the spot in the end zone that was touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if self.view?.isPaused == true || startOver == true
            {
                if startOver == true
                {
                    makeTennisBall()
                    resetGame()
                }
                tennisBall.position = CGPoint(x: frame.midX, y: frame.midY)
                self.view?.isPaused = false
                startOver = false
                
                if loseZone2.contains(location)
                {
                    tennisRacket1.position.x = location.x
                    tennisBall.physicsBody?.isDynamic = true
                    tennisBall.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
                }
                
                if loseZone.contains(location)
                {
                    tennisRacket2.position.x = location.x
                    tennisBall.physicsBody?.isDynamic = true
                    tennisBall.physicsBody?.applyImpulse(CGVector(dx: -5, dy: -5))
                }
            }
        }
    }
    
    //Checks if a touch is dragged across the endzone and moves the players to the spot
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if loseZone2.contains(location)
            {
                tennisRacket1.position.x = location.x
            }
            if loseZone.contains(location)
            {
                tennisRacket2.position.x = location.x
            }
        }
    }
    
    //Checks if the balls the top endzone and if it does it gives the bottom player an extra point and follows the scoring in tennis (and plays a miss sound)
    func didBegin(_ contact: SKPhysicsContact)
    {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        if (bodyAName == "tennisBall" && bodyBName == "loseZone") || (bodyAName == "loseZone" && bodyBName == "tennisBall")
        {
            bottomPlayerScore += 1
            if bottomPlayerScore == 1
            {
                if topPlayerScore == 0
                {
                    topPlayerScoreText = "0"
                    bottomPlayerScoreText = "15"
                } else
                {
                    bottomPlayerScoreText = "15"
                }
            }
            if bottomPlayerScore == 2
            {
                bottomPlayerScoreText = "30"
            }
            if bottomPlayerScore == 3
            {
                bottomPlayerScoreText = "40"
            }
            if bottomPlayerScore >= 4 && bottomPlayerScore == topPlayerScore
            {
                bottomPlayerScoreText = "Deuce"
                topPlayerScoreText = "Deuce"
            }
            if bottomPlayerScore >= 4 && bottomPlayerScore > topPlayerScore
            {
                bottomPlayerScoreText = "Advantage"
                topPlayerScoreText = " -- "
            }
            if bottomPlayerScore >= 4 && bottomPlayerScore > (topPlayerScore + 1)
            {
                bottomPlayerScoreText = "WON GAME \(game)!!!"
                game += 1
                bottomPlayerGamesWon += 1
                bottomPlayerScoreBoard.text = "Player 2: " + String(bottomPlayerGamesWon)
                if bottomPlayerGamesWon >= 6 && (bottomPlayerGamesWon == 7 || bottomPlayerGamesWon - 1 > topPlayerGamesWon) {
                    //                  WINNING ROUTINE!!!
                    run(SKAction.playSoundFileNamed("winning.wav", waitForCompletion: true))
                    tennisBall.removeFromParent()
                    startOver = true
                }
                bottomPlayerScore = 0
                topPlayerScore = 0
                run(SKAction.playSoundFileNamed("tada.mp3", waitForCompletion: true))
            }
            if startOver == true
            {
                scoreBoard.text = "Player 2 Has Won!!!"
                scoreBoard2.text = "Click to Reset Game"
            } else
            {
                scoreBoard2.text = " \(bottomPlayerScoreText)"
                scoreBoard.text = " \(topPlayerScoreText)"
                run(SKAction.playSoundFileNamed("miss.wav", waitForCompletion: false))
            }
        }
        //Checks if the balls hit the bottom endzone and if it does it gives the top player an extra point and follows the scoring in tennis (and plays a miss sound)
        if (bodyAName == "tennisBall" && bodyBName == "loseZone2") || (bodyAName == "loseZone2" && bodyBName == "tennisBall")
        {
            topPlayerScore += 1
            if topPlayerScore == 1
            {
                if bottomPlayerScore == 0
                {
                    bottomPlayerScoreText = "0"
                    topPlayerScoreText = "15"
                } else
                {
                    topPlayerScoreText = "15"
                }
            }
            if topPlayerScore == 2
            {
                topPlayerScoreText = "30"
            }
            if topPlayerScore == 3
            {
                topPlayerScoreText = "40"
            }
            if topPlayerScore >= 4 && bottomPlayerScore == topPlayerScore
            {
                bottomPlayerScoreText = "Deuce"
                topPlayerScoreText = "Deuce"
            }
            if topPlayerScore >= 4 && topPlayerScore > bottomPlayerScore
            {
                topPlayerScoreText = "Advantage"
                bottomPlayerScoreText = " -- "
            }
            if topPlayerScore >= 4 && topPlayerScore > (bottomPlayerScore + 1)
            {
                topPlayerScoreText = "WON GAME \(game)!!!"
                game += 1
                topPlayerGamesWon += 1
                topPlayerScoreBoard.text = "Player 1: " + String(topPlayerGamesWon)
                if topPlayerGamesWon >= 6 && (topPlayerGamesWon == 7 || topPlayerGamesWon - 1 > bottomPlayerGamesWon) {
                    //                  WINNING ROUTINE!!!
                    run(SKAction.playSoundFileNamed("winning.wav", waitForCompletion: true))
                    tennisBall.removeFromParent()
                    startOver = true
                }
                topPlayerScore = 0
                bottomPlayerScore = 0
                run(SKAction.playSoundFileNamed("tada.mp3", waitForCompletion: true))
            }
            if startOver == true
            {
                scoreBoard.text = "Player 1 Has Won!!!"
                scoreBoard2.text = "Click to Reset"
            //If the ball hits a player just play the hit sound
            } else {
                scoreBoard.text = " \(topPlayerScoreText)"
                scoreBoard2.text = " \(bottomPlayerScoreText)"
                run(SKAction.playSoundFileNamed("miss.wav", waitForCompletion: false))
            }
        }
        if (bodyAName == "tennisRacket1" || bodyBName == "tennisRacket1") || (bodyAName == "tennisRacket2" || bodyBName == "tennisRacket2")
        {
            if topPlayerScoreText == "WON GAME \(game - 1)!!!" || bottomPlayerScoreText == "WON GAME \(game - 1)!!!"
            {
                topPlayerScoreText = "0"
                bottomPlayerScoreText = "0"
                scoreBoard.text = " \(topPlayerScoreText)"
                scoreBoard2.text = " \(bottomPlayerScoreText)"
            }
            run(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false))
        }
    }
    
    //The game checks before every frame is drawn to make sure the ball isn't going to fast or slow or stuck
    override func update(_ currentTime: TimeInterval)
    {
        let maxSpeed: CGFloat = 400.0
        
        let xSpeed = sqrt(tennisBall.physicsBody!.velocity.dx * tennisBall.physicsBody!.velocity.dx)
        let ySpeed = sqrt(tennisBall.physicsBody!.velocity.dy * tennisBall.physicsBody!.velocity.dy)
        
        let speed = sqrt(tennisBall.physicsBody!.velocity.dx * tennisBall.physicsBody!.velocity.dx + tennisBall.physicsBody!.velocity.dy * tennisBall.physicsBody!.velocity.dy)
        
        if xSpeed <= 10.0
        {
            tennisBall.physicsBody!.applyImpulse(CGVector(dx: 5.0, dy: 0.0))
        }
        if ySpeed <= 10.0
        {
            tennisBall.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 5.0))
        }
        
        if speed > maxSpeed
        {
            tennisBall.physicsBody!.linearDamping = 0.4
        }
        else
        {
            tennisBall.physicsBody!.linearDamping = 0.0
        }
    }
    
    //Create the game background
    func createBackground()
    {
        let tennisCourt = SKTexture(imageNamed: "court")
        let tennisCourtBackground = SKSpriteNode(texture: tennisCourt)
        tennisCourtBackground.zPosition = -1
        tennisCourtBackground.position = CGPoint(x: 0, y: 0)
        tennisCourtBackground.setScale(1.45)
        addChild(tennisCourtBackground)
    }
    
    //Creates the tennis ball
    func makeTennisBall()
    {
        tennisBall = SKShapeNode(circleOfRadius: 10)
        tennisBall.position = CGPoint(x: frame.midX, y: frame.midY)
        tennisBall.strokeColor = UIColor.white
        tennisBall.fillColor = UIColor.green
        tennisBall.name = "tennisBall"
        tennisBall.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        tennisBall.physicsBody?.isDynamic = false   //ignores all forces and impulses
        tennisBall.physicsBody?.usesPreciseCollisionDetection = true
        tennisBall.physicsBody?.friction = 0
        tennisBall.physicsBody?.affectedByGravity = false
        tennisBall.physicsBody?.restitution = 1
        tennisBall.physicsBody?.angularDamping = 0
        tennisBall.physicsBody?.linearDamping = 0
        tennisBall.physicsBody?.contactTestBitMask = (tennisBall.physicsBody?.collisionBitMask)!
        tennisBall.physicsBody?.velocity = CGVector(dx: 20, dy: 20)   // sets the ball speed to a lower speed initially
        addChild(tennisBall)
    }
    
    //Makes Player 1
    func makeRacket1()
    {
        tennisRacket1 = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 72, height: 72))
        tennisRacket1.position = CGPoint(x: frame.midX, y: frame.minY + 55)
        tennisRacket1.name = "tennisRacket1"
        tennisRacket1.physicsBody = SKPhysicsBody(rectangleOf: tennisRacket1.size)
        tennisRacket1.physicsBody?.isDynamic = false
        //Generates a random number between 0 and 7
        randomIndex = arc4random_uniform(8)
        switch(randomIndex)
        {
        case 0 : player1Named = "Hulk-icon"
        case 1 : player1Named = "Captain-America-icon"
        case 2 : player1Named = "Iron-Man-icon"
        case 3 : player1Named = "Hawkeye-icon"
        case 4 : player1Named = "Loki-icon"
        case 5 : player1Named = "Thor-icon"
        case 6 : player1Named = "Nick-Fury-icon"
        case 7 : player1Named = "Black-Widow-icon"
        default : player1Named = "Hulk-icon"
        }
        tennisRacket1.texture = SKTexture(imageNamed: player1Named)//Picks the player with the matching random number
        addChild(tennisRacket1)
    }
    
    //Makes player 2
    func makeRacket2()
    {
        tennisRacket2 = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 72, height: 72))
        tennisRacket2.position = CGPoint(x: frame.midX, y: frame.maxY - 55)
        tennisRacket2.name = "tennisRacket2"
        tennisRacket2.physicsBody = SKPhysicsBody(rectangleOf: tennisRacket2.size)
        tennisRacket2.physicsBody?.isDynamic = false
        randomIndex = arc4random_uniform(8)//generates a random number between 0 and 7
        switch(randomIndex)
        {
        case 0 : player2Named = "Black-Widow-icon"
        case 1 : player2Named = "Hulk-icon"
        case 2 : player2Named = "Captain-America-icon"
        case 3 : player2Named = "Iron-Man-icon"
        case 4 : player2Named = "Hawkeye-icon"
        case 5 : player2Named = "Loki-icon"
        case 6 : player2Named = "Thor-icon"
        case 7 : player2Named = "Nick-Fury-icon"
        default : player2Named = "Thor-icon"
        }
        tennisRacket2.texture = SKTexture(imageNamed: player2Named)//Picks the player with the matching random number
        addChild(tennisRacket2)
    }
    
    //Makes the bottom losing zone
    func makeLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 840, height: 140))
        loseZone.position = CGPoint(x: frame.minX, y: frame.maxY)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    //Makes the top losing zone
    func makeLoseZone2()
    {
        loseZone2 = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 840, height: 140))
        loseZone2.position = CGPoint(x: frame.maxX, y: frame.minY)
        loseZone2.name = "loseZone2"
        loseZone2.physicsBody = SKPhysicsBody(rectangleOf: loseZone2.size)
        loseZone2.physicsBody?.isDynamic = false
        addChild(loseZone2)
    }
    
    //Makes bottom game score
    func makeScoreBoard()
    {
        scoreBoard.fontSize = 50
        scoreBoard.fontColor = SKColor.lightText
        scoreBoard.position = CGPoint(x: frame.midX, y: frame.minY + 600)
        scoreBoard.text = " " + String(topPlayerScore)
        addChild(scoreBoard)
    }
    
    //Make top game score
    func makeScoreBoard2()
    {
        scoreBoard2.fontSize = 50
        scoreBoard2.fontColor = SKColor.lightText
        scoreBoard2.position = CGPoint(x: frame.midX, y: frame.minY + 150)
        scoreBoard2.text = " " + String(bottomPlayerScore)
        addChild(scoreBoard2)
    }
    
    //Keeps track of player 1 games won
    func makeTopPlayerScoreBoard()
    {
        topPlayerScoreBoard.fontSize = 15
        topPlayerScoreBoard.fontColor = SKColor.red
        topPlayerScoreBoard.position = CGPoint(x: frame.minX + 45, y: frame.maxY - 30)
        topPlayerScoreBoard.text = "Player 1: " + String(topPlayerGamesWon)
        addChild(topPlayerScoreBoard)
    }
    
    //Keeps track of player 2 games won
    func makeBottomPlayerScoreBoard()
    {
        bottomPlayerScoreBoard.fontSize = 15
        bottomPlayerScoreBoard.fontColor = SKColor.red
        bottomPlayerScoreBoard.position = CGPoint(x: frame.minX + 45, y: frame.maxY - 50)
        bottomPlayerScoreBoard.text = "Player 2: " + String(bottomPlayerGamesWon)
        addChild(bottomPlayerScoreBoard)
    }
    
    //Resets all the game variables and score boards ONLY when the variable startOver = true
    func resetGame()
    {
        topPlayerScore = 0
        bottomPlayerScore = 0
        bottomPlayerScoreText = "0"
        topPlayerScoreText = "0"
        game = 1
        topPlayerGamesWon = 0
        bottomPlayerGamesWon = 0
        scoreBoard2.text = " \(bottomPlayerScoreText)"
        scoreBoard.text = " \(topPlayerScoreText)"
        bottomPlayerScoreBoard.text = "Player 2: " + String(bottomPlayerGamesWon)
        topPlayerScoreBoard.text = "Player 1: " + String(topPlayerGamesWon)
    }
}
