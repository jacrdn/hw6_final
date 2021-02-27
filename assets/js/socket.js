import {Socket} from "phoenix";

let state = {

  // the game we log into
  name: "",

  bulls1: 0,
  cows1: 0,
  lastGuess1: [],

  bulls2: 0,
  cows2: 0,
  lastGuess2: [],

  bulls3: 0,
  cows3: 0,
  lastGuess3: [],

  bulls4: 0,
  cows4: 0,
  lastGuess4: [],
};

let socket = new Socket(
  "/socket",
  {params: {token: state.name}}
);
socket.connect();

console.log(state.name);
let channel = socket.channel("game:", {});


let callback = null;

// The server sent us a new state.
function state_update(st) {
  console.log("New state", st);
  state = st;
  if (callback) {
    callback(st);
  }
}

export function ch_join(cb) {
  callback = cb;
  callback(state);
}

export function ch_login(name) {
  channel = socket.channel("game:" + name, {}); // name goes here FIXME
  channel.join();
  console.log("channel: " + channel.name);
  channel.push("login", {name: name})
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to login", resp)
         });
  
}

export function ch_push(guess) {
  console.log("guess pushed to channel: " + guess)
  channel.push("guess", guess)
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to push", resp)
         });
}

export function ch_usernum(un) {
  console.log("username pushed to channel")
  channel.push("username", un)
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to push", resp)
         });
}
export function ch_reset() {
  channel.push("reset", {})
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to push", resp)
         });
}

channel.join()
       .receive("ok", state_update)
       .receive("error", resp => {
         console.log("Unable to join", resp)
       });


channel.on("view", state_update);
