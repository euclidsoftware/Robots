//
//  Item.m
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "Item.h"

@interface Item ()

@property (assign, nonatomic) BOOL placed;

@end

@implementation Item

-(void)moveToX:(NSInteger)x y:(NSInteger)y {
    _x = x;
    _y = y;
}


@end
