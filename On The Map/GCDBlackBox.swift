//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Jess Gates on 7/25/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}