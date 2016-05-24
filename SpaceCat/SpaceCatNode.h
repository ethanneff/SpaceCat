//
//  SpaceCatNode.h
//  SpaceCat
//
//  Created by Ethan Neff on 9/2/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SpaceCatNode : SKSpriteNode

// convience constructor (class method +)
+ (instancetype) spaceCatAtPosition:(CGPoint)position;

// function
- (void) performTap;

@end
