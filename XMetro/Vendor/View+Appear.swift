//
//  ViewWrapper.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/20.
//

import UIKit
import SwiftUI

struct WillDisappearHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let onWillDisappear: () -> Void
    func makeCoordinator() -> WillDisappearHandler.Coordinator { Coordinator(onWillDisappear: onWillDisappear) }
    func makeUIViewController(context: UIViewControllerRepresentableContext<WillDisappearHandler>) -> UIViewController { context.coordinator }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<WillDisappearHandler>) { }

    class Coordinator: UIViewController {
        let onWillDisappear: () -> Void
        init(onWillDisappear: @escaping () -> Void) {
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
    }
}

struct WillAppearHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let onWillAppear: () -> Void
    func makeCoordinator() -> WillAppearHandler.Coordinator { Coordinator(onWillAppear: onWillAppear) }
    func makeUIViewController(context: UIViewControllerRepresentableContext<WillAppearHandler>) -> UIViewController { context.coordinator }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<WillAppearHandler>) { }

    class Coordinator: UIViewController {
        let onWillAppear: () -> Void
        init(onWillAppear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
    }
}

struct didAppearHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let onDidAppear: () -> Void
    func makeCoordinator() -> didAppearHandler.Coordinator { Coordinator(onDidAppear: onDidAppear) }
    func makeUIViewController(context: UIViewControllerRepresentableContext<didAppearHandler>) -> UIViewController { context.coordinator }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<didAppearHandler>) { }

    class Coordinator: UIViewController {
        let onDidAppear: () -> Void
        init(onDidAppear: @escaping () -> Void) {
            self.onDidAppear = onDidAppear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            onDidAppear()
        }
    }
}

struct didDisappearHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let onDidDisappear: () -> Void
    func makeCoordinator() -> didDisappearHandler.Coordinator { Coordinator(onDidDisappear: onDidDisappear) }
    func makeUIViewController(context: UIViewControllerRepresentableContext<didDisappearHandler>) -> UIViewController { context.coordinator }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<didDisappearHandler>) { }

    class Coordinator: UIViewController {
        let onDidDisappear: () -> Void
        init(onDidDisappear: @escaping () -> Void) {
            self.onDidDisappear = onDidDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            onDidDisappear()
        }
    }
}

struct WillDisappearModifier: ViewModifier {
    let callback: () -> Void

    func body(content: Content) -> some View {
        content
            .background(WillDisappearHandler(onWillDisappear: callback))
    }
}

struct WillAppearModifier: ViewModifier {
    let callback: () -> Void
    func body(content: Content) -> some View {
        content
            .background(WillAppearHandler(onWillAppear: callback))
    }
}

struct didAppearModifier: ViewModifier {
    let callback: () -> Void
    func body(content: Content) -> some View {
        content
            .background(didAppearHandler(onDidAppear: callback))
    }
}

struct didDisappearModifier: ViewModifier {
    let callback: () -> Void
    func body(content: Content) -> some View {
        content
            .background(didDisappearHandler(onDidDisappear: callback))
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(WillDisappearModifier(callback: perform))
    }
    
    func onWillAppear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(WillAppearModifier(callback: perform))
    }
    
    func onDidAppear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(didAppearModifier(callback: perform))
    }

    func onDidDisappear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(didDisappearModifier(callback: perform))
    }
}
