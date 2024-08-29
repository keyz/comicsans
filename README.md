# comicsans

## Install

```bash
$ brew install keyz/tap/comicsans
```

## Usage

```bash
# pass text as an argument
$ cs 'Write something here and get a png back'
File generated: ./write-something-here-and-get-a-png-back.png

# or pass text through a pipe
$ echo -n 'seems legit' | cs -
File generated: ./seems-legit.png
```

<img src="./.github/assets/write-something-here-and-get-a-png-back.png" alt="write-something-here-and-get-a-png-back.png" width="160" />

## How does it work?

Fitting text to a container is not a trivial problem. On web this can be done with an off-screen render-measure-resize loop, like [`STRML/textFit`](https://github.com/STRML/textFit) (which powers https://keyan.io/pink).

Without a browser environment we need a rendering engine with good typography support. Turns out SwiftUI's [`minimumScaleFactor`](https://developer.apple.com/documentation/swiftui/environmentvalues/minimumscalefactor) handling is pretty good at this:

1. Text goes to an off-screen SwiftUI text view, with an arbitrarily large font size and high `minimumScaleFactor`
2. SwiftUI resizes the text to fit the container
3. [`ImageRenderer`](https://developer.apple.com/documentation/swiftui/imagerenderer) rasterizes the view into a PNG bitmap

## More options

```
OVERVIEW: cs (comic sans) for :pink-slack-emoji:

Converts text to pink comic sans slack emoji. https://github.com/keyz/comicsans

USAGE: Pass text as an argument:
       $ cs 'Write something here and get a png back'

       Or pass text through a pipe:
       $ echo -n 'seems legit' | cs -

ARGUMENTS:
  <text>                  Text to convert

OPTIONS:
  -p, --padding <padding> Padding (values: 0, 4, 8, 12, 16, 20, 24) (default: 4)
  -h, --horizontal <horizontal>
                          Horizontal alignment (values: leading, center,
                          trailing; default: leading)
  -v, --vertical <vertical>
                          Vertical alignment (values: top, center, bottom;
                          default: center)
  -o, --output <output>   Output directory
  --version               Show the version.
  --help                  Show help information.
```
