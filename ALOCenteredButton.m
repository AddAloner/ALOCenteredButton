//
//  ALOCenteredButton.m
//
//  Created by Alexey Yachmenev on 16.07.14.
//  Copyright (c) 2014 Alexey Yachmenov. All rights reserved.
//

#import "ALOCenteredButton.h"

static CGFloat const kALODefaultImageLabelSpacing = 10.f;

@implementation ALOCenteredButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fieldsInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self fieldsInit];
    }
    return self;
}

- (void)fieldsInit
{
    _buttonOrientation = ALOCenteredButtonOrientationHorizontal;
    _imageLabelSpacing = kALODefaultImageLabelSpacing;
}

- (void)layoutIfInSuperview
{
    if (self.superview) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setImageLabelSpacing:(CGFloat)imageLabelSpacing
{
    if (_imageLabelSpacing != imageLabelSpacing) {
        _imageLabelSpacing = imageLabelSpacing;
        [self layoutIfInSuperview];
    }
}

- (void)setButtonOrientation:(ALOCenteredButtonOrientation)buttonOrientation
{
    if (_buttonOrientation != buttonOrientation) {
        _buttonOrientation = buttonOrientation;
        [self layoutIfInSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.buttonOrientation == ALOCenteredButtonOrientationHorizontal) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        CGFloat sumWidth = CGRectGetWidth(self.imageView.frame) + CGRectGetWidth(self.titleLabel.frame) + self.imageLabelSpacing;
        
        // reposition icon
        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin = CGPointMake(truncf((self.bounds.size.width - sumWidth) / 2),
                                        truncf((self.bounds.size.height - imageFrame.size.height) / 2));
        self.imageView.frame = imageFrame;
        // reposition label
        CGRect labelFrame = self.titleLabel.frame;
        labelFrame.origin = CGPointMake(CGRectGetMaxX(imageFrame) + self.imageLabelSpacing,
                                truncf((self.bounds.size.height - labelFrame.size.height) / 2));
        self.titleLabel.frame = labelFrame;
    } else {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat sumHeight = CGRectGetHeight(self.imageView.frame) + CGRectGetHeight(self.titleLabel.frame) + self.imageLabelSpacing;
        
        // reposition image
        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin = CGPointMake(truncf((self.bounds.size.width - self.imageView.frame.size.width) / 2),
                                        truncf((self.bounds.size.height - sumHeight) / 2));
        self.imageView.frame = imageFrame;
        
        // reposition label
        CGRect labelFrame = CGRectMake(0,
                                       CGRectGetMaxY(imageFrame) + self.imageLabelSpacing,
                                       self.bounds.size.width, self.titleLabel.frame.size.height);
        self.titleLabel.frame = labelFrame;
    }
}

@end
