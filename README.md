
# react-native-jm-device-wifi-activator

## Getting started

`$ npm install react-native-jm-device-wifi-activator --save`

### Mostly automatic installation

`$ react-native link react-native-jm-device-wifi-activator`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-jm-device-wifi-activator` and add `RNJmDeviceWifiActivator.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNJmDeviceWifiActivator.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.quenice.cardview.RNJmDeviceWifiActivatorPackage;` to the imports at the top of the file
  - Add `new RNJmDeviceWifiActivatorPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-jm-device-wifi-activator'
  	project(':react-native-jm-device-wifi-activator').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-jm-device-wifi-activator/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-jm-device-wifi-activator')
  	```


## Usage
```javascript
import RNJmDeviceWifiActivator from 'react-native-jm-device-wifi-activator';

// TODO: What to do with the module?
RNJmDeviceWifiActivator;
```
  