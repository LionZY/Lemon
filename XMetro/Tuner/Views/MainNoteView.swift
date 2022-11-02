import SwiftUI

struct MainNoteView: View {
    let note: String
    var body: some View {
        Text(note).font(.custom("Arial-BoldMT", size: 88))
    }
}

struct MainNoteView_Previews: PreviewProvider {
    static var previews: some View {
        MainNoteView(note: "A")
            .previewLayout(.sizeThatFits)
    }
}
