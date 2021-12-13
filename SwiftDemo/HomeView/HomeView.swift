//
//  HomeView.swift
//  SwiftDemo
//
//  Created by Arun on 06/12/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = PhotoViewModel()
    @State var isExpanded = false
    @State private var selection: Set<PhotoModel> = []


    var body: some View {
        showList
    }
    
    
    var showList: some View {
        List(self.viewModel.photoList) { photo in
            PhotoView(photo: photo, isExpanded: self.selection.contains(photo))
                .onTapGesture { self.selectDeselect(photo)
                }
                .animation(.linear(duration: 0.3))

        }
        
        .navigationViewStyle(.stack)
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Photo")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            self.viewModel.GetPhotoList()
        }
    }

    private func selectDeselect(_ photo: PhotoModel) {
        if selection.contains(photo) {
            selection.remove(photo)
        } else {
            selection.insert(photo)
        }
    }
}


struct PhotoView: View {
    let photo: PhotoModel
    let isExpanded: Bool
    
    var body: some View {
        HStack {
            content
            Spacer()
        }
        .contentShape(Rectangle())
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: photo.thumbnailUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.purple.opacity(0.1)
                }
                .scaledToFit()
                .frame(height: 70)
                .cornerRadius(4)
                VStack(alignment: .leading, spacing: 5){
                Text(photo.title.capitalized)
                    .fontWeight(.semibold)
                    .lineLimit(3)
                    .minimumScaleFactor(0.5)
                }
            }
            
            if isExpanded {
                VStack(alignment: .center ) {
                    AsyncImage(url: URL(string: photo.url)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.purple.opacity(0.1)
                    }.padding()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(4)
                    
                }
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



