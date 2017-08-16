//
//  FileReader.swift
//  MusicPlayer
//
//  Created by Bindu on 14/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit

class FileReader: NSObject {

    class func readFiles() -> [String] {
        print(Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil).count)
        return  Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil) 
    }
    
}
