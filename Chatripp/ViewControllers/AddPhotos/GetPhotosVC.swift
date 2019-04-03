//
//  GetPhotosVC.swift
//  Chatripp
//
//  Created by KpStar on 3/4/19.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import Parse

protocol GetPhotosVCDelegate {
	func setImage(img: UIImage)
	func setPhotoSet(obj: PFObject)
}

class GetPhotosVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnTabLibrary: UIButton!
    @IBOutlet weak var btnTabPhoto: UIButton!
    @IBOutlet weak var btnTabVideo: UIButton!
    
    @IBOutlet weak var uiPreview: UIView!
    @IBOutlet weak var btnShot: UIButton!
    @IBOutlet weak var uiFlash: UIView!
    @IBOutlet weak var uiCameraFrame: UIView!
    
    @IBOutlet weak var cvImage: UICollectionView!
    
    var addPhotoDelegate : GetPhotosVCDelegate?
    
    var imageArray = [UIImage]()
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var camera: AVCaptureDevice!
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCamera()
        initLibrary()
        setupTab(tabNo: 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cvImage.collectionViewLayout.invalidateLayout()
    }
    
    func initLibrary() {
        
        cvImage.delegate = self
        cvImage.dataSource = self
        cvImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        grabPhotos()
    }
    
    func initCamera() {
        
        checkLibraryPermission()
        checkCameraPermission()
        setupCamera(type: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        videoPreviewLayer?.frame = uiCameraFrame.bounds
    }
    
    func checkLibraryPermission() {
        
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .notDetermined {
                    self.goBackVC()
                }
            })
        }
    }
    
    func checkCameraPermission() {
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                } else {
                    self.goBackVC()
                }
            })
        }
    }
    
    func setupCamera(type: Int) {
        
        if session == nil {
            session = AVCaptureSession()
            session!.sessionPreset = AVCaptureSession.Preset.photo
        }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        camera = (type == 1 ? getFrontCamera() : getBackCamera())
        do {
            input = try AVCaptureDeviceInput(device: camera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        for i : AVCaptureDeviceInput in (self.session?.inputs as! [AVCaptureDeviceInput]){
            self.session?.removeInput(i)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey:  AVVideoCodecJPEG]
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity =    AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.portrait
                self.uiCameraFrame.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
            }
        }
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        var frontCamera: AVCaptureDevice?
        if let videoDevices = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
            frontCamera = videoDevices
        }
        return frontCamera
    }
    
    func getBackCamera() -> AVCaptureDevice? {
        var backCamera: AVCaptureDevice?
        if let videoDevices = AVCaptureDevice.default(for: AVMediaType.video) {
            backCamera = videoDevices
        }
        return backCamera
    }
    
    func setupTab(tabNo: Int) {
        
        btnTabLibrary.setTitleColor(Constants.colorGray, for: .normal)
        btnTabPhoto.setTitleColor(Constants.colorGray, for: .normal)
        btnTabVideo.setTitleColor(Constants.colorGray, for: .normal)
        self.uiPreview.isHidden = true
        self.cvImage.isHidden = true
        self.uiFlash.isHidden = true
        
        var title: String?
        
        if tabNo == 0 {
            btnTabLibrary.setTitleColor(Constants.colorBlack, for: .normal)
            self.cvImage.isHidden = false
            title = "Library"
            
            grabPhotos()
            
        } else if tabNo == 1 {
            btnTabPhoto.setTitleColor(Constants.colorBlack, for: .normal)
            self.uiPreview.isHidden = false
            btnShot.imageView?.image = UIImage(named: "ic_camera_shot")
            self.uiFlash.isHidden = false
            
            let fTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.btnAutoFlash))
            self.uiFlash.addGestureRecognizer(fTapGesture)
            title = "Photo"
        } else {
            btnTabVideo.setTitleColor(Constants.colorBlack, for: .normal)
            self.uiPreview.isHidden = false
            btnShot.imageView?.image = UIImage(named: "ic_video_shot")
            title = "Video"
        }
        lblTitle.text = title
    }
    
    @objc func btnAutoFlash() {
        
    }
    
    @IBAction func clickCapture(_ sender: UIButton) {
        
        if let output = stillImageOutput {
            if let videoConnection = output.connection(with: AVMediaType.video) {
                output.captureStillImageAsynchronously(from: videoConnection) {
                    (imageDataSampleBuffer, error) -> Void in
                    if let buffer = imageDataSampleBuffer {
                        if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
                            
                            if let img = UIImage(data: imageData) {
                                self.moveToSelectedPhotoVC(image: img)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backBtn_Clicked(_ sender: Any) {
        
        self.goBackVC()
    }
    
    @IBAction func btnChangeCamera_Clicked(_ sender: Any) {
        
        if camera.position == .back {
            setupCamera(type: 1)
        } else {
            setupCamera(type: 0)
        }
    }
    
    @IBAction func btnTab_Clicked(_ sender: UIButton) {
        
        setupTab(tabNo: sender.tag - 101)
    }
    
    func grabPhotos() {
        
        imageArray = []
        
        Helper.showLoading(target: self)
        DispatchQueue.global(qos: .background).async {
            print("Background Fetch")
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            
            if fetchResult.count > 0 {
                
                for i in 0..<fetchResult.count {
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: requestOptions, resultHandler: {(image, error) in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("You got no photos")
            }
            
            DispatchQueue.main.async {
                self.cvImage.reloadData()
                Helper.hideLoading(target: self)
            }
        }
    }
    
    func moveToSelectedPhotoVC(image: UIImage){
        let selectedPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseImageVC") as! ChooseImageVC
        
        selectedPhotoVC.image = image
        selectedPhotoVC.addPhotoDelegate = self.addPhotoDelegate
        self.navigationController?.pushViewController(selectedPhotoVC, animated: true)
    }
}

extension GetPhotosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as! LibraryCollectionViewCell
        cell.imgPic.contentMode = .scaleAspectFill
        cell.imgPic.clipsToBounds = true
        cell.imgPic.image = self.imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        return CGSize(width: width/4 - 1, height: width/4 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveToSelectedPhotoVC(image: self.imageArray[indexPath.item])
    }
}
