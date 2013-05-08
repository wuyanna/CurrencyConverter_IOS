//
//  FigureTextLabel.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-28.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "FigureTextLabel.h"

@implementation FigureTextLabel

@synthesize delegate;
@synthesize clearsOnBeginEditing;
@synthesize formatter;
@synthesize number;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
//    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL b = [super becomeFirstResponder];
    if (b && [delegate respondsToSelector:@selector(textLabelDidBeginEditing:)]) {
        [delegate textLabelDidBeginEditing:self];
    }
    return b;
}

- (BOOL)resignFirstResponder {
    BOOL b = [super resignFirstResponder];
    if (b && [delegate respondsToSelector:@selector(textLabelDidEndEditing:)]) {
        [delegate textLabelDidEndEditing:self];
    }
    return b;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    if ([delegate respondsToSelector:@selector(textLabelDidChange:)]) {
        [delegate textLabelDidChange:self];
    }
}

- (NSNumber *)number {
    if (self.formatter) {
        NSNumber *num = [self.formatter numberFromString:self.text];
        return num;
    }
    return [NSNumber numberWithDouble:[self.text doubleValue]];
}

- (void)setNumber:(NSNumber *)aNumber {
    if (self.formatter) {
        self.text = [self.formatter stringFromNumber:aNumber];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)hasText {
    return (self.text.length != 0);
}

- (void)insertText:(NSString *)text {
    NSMutableString *s = [NSMutableString stringWithString:self.text];
    [s appendString:text];
    self.text = [NSString stringWithString:s];
}

- (void)deleteBackward {
    if (self.text.length > 1) {
        NSString *s = [self.text substringToIndex:(self.text.length - 1)];
        self.text = s;
    } else {
        self.text = @"0";
    }
}

@end
