//
//  CustomLayout.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

class CustomLayout: UICollectionViewLayout {
    private var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var columsCount = 4
    private let columsHeight: CGFloat = 135.0
    private var totalCellsHeight: CGFloat = .zero
    
    override func prepare() {
        super.prepare()
        cacheAttributes = [:]
        makeLayout()
    }
    
    func makeLayout() {
        guard
            let collectionView = collectionView
        else {return}
        let collectionViewElements = collectionView.numberOfItems(inSection: 0)
        let bigWidthCell = collectionView.bounds.width
        let smallWidthCell = collectionView.bounds.width / CGFloat(columsCount)
        
        var lastX: CGFloat = .zero
        var lastY: CGFloat = .zero
        
        for index in 0..<collectionViewElements {
            let indexPath = IndexPath(row: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (index + 1) % (columsCount + 1) == 0
            
            if isBigCell {
                attributes.frame = CGRect(
                    x: 0.0,
                    y: lastY,
                    width: bigWidthCell,
                    height: columsHeight)
                lastY += columsHeight
            } else {
                attributes.frame = CGRect(
                    x: 0.0,
                    y: lastY,
                    width: smallWidthCell,
                    height: columsHeight)
                
                let isLastColumn = (index + 2) % (columsCount + 1) == 0 || index == collectionViewElements - 1
                
                
                if isLastColumn {
                    lastX = .zero
                    lastY += columsHeight
                } else {
                    lastX += smallWidthCell
                }
            }
            
            cacheAttributes[indexPath] = attributes
        }
        totalCellsHeight = lastY
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cacheAttributes.values.filter{ rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(
            width: self.collectionView?.frame.width ?? 0.0,
            height: self.totalCellsHeight)
    }
    
}
    

