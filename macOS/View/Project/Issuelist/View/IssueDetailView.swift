//
//  IssueDetailView.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/09/01.
//

import SwiftUI
import Kingfisher

struct IssueDetailView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @Binding var currentIssue: Issue?
    @ObservedObject var viewModel = IssueDetailViewModel()
    
    @State private var isEditing = false
    @State private var isShowComments = false
    
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isEditing {
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text(title)
                            Spacer()
                            Image(system: .edit)
                                .onTapGesture {
                                    self.isEditing = false
                                }
                            Image(system: .xmark)
                                .onTapGesture {
                                    withAnimation {
                                        self.currentIssue = nil
                                    }
                                }
                        }
                        
                        VStack(spacing: 10) {
                            TextField("제목", text: $viewModel.title)
                                .font(.title)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            HStack {
                                Text("이슈 설명")
                                Spacer()
                                if self.viewModel.isBody {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isBody = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isBody = true
                                        }
                                }
                            }
                            
                            if viewModel.isBody {
                                TextField("설명", text: $viewModel.body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.all, 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(Asset.black), lineWidth: 1)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text("이슈 상태")
                                Spacer()
                                Image(system: .xmark)
                                    .onTapGesture {
                                        self.viewModel.state = nil
                                    }
                            }
                            
                            IssueFilterStateView(state: $viewModel.state)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text("이슈 마감일")
                                Spacer()
                                if  self.viewModel.isDate {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isDate = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isDate = true
                                        }
                                }
                                
                            }
                            
                            if self.viewModel.isDate {
                                DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .clipped()
                                    .labelsHidden()
                            }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text("이슈 진행도")
                                if  self.viewModel.isProgress {
                                    
                                    HStack(spacing: 0) {
                                        Text(String(viewModel.progress))
                                        Text("%")
                                    }
                                    .foregroundColor(.blue)
                                }
                                Spacer()
                                if self.viewModel.isProgress {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isProgress = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isProgress = true
                                        }
                                }
                                
                            }
                            
                            if self.viewModel.isProgress {
                                HStack {
                                    Button(action: {
                                        if viewModel.progress > 0 {
                                            viewModel.progress -= 10
                                        }
                                    }, label: {
                                        Image(system: .minus)
                                            .padding()
                                    }).buttonStyle(PlainButtonStyle())
                                    
                                    ProgressView(value: viewModel.progress, total: 100)
                                    
                                    Button(action: {
                                        if viewModel.progress < 100 {
                                            viewModel.progress += 10
                                        }
                                    }, label: {
                                        Image(system: .plus)
                                            .padding()
                                    }).buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("이슈 대상자")
                                Spacer()
                                if  self.viewModel.isUser {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isUser = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isUser = true
                                        }
                                }
                            }
                            
                            if self.viewModel.isUser {
                                if viewModel.users.isEmpty == false {
                                    LazyVStack(alignment: .leading) {
                                        ForEach(0...viewModel.users.count - 1, id: \.self) { index in
                                            IssueUserRow(user: viewModel.users[index])
                                                .onTapGesture {
                                                    viewModel.users[index].isSelected.toggle()
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("태그")
                                Spacer()
                                if  self.viewModel.isTag {
                                    Image(system: .xmark)
                                        .onTapGesture {
                                            self.viewModel.isTag = false
                                        }
                                } else {
                                    Image(system: .plus)
                                        .onTapGesture {
                                            self.viewModel.isTag = true
                                        }
                                }
                            }
                            
                            if self.viewModel.isTag {
                                HStack(spacing: 20) {
                                    TextField("새 태그 추가", text: $viewModel.newTag)
                                    
                                    Text("추가")
                                        .foregroundColor(Color(Asset.black))
                                        .padding(.all, 5)
                                        .padding(.horizontal, 10)
                                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                                        .onTapGesture {
                                            viewModel.tags.append( SelectIssueTag(tag: IssueTag(tag: viewModel.newTag)))
                                            viewModel.newTag = ""
                                        }
                                }
                                
                                if viewModel.tags.isEmpty == false {
                                    LazyVStack(alignment: .leading) {
                                        ForEach(0...viewModel.tags.count - 1, id: \.self) { index in
                                            HStack {
                                                Text("# \(viewModel.tags[index].tag)")
                                                    .padding(.all, 10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10).foregroundColor(.clear).border(Color.gray.opacity(0.5))
                                                    )
                                                Spacer()
                                                if viewModel.tags[index].isSelected {
                                                    Image(system: .checkmark)
                                                }
                                            }.onTapGesture {
                                                viewModel.tags[index].isSelected.toggle()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer(minLength: 0)
                
                HStack {
                    Text("취소")
                        .padding(.all, 10)
                        .padding(.horizontal, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.black), lineWidth: 1)
                        )
                        .onTapGesture {
                            self.isEditing = false
                        }
                    
                    Spacer()
                    
                    Text("확인")
                        .padding(.all, 10)
                        .padding(.horizontal, 5)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                        .onTapGesture {
                            self.isEditing = false
                            self.viewModel.apply(.change(id: self.currentIssue!.id))
                        }
                }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text(title)
                            Spacer()
                            Image(system: .edit)
                                .onTapGesture {
                                    self.isEditing = true
                                }
                            Image(system: .xmark)
                                .onTapGesture {
                                    withAnimation {
                                        self.currentIssue = nil
                                    }
                                }
                        }
                        
                        if currentIssue?.content != nil {
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("이슈 설명")
                                    Spacer(minLength: 0)
                                }
                                
                                HStack {
                                    Text(currentIssue!.content!).foregroundColor(.gray)
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                        
                        if currentIssue?.state != nil {
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("이슈 상태")
                                    Spacer(minLength: 0)
                                }
                                
                                switch currentIssue!.state {
                                case IssueState.ready.rawValue:
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("Ready")
                                        Spacer(minLength: 0)
                                    } .foregroundColor(.blue)
                                case IssueState.progress.rawValue:
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("In Progress")
                                        Spacer(minLength: 0)
                                    }.foregroundColor(.gray)
                                default:
                                    HStack {
                                        Circle().frame(width: 10, height: 10)
                                        Text("Done")
                                        Spacer(minLength: 0)
                                    }.foregroundColor(.green)
                                }
                            }
                        }
                        
                        if currentIssue?.endDate != nil {
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("이슈 마감일")
                                    Spacer(minLength: 0)
                                }
                                
                                HStack {
                                    Text(currentIssue!.endDate!)
                                        .foregroundColor(.red)
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                        
                        if currentIssue?.progress != nil {
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("이슈 진행도")
                                    Text("\(String(currentIssue!.progress!))%")
                                        .foregroundColor(.blue)
                                }
                                
                                ProgressView(value: Double(currentIssue!.progress!), total: 100)
                            }
                        }
                        
                        if currentIssue?.users != nil {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("이슈 대상자")
                                    Spacer()
                                }
                                
                                if currentIssue!.users.isEmpty {
                                    HStack {
                                        Text("비어 있음").foregroundColor(.gray)
                                        Spacer()
                                    }
                                } else {
                                    ScrollView {
                                        LazyVStack(alignment: .leading) {
                                            ForEach(currentIssue!.users, id: \.self) { user in
                                                UserBorderRow(user: user)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if currentIssue?.tags != nil {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("태그")
                                    Spacer()
                                }
                                
                                if currentIssue!.tags.isEmpty {
                                    HStack {
                                        Text("비어 있음").foregroundColor(.gray)
                                        Spacer()
                                    }
                                } else {
                                    ScrollView {
                                        LazyVStack(alignment: .leading) {
                                            ForEach(currentIssue!.tags, id: \.self) { tag in
                                                Text("# \(tag.tag)")
                                                    .padding(.all, 10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10).foregroundColor(.clear).border(Color.gray.opacity(0.5))
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if currentIssue?.comments?.isEmpty != nil {
                        HStack {
                            Text("댓글")
                            Group {
                                if self.isShowComments {
                                    Image(system: .upArrow)
                                } else {
                                    Image(system: .downArrow)
                                }
                            }.onTapGesture {
                                self.isShowComments.toggle()
                            }
                        }
                        
                        if self.isShowComments {
                            LazyVStack(alignment: .leading) {
                                ForEach(currentIssue!.comments!, id: \.self) { comment in
                                    HStack {
                                        VStack {
                                            KFImage(URL(string: comment.user.imageURL))
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            Text(comment.user.name)
                                        }
                                        
                                        Text(comment.content)
                                    }
                                }
                            }
                            HStack(spacing: 20) {
                                TextField("댓글 작성", text: $viewModel.newComment)
                                
                                Text("확인")
                                    .foregroundColor(Color(Asset.black))
                                    .padding(.all, 5)
                                    .padding(.horizontal, 10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                                    .onTapGesture {
                                        viewModel.apply(.addComment(id: currentIssue!.id))
                                    }
                            }
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                HStack {
                    Spacer()
                    Text("삭제")
                        .foregroundColor(Color(Asset.black))
                        .padding(.all, 10)
                        .padding(.horizontal, 10)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                        .onTapGesture {
                            withAnimation {
                                self.homeVM.toast = .issueDelete(execute: {
                                    self.viewModel.apply(.delete(id: currentIssue!.id))
                                    
                                    self.currentIssue = nil
                                })
                            }
                        }
                }
            }
        }.padding()
            .padding(.leading, 10)
            .onAppear {
                self.viewModel.setForUpdate(issue: self.currentIssue)
            }.onChange(of: self.currentIssue, perform: {
                newIssue in
                self.viewModel.setForUpdate(issue: newIssue)
            })
    }
}

struct UserBorderRow: View {
    let user: IssueUser
    var body: some View {
        HStack {
            KFImage(URL(string: user.imageURL))
                .resizable()
                .frame(width: 20, height: 20)
            Text(user.name)
        }.padding(.all, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 10).foregroundColor(.clear).border(Color.gray.opacity(0.5))
            )
    }
}

struct IssueDeleteView: View {
    let execute: () -> Void
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("메세지를 삭제하시겠습니까?")
                .fontWeight(.bold)
                .font(.title)
            
            Text("한 번 삭제하면 다시 복구할 수 없습니다.")
            
            HStack(spacing: 15) {
                Spacer()
                Text("취소")
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(Asset.black), lineWidth: 1)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
                
                Text("삭제")
                    .foregroundColor(Color(Asset.black))
                    .padding(.all, 10)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                    .onTapGesture {
                        self.execute()
                        withAnimation {
                            self.homeVM.toast = nil
                        }
                    }
            }
        }.padding()
            .padding(.all, 10)
    }
}

struct IssueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetailView(currentIssue: .constant(nil), title: "이슈1")
            .frame(width: 300)
            .environmentObject(HomeViewModel())
    }
}
