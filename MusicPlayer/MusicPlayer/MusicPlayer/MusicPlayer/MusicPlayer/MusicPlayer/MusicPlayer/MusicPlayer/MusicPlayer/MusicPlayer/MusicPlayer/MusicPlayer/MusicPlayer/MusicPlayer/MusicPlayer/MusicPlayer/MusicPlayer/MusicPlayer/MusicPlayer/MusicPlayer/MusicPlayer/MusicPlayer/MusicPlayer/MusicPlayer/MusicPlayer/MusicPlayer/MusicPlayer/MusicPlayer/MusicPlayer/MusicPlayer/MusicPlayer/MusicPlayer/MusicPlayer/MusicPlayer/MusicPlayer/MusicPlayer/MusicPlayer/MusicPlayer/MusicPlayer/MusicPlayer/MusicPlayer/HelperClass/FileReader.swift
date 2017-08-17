//
//  FileReader.swift
//  MusicPlayer
//
//  Created by Bindu on 14/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import MediaPlayer

class FileReader: NSObject {
    
    class func readFiles() -> [MPMediaItem] {
        //        print(Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil).count)
        //        return  Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
        
        
        let songList = (MPMediaQuery.songs().items?.filter{$0.assetURL != nil})!
        
        print(songList)
        return songList
    }
    
}
