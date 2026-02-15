//
//  ContentView.swift
//  YarukilLog
//
//  Created by 松本康秀 on 2026/02/02.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var store = LogStore()
    @State private var showAlreadyRecordedAlert = false
    @State private var isExporting = false
    @State private var exportDocument = CSVDocument(text: "")
    @State private var exportErrorMessage: String?
    @State private var showExportErrorAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("やる気の出ない日ログ")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            
                .font(.headline)
            
            HStack {
                Text("累計: \(store.dates.count)日")
                Text("今月: \(store.currentMonthCount())日")
                Text("連続: \(store.currentStreak())日")
            }
            .font(.headline)
            
            
            
            Button {
                if !store.addToday() {
                    showAlreadyRecordedAlert = true
                }
            } label: {
                Text("今日、やる気が出なかった")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            
            if store.dates.isEmpty {
                Text("まだ記録がありません")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            } else {
                List {
                    ForEach(store.dates, id: \.self) { date in
                        Text("\(date)：出なかった")
                    }
                    .onDelete(perform: store.delete)
                }
                .listStyle(.plain)
            }
        }
        .padding()
        .fileExporter(isPresented: $isExporting,
                      document: exportDocument,
                      contentType: .commaSeparatedText,
                      defaultFilename: "やる気の出ない日ログ") { result in
            if case .failure(let error) = result {
                exportErrorMessage = error.localizedDescription
                showExportErrorAlert = true
            }
        }
                      .alert("今日は既に記録済み", isPresented: $showAlreadyRecordedAlert) {
                          Button("OK", role: .cancel) {}
                      }
                      .alert("CSV出力に失敗しました", isPresented: $showExportErrorAlert) {
                          Button("OK", role: .cancel) {}
                      } message: {
                          Text(exportErrorMessage ?? "不明なエラーが発生しました。")
                      }

    
    
    Button {
        exportDocument = CSVDocument(text: store.csvText())
        isExporting = true
    } label: {
        Label("CSV出力", systemImage: "square.and.arrow.up")
            .frame(maxWidth: .infinity)
    }
    .controlSize(.regular)
    .buttonStyle(.bordered)
    
    }
    
    ///ここに広告を入れるかも
    
    
    
    
}

#Preview {
    ContentView()
}
