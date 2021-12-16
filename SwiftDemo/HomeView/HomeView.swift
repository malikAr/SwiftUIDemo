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
            PhotoView( photo: photo, isExpanded: self.selection.contains(photo))
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
    let imageSize: CGFloat = 70

    @StateObject var viewModelImageLoader:ImageLoader

    init(photo:PhotoModel,isExpanded:Bool){
        self.photo = photo
        self.isExpanded = isExpanded
        self._viewModelImageLoader = StateObject(wrappedValue: ImageLoader())
    }

    
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
                if viewModelImageLoader.thumbnailImage != nil{
                    Image(uiImage: viewModelImageLoader.thumbnailImage!)
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .scaledToFit()
                        .cornerRadius(4)
                }
                else {
                   ProgressView()
                        .frame(width: imageSize, height: imageSize)
                }

                VStack(alignment: .leading, spacing: 5){
                Text(photo.title)
                }
            }
            
            if isExpanded {
                VStack(alignment: .center ) {
                    if viewModelImageLoader.image != nil{
                        Image(uiImage: viewModelImageLoader.image!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                            .cornerRadius(4)
                            .clipped()
                    }
                    else {
                       ProgressView()
                            .frame(width: imageSize, height: imageSize)
                    }
                }.onAppear{
                    self.viewModelImageLoader.getImage(urlString:photo.thumbnailUrl)
                }
            }
        }
        .onAppear{
            self.viewModelImageLoader.getThumbnail(urlString: photo.url)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



