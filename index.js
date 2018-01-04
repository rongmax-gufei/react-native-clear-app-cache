'use strict';
import React, { PropTypes, Component } from 'react';
import {
    DeviceEventEmitter,
    NativeModules,
    Platform,
    NativeAppEventEmitter,
    AppState
} from 'react-native'

var clearCacheModuleObj = NativeModules.ClearCacheModule;

class clear {
  constructor () {
  }

  getAppCacheSize(callBack) {
      clearCacheModuleObj.getAppCacheSize(callBack);
  }

  clearAppCache(callBack) {
      clearCacheModuleObj.clearAppCache(callBack);
  }
}
export default new clear();
