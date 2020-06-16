//
//  InfoView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/26.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct InfoView: View {
    
    @EnvironmentObject var obs : Observer
    
    @Binding var Signup:Bool
    @Binding var SignupAccount : String
    @Binding var SignupUid : String
    
    
    
    

    
    
//    @Binding var UserId:String
    
    @State var Index:Int = 0
    
    @State var Name = ""
    @State var Age = ""
    @State var Sex = "Male"
    @State var Image_ = ""
    @State var ImageData : Data = .init(count: 0)
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    
    @State var picker = false
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    func createUser(id:String , email:String , age:String , name:String , sex:String, image:String){
        print(id + "想要註冊..")
        self.db.collection("users").document(id).setData([
            "email":email,
            "age": age,
            "name": name ,
            "sex": sex,
            "image": image
        ])
        self.createMatchData(id)
    }
    
    
    
    func createMatchData(_ uid:String){
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    print(document.data())
                    if(uid != document.documentID){
                        self.db.collection("to_be_match").addDocument(data:
                            [
                                "match_status" : 0,
                                "create_time" : Date(),
                                "userA_id" : document.documentID,
                                "userA_status" : 0,
                                "userB_id" : uid,
                                "userB_status" : 0,
                                "update_time" : Date(),
                        ])
                    }
                    
                }
            }
        }
    }
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: .init(colors: [Color("Color5"),Color("Color6")]), startPoint: .top, endPoint: .bottom)
            
            if self.Index == 0{
                // Name
                VStack(alignment: .center, spacing: 15){
                
                    Text("叫啥名字").foregroundColor(.black).fontWeight(.heavy).font(.system(size: 40)).padding(.bottom,100)
                    
                    
                    VStack{
                        
                        TextField("Name",text: $Name).padding(.leading,12).font(.system(size: 20)).autocapitalization(.none).foregroundColor(.secondary)
                        
                        Divider()
                        .frame(height: 2)
                        .padding(.horizontal, 30)
                            .background(Color.gray)
                        
                        Button(action: {
                            
                            if self.Name != ""{
                                self.Index += 1
                            }
                       
                        }){
                            Text("下一步").foregroundColor(.white).padding().frame(width: 200,height: 40)
                        }.background(LinearGradient(gradient: .init(colors: [Color("Color9"),Color("Color10")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .offset( y: 15)
                        .shadow(radius: 25)
                        
                    }.padding(12)
                    
                    
                    
                }.padding(.horizontal,18).offset( y: 15)
            }
            else if self.Index == 1{
                // Age
                VStack(alignment: .center, spacing: 15){
                
                    Text("幾歲").foregroundColor(.black).fontWeight(.heavy).font(.system(size: 40)).padding(.bottom,100)
                    
                    
                    VStack{
                        
                        TextField("Age",text: $Age).padding(.leading,12).font(.system(size: 20)).autocapitalization(.none).foregroundColor(.secondary)
                        
                        Divider()
                        .frame(height: 2)
                        .padding(.horizontal, 30)
                            .background(Color.gray)
                        
                        Button(action: {
                            if self.Age == ""{
                                print("Input Error, Nil value")
                            }
                            else{
                                if Int(self.Age) == nil {
                                    print("Input Error, Not a Number")
                                    
                                }else{
                                    self.Index += 1
                                }
                            }
                            
                        }){
                            Text("下一步").foregroundColor(.white).padding().frame(width: 200,height: 40)
                        }.background(LinearGradient(gradient: .init(colors: [Color("Color9"),Color("Color10")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .offset( y: 15)
                        .shadow(radius: 25)
                        
                    }.padding(12)
                    
                    
                    
                }.padding(.horizontal,18).offset( y: 15)
                
            }
            else if self.Index == 2{
                // Sex
                
                VStack(alignment: .center, spacing: 15){
                
                    Text("性別").foregroundColor(.black).fontWeight(.heavy).font(.system(size: 40)).padding(.bottom,70)
                    
                    
                    VStack{
                        
                        HStack{
                            Button(action: {
                                
                                self.Sex = "Male"
                               
                            }){
                                Text("男生").foregroundColor(.gray).padding().frame(width: 120,height: 40)
                            }.background(Sex == "Female" ? Color.white : Color.init("Color4"))
                            .cornerRadius(40)
                            .shadow(radius: 25)
                                .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.init("Color3"),lineWidth: 3)).padding(.horizontal,20)
                            
                            Button(action: {
                                
                                self.Sex = "Female"
                            }){
                                Text("女生").foregroundColor(.gray).padding().frame(width: 120,height: 40)
                            }.background(Sex == "Male" ? Color.white : Color.init("Color4"))
                            .cornerRadius(40)
                            .shadow(radius: 25)
                                .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.init("Color3"),lineWidth: 3)).padding(.horizontal,20)
                            
                                
                        }.padding(.bottom,30)
                        
                    
                        
                        Button(action: {
                            
                            // Create New users insert to DB
                            //self.db.collection("users").document("\(self.UserId)").setData(["age":"\(self.Age)","name":"\(self.Name)","sex":"\(self.Sex)","image":""])
                            
                            //self.Signup = false
                            self.Index += 1
                            
                        }){
                            Text("下一步").foregroundColor(.white).padding().frame(width: 200,height: 40)
                        }.background(LinearGradient(gradient: .init(colors: [Color("Color9"),Color("Color10")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .offset( y: 15)
                        .shadow(radius: 25)
                        
                    }.padding(12)
                    
                    
                    
                }.padding(.horizontal,18).offset( y: 15)
            }
            else if self.Index == 3{
                VStack(alignment: .center, spacing: 15){
                
                    Text("照片").foregroundColor(.black).fontWeight(.heavy).font(.system(size: 40))
                    VStack(spacing: 20){
                        
                        HStack( spacing: 25){
                            
                            // Image1
                            Button(action: {

                                self.picker.toggle()

                            }){

                                if ImageData.count == 0{
                                    Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width:30,height: 30)
                                    .foregroundColor(.pink).offset(x:33,y:63)
                                }
                                else{
                                    Image(uiImage:UIImage(data: ImageData)!).renderingMode(.original).resizable().frame(width: 100, height: 160)
                                }

                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                            // Image2
                            Button(action: {
                                self.showImagePicker.toggle()
                            }){
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width:30,height: 30)
                                    .foregroundColor(.pink).offset(x:33,y:63)
                                
                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                            // Image3
                            Button(action: {}){
                                
                                Image(systemName: "plus.circle.fill")
                                .resizable().frame(width:30,height: 30)
                                .foregroundColor(.pink).offset(x:33,y:63)
                                
                                
                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                        
                        }
                        HStack( spacing: 25){
                            // Image1
                            Button(action: {}){
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width:30,height: 30)
                                    .foregroundColor(.pink).offset(x:33,y:63)
                                
                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                            // Image2
                            Button(action: {}){
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width:30,height: 30)
                                    .foregroundColor(.pink).offset(x:33,y:63)
                                
                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                            // Image3
                            Button(action: {}){
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width:30,height: 30)
                                    .foregroundColor(.pink).offset(x:33,y:63)
                                
                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                        
                        }
                        HStack( spacing: 25){
                            // Image1
                            Button(action: {}){
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width:30,height: 30)
                                    .foregroundColor(.pink).offset(x:33,y:63)
                                
                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                            // Image2
                            Button(action: {}){
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width:30,height: 30)
                                    .foregroundColor(.pink).offset(x:33,y:63)
                                
                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                            // Image3
                            Button(action: {}){
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width:30,height: 30)
                                    .foregroundColor(.pink).offset(x:33,y:63)
                                
                            }.frame(width: 100, height: 160,alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                                ).background(Color("Color11")).cornerRadius(10)
                            
                        
                        }
                        
                        /*
                         This is where create data to DB
                         All main DB Operation is here
                         */
                        
                        Button(action: {
                            
                            if self.ImageData.count == 0{
                                print("Error with Img")
                                return
                            }
                            
                            // Create New users insert to DB
                            let IMAGE_ROOT = "profilePic"
                            
                            let uid = Auth.auth().currentUser?.uid
                            let metadata = StorageMetadata()
                            metadata.contentType = "image/jpeg"
                            
                            self.storage.child(IMAGE_ROOT).child("\(uid!).jpg").putData(self.ImageData, metadata:metadata){(metadata,err) in
                                if err != nil {
                                    print((err?.localizedDescription)!)
                                    return
                                }
                                
                                self.storage.child(IMAGE_ROOT).child("\(uid!).jpg").downloadURL{(url,err) in
                                    if err != nil{
                                        print((err?.localizedDescription)!)
                                        return
                                    }
                                    // Create self as a new user
                                    print(self.SignupUid)
                                    
                                    
                                    self.createUser(id: self.SignupUid, email: self.SignupAccount, age: self.Age, name: self.Name, sex: self.Sex, image: "\(url!)")
                                    
                                    self.Image_ = "\(url!)"
                                    print("Successed with URL : \(url!)")
                                }
                                
                            }
                            
                            self.Signup = false
                            
                        }){
                            Text("完成").foregroundColor(.white).padding().frame(width: 180,height: 30)
                        }.background(LinearGradient(gradient: .init(colors: [Color("Color9"),Color("Color10")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(30)
                        .shadow(radius: 25)
                            .offset(y:-10)
                        
                    }.padding(10)
                    
                    }.padding(.horizontal,18)
                    .sheet(isPresented: $picker,content: {
                        
                        ImagePicker(picker: self.$picker, imagedata: self.$ImageData)
                        
                    })
            }
            
        }
    }
}

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var picker : Bool
    @Binding var imagedata : Data
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent1 : ImagePicker) {
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            //let image = info[] as! UIImage
            let image = info[.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.45)
            
            self.parent.imagedata = data!
            
            self.parent.picker.toggle()
        }
        
    }
}
