//
//  ViewController.swift
//  AKMediaViewerExample
//
//  Created by Diogo Autilio on 3/18/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AKMediaViewerDelegate {
    
    var statusBarHidden: Bool = false
    var mediaNames: [String] = ["1f.jpg", "2f.jpg", "3f.mp4", "4f.jpg"]
    var mediaFocusManager: AKMediaViewerManager?
    
    @IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaFocusManager = AKMediaViewerManager.init()
        mediaFocusManager!.delegate = self
        mediaFocusManager!.elasticAnimation = true
        mediaFocusManager!.focusOnPinch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return self.statusBarHidden
    }
    
    // MARK: - <AKMediaViewerDelegate>
    
    func parentViewControllerForMediaFocusManager(_ manager: AKMediaViewerManager) -> UIViewController {
        return self
    }
    
    func mediaFocusManager(_ manager: AKMediaViewerManager,  mediaURLForView view: UIView) -> URL {
        let index: Int = view.tag - 1
        let name: NSString = mediaNames[index]
        let url: URL = Bundle.main().urlForResource(name.deletingPathExtension, withExtension: name.pathExtension)!
        
        return url
    }
    
    func mediaFocusManager(_ manager: AKMediaViewerManager, titleForView view: UIView) -> String {
        let url: URL = mediaFocusManager(manager, mediaURLForView: view)
        let fileExtension: String = url.pathExtension!.lowercased()
        let isVideo: Bool = fileExtension == "mp4" || fileExtension == "mov"
    
        return (isVideo ? "Videos are also supported." : "Of course, you can zoom in and out on the image.")
    }
    
    func mediaFocusManagerWillAppear(_ manager: AKMediaViewerManager) {
        /*
         *  Call here setDefaultDoneButtonText, if you want to change the text and color of default "Done" button
         *  eg: [self.mediaFocusManager setDefaultDoneButtonText:@"Panda" withColor:[UIColor purpleColor]]
         */
        self.statusBarHidden = true
        if (self.responds(to: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate))) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func mediaFocusManagerWillDisappear(_ mediaFocusManager: AKMediaViewerManager) {
        self.statusBarHidden = false
        if (self.responds(to: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate))) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - <UITableViewDataSource>
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {

        let cell = (tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaCell)
        let path: String = String.init(format: "%d.jpg", (indexPath as NSIndexPath).row + 1)
        let image: UIImage = UIImage.init(named: path)!
        
        cell.thumbnailView.image = image
        cell.thumbnailView.tag = (indexPath as NSIndexPath).row + 1
        mediaFocusManager!.installOnView(cell.thumbnailView)        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaNames.count
    }
}

