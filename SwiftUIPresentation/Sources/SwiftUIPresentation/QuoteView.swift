import SwiftUI

import Domain

struct QuoteView: View {
  private let quote: Quote
  private let update: (QuoteRepository.UpdateQuoteType) -> Void

  init(
    quote: Quote,
    update: @escaping (QuoteRepository.UpdateQuoteType) -> Void
  ) {
    self.quote = quote
    self.update = update
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
            quote.userDetails?.upvote ?? false ? update(.clearvote) : update(.upvote)
          }
        )

        QuoteActionView(
          imageName: "heart.circle\(quote.userDetails?.favorite ?? false ? ".fill" : "")",
          text: "\(quote.favoritesCount)",
          action: {
            quote.userDetails?.favorite ?? false ? update(.unfav) : update(.fav)
          }
        )

        QuoteActionView(
          imageName: "arrow.down.circle\(quote.userDetails?.downvote ?? false ? ".fill" : "")",
          text: "\(quote.downvotesCount)",
          action: {
            quote.userDetails?.downvote ?? false ? update(.clearvote) : update(.downvote)
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
        update: { _ in }
      )
    }
  }
}
#endif

