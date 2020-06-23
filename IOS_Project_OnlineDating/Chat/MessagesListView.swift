

import SwiftUI

let coloredNavAppearance = UINavigationBarAppearance()


struct MessagesListView: View {
    @EnvironmentObject var obs : Observer
    
    func getPairsUser()-> [User]{
        var beSortedArray = Array(self.obs.pairUsers.values)
        beSortedArray = beSortedArray.sorted(by: { self.obs.pairLastMessagesDate[$0.pairUid] ?? Date()  > self.obs.pairLastMessagesDate[$1.pairUid] ?? Date() })
        return beSortedArray

    }
    func getPairUserKeys()-> [String]{
        return Array(self.obs.pairUsers.keys)
    }
    init(){
        
    }
    
    var body : some View{
        NavigationView {
            List(getPairsUser()){i in
                
                NavigationLink(destination: ChatView(friend:i).navigationBarTitle(Text(i.name))){
                    cellView(user : i)
                }
                .navigationBarTitle(Text("Friends List"),displayMode: .inline)
            }
                .navigationBarHidden(true)

            
        }.frame(minWidth: UIScreen.main.bounds.width, idealWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width,  maxHeight: .infinity)
            .clipShape(Rounded())

    }
    
}

struct cellView : View {
    @EnvironmentObject var obser:Observer
    
    var user : User!
    var img:UIImage!
    
    init(user:User){
        self.user = user
        let url_str = self.user.image
        //        print(url_str)
        let _url = URL(string: url_str)!
        //        print(_url)
        let selfPointer = UnsafeMutablePointer(&self)
        if let data = try? Data(contentsOf: _url) {
            if let image = UIImage(data: data) {
                selfPointer.pointee.img = image
            }
        }
        
        
    }
    
    var body : some View{
        HStack(spacing: 10){
            
            // Chater Img
            Image(uiImage: self.img)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            // Chater Name and Last msg
            VStack(alignment: .leading, spacing: 10) {
                Text(user.name)
                if((self.obser.pairLastMessages[user.pairUid]) != nil){
                    Text(self.obser.pairLastMessages[user.pairUid]!).font(.caption).lineLimit(2)
                }
                
            }
            
            Spacer(minLength: 0)
            
            VStack(spacing:10){
                if(self.obser.pairLastMessagesDate[user.pairUid] != nil){
                    //                    Text(self.obser.date2String(self.obser.pairLastMessagesDate[user.pairUid]!, dateFormat: "MM/dd HH:mm"))
                    Text(self.obser.date2String(self.obser.pairLastMessagesDate[user.pairUid]!, dateFormat: "HH:mm"))
                }
                
                if(self.obser.unreadMessageCount[user.pairUid] ?? 0 > 0 ){
                    Text(String(self.obser.unreadMessageCount[user.pairUid] ?? 0)).padding(8).background(Color("Color7")).foregroundColor(.white).clipShape(Circle())
                    
                }
                
                
                
                //                已讀未讀
                
                
                Spacer()
            }
        }.padding(9)
    }
}

struct shape : Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}



struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesListView()
    }
}


struct Rounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topRight], cornerRadii: CGSize(width: 30, height: 30))
        //        55
        return Path(path.cgPath)
    }
}
