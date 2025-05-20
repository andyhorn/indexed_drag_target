# IndexedDragTarget

A Flutter package for drag-and-drop interactions with indexed slots in lists or grids. 
Easily drop widgets into specific positions with full control over slot behavior.

**Note:** 

This package is still in early development - please report bugs and submit feature 
requests on GitHub.

## Features

* Drag and drop Widgets into lists and grids
* Get notified when a Widget is dropped with the index it was dropped at
* Display and customize indicators signifying where the current Widget will 
  be dropped at

## Getting started

Install the latest version in your Flutter project.

## Usage

### Lists

This package contains three Widgets that display and order a drag target with 
a list: `IndexedDragTargetRow`, `IndexedDragTargetColumn`, and 
`IndexedDragTargetWrap`.

#### IndexedDragTargetRow and IndexedDragTargetColumn

These two Widgets display a row or column, respectively, that acts as a drag 
target. When the row or column contain other Widgets, they will be displayed 
along the respective axis. When a `Draggable` is placed over the top of the 
drag target, an indicator line will be displayed between the drag target's 
children. When the `Draggable` is released, the drag target will notify you 
with the data and the index where it was released, so that you can update the 
list of children accordingly.

Each of these Widgets exposes an API that allows you to control whether a 
certain `Draggable` is allowed to be placed at the current index.

```dart
IndexedDragTargetRow(
    // void onAccept<T>(T data, int index)
    onAccept: (data, index) {
        // get notified when a Widget, represented by its [data], is released 
        // and accepted at [index].
    },
    // bool onWillAccept<T>(T data, int index)
    onWillAccept: (data, index) {
        // do something to determine if the Widget represented by [data] is 
        // allowed to be placed at [index]. This callback is optional.
    },
    children: [
        WidgetA(),
        WidgetB(),
        WidgetC(),
    ],
),
```

### Grids

This package contains one Widget that utilizes a grid layout.

#### IndexedDragTargetGrid

This Widget is designed like a `GridView`, allowing you to set up a grid with 
a `crossAxisCount` and a list of children. Each cell of the grid is a viable 
drag target for your `Draggable`s.

Just like with `IndexedDragTargetRow` and `IndexedDragTargetColumn`, when a 
draggable item is placed over a grid cell, an indicator can be displayed in 
that cell to let the user know. When the item is released, the grid Widget 
will notify you of its targeted index.

Additionally, an API is exposed to control whether an item is allowed to be 
placed at any given cell and how to display that indicator if a Widget is 
already present.

```dart
IndexedDragTargetGrid(
    crossAxisCount: 3,
    // void onAccept<T>(T data, int index)
    onAccept: (data, index) {
        // get notified when a Widget, represented by its [data], is released 
        // and accepted at [index].
    },
    // bool onWillAccept<T>(T data, int index)
    onWillAccept: (data, index) {
        // do something to determine if the Widget represented by [data] is 
        // allowed to be placed at [index]. This callback is optional.
    },
    // Widget indicatorBuilder(BuildContext context, int index)
    indicatorBuilder: (context, index) {
        // an optional method to build a custom indicator when the cell 
        // represented by [index] is targeted.
    },
    // how to display the indicator if a child Widget is also present.
    // options are:
    //  * none (do not display the indicator)
    //  * above (stack the indicator on top of the child Widget)
    //  * and below (stack the child Widget on top of the indicator)
    indicatorStrategy: IndexedDragTargetGridIndicatorStrategy.above,
    children: [
        WidgetA(),
        null,
        null,
        WidgetB(),
        WidgetC(),
        null,
        null,
        null,
        null,
    ],
),
```
