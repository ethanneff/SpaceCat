//
//  GameOverNode.h
//  SpaceCat
//
//  Created by Ethan Neff on 9/3/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverNode : SKNode

+ (instancetype) gameOverAtPosition:(CGPoint)position;
- (void) performAnimation;

@end
