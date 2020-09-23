# RuneterraDecks

Decks in Legends of Runeterra can be converted into and from a Base32 string that can be easily used to share decks with other players and game clients.
 
## Decoding & Encoding

A deck is represented by a list of card entries. Each entry specify a single card by its corresponding code and how many copies are present in the deck.

The library supports up the the Call of the Mountain (Targon) expansion set. It also supports special case decks with 4+ copies of a card.


### Decoding:

This is an example decoding my favorite Jinx & Draven deck:

```swift
import RuneterraDecks

let deckCode = "CEBAGAIDCQRSOCIBAQAQYEQ4EYTSQLJUAIAQCAYLAEAQIDIA"
let cardEntries = try? DeckDecoder.decode(deckCode)
```

### Encoding:

To encode a deck, just create an `Entry` array for the cards and pass is to the encoder:

```swift
import RuneterraDecks

// Add your card entries to an array in any way you like
let cards: [Entry] = [Entry(cardCode: "01NX020", count: 3), ... ] 
let code = try? DeckEncoder.encode(cards)
```


