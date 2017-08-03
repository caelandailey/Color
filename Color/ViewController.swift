//
//  ViewController.swift
//  Color
//
//  Created by Caelan Dailey on 7/31/17.
//  Copyright © 2017 Caelan Dailey. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarDelegate {
    
    let cellId = "cellId"
    var cellSize: CGFloat = 15.0
    let cellHexColor = "#121212"
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.groupTableViewBackground
        collectionView?.register(ColorCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.collectionViewLayout = ColorCellLayout(itemWidth: cellSize, itemHeight: cellSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(collectionView.frame.width/cellSize)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(collectionView.frame.height/cellSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ColorCell
        feedCell.backgroundColor = UIColor.clear

        feedCell.firPathObserver = "\(indexPath.item),\(indexPath.section)"   // Retreive firebase data at location

        return feedCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellSize,height: cellSize)
    }
}

