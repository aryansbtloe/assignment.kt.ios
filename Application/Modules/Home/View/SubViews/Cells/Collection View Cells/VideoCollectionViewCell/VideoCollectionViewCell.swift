//
//  VideoCollectionViewCell.swift
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

/// <#Description#>
class VideoCollectionViewCell: UICollectionViewCell {
    
    /// <#Description#>
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var dateInfoLabel: UILabel!
    @IBOutlet weak var sizeInfoLabel: UILabel!

    /// <#Description#>
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        statusImageView.image = nil
        dateInfoLabel.text = nil
        sizeInfoLabel.text = nil
    }
    
    /// <#Description#>
    var viewModal:VideoViewModal? {
        didSet {
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true
            if let viewModal = viewModal {
                imageView.setImage(with: viewModal.thumbnailUrl)
                statusImageView.setImage(with: viewModal.statusImageUrl)
                dateInfoLabel.text = viewModal.dateTimeDescription
                sizeInfoLabel.text = viewModal.fileSizeDescription
            }
        }
    }
}
