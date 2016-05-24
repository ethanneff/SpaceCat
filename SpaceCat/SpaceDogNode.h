//
//  SpaceDogNode.h
//  SpaceCat
//
//  Created by Ethan Neff on 9/3/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

// create the parameter input for the convience constructor
typedef NS_ENUM(NSUInteger, spaceDogType) {
    spaceDogTypeA = 0,
    spaceDogTypeB = 1,
};

@interface SpaceDogNode : SKSpriteNode

@property (nonatomic, getter = isDamaged) BOOL damaged;
@property (nonatomic) spaceDogType type;

// convience class constructor
+ (instancetype) spaceDogOfType:(spaceDogType)type;

@end
