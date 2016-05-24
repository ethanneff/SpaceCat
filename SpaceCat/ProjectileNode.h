//
//  ProjectileNode.h
//  SpaceCat
//
//  Created by Ethan Neff on 9/2/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ProjectileNode : SKSpriteNode


// convience constructor (class method +)
+ (instancetype) projectileAtPosition:(CGPoint)position;

- (void) moveTowardsPosition:(CGPoint)position;

@end
