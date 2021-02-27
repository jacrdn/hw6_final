import React, { useState, useEffect } from 'react';
import 'milligram';

import { ch_join, ch_push,
         ch_login, ch_reset, ch_usernum } from './socket';

function GameOver(props) {
  //let reset = props['reset'];
  let {reset} = props;

  // On GameOver screen,
  // set page title to "Game Over!"

  return (
    <div className="row">
      <div className="column">
        <h1>Game Over!</h1>
        <p>
          <button onClick={reset}>
            Reset
          </button>
        </p>
      </div>
    </div>
  );
}

function Controls({guess, reset, state}) {
  // WARNING: State in a nested component requires
  // careful thought.
  // If this component is ever unmounted (not shown
  // in a render), the state will be lost.
  // The default choice should be to put all state
  // in your root component.
  const [text, setText] = useState("");
  const [un, setUn] = useState("");

  function updateText(ev) {
    let tx = ev.target.value;
    if (tx.length > 4) {
      tx = "";
    }
    setText(tx);
  }

  function keyPress(ev) {
    if (ev.key == "Enter") {
      guess(text);
      setText("")
    }
  }


  if(un == "") {
    return (<div className="column">
        <input type="text"
               value={un}
               onChange={(ev) => {
                 if(un == "" && (ev.target.value == "1" 
                 || ev.target.value == "2" 
                 || ev.target.value == "3" 
                 || ev.target.value == "4")) {
                    setUn(ev.target.value)
                  // } else {
                  //   setUn(un)
                  }
               }} />
               </div>)
  
        } else {
  return (
    <div className="row">
      <div className="column">
        <p>
          <input type="number"
                 value={text}
                 onChange={updateText}
                 onKeyPress={keyPress} />
        </p>
      </div>
      <div className="column">
        <p>
          <button onClick={() => {guess([un, text])
                                  setText("")}}>Guess</button>
        </p>
      </div>
      <div className="column">
        <p>
          <button onClick={reset}>
            Reset
          </button>
        </p>
      </div>
    </div>
  );
          }
}

function reset() {
  console.log("Time to reset");
  ch_reset();
}

function Play({state}) {
  let {lastGuess1, cows1, bulls1, 
    lastGuess2, cows2, bulls2, 
    lastGuess3, cows3, bulls3, 
    lastGuess4, cows4, bulls4, 
    name} = state;


  function guess(text) {
    // Inner function isn't a render function
    ch_push({gs: text});
  }

  function timer() {
    const [counter, setCounter] = React.useState(30);
  
    // Third Attempts
    React.useEffect(() => {
      const timer =
        counter > 0 && setInterval(() => setCounter(counter - 1), 1000);
      return () => clearInterval(timer);
    }, [counter]);
  
    return (
      <div className="timer">
        <div>Countdown: {counter}</div>
      </div>
    );
  }

  // function usern(text) {
  //   // Inner function isn't a render function
  //   ch_usernum({un: text});
  // }


   /**<div className="column">
          <p>Guesses: {guesses.join(' ')}</p>
        </div>s */
  return (
    
    <div>

<div className="row">
<div className="column">
          <p>Room Code: {name}</p>
        </div>
        </div>

        <div className="timer">
        <div>{timer()}</div>
      </div>

      <div className="row">
        <div className="column">
          <p>Player 1's last guess: {lastGuess1}</p>
        </div>
      
      </div>
        <div className="column">
          <p>Player 1's bulls: {bulls1}</p>
        </div>
        <div className="column">
          <p>Player 1's cows: {cows1}</p>
        </div>

        <div className="row">
        <div className="column">
          <p>Player 2's last guess: {lastGuess2}</p>
        </div>
      </div>
        <div className="column">
          <p>Player 2's bulls: {bulls2}</p>
        </div>
        <div className="column">
          <p>Player 2's cows: {cows2}</p>
        </div>

        <div className="row">
        <div className="column">
          <p>Player 3's last guess: {lastGuess3}</p>
          <p>Player 3's bulls: {bulls3}</p>
          <p>Player 3's cows: {cows3}</p>
        </div>
      {/* </div>
        <div className="column">
        </div>
        <div className="column"> */}

        </div>

        <div className="row">
        <div className="column">
          <p>Player 4's last guess: {lastGuess4}</p>
        </div>
      </div>
        <div className="column">
          <p>Player 4's bulls: {bulls4}</p>
        </div>
        <div className="column">
          <p>Player 4's cows: {cows4}</p>
        </div>

        <div className="row">
      <Controls reset={reset} guess={guess} state={state}/>
      </div>
    </div>
  
    
  );
}


// function timer() {
//   const [countdown, setCD ] =  useState(0);

//   useEffect(() => {
//     const interval = setInterval(() => {
//       setCD(countdown + 1);
//     }, 1000)
//     return () => clearInterval(interval);
//   }, [countdown]);

//   return (
// <div className="column">
//           <p id="timer">Time Left: {countdown}</p>
//         </div>
//   )
// }

// export default timer;


// ch_username1
// ch_username2
// ch_username3
// ch_username4


// if player number entered: 1 
// ch_username1


function Login() {
  const [name, setName] = useState("");

  return (
    <div className="row">
      <div className="column">
        <input type="text"
               value={name}
               onChange={(ev) => setName(ev.target.value)} />
      </div>
      <div className="column">
        <button onClick={() => {ch_login(name)}}>
          Login
        </button>
      </div>
    </div>
  );
}

function Bulls() {
  // render function,
  // should be pure except setState
  const [state, setState] = useState({

    // playerNumber: "",

    // for player 1
    username1: "",
    lastGuess1: [],
    cows1: 0,
    bulls1: 0,

    // for player 2
    username2: "",
    lastGuess2: [],
    cows2: 0,
    bulls2: 0,

    // player 3
    username3: "",
    lastGuess3: [],
    cows3: 0,
    bulls3: 0,

    // player 4
    username4: "",
    lastGuess4: [],
    cows4: 0,
    bulls4: 0,
 
  });

  useEffect(() => {
    ch_join(setState);
  });

  let body = null;

  if (state.name === "") {
    body = <Login />;
  }
  // FIXME: Correct guesses shouldn't count.
  else if (state.bulls1 < 4 && state.bulls2 < 4 && state.bulls3 < 4 && state.bulls4 < 4) {
    body = <Play state={state} />;
  }
  else {
    body = <GameOver reset={reset} />;
  }

  return (
    <div className="container">
      {body}
    </div>
  );
}

export default Bulls;