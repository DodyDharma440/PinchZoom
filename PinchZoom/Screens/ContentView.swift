//
//  ContentView.swift
//  PinchZoom
//
//  Created by Dodi Aditya on 27/04/23.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State private var isAnimating: Bool = false
    @State private var isDrawerOpen: Bool = false
    
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    let pages: [Page] = pagesData
    @State private var pageId: Int = 0
    
    // MARK: - FUNCTION
    
    func resetImageState() {
        withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentImage() -> String {
        if let page = pages.first(where: {$0.id == pageId}) {
            return page.imageName
        } else {
            return ""
        }
    }
    
    // MARK: - CONTENT
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                
                // MARK: - IMAGE
                Image(currentImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .scaleEffect(imageScale)
                // MARK: - DOUBLE TAP GESTURE
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    })
                // MARK: - DRAG GESTURE
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            withAnimation(.linear(duration: 1)) {
                                imageOffset = gesture.translation
                            }
                        }
                        .onEnded { _ in
                            if imageScale == 1 {
                                resetImageState()
                            }
                        }
                    ) // Gesture
                // MARK: - MAGNIFICATION
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
            } // ZStack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                isAnimating = true
            })
            // MARK: - INFO PANEL
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            // MARK: - CONTROLS
            .overlay(
                Group {
                    HStack {
                        // Scale Down
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // Reset
                        Button {
                            withAnimation(.spring()) {
                                resetImageState()
                            }
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // Scale Up
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1).delay(1), value: isAnimating)
                } // Group
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            // MARK: - DRAWER
            .overlay(
                HStack(spacing: 12) {
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        })
                    // MARK: - THUMBNAILS
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .offset(y: page.id == pageId ? -8 : 0)
                            .animation(.easeOut, value: isDrawerOpen)
                            .animation(.spring(), value: pageId)
                            .onTapGesture(perform: {
                                isAnimating = true
                                pageId = page.id
                            })
                    }
                    Spacer()
                } // HStack
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                , alignment: .topTrailing
            )
        } // Navigation
        .navigationViewStyle(.stack)
        .onAppear(perform: {
            if pageId == 0 {
                pageId = pages[0].id
            }
        })
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
