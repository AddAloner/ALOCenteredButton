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
    
    // fix for zero width label
    if (labelSize.width == 0) {
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.size.width = 0;
        self.titleLabel.frame = titleFrame;
    }
    
    switch (self.buttonOrientation) {
        case ALOCenteredButtonOrientationRightToLeft:
        case ALOCenteredButtonOrientationLeftToRight:
            return CGSizeMake(labelSize.width + imageSize.width + self.imageLabelSpacing + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
                              MAX(labelSize.height, imageSize.height) + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
            
        case ALOCenteredButtonOrientationVertical:
            return CGSizeMake(MAX(labelSize.width, imageSize.width) + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
                              labelSize.height + imageSize.height + self.imageLabelSpacing + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
    }
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.buttonOrientation == ALOCenteredButtonOrientationVertical) {
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
        return;
    }
    
    // horizontal
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    CGFloat sumWidth = CGRectGetWidth(self.imageView.frame) + CGRectGetWidth(self.titleLabel.frame) + self.imageLabelSpacing;
    CGFloat buttonWidth = CGRectGetWidth(self.bounds);
    
    CGRect labelFrame = self.titleLabel.frame;
    if (sumWidth > buttonWidth) {
        labelFrame.size.width -= sumWidth - buttonWidth;
    }
    
    CGRect imageFrame = self.imageView.frame;
    CGFloat startX = truncf((buttonWidth - sumWidth) / 2);
    CGFloat labelFrameY = truncf((self.bounds.size.height - labelFrame.size.height) / 2);
    CGFloat imageFrameY = truncf((self.bounds.size.height - imageFrame.size.height) / 2);
    if (self.buttonOrientation == ALOCenteredButtonOrientationRightToLeft) {
        labelFrame.origin = CGPointMake(startX, labelFrameY);
        imageFrame.origin = CGPointMake(CGRectGetMaxX(labelFrame) + self.imageLabelSpacing, imageFrameY);
    } else {
        imageFrame.origin = CGPointMake(startX, imageFrameY);
        labelFrame.origin = CGPointMake(CGRectGetMaxX(imageFrame) + self.imageLabelSpacing, labelFrameY);
    }
    
    self.titleLabel.frame = labelFrame;
    self.imageView.frame = imageFrame;
}

@end
