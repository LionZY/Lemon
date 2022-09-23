//
//  ActivityViewController.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/9/23.
//

import UIKit
import SwiftUI

struct ActivityVC: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityVC>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityVC>) {}
}
