//
//  HomeView.swift
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

class HomeViewController: AksBaseViewController {
    
    var presenter: HomePresenterProtocol?

    @IBOutlet var collectionView:UICollectionView!
    
    var viewModal: [VideoViewModal] = [] {
        didSet {
            defer {
                self.collectionView.reloadData()
            }
        }
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        startUpInitialisations()
        registerForNotifications()
        updateUserInterfaceOnScreen()
        presenter?.viewDidLoad()
    }
    
    private func startUpInitialisations(){
        collectionView.delegate = self
        collectionView.dataSource = self
        registerNib("VideoCollectionViewCell", collectionView: collectionView)
    }
    
    private func registerForNotifications(){
    
    }

    private func updateUserInterfaceOnScreen(){
        
    }

    func setupNavigationBar(){
        title = "Video Files"
        if #available(iOS 11, *) {
              self.navigationController?.navigationBar.prefersLargeTitles = true
              self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        
        let rightBarButton1 = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(HomeViewController.onClickOfBarButtonItems))
        let rightBarButton2 = UIBarButtonItem(image: UIImage(named: "calendar"), style: .plain, target: self, action: #selector(HomeViewController.onClickOfBarButtonItems))
        self.navigationItem.rightBarButtonItems = [rightBarButton1,rightBarButton2]
    }
}

//MARK: - Pagination Controller
extension HomeViewController {
    
    @objc func onClickOfBarButtonItems() {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if velocity < 0 && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
            presenter?.reachedEndOfThePage()
        }
    }
    
}


extension HomeViewController: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModal.count
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width)/CGFloat(2) - 15
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        cell.viewModal = viewModal[indexPath.row]
        return cell
    }
        
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: HomeViewProtocol {
    
}

