/**
 * Example that loads up election data and draws something with it.
 */

// window size (it's a square)
final int WINDOW_SIZE = 400;
// how many milliseconds to show each state for
final int MILLIS_PER_STATE= 1000;
 
// will hold our anti-aliased font
PFont font;
// when did we last change states?
int lastStateMillis = 0;
// loads and holds the data in the election results CSV
ElectionData data;
// holds a list of state postal codes
String[] statePostalCodes;
// what index in the statePostalCodes array are we current showing
int currentStateIndex = 0;


int n = 100;
int x;
float y = .05;
float noiseY;
int vote = 0;

/**
 * This is called once at the start to initialize things
 **/
void setup() {
  // create the main window
  size(WINDOW_SIZE, WINDOW_SIZE);
  // load the font
  font = createFont("Helvetica",20,true);
  // load in the election results data
  data = new ElectionData(loadStrings("data/2012_US_election_state.csv"));
  statePostalCodes = data.getAllStatePostalCodes();
  print("Loaded data for "+data.getStateCount()+" states");
}

/**
 * This is called repeatedly
 */
void draw() {
  println(vote);
  // only update if it's has been MILLIS_PER_STATE since the last time we updated
  if ((millis() - lastStateMillis >= MILLIS_PER_STATE )) {
    // reset everything
    background(255);
    stroke(100);
    
    // draw the state name
    textFont(font,20);
    fill(0,0,0,150);  // Grey
    String currentPostalCode = statePostalCodes[currentStateIndex];
    StateData state = data.getState(currentPostalCode);
    text(state.name,WINDOW_SIZE/2-180,WINDOW_SIZE/9);
    
    if (vote == 0){

      // draw the obama vote count and title
      
      for(int i = 1; i < n; i++) {
        y += .02;
        x = i* (width/n);
        noiseY = noise(y) * height;
        println(noiseY);
        line(x, height, x, noiseY+Math.round(state.pctForObama));
        line(x+100, height, x, noiseY+Math.round(state.pctForObama));
      }
      
      textFont(font,15);
      fill(0,0,0,100);  // Grey
      text("Obama",WINDOW_SIZE/2-146,WINDOW_SIZE/7);
      text(Math.round(state.pctForObama)+"%",WINDOW_SIZE/2-180,WINDOW_SIZE/7);
      lastStateMillis = millis();
      vote++;
      
    }else if (vote ==1){

      // draw the romney vote count and title
      
      for(int i = 1; i < n; i++) {
        y += .02;
        x = i* (width/n);
        noiseY = noise(y) * height;
        line(x, height, x, noiseY+Math.round(state.pctForRomney));
        line(x+100, height, x, noiseY+Math.round(state.pctForRomney));
      }
      
      textFont(font,15);
      fill(0,0,0,100);  // Grey
      text("Romney",WINDOW_SIZE/2-146,WINDOW_SIZE/7);
      text(Math.round(state.pctForRomney)+"%",WINDOW_SIZE/2-180,WINDOW_SIZE/7);
      // update which state we're showing
      vote = 0;
      currentStateIndex = (currentStateIndex+1) % statePostalCodes.length;
      // update the last time we drew a state
      lastStateMillis = millis();
      
    }
  }
}

