//
//  PhotoBrowseController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/12.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit


let PhotoBrowseCellID = "PhotoBrowseCell"



class PhotoBrowseController: UIViewController {

    var indexpath: IndexPath
    var urls : [URL]
    
    fileprivate lazy var collectionview: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowseFlowLayout())
    
    
    init(indexPath: IndexPath, picUrls: [URL]) {
        self.indexpath = indexPath
        self.urls = picUrls
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 默认滚到indexPath位置
        collectionview.scrollToItem(at: indexpath, at: .left, animated: false)
       
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension PhotoBrowseController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowseCellID , for: indexPath) as! PhotoBrowseCell
        cell.url = urls[indexPath.item]
        cell.delegate = self
        return cell
    }
}
//MARK: -- 退出
extension PhotoBrowseController : tapImageDelegate{

    func imageViewClick(_ cell: PhotoBrowseCell) {
        dismiss(animated: true, completion: nil)

    }
}

extension PhotoBrowseController {
    fileprivate func setupUI() {
        
        view.addSubview(collectionview)
        collectionview.frame = view.bounds
        collectionview.dataSource = self
        collectionview.register(PhotoBrowseCell.self, forCellWithReuseIdentifier: PhotoBrowseCellID)
    }
}

class PhotoBrowseFlowLayout: UICollectionViewFlowLayout {
 
    override func prepare() {
        super.prepare()
        
        
        itemSize = collectionView!.bounds.size
        minimumLineSpacing = 0 //行间距
        minimumInteritemSpacing = 0
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        
    }
    
}


