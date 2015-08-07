//
//  EditPageViewController.swift
//  TryOn
//
//  Created by QiFeng on 7/26/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import UIKit


class EditPageViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    var takePhotoBtn: UIButton!
    var selectPhotoBtn: UIButton!
    var savedImgView: UIImageView!
    var savedLabel: UILabel!
    let filterSelectors: [GlassesType: Selector] = [
        GlassesType.round: "roundTry:",
        GlassesType.Oval: "OvalTry:",
        GlassesType.Wayfares: "WayfaresTry:",
        GlassesType.Cateye: "CateyeTry:",
        GlassesType.Thick: "ThickTry:",
        GlassesType.Nerd: "NerdTry:",
        GlassesType.Geek: "GeekTry:",
        GlassesType.Fly: "FlyTry:",
        GlassesType.Grandpa: "GrandpaTry:",
        GlassesType.Hanjian: "HanjianTry:",
        GlassesType.Dawn: "DawnTry:",
        GlassesType.Proces: "ProcessTry:",
        GlassesType.Hefe: "HefeTry:"
    ]
    
    let filterOrder = [
        GlassesType.round,
        GlassesType.Oval,
        GlassesType.Wayfares,
        GlassesType.Cateye,
        GlassesType.Thick,
        GlassesType.Nerd,
        GlassesType.Geek,
        GlassesType.Fly,
        GlassesType.Grandpa,
        GlassesType.Hanjian,
        GlassesType.Dawn,
        GlassesType.Proces,
        GlassesType.Hefe,
    ]
    
    var cancelBtn: UIButton!
    var saveBtn: UIButton!
    var CurrentPhoto: UIImage!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var toolbar: UIToolbar!
    var filters: [UIBarButtonItem] = []
    var selectedFilter: UIButton!

    //glass thing
    var fgimageView: UIImageView!
    var glassRect: CGRect!
    var landmarks: faceLandmarks!
    
    
    var spin:UIActivityIndicatorView!
    var savedFloatingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor.grayColor().CGColor
        loadImageScrollView()
        loadPhotoButtons()
        loadSaveButtons()
        loadBottomToolbar()
        initDefaultLandmarks()
    }
    
    func loadImageScrollView() {
        //image view
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.view.addSubview(scrollView)
        let defaultimg = UIImage(named: "default_image.jpg")!
        imageView = UIImageView(image: defaultimg)
        
        self.automaticallyAdjustsScrollViewInsets = false;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.userInteractionEnabled = false
        
        scrollView.contentSize = defaultimg.size
        scrollView.contentMode = UIViewContentMode.ScaleAspectFill
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 4
        scrollView.zoomScale = minScale
        scrollView.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        scrollView.decelerationRate = 0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func loadPhotoButtons() {
        self.navigationController?.navigationBarHidden = true
        //take photo button
        takePhotoBtn = UIButton(frame: CGRectMake(self.view.frame.width/2 - 70, 22, 42, 42)) //TODO
        takePhotoBtn.setBackgroundImage(UIImage(named: "takephoto"), forState: UIControlState.Normal)
        takePhotoBtn.setBackgroundImage(UIImage(named:"selectphoto"), forState: UIControlState.Highlighted)
        takePhotoBtn.addTarget(self, action: "takePhotoTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(takePhotoBtn)
        
        //select photo button
        selectPhotoBtn = UIButton(frame: CGRectMake(self.view.frame.width/2 + 20, 22, 42, 42)) //TODO
        selectPhotoBtn.setBackgroundImage(UIImage(named:"selectphoto"), forState: UIControlState.Normal)
        selectPhotoBtn.setBackgroundImage(UIImage(named:"takephoto"), forState: UIControlState.Highlighted)
        selectPhotoBtn.addTarget(self, action: "selectPhotoTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(selectPhotoBtn)
    }
    
    func loadSaveButtons() {
        cancelBtn = UIButton(frame: CGRect(x:10, y:22, width:42, height:42))
        cancelBtn.setBackgroundImage(UIImage(named:"cross"), forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action:"CancelBtnTouchUp:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(cancelBtn)
     
        saveBtn = UIButton(frame: CGRect(x:self.view.frame.width - 52, y:22, width:42, height:42))
        saveBtn.setBackgroundImage(UIImage(named:"check"), forState: UIControlState.Normal)
        saveBtn.setBackgroundImage(UIImage(named:"cross"), forState: UIControlState.Highlighted)
        saveBtn.addTarget(self, action:"SaveBtnTouchUp:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(saveBtn)
        
        cancelBtn.hidden = true
        saveBtn.hidden = true
    }
    func loadBottomToolbar() {
        var toolbarItems: [UIBarButtonItem] = []
        for glassType in filterOrder {
            let filterBtn = BottomToolbarHelper.filterBtn(glassType, parentView: self, handler: filterSelectors[glassType]!)
            toolbarItems.append(filterBtn)
        }
        
        let beautyButton = BottomToolbarHelper.setBtnImgNatual(ImgLib.FiltersPhoto._Dawn!, parentView: self, handler: "beautyTab:")
        self.selectedFilter = beautyButton
        // Build scrollable bottom toolbar
        toolbar = ScrollableBottomToolbar.insertScrollableBottomToolbar(self, btnArray: toolbarItems)
    }
    func loadAnimation() {
        animBackground.addFloatingView(self)
        let animationLoader = FeHandwriting(view: self.view)
        self.view.addSubview(animationLoader)
        animationLoader.showWhileExecutingBlock({
            sleep(6)
            }, completion: {
                animationLoader.hidden = true
                animBackground.removeFloatingView(self)
        })
    }
    func calculateFace() {
        if( fgimageView !== nil ) {
            self.fgimageView.removeFromSuperview()
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.landmarks = faceAPI.uploadImage(self.CurrentPhoto)
            self.glassRect = CGRectMake(50, 50,  100, 30)
            self.fgimageView = UIImageView(frame: CGRectMake(self.glassRect.origin.x, self.glassRect.origin.y, self.glassRect.width, self.glassRect.height))
            self.view.addSubview(self.fgimageView)
            dispatch_async(dispatch_get_main_queue()) {
                self.cancelBtn.hidden = false
                self.saveBtn.hidden = false
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        centerScrollViewContents()
    }
/* ***************
    scroll view helper
***************** */
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

/* *************
    button click action
************* */
    func SaveBtnTouchUp(sender: AnyObject) {
         UIImageWriteToSavedPhotosAlbum(self.CurrentPhoto, nil, nil, nil)
         SavedViewHelper.addFloatingView(self)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            sleep(2)
            dispatch_async(dispatch_get_main_queue()) {
                SavedViewHelper.removeFloatingView(self)
            }
        }
    }
    
    func CancelBtnTouchUp(sender: AnyObject) {
        self.cancelBtn.hidden = true
        self.saveBtn.hidden = true
    }
    
    func roundTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.glass_ori.Round_ori!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }

    func OvalTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        
        let bgimage = ImgLib.glass_ori.Oval_ori!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    func WayfaresTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto.Wayfares!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    
    func CateyeTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        
        let bgimage = ImgLib.FiltersPhoto.Cateye!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    func ThickTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto.Thick!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    
    func NerdTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto.Nerd!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    func GeekTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto.Geek!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    
    func FlyTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto.Fly!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    func GrandpaTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto.Grandpa!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    
    func HanjianTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto.Hanjian!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    func DawnTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto._Dawn!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    
    func ProcessTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto._Process!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    
    func HefeTry(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        let bgimage = ImgLib.FiltersPhoto._Hefe!
        transformClickedGlass(bgimage)
        selectedFilter = sender
    }
    
    func tabChangeOn(oldFilter: UIButton, newFilter: UIButton) -> Bool{
        if (oldFilter == newFilter) {
            return false
        }
        oldFilter.layer.backgroundColor = UIColor.clearColor().CGColor
        newFilter.layer.backgroundColor = ColorSpace.View.BarItemHighlightedBgColor.CGColor
        if( fgimageView !== nil ) {
            fgimageView.removeFromSuperview()
        }
        return true
    }
    
    func getAbsWidth(inputW: CGFloat) -> CGFloat {
        var imageWidth: CGFloat!
        if( self.CurrentPhoto == nil ) {
            imageWidth = 750.0
        } else {
            imageWidth = self.CurrentPhoto.size.width
        }
        return CGFloat(inputW) / imageWidth * 375.0
    }
    
    func getAbsHeight(inputH: CGFloat) -> CGFloat {
        var imageWidth: CGFloat!
        if( self.CurrentPhoto == nil ) {
            imageWidth = 750.0
        } else {
            imageWidth = self.CurrentPhoto.size.width
        }
        return CGFloat(inputH) / imageWidth * 375.0 + imageView.frame.origin.y
    }
    
    func transformClickedGlass(bgimage: UIImage) {
        //caculate rect
        let deltaX = self.getAbsWidth(self.landmarks.rightEyeOuter.x - self.landmarks.leftEyeOuter.x)
        let deltaY = self.getAbsHeight(self.landmarks.rightEyeOuter.y - self.landmarks.leftEyeOuter.y)
        let glassWidth :CGFloat = 1.3 * sqrt( deltaX * deltaX + deltaY * deltaY )
        let glassHeight: CGFloat = ( glassWidth / bgimage.size.width ) * bgimage.size.height
        NSLog("width = %f, height = %f", glassWidth, glassHeight)
       
        self.fgimageView = UIImageView(frame: CGRectMake(0, 0, glassWidth, glassHeight))
        let eye_centerX = self.getAbsWidth( ( landmarks.leftEyeOuter.x + landmarks.rightEyeOuter.x ) / 2 )
        let eye_centerY = self.getAbsHeight( ( landmarks.leftEyeOuter.y + landmarks.rightEyeOuter.y ) / 2 )
        self.fgimageView.center = CGPointMake(eye_centerX, eye_centerY)
        self.ThreeDtransform(bgimage, landmarks:self.landmarks, glassImageViewCenter: self.fgimageView.center)
        self.view.addSubview(self.fgimageView)
    }
    
    func ThreeDtransform(fgImage: UIImage, landmarks: faceLandmarks, glassImageViewCenter: CGPoint) {
        fgimageView.image = fgImage
        var transform:CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -500
        let pitch:CGFloat = landmarks.pitch
        let roll =  landmarks.roll
        let yaw = landmarks.yaw
        
        //translate
        let eye_centerX = self.getAbsWidth( ( landmarks.leftEyeOuter.x + landmarks.rightEyeOuter.x ) / 2 )
        let eye_centerY = self.getAbsHeight( ( landmarks.leftEyeOuter.y + landmarks.rightEyeOuter.y ) / 2 )
        let glass_originCenterX = glassImageViewCenter.x
        let glass_originCenterY = glassImageViewCenter.y
        NSLog("eye center: %f", eye_centerX)
        NSLog("glass center: %f , %f", glass_originCenterX, glass_originCenterY)
        transform = CATransform3DRotate(transform, CGFloat(Double(yaw) * M_PI / 180.0), 0, 1, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double(pitch) * M_PI / 180.0), 1, 0, CGFloat(0.0))
        transform = CATransform3DRotate(transform, CGFloat(Double(roll) * M_PI / 180.0), 0, 0, CGFloat(1.0))
        transform = CATransform3DTranslate(transform, eye_centerX - glass_originCenterX  , eye_centerY - glass_originCenterY , 0.0 )

        transform = CATransform3DTranslate(transform, 0.0  , 0.0 , CGFloat(50) )
        fgimageView.layer.transform = transform
    }
    
    //************image picker************/
    func takePhotoTouchUp(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.cameraDevice = .Front
        let cameraTransform: CGAffineTransform //= CGAffineTransformMakeScale(1.25, 1.25)
        var transform:CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -500
        transform = CATransform3DRotate(transform, CGFloat( M_PI ), 0, CGFloat(1.0), 0)
        cameraTransform = CATransform3DGetAffineTransform(transform)
        imagePicker.cameraViewTransform = cameraTransform
        presentViewController(imagePicker, animated: true, completion: nil) //TODO
    }
    func selectPhotoTouchUp(sender: AnyObject?) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .SavedPhotosAlbum
        presentViewController(imagePicker, animated: true, completion: nil) //TODO
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        CurrentPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
      //  performSegueWithIdentifier("processPhoto", sender: nil)
        imageView.image = CurrentPhoto
        loadAnimation()
        calculateFace()
    }
    
    func initDefaultLandmarks() {
        self.landmarks = faceLandmarks()
        landmarks.initfaceLandmarks()
        self.landmarks.roll = -13.3
        self.landmarks.pitch = 0.0
        self.landmarks.yaw = -12.6
        self.landmarks.leftEyeOuter = CGPointMake(219, 427)
        self.landmarks.rightEyeOuter = CGPointMake(490, 335)
    }
}
