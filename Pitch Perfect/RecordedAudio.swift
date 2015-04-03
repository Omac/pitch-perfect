//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Omar Osorio on 4/1/15.
//  Copyright (c) 2015 Kioru. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
