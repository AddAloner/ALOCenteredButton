//
//  ALOCenteredButton.h
//
//  Created by Alexey Yachmenev on 16.07.14.
//  Copyright (c) 2014 Alexey Yachmenov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ALOCenteredButtonOrientation) {
    ALOCenteredButtonOrientationHorizontal,
    ALOCenteredButtonOrientationVertical
};

@interface ALOCenteredButton : UIButton

@property (nonatomic, assign) ALOCenteredButtonOrientation buttonOrientation;
@property (nonatomic, assign) CGFloat imageLabelSpacing;

@end
