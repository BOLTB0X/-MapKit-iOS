//
//  ActionSheet.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/16/24.
//

import SwiftUI

struct ActionSheet: View {
    @State private var isPresentingConfirm: Bool = false
        
        var body: some View {
            Button("Delete", role: .destructive) {
                isPresentingConfirm = true
            }
            .confirmationDialog("Are you sure?",
                                isPresented: $isPresentingConfirm) {
                Button("삭제 / 저장 해제", role: .destructive) {
                    // 삭제 / 저장 해제 로직 추가
                }

                // 캔슬 버튼 레이블 한글로 변경
                Button("취소", role: .cancel) {}
            }
        }
}

#Preview {
    ActionSheet()
}
