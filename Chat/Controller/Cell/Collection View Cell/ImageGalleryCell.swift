//
//  ImageGalleryViewCell.swift
//  Chat
//
//  Created by Ta Huy Hung on 7/14/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

protocol ImageCellDelegate {
    func delete(cell : ImageGalleryCell)
}

class ImageGalleryCell: UICollectionViewCell {
    var delegate : ImageCellDelegate?
    
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var imgGallery: UIImageView!
    
    @IBAction func deleteImageTapped(_ sender: Any) {
        delegate?.delete(cell: self)
    }
    
    public func setImage(image : UIImage){
        imgGallery.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeDeleteViewRound()
    }
    
    private func makeDeleteViewRound(){
        deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
        deleteButtonBackgroundView.layer.masksToBounds = true
    }
}
