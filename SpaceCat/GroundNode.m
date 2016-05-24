//
//  GroundNode.m
//  SpaceCat
//
//  Created by Ethan Neff on 9/3/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "GroundNode.h"
#import "Util.h"

@implementation GroundNode

// create scene (convenience contructor)
+ (instancetype) groundWithSize:(CGSize)size {
    GroundNode *ground = [self spriteNodeWithColor:[SKColor colorWithWhite:255 alpha:0] size:size];
    ground.name = @"Ground'";
    ground.position = CGPointMake(size.width/2, size.height/2);
    ground.zPosition = 7;
    [ground setupPhysicsBody];
    
    return ground; // create ground
}

// scene additional characteristics
- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO; // not effected by the physics
    self.physicsBody.categoryBitMask = collisionCategoryGround; // which category does the ground belong to?
    self.physicsBody.collisionBitMask = collisionCategoryDebris;
    self.physicsBody.contactTestBitMask = collisionCategoryEnemy;
}

@end
