//
//  HomePresenter.swift
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

import Foundation
import UIKit

class HomePresenter: HomePresenterProtocol, HomeInteractorOutputProtocol {
 
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var paginationController = AKSPaginator()

    init() {}
}


// MARK: - HomePresenterProtocol
extension HomePresenter : AKSPaginatorOutProtocol {

    func viewDidLoad() {
        setupForPaginationController()
        fetchFirstPage()
    }
    
    func setupForPaginationController(){
        weak var weakSelf = self
        paginationController.delegate = self
        paginationController.setup(10)
        paginationController.completionBlock =
            { (paginator) -> () in
                weakSelf?.updateResultsOnView()
        }
    }
        
    func fetchNextData(){
        if paginationController.reachedLastPage() == false{
            if paginationController.requestStatus == RequestStatus.requestStatusNone {
                paginationController.fetchNextPage()
            }
        }
        updateResultsOnView()
    }
    
    func fetchFirstPage(){
        paginationController.reset()
        paginationController.fetchFirstPage()
        updateResultsOnView()
    }
    
    func fetchPage(_ page: Int) {
        interactor?.fetchVideos(pageSize: Int(paginationController.pageSize), pageNo: Int(page))
    }
    
    func updateResultsOnView(){
        
        let dateFormatterRead = DateFormatter()
        dateFormatterRead.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterWrite = DateFormatter()
        dateFormatterWrite.dateFormat = "yyyy/MM/dd\n@ h:m:s"

        if let viewModal = paginationController.results as? [Video] {
            let videosViewModals = viewModal.map { video -> VideoViewModal in
                let thumbnailUrl = video.thumbnail
                let fileSizeDescription = video.fileSize
                let statusImageUrl = "https://interview-images-roads.s3.amazonaws.com/\(video.status).png"
                let date = dateFormatterRead.date(from: video.dateTime)
                let dateTimeDescription = dateFormatterWrite.string(from: date ?? Date())
                let videoViewModal = VideoViewModal(dateTimeDescription: dateTimeDescription,
                                                    statusImageUrl: statusImageUrl,
                                                    thumbnailUrl: thumbnailUrl,
                                                    fileSizeDescription: fileSizeDescription)
                return videoViewModal
            }
            view?.viewModal = videosViewModals
        }
    }
    
}

// MARK: - HomeInteractorOutputProtocol
extension HomePresenter {
    
    func reachedEndOfThePage() {
        if paginationController.reachedLastPage() == false{
            if paginationController.requestStatus == RequestStatus.requestStatusNone {
                if paginationController.results.count > 0 {
                    fetchNextData()
                }else{
                    fetchFirstPage()
                }
            }
        }
    }

    func pageRequestCompleted(pageSize: Int, pageNo: Int, results: [Video]) {
        paginationController.setSuccess(results, totalResults: 1024)
    }

    func pageRequestFailed() {
         paginationController.setFailure()
    }

}
