//
//  AMErrorViewController.h
//  appic
//
//  Created by Michael Kamphausen on 24.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMLoadingViewController.h"
#import "AMButton.h"

@protocol AMErrorViewControllerDelegate <NSObject>

- (void) reloadAfterError:(id)sender;

@end

@interface AMErrorViewController : AMLoadingViewController {
    NSString* defaultDescription;
}

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet AMButton *reloadButton;
@property (weak, nonatomic) id<AMErrorViewControllerDelegate> delegate;

- (IBAction)reload:(id)sender;
- (void)setDefaultDescription;

@end
