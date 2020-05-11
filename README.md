***Add shadow and rounded corners to any UIView effortlessly***

## Usage: ##

Add the extension class to your project and that's it....

```
let sampleView = UIView()
sampleView.addRoundedCorner(with: 20, at: [.allCorners])

sampleView.addShadowWith(shadowColor: .black, offSet: CGSize(width: 1, height: 1), opacity: 0.12, shadowRadius: 15.0, shadowSides: .topLeftRight, fillColor: .white, radius: 10.0, corners: [.topLeft,.topRight])
```

**Supported ShadowPositions**
- topBottom
- leftRight
- topLeftRight
- bottomLeftRight
- all
