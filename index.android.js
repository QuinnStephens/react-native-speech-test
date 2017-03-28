import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';
import Home from './Home'

export default class SpeechTest extends Component {

  render() {
    return (
      <Home/>
    )
  }
}

AppRegistry.registerComponent('SpeechTest', () => SpeechTest);
