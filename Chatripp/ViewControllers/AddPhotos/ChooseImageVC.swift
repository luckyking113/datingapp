//
//  ChooseImageVC.swift
//  Chatripp
//
//  Created by KpStar on 3/5/19.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

class ChooseImageVC: UIViewController {

    var image : UIImage!
    var rotation : CGFloat = 0.0
    var addPhotoDelegate : AddPhotosVCDelegate?
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photoView.image = self.image
    }

    @IBAction func clickClose(_ sender: UIButton) {
        self.goBackVC()
    }
    
    func goBackToAddPhotosVC() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AddPhotosVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func clickChoose(_ sender: UIButton) {
        
        self.addPhotoDelegate?.setImage(img: self.image.rotate(radians: rotation))
        goBackToAddPhotosVC()
    }
    
    @IBAction func clickRotate(_ sender: UIButton) {
        
        rotation -= CGFloat(Double.pi/2)
        UIView.animate(withDuration: 0.1, animations: {
            self.photoView.transform = CGAffineTransform(rotationAngle: self.rotation)
        })
    }
}
