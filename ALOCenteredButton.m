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
    _buttonOrientation = ALOCenteredButtonOrientationVertical;
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

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize labelSize = [self.titleLabel sizeThatFits:size];
    CGSize imageSize = [self.imageView sizeThatFits:size];
    
    if (self.buttonOrientation == ALOCenteredButtonOrientationRightToLeft) {
        return CGSizeMake(labelSize.width + imageSize.width + self.imageLabelSpacing,
                          MAX(labelSize.height, imageSize.height));
    } else {
        return CGSizeMake(MAX(labelSize.width, imageSize.width),
                          labelSize.height + imageSize.height + self.imageLabelSpacing);
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.buttonOrientation == ALOCenteredButtonOrientationRightToLeft) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        CGFloat sumWidth = CGRectGetWidth(self.imageView.frame) + CGRectGetWidth(self.titleLabel.frame) + self.imageLabelSpacing;
        CGFloat buttonWidth = CGRectGetWidth(self.bounds);
        // reposition label
        CGRect labelFrame = self.titleLabel.frame;

        if (sumWidth > buttonWidth) {
            labelFrame.size.width -= sumWidth - buttonWidth;
        }
        
        labelFrame.origin = CGPointMake(truncf((buttonWidth - sumWidth) / 2),
                                truncf((self.bounds.size.height - labelFrame.size.height) / 2));
        self.titleLabel.frame = labelFrame;
        // reposition icon
        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin = CGPointMake(CGRectGetMaxX(labelFrame) + self.imageLabelSpacing,
                                        truncf((self.bounds.size.height - imageFrame.size.height) / 2));
        self.imageView.frame = imageFrame;
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
