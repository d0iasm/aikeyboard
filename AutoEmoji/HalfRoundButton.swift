//
//  HalfRoundButton.swift
//  AutoEmoji
//
//  Created by Asami Doi on 2023/04/09.
//

import UIKit

class HalfRoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerProperties()
    }

    private func updateLayerProperties() {
        let radius = bounds.height / 2
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
}
