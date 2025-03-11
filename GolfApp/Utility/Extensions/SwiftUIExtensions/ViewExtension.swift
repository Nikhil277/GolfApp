//
//  ViewExtension.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import SwiftUI
import UIKit
import Combine

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
    
    func onFirstAppear(_ action: @escaping () -> Void) -> some View {
        modifier(FirstAppear(action: action))
    }
    
    public func foregroundLinearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> some View {
        self.overlay(LinearGradient( colors: colors, startPoint: startPoint, endPoint: endPoint).mask(self))
    }
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func readGloabalOrigin(onChange: @escaping (CGPoint) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: OriginPreferenceKey.self, value: CGPoint(x: geometryProxy.frame(in: .global).minX, y: geometryProxy.frame(in: .global).minY))
            }
        )
        .onPreferenceChange(OriginPreferenceKey.self, perform: onChange)
    }
    
    func transparentNonAnimatingFullScreenCover<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        modifier(TransparentNonAnimatableFullScreenModifier(isPresented: isPresented, fullScreenContent: content))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func adaptsToKeyboard() -> some View {
        return modifier(AdaptsToKeyboard())
    }
    
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
          .Merge(
            NotificationCenter
              .default
              .publisher(for: UIResponder.keyboardWillShowNotification)
              .map { _ in true },
            NotificationCenter
              .default
              .publisher(for: UIResponder.keyboardWillHideNotification)
              .map { _ in false })
          .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
          .eraseToAnyPublisher()
      }
}

// MARK: - Helpers

private struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners
    
    var animatableData: Double {
        get { return radius }
        set { radius = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

private struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

private struct FirstAppear: ViewModifier {
    let action: () -> Void
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private struct OriginPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = CGPoint(x: 0, y: 0)
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

private struct TransparentNonAnimatableFullScreenModifier<FullScreenContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let fullScreenContent: () -> (FullScreenContent)
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented, { oldValue, newValue in
                UIView.setAnimationsEnabled(false)
            })
            .fullScreenCover(isPresented: $isPresented,
                             content: {
                ZStack {
                    fullScreenContent()
                }
                .background(FullScreenCoverBackgroundRemovalView())
                .onAppear {
                    if !UIView.areAnimationsEnabled {
                        UIView.setAnimationsEnabled(true)
                    }
                }
                .onDisappear {
                    if !UIView.areAnimationsEnabled {
                        UIView.setAnimationsEnabled(true)
                    }
                }
            })
    }
    
}

private struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
    
    private class BackgroundRemovalView: UIView {
        
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            superview?.superview?.backgroundColor = .clear
        }
        
    }
    
    func makeUIView(context: Context) -> UIView {
        return BackgroundRemovalView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}

private struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            withAnimation(.easeOut(duration: 0.16)) {
                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                            }
                    }
                    .map { rect in
                        rect.height - geometry.safeAreaInsets.bottom
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { _ in
                            CGFloat.zero
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}
