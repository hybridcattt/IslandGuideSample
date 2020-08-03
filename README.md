# IslandGuideSample

This app was originally created as a demo app for a workshop that I instructed in 2019. 

These days this project is a fully working example of `UICompositionalCollectionViewLayout` 
and `NSDiffableDataSource` powering a dynamic multi-section collection view. 

I keep referring to this project myself whenever I want to remember how to get the full setup going, 
or if I hit an obscure bug that shouldn't be happening. 

Feel free to fork the project and make your own changes. 
If you notice a bug or just code that can be improved, PRs are welcome 💛

## About 

Demo app for Collection Views workshop @ [Swift Island 2019](https://swiftisland.nl). Slides: [SpeakerDeck](https://speakerdeck.com/hybridcattt/collection-views-diffable-data-sources-and-compositional-layout-workshop-at-swiftisland-2019).

Created by [Marina Gornostaeva](https://twitter.com/hybridcattt).

![the demo](demo.gif)

During the workshop we went through refactoring of this app from using
classic `UICollectionViewDataSource` and `UICollectionViewFlowLayout`
to using the new diffable data source and compositional layout.

The steps below can be checked out from separate branches in this repo.

### Part 1: Diffable Data Source

1. Simple data source
2. Creating and updating data in different ways

### Part 2: Compositional layout

3. Basic concepts of compositional layout
4. Trying out nested groups and using estimated height

### Optional excercises 

- Different layout for different size classes
- Section inset based on system layout margins
- Supplementary views, headers

## After the workshop

WWDC 2019 has two great sessions that go in depth into the new compositional layout and diffable data source.

[Advances in Collection View Layout](https://developer.apple.com/videos/play/wwdc2019/215/)

[Advances in UI Data Sources](https://developer.apple.com/videos/play/wwdc2019/220)
