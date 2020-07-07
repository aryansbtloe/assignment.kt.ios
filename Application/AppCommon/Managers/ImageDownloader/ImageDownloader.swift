//
//  ImageDownloader.swift
//  aryansbtloe
//
//  Created by Alok on 08/04/2020.
//  Copyright (c) 2020 Aryansbtloe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit

typealias ImageClosure = (UIImage?,_ url: String) -> Void

class ImageDownloader: NSObject {
    
    static let shared = ImageDownloader()
    private(set) var cache:NSCache<AnyObject, AnyObject> = NSCache()
    private var queue = OperationQueue()
    private var dictionaryBlocks = [UIImageView:(String, ImageClosure, ImageDownloadOperation)]()
    
    private override init() {
        queue.maxConcurrentOperationCount = 3
    }
    
    func addOperation(url: String, imageView: UIImageView,completion: @escaping ImageClosure) {
        if let image = getImageFromCache(key: url)  {
            completion(image,url)
            if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                tupple.2.cancel()
            }
        } else {
            if !checkOperationExists(with: url,completion: completion) {
                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                    tupple.2.cancel()
                }
                let newOperation = ImageDownloadOperation(url: url) { (image,downloadedImageURL) in
                    if let tupple = self.dictionaryBlocks[imageView] {
                        if tupple.0 == downloadedImageURL {
                            if let image = image {
                                self.saveImageToCache(key: downloadedImageURL, image: image)
                                tupple.1(image,downloadedImageURL)
                                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                                    tupple.2.cancel()
                                }
                            } else {
                                tupple.1(nil, downloadedImageURL)
                            }
                            _ = self.dictionaryBlocks.removeValue(forKey: imageView)
                        }
                    }
                }
                dictionaryBlocks[imageView] = (url, completion, newOperation)
                queue.addOperation(newOperation)
            }
        }
    }
    
    internal func getImageFromCache(key : String) -> UIImage? {
        return self.cache.object(forKey: key as AnyObject) as? UIImage
    }
    
    internal func saveImageToCache(key : String, image : UIImage) {
        self.cache.setObject(image, forKey: key as AnyObject)
    }
    
    func checkOperationExists(with url: String,completion: @escaping (UIImage,_ url: String) -> Void) -> Bool {
        if let arrayOperation = queue.operations as? [ImageDownloadOperation] {
            let operations = arrayOperation.filter{$0.url == url}
            return operations.count > 0 ? true : false
        }
        return false
    }
}

extension UIImageView {
    
    func setImage(with url: String){
        self.showActivityIndicator()
        ImageDownloader.shared.addOperation(url: url,imageView: self) {  [weak self] (image,downloadedImageURL) in
            DispatchQueue.main.async {
                if let image = image {
                    self?.image = image
                }
                self?.hideActivityIndicator()
            }
        }
    }
    
}

class ImageDownloadOperation: Operation {
    
    let url : String?
    
    var completion: ((_ image : UIImage?,_ url: String) -> Void)?
    
    init(url : String, completion : @escaping ((_ image : UIImage?,_ url : String) -> Void)) {
        self.url = url
        self.completion = completion
    }
    
    override func main() {
        if self.isCancelled { return }
        if let url = self.url {
            URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    return
                }
                DispatchQueue.main.async {
                    if self.isCancelled { return }
                    let image = UIImage(data: data!)
                    if let block = self.completion{
                        block(image, url)
                    }
                }
            }).resume()
        }
    }
}
