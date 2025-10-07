//
//  ProfilePageView.swift
//  Cooksyy
//
//  Created by Nxtwave on 18/09/25.
//
import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var viewModel = GoogleAuthViewModel()

    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""

    @State private var profileImage: UIImage? = nil
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var isPhotoPickerPresented = false
    @State private var showingSaveConfirmation = false

    // MARK: - Profile Image Picker
    private var profileImageView: some View {
        Group {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
            } else if let url = viewModel.profile?.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    default:
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
        .scaledToFill()
        .frame(width: 100, height: 100)
        .clipShape(Circle())
        .shadow(radius: 4)
        .onTapGesture { isPhotoPickerPresented = true }
    }

    var body: some View {
        NavigationStack {
            Form {
                // Profile Photo
                Section(header: Text("Profile Photo")) {
                    VStack {
                        profileImageView
                        Text("Tap to change photo")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                //  Personal Details
                Section(header: Text("Personal Details")) {
                    TextField("Username", text: $username)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)

                }

                                Section {
                    Button("Save Changes") {
                        showingSaveConfirmation = true
                    }
                }
            }
            .navigationTitle("Profile Page")
            .photosPicker(isPresented: $isPhotoPickerPresented,
                          selection: $selectedPhoto,
                          matching: .images)
            .onChange(of: selectedPhoto) { oldValue, newValue in
                guard let item = newValue else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        profileImage = uiImage
                    }
                }
            }
            .onAppear {
                // Load Google profile into fields
                if let profile = viewModel.profile {
                    username = profile.name
                    email = profile.email
                }
            }
            .alert("Changes saved!", isPresented: $showingSaveConfirmation) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
#Preview {
    ProfileView()
}
