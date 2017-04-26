//
//  ResizePhoto.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/6/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class ResizePhoto: UIViewController {
    
    weak var dowloadProgress: UIProgressView!
    weak var imageView: UIImageView!
    lazy var downloadsSession: Foundation.URLSession = {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.dowloadProgress.progress = 0.0
        
    }
    
    @IBAction func downloadResize(_ sender: AnyObject) {
        //let url = NSURL(string: "https://hd.unsplash.com/photo-1465232377925-cce9a9d87843")
        let url = URL(string: "https://images.unsplash.com/photo-1470897655254-05feb2d2ab97?dpr=1&auto=compress,format&crop=entropy&fit=crop&w=1199&h=799&q=80&cs=tinysrgb")
        
        if downloadTask != nil {
            downloadTask!.cancel()
        }
        self.imageView.image = nil
        downloadTask = downloadsSession.downloadTask(with: url!)
        self.dowloadProgress.progress = 0.0
        downloadTask!.resume()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        downloadsSession.finishTasksAndInvalidate()
        
    }

}


//MARK: NSURLSessionDownloadDelegate
extension ResizePhoto: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath + "/image.png")
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            showImage(destinationURLForFile)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                showImage(destinationURLForFile)
            }catch{
                print("Không thể copy file")
            }
        }
    }
    
    
    func showImage(_ location : URL) {
        DispatchQueue.main.async(execute: {
            if let data: Data = try? Data(contentsOf: location) {
                self.imageView.image = UIImage(data: data)
            }
        })
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        print(totalBytesWritten, totalBytesExpectedToWrite)
        
        DispatchQueue.main.async(execute: {
            self.dowloadProgress.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            print("\(self.dowloadProgress.progress)\n")
        })
        
    }
}
