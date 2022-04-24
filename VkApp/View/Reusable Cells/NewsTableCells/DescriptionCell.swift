//
//  DescriptionCell.swift
//  VkApp
//
//  Created by Карим Руабхи on 15.01.2022.
//

import UIKit

//fileprivate var isPressed: Bool = false

class DescriptionCell: UITableViewCell {

    @IBOutlet var buttonShowText: UIButton!
    @IBOutlet var myDescription: UILabel!
    private var test: Int?
    private var isPressed = Bool()
    private var nextValue: Bool = false
    private var source: UpdateTableView?
    private var indexPath: IndexPath?
    
    @IBAction func buttonPressed(_ sender: Any) {
        isPressed = !isPressed  // при проверке на следующей строчке,  isPressed принимает ожидаемое значение, но в методе config значение другое... Такое ощущение, что метод конфиг срабатывает раньше, чем меняется значение isPressed, хотя при отслеживании через брейкпоинты все идет последовательно
        test = 1 // Тут присвоение 1 к свойству test, а далее в следующем методе оно равно nil
        guard let index = indexPath else { return }
        self.source?.updateTV(index: index)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//            self.source?.updateTV(index: index)
//        })
    }
    
    override func prepareForReuse() {
        
    }

    
//    @objc
//    func touchUpInside() {
//        guard let index = indexPath else { return }
//        self.source?.updateTV(index: index)
//    }
//
//    @objc
//    func touchDown() {
//        isPressed = !isPressed
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ text: String, source: UpdateTableView, _ indexPath: IndexPath) {
//        buttonShowText.addTarget(
//            self,
//            action: #selector(touchUpInside),
//            for: .touchUpInside
//        )
//
//        buttonShowText.addTarget(
//            self,
//            action: #selector(touchDown),
//            for: .touchDown
//        )
        if isPressed {
            myDescription.numberOfLines = 1000
            buttonShowText.setTitle(
                "Свернуть",
                for: .normal
            )
        } else {
            myDescription.numberOfLines = 4
            buttonShowText.setTitle(
                "Показать больше",
                for: .normal
            )
        }

        self.source = source
        if text.count > 150 {
            buttonShowText.isHidden = false
        } else {
            buttonShowText.isHidden = true
        }
        myDescription.text = text
        self.indexPath = indexPath
    }
}
