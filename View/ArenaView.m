//
//  ArenaView.m
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "ArenaView.h"

@interface ArenaView ()

@property (assign, nonatomic) NSInteger numberOfColumns;
@property (assign, nonatomic) NSInteger numberOfRows;

@end

@implementation ArenaView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    
    CGFloat cellWidth = (size.width - 4) / self.numberOfColumns;
    CGFloat cellHeight = (size.height - 4) / self.numberOfRows;
    
    NSInteger lineWidth = cellWidth * self.numberOfColumns;
    NSInteger lineHeight = cellHeight * self.numberOfRows;
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor); //change color here
    CGContextSetLineWidth(context, 1);
    
    NSInteger i = 0;
    for (CGFloat x = 2; i <= self.numberOfColumns; x += cellWidth) {
        CGContextMoveToPoint(context, x, 2);
        CGContextAddLineToPoint(context, x, lineHeight + 2);
        i++;
    }
    
    i = 0;
    for (CGFloat y = 2; i <= self.numberOfRows; y += cellHeight) {
        CGContextMoveToPoint(context, 2, y);
        CGContextAddLineToPoint(context, lineWidth + 2, y);
        i++;
    }

    
    CGContextStrokePath(context);

}

-(void) setColumns:(NSInteger)columns rows:(NSInteger)rows {
    _numberOfColumns = columns;
    _numberOfRows = rows;
}

@end
