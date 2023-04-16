import SwiftUI

import Domain

struct QuoteView: View {
  private let quote: Quote
  private let upvote: () -> Void
  private let downvote: () -> Void
  private let clearvote: () -> Void
  private let favorite: () -> Void
  private let unfavorite: () -> Void

  init(
    quote: Quote,
    upvote: @escaping () -> Void,
    downvote: @escaping () -> Void,
    clearvote: @escaping () -> Void,
    favorite: @escaping () -> Void,
    unfavorite: @escaping () -> Void
  ) {
    self.quote = quote
    self.upvote = upvote
    self.downvote = downvote
    self.clearvote = clearvote
    self.favorite = favorite
    self.unfavorite = unfavorite
  }

  var body: some View {
    VStack(spacing: 10) {
      Text("\"\(quote.body)\"")
        .italic()
        .font(.title3)
        .fontWeight(.medium)
        .frame(
          maxWidth: .infinity,
          alignment: .leading
        )

      Text("— \(quote.authorName)")
        .font(.headline)
        .fontWeight(.medium)
        .frame(
          maxWidth: .infinity
        )
        .foregroundColor(.accentColor)

      HStack {
        QuoteActionView(
          imageName: "arrow.up.circle\(quote.userDetails?.upvote ?? false ? ".fill" : "")",
          text: "\(quote.upvotesCount)",
          action: {
            quote.userDetails?.upvote ?? false ? clearvote() : upvote()
          }
        )

        QuoteActionView(
          imageName: "heart.circle\(quote.userDetails?.favorite ?? false ? ".fill" : "")",
          text: "\(quote.favoritesCount)",
          action: {
            quote.userDetails?.favorite ?? false ? self.unfavorite() : self.favorite()
          }
        )

        QuoteActionView(
          imageName: "arrow.down.circle\(quote.userDetails?.downvote ?? false ? ".fill" : "")",
          text: "\(quote.downvotesCount)",
          action: {
            quote.userDetails?.downvote ?? false ? clearvote() : downvote()
          }
        )
      }
    }
  }
}

struct QuoteActionView: View {

  private let imageName: String
  private let text: String
  private let action: () -> Void

  init(
    imageName: String,
    text: String,
    action: @escaping () -> Void
  ) {
    self.imageName = imageName
    self.text = text
    self.action = action
  }

  var body: some View {
    Button(
      action: action,
      label: {
        HStack {
          Image(systemName: imageName)
            .resizable()
            .frame(width: 25, height: 25)

          Text(text)
            .fontWeight(.medium)
            .font(.caption)
        }
      }
    )
    .buttonStyle(.plain)
    .frame(maxWidth: .infinity)
  }
}

#if targetEnvironment(simulator) && DEBUG
struct QuoteView_Previews: PreviewProvider {
  static var previews: some View {
    List((0...5), id: \.self) { _ in
      QuoteView(
        quote: .mock,
        upvote: {},
        downvote: {},
        clearvote: {},
        favorite: {},
        unfavorite: {}
      )
    }
  }
}
#endif

