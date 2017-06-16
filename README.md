# FirstFramework

## Installation with CocoaPods

 You can install it with the following command:

```bash
$ gem install cocoapods
```


#### Podfile

Specify it in your `Podfile`:

```ruby

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/marian19/FirstFramework.git'
platform :ios, '9.0'

target 'TargetName' do

use_frameworks!
pod 'FirstFramework'

end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### TasksManager

`TasksManager` creates and manages an `NSURLSession` object .

#### Creating Data Task

```objective-c
[[TasksManager sharedTasksManager] dataTaskWithURL:@"http://example.com" method:HTTPRequestGET withParameters:nil successCompletionHandler:^(NSData* responseData) {

} failureCompletionHandler:^(NSError *error) {


}];
```

### UIImageView+FirstFramework

`setImageWithURL` is a method that allows images to be downloaded asynchronously and shows an activity indicator While the image is being downloaded. 

```objective-c
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

[self.imageview setImageWithURL:@"http://example.com/image.jpg"];
```

