//
//  SomeCollectionReusableView.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

class SomeCollectionReusableView: UICollectionReusableView {
    
    
    @IBOutlet var personImage: UIImageView!
    @IBOutlet var firstname: UILabel!
    @IBOutlet var lastname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(personLastname: String, personFirstname: String, personImage: String) {
        self.lastname.text = personLastname
        self.firstname.text = personFirstname
        let url = URL(string: personImage)
        let data = try? Data(contentsOf: url!)
        self.personImage.image = UIImage(data: data!)
        
    }
    
}
