//
//  Util.m
//  SpaceCat
//
//  Created by Ethan Neff on 9/3/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random()%(max-min) + min;
}
@end
