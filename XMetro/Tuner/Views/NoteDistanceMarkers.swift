import SwiftUI

struct NoteDistanceMarkers: View {
    var body: some View {
        createMarkers()
    }
    
    @ViewBuilder func createMarkers() -> some View {
        HStack {
            ForEach(0...40, id: \.self) { i in
                Rectangle()
                    .frame(width: 1, height: heightCal(i: i))
                    .foregroundColor(frontColor(i: i))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func frontColor(i: Int) -> Color {
        if i == 20 { return Theme.greenColor }
        if i % 5 == 0 { return Theme.grayColorCD }
        return Theme.grayColorE
    }
    
    private func heightCal(i: Int) -> CGFloat {
        if i == 20 { return 68 }
        if i % 5 == 0 { return 42 }
        return 18
    }
}

struct NoteDistanceMarkers_Previews: PreviewProvider {
    static var previews: some View {
        NoteDistanceMarkers().previewLayout(.sizeThatFits)
    }
}
