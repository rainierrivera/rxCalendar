# rxCalendar

## RxCalendar
Plain Calendar App using RxSwift

## Installation
Use the cocopods to install RxSwift and other sdks to run Calendar App.

## Architecture
MVVM with Scene as the router of the app.

## Usage
Accepting EventKit permission is required to use the app. <br />
Use the EventKitManager to create events that will integrate to native Calendar. <br />
Table rows have background color; lightgray - done event; green - ongoing event; white - future event. <br />
Editing/Deleting events will edit directly to native Event Calendar. <br />
