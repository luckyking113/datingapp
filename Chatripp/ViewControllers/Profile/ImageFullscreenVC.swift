//
//  ImageFullscreenVCViewController.swift
//  Chatripp
//
//  Created by Famousming on 2019/02/20.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse
import KFImageViewer

class ImageFullscreenVC: UIViewController {

    var objs = [PFObject]()
    
    @IBOutlet weak var slideshow: KFImageViewer!
    var imageUrls = [InputSource]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.slideshow.zoomEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        
        for obj in objs {
            if let photo = obj[DBNames.posts_photo] as? PFFileObject {
                if let urlStr = photo.url {
                    if let url = URL.init(string: urlStr){
                        self.imageUrls.append(KingfisherSource(url: url))
                    }
                }
            }
        }
        
        self.slideshow.setImageInputs(imageUrls)
        self.slideshow.setCurrentPage(currentIndex, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setImage(objs: [PFObject], currentIndex: Int) {
        
        self.objs = objs
        self.currentIndex = currentIndex
    }

    @IBAction func clickClose(_ sender: Any) {
        
        self.goBackVC()
    }
}
