//
//  PostIMageVideosVC.swift
//  MySchollKinect
//
//  Created by Admin on 20/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


class PostIMageVideosVC:LightboxController{

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.images = [
          LightboxImage(imageURL: URL(string: "https://cdn.arstechnica.net/2011/10/05/iphone4s_sample_apple-4e8c706-intro.jpg")!),
          LightboxImage(
            image: UIImage(named: "photo1")!,
            text: "This is an example of a remote image loaded from URL"
          ),
          LightboxImage(
            image: UIImage(named: "photo2")!,
            text: "",
            videoURL: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
          ),
          LightboxImage(
            image: UIImage(named: "photo3")!,
            text: "This is an example of a local image."
          )
        ]
    }

}
