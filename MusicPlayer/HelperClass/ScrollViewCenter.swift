 //
//  ScrollViewCenter.swift
//  MusicPlayer
//
//  Created by Bindu on 17/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    func scrollRectToVisibleCenteredOn(visibleRect:CGRect,animated:Bool) {
        
        let centeredRect = CGRect(x: visibleRect.origin.x + visibleRect.size.width/2.0 - self.frame.size.width/2.0, y:  visibleRect.origin.y + visibleRect.size.height/2.0 - self.frame.size.height/2.0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.scrollRectToVisible(centeredRect, animated: true)
    }
}
