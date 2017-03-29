import React, { Component } from 'react'
import {
  Alert,
  AppRegistry,
  NativeModules,
  StyleSheet,
  Text,
  TouchableHighlight,
  View
} from 'react-native'

async function getPermission() {
  try {
    let result = await NativeModules.SpeechManager.getPermission()
    console.log(result)
  } catch(e) {
    console.error(e)
  }
}

getPermission()

export default class Home extends Component {

  constructor(props) {
    super(props);
    
    this.toggleRecording = this.toggleRecording.bind(this)
    this.speak = this.speak.bind(this)

    this.state = { 
      intro: "Speak friend and enter",
      recording: false,
      result: ""
    }

    this.speak(this.state.intro)
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.instructions}>
          {this.state.intro}
        </Text>

        <Text style={styles.result}>
          {this.state.result}
        </Text>

        <TouchableHighlight style={this.state.recording ? styles.buttonActive : styles.button} onPress={this.toggleRecording}>
          <Text style={styles.buttonText}>
            {this.state.recording ? "Stop" : "Record"}
          </Text>
        </TouchableHighlight>
      </View>
    )
  }

  async toggleRecording() {
    this.setState({
      recording: !this.state.recording  
    })
    try{
      let result = await NativeModules.SpeechManager.toggleRecording()
      this.setState({
        result: result
      })
      this.speak(result)

      if (this.state.recording) { 
        this.setState({ recording: false }) 
      }

    } catch(e) {
      Alert.alert(
      "Sorry, I didn't catch that.",
      "Please try again!",
      [
        {text: "OK", onPress: () => {}}
      ])
    }
  }

  speak(text) {
    NativeModules.SpeechManager.speak(text)
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  instructions: {
    textAlign: 'center',
    color: '#dddddd',
    marginBottom: 5,
  },
  button: {
    backgroundColor: 'green',
    borderRadius: 8,
    margin: 12,
    padding: 24,
  },
  buttonActive: {
    backgroundColor: 'red',
    borderRadius: 8,
    margin: 12,
    padding: 24,
  },
  buttonText: {
    color: 'white',
    fontSize: 22,
  },
  result: {
    fontSize: 22,
    padding: 24,
  },
})
