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
    var cellHexColor = "121212"
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorPicker()
 
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
        return Int(collectionView.frame.height-80/cellSize)
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
    
    func setupColorPicker() {
        let screenWidth = self.view.frame.width
        
        let view = UIView()
        let viewHeight:CGFloat = 100
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: 0, y: self.view.frame.height - viewHeight, width: screenWidth, height: viewHeight)
        
        addColorButton(color: 0x000000, view: view, pos: 0) // Black
        addColorButton(color: 0xcccccc, view: view, pos: 2) // Gray
        addColorButton(color: 0xffffff, view: view, pos: 1) // White
        addColorButton(color: 0xFFC0CB, view: view, pos: 3) // Pink
        addColorButton(color: 0xff00ff, view: view, pos: 9) // Purple
        addColorButton(color: 0xff0000, view: view, pos: 5) // Red
        addColorButton(color: 0xffa500, view: view, pos: 6) // Orange
        addColorButton(color: 0x00ff00, view: view, pos: 7) // Green
        addColorButton(color: 0xffff00, view: view, pos: 8) // Yellow
        addColorButton(color: 0x0000ff, view: view, pos: 4) // Blue
      
        self.view.addSubview(view)
    }
    
    private func addColorButton(color: Int, view: UIView, pos: Int) {
    
        let button = UIButton()
        let size = 35
        let height = Int(view.frame.size.height)
        let columnCount = 5
        let rowCount = 2
        
        let x = ((pos % columnCount) + 1 ) * ( (Int(self.view.frame.width) - (columnCount*size) )/(columnCount+1)) + (size * (pos % columnCount))
        let yOffset1 = (Int(pos/columnCount) + 1) * (height - rowCount*size) / (rowCount+1)
        let yOffset2 = size * Int(pos / columnCount)
        let y = yOffset1 + yOffset2
        
        button.frame = CGRect(x: x, y: y, width: size, height: size)
        button.backgroundColor = UIColor(rgb: color)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(setColor), for: .touchUpInside)
        view.addSubview(button)
    
    }
    
    func setColor(sender: UIButton) {
        
        if let color = sender.backgroundColor?.toHexString {
            cellHexColor = color
        }
        
    }
    
}

