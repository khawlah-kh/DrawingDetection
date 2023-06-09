//
//  ContentView.swift
//  DrawingDetection
//
//  Created by Khawlah Khalid on 22/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var lines: [Line] = []
    @State private var selectedColor = Color.orange
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(!vm.result.isEmpty ? "Predection: \(vm.result)" : "Predection")
                    .foregroundColor( !vm.result.isEmpty ? .black : .white)
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background{
                        !vm.result.isEmpty ?
                        Color.purple.opacity(0.5) :
                        Color.clear
                    }
                    .cornerRadius(8)
                
                HStack{
                    canvas
                    
                    VStack {
                        ForEach([Color.green, .orange, .blue, .red, .pink, .black, .purple], id: \.self) { color in
                            colorButton(color: color)
                                .padding(.vertical, 4)
                        }
                        clearButton()
                        Spacer()
                    }
                    .padding(.trailing)
                    
                }
                
                Button {
                    let renderer = ImageRenderer(content: canvas.frame(width: 300, height: 300))
                    if let image = renderer.uiImage {
                        vm.drawing = image
                        vm.classify()
                    }
                } label: {
                    Text("Detect 🤔")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal,24)
                        .padding(.vertical, 8)
                        .background{
                            Color.purple
                        }
                        .cornerRadius(8)
                        .padding(.bottom)
                }
                
                Spacer()
                
            }
            .padding(.leading)
            .navigationTitle("Drawing detection")
            
        }
    }
    
    
    var canvas: some View {
        Canvas {ctx, size in
            for line in lines {
                var path = Path()
                path.addLines(line.points)
                
                ctx.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
        }
        
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    let position = value.location
                    
                    if value.translation == .zero {
                        lines.append(Line(points: [position], color: selectedColor))
                    } else {
                        guard let lastIdx = lines.indices.last else {
                            return
                        }
                        
                        lines[lastIdx].points.append(position)
                    }
                })
        )
    }
    
    
    @ViewBuilder
    func colorButton(color: Color) -> some View {
        Button {
            selectedColor = color
        } label: {
            Image(systemName: "circle.fill")
                .font(.largeTitle)
                .foregroundColor(color)
                .mask {
                    Image(systemName: "pencil.tip")
                        .font(.largeTitle)
                }
        }
    }
    
    @ViewBuilder
    func clearButton() -> some View {
        Button {
            lines = []
            vm.result = ""
        } label: {
            Image(systemName: "pencil.tip.crop.circle.badge.minus")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
