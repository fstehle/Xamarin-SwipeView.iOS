# Xamarin SwipeView.iOS

MonoTouch (Xamarin.iOS) bindings for [SwipeView](https://github.com/nicklockwood/SwipeView)

## Requirements

* iOS SDK
* [Xamarin Studio](https://xamarin.com/studio)
* Cocoapods
* Make
* NuGet (optional for packaging)

## Building the bindings

Just run

	make

This downloads sources via CocoaPods, creates the static objective-c library and finally creates a .dll-file.

## Creating the NuGet package

Run

	make package

## Pushing the NuGet package to a private feed

Setup a private NuGet feed, for example on [myget](https://www.myget.org/).
Push the package to the feed source:

	nuget push SwipeView.iOS.$(version).nupkg -Source "$(source_url)" -ApiKey "$(api_key)"

