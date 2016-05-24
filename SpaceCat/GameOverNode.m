//
//  GameOverNode.m
//  SpaceCat
//
//  Created by Ethan Neff on 9/3/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "GameOverNode.h"

@implementation GameOverNode

// create scene (convenience contructor)
+ (instancetype) gameOverAtPosition:(CGPoint)position {
    GameOverNode *gameOver = [self node];
    gameOver.name = @"GameOver";
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontName = @"GameOverLabel";
    gameOverLabel.fontSize = 48;
    gameOverLabel.position = position;
    
    [gameOver addChild:gameOverLabel];
    
    return gameOver;
}

// animation (called by gameplayscene)
- (void) performAnimation {
    SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"GameOverLabel"];
    label.xScale = 0;
    label.yScale = 0;
    SKAction *scaleUp = [SKAction scaleTo:1.2f duration:0.75f];
    SKAction *scaleDown = [SKAction scaleTo:0.9f duration:0.25f];
    SKAction *run = [SKAction runBlock:^{
        SKLabelNode *touchToRestart = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        touchToRestart.text = @"Touch To Restart";
        touchToRestart.fontName = @"TouchToRestartLabel";
        touchToRestart.fontSize = 22;
        touchToRestart.position = CGPointMake(label.position.x, label.position.y-40);
        [self addChild:touchToRestart];
    }];
    
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleDown, run]];
    [label runAction:scaleSequence];
    
}

@end
