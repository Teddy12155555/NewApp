import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage




struct Profile : View {
    
    @EnvironmentObject var obs:Observer
    @State var name = ""
    @State var pass = ""
    @State var sex  = ""
    
    
    @State private var showingAlert = false
    @State var AlertMessage:String = ""
    @State var AlertTitle:String = ""
    
    
    var db = Firestore.firestore()
    
    @State var picker = false
    @State var ImageData : Data = .init(count: 0)
    var storage = Storage.storage().reference()

    func updateProfile(image:String){
        if(self.AlertTitle != "更新成功"){
            return
        }
        self.db.collection("users").document(self.obs.__THIS__.Uid).updateData([
            "image": image
        ])
        self.obs.__THIS__.Image_ = image
        
    }
    
    @State var age = ""
    @State var intro = ""
    
    func updateProfile(name:String,age:String,sex:String,intro:String){
        if(self.AlertTitle != "更新成功"){
            return
        }

        self.db.collection("users").document(self.obs.__THIS__.Uid).updateData([
            "name": name,
            "age": age,
            "sex": sex,
            "intro" : intro,
        ])
        self.obs.__THIS__.Name = name
        self.obs.__THIS__.Age = age
        self.obs.__THIS__.Sex = sex
        self.obs.__THIS__.Intro  = intro
    }
    
    
    init(name:String,image:String, age:String,sex:String,intro:String){
        print("name:" + name)
        print("image:" + image)

        self._name = State(initialValue: name ?? "")
        self._age = State(initialValue: age ?? "18")
        self._sex = State(initialValue: sex ?? "Male")
        
        
        self._intro = State(initialValue: intro ?? "")
        var bufData:Data = .init(count:0)
        // 2
         let _url = URL(string: image)!
        if let data = try? Data(contentsOf: _url) {
            print("get init imagedata!!")
            bufData = data
        }
        self._ImageData = State(initialValue: bufData)
        print(self.ImageData)
        
    }
    
    var body : some View{
        
        VStack{
            
            VStack(alignment: .center){
                
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
                    
                    
                }.frame(width: 100, height: 100,alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,style: StrokeStyle(lineWidth: 3, dash: [10] ))
                ).background(Color("Color11")).cornerRadius(10)
                
                Divider()
            }.sheet(isPresented: $picker,content: {
                ImagePicker(picker: self.$picker, imagedata: self.$ImageData)
                
            })
            
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    
                    Text("Name").font(.headline).fontWeight(.heavy).foregroundColor(Color.white.opacity(0.75))
                    
                    HStack{
                        
                        TextField("請輸入要更改的名稱", text: $name)
                            .padding(12)
                            .background(Color.white).cornerRadius(20)
                            .background(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.black)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 5))
                        
                        
                    }
                    
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    
                    Text("Age").font(.headline).fontWeight(.heavy).foregroundColor(Color.white.opacity(0.75))
                    
                    TextField("請輸入你的年齡", text: $age)
                        .padding(12)
                        .background(Color.white).cornerRadius(20)
                        .background(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 5))
                    
                    Divider()
                }
                
                VStack(alignment: .leading){
                    
                    Text("自我介紹").font(.headline).fontWeight(.heavy).foregroundColor(Color.white.opacity(0.75))
                    
                    TextField("請輸入自我介紹", text: $intro)
                        .padding(12)
                        .background(Color.white).cornerRadius(20)
                        .background(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 5))
                    
                    Divider()
                }

                
                
                
                VStack(alignment: .leading){
                    
                    Text("Sex").font(.headline).fontWeight(.heavy).foregroundColor(Color.white.opacity(0.75))
                    
                    
                    HStack{
                        Button(action: {
                            
                            self.sex = "Male"
                           
                        }){
                            Text("男生").foregroundColor(.gray).padding().frame(width: 120,height: 40)
                        }.background(sex == "Female" ? Color.init("Color12") : Color.white)
                        .cornerRadius(40)
                        .shadow(radius: 25)
                            .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.init("Color3"),lineWidth: 3)).padding(.horizontal,20)
                        
                        Button(action: {
                            
                            self.sex = "Female"
                        }){
                            Text("女生").foregroundColor(.gray).padding().frame(width: 120,height: 40)
                        }.background(sex == "Male" ?Color.init("Color12")  : Color.white )
                        .cornerRadius(40)
                        .shadow(radius: 25)
                            .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.init("Color3"),lineWidth: 3)).padding(.horizontal,20)
                        
                            
                    }.padding(.bottom,30)
                    
                    Divider()
                }
                
                
                
                
                
            }.padding(.horizontal, 6)
            
            
            VStack{
                
                Button(action: {
                    self.showingAlert = true
                    self.AlertMessage = ""
                    self.AlertTitle = ""
                    if(self.name == ""){
                        //                        alert
                        self.showingAlert = true
                        self.AlertMessage = "名字不能是空的喔"
                        self.AlertTitle = "更新個人資訊錯誤"
                        print("name cant not be empty")
                    }
                    
                    if(self.intro == ""){
                        //                        alert
                        self.showingAlert = true
                        self.AlertMessage = "自我介紹不能是空的喔"
                        self.AlertTitle = "更新個人資訊錯誤"
                        print("name cant not be empty")
                    }
                    
                    if(self.age == ""){
                        self.showingAlert = true
                        self.AlertTitle = "更新個人資訊錯誤"

                        self.AlertMessage = "年齡不能是空的喔"
                        print("age cant not be empty")

                    }
                    
                    if self.ImageData.count == 0{
                        self.showingAlert = true
                        self.AlertTitle = "更新個人資訊錯誤"
                        self.AlertMessage = "圖片不能是空的歐"

                        print("Error with Img")
                        return
                    }
                    
                    if(self.AlertTitle == "" && self.AlertMessage == ""){
                        self.AlertTitle = "更新成功"
                        self.AlertMessage = "更新個人資訊成功"
                        self.showingAlert = true

                    }
                    
                    // Create New users insert to DB
                    let IMAGE_ROOT = "profilePic"
                    
                    let uid = Auth.auth().currentUser?.email
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
                            
                            
                            self.updateProfile(image: "\(url!)")
                            
//                            self.Image_ = "\(url!)"
                            print("Successed with URL : \(url!)")
                        }
                        
                    }
                    
                    self.updateProfile(name: self.name,age:self.age,sex:self.sex,intro: self.intro)
                    
                    
                }) {
                    
                    Text("送出").fontWeight(.heavy).foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                    .cornerRadius(40)
                    .shadow(radius: 25)
                        .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.init("Color3"),lineWidth: 3)).padding(.horizontal,20)
                    
                    
                }.background(Color("bg"))
                    .clipShape(Capsule())
                    .padding(.top, 45)
                    .alert(isPresented: $showingAlert){
                        Alert(title: Text(self.AlertTitle), message: Text(self.AlertMessage), dismissButton: .default(Text("OK")))
                }
                
                
                
                
            }
            
            
        }.padding()
    }
}


