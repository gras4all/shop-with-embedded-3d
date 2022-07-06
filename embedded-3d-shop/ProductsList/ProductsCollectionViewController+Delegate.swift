//
//  ProductsCollectionViewController+Delegate.swift
//
//
//  Created by Andrey Grunenkov on 27.05.2020.
//  Copyright © 2020 Andrey Grunenkov. All rights reserved.
//

import UIKit

extension ProductsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - sideInset * 3) / 2
        return CGSize(width: width, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sideInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sideInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sideInset, left: sideInset, bottom: 0, right: sideInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = Storage.products[indexPath.section][indexPath.item]
        let detailViewController = ProductDetailViewController(product: product)
        detailViewController.delegate = self
        detailViewController.onSelectDevice = { receivedDevice in
            print(receivedDevice)
        }
        self.present(detailViewController, animated: true, completion: nil)
    }
}

extension ProductsCollectionViewController: AddToCartButtonDelegate {
    
    func didTapAddToCartButton(_ product: Product) {
        print(product)
    }
}

private extension ProductsCollectionViewController {
    
    var sideInset: CGFloat { return 8 }
    
}
