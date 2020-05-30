import java.util.*;

//GLOBAL VARIABLES AND OBJECTS
int screen = 0; 
int inittime = calculateTime(); //time since program first opened
int time = inittime; //current time
color THEME1 = #e84a5f;
color THEME2 = #ff847c;
color THEME3 = #feceab;
color THEME4 = #99b898;
color THEME2v2 = #ffdddb;
ArrayList<Task> tasks = new ArrayList<Task>(); 

/*
 screen 0 = main screen dashboard
 screen 1 = add task screen
 screen 2 = individual task
 */

//"Add Task" page
int frames = 0;
boolean cursor = false;
Field typedName = new Field("Topic Name");

//”Task specification” page
int selectedTask = 0;

//Button Instantiations
Button[] dash = {new Button(530, 725, 75), new Button(70, 725, 75), new Button(62, 127, 75), new Button(162, 127, 75), new Button(262, 127, 75)}; 
// refresh, add task (slide 0), back, delete, review (slide 2)
int buttonPressed = -1;

boolean adding = false;


//Font/Image Setup
PFont bold;
PFont plain;
PImage refresh;

//"Do once" method
void setup() { 
  size (600, 800);
  bold = loadFont("LeelawadeeUI-Bold-48.vlw");
  plain = loadFont("LeelawadeeUI-30.vlw");
  refresh = loadImage("https://p1.hiclipart.com/preview/762/574/379/black-n-white-white-refresh-icon-png-clipart.jpg", "jpg");
  tasks.add(new Task("chapter 1"));
  tasks.add(new Task("chapter 2"));
}

//"Repeat Forever" method
void draw() {
  background(255);
  textSize(30);
  fill(0);

  if (screen == 0) {
    background(THEME3);

    fill(THEME1); // top bar
    noStroke();
    rect(0, 0, 600, 100);

    textSize(50);  // "Dashboard"
    fill(THEME3);
    textFont(bold);
    text("Dashboard", 25, 70);

    if(!adding) {
      dash[1].drawButton(THEME1); //draw dashboard buttons
      image(refresh, 70, 725);
      dash[0].drawButton(THEME1);
    }
    
    fill(THEME3);
    rect(526, 698, 10, 55, 5);
    rect(503, 720, 55, 10, 5);


    int taskY = 200;
    fill(THEME1);
    rect(10, taskY-90, 580, 40, 25);
    textFont(plain, 25);
    fill(THEME3);
    text("Task Name", 25, taskY-62);
    text("Amount of Info Retained", 300, taskY-62);

    for (Task t : tasks) { // draw topics that are currently being reviewed
      t.y = taskY;
      t.drawTask();
      taskY += 80;
    }
  } 


if(adding) addNewTopic();

  if (screen == 2) {
    background(THEME3);
    fill(THEME1); 
    noStroke();
    rect(0, 0, 600, 200);
    fill(THEME3);
    textFont(bold, 40);
    Task selected = tasks.get(selectedTask);
    text(selected.name + " Specifications", 25, 60);
    
    //buttons
    dash[2].drawButton(THEME3);
    dash[3].drawButton(THEME3);
    dash[4].drawButton(THEME3);

  displayData(selected);
  }


  time = calculateTime();
}


// static methods
static int calculateTime() {
  int hour = hour();
  int minute = minute();
  int second = second();
  return 3600*hour+60*minute+second;
}


//classes
class Task {
  String name; //name of task
  int objTime; //time in which this object was instantiated
  int y;
  double retentionRate;
  int month, day, hour, min, second;
  int timesReviewed;


  Task() {
  }

  Task (String name) {
    this.name = name;
    objTime = time;
    timesReviewed = 1;
    retentionRate = 100;
    updateDate();
  }
  
  void updateDate(){
     month = month();
     day = day();
     hour = hour();
     min = minute();
     second = second();
  }
  
  void review(){
      timesReviewed++;
      updateDate();
  }

  void drawTask() {
    fill(THEME2);
    rect(10, y-45, 580, 75, 25);
    textSize(50);
    fill(THEME3);
    textFont(plain);
    text(name, 25, y);
    text(nf((float)retentionRate, 0, 2), 300, y);
  }

  void calculateRetention() {
    int timePassed = time - objTime;
    double retention = 100 * Math.exp(-1*(((double)timePassed/3600)/(double)(timesReviewed)));
    retentionRate = retention;
  }
}



class Button {
  int x, y;
  float diameter;

  Button(int x, int y, float diameter) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
  }

  void drawButton(color rgb) {
    fill(rgb);
    noStroke();
    circle(x, y, diameter);
  }
}

class Field {
  String name;
  int y;
  String userTyped = "";

  Field(String n) {
    name = n;
  }
}

void refresh() {
  for (int j = 0; j < tasks.size(); j++) {
    tasks.get(j).calculateRetention();
  }

  Collections.sort(tasks, new Comparator<Task>() {
    public int compare(Task a, Task b) {
      if (a.retentionRate < b.retentionRate) return -1;
      else if (a.retentionRate > b.retentionRate) return 1;
      else return (a.name.compareTo(b.name));
    }
  }
  );
}

void displayData(Task t){
  fill(THEME1);
  textSize(40);
  textFont(plain);
  text("Current Estimated Retained % of Data: ", 10, 300);
 text(nf((float)t.retentionRate, 0, 2), 10, 350);
  text("Last time you studied: ", 10, 400); 
 text(t.month +  "/" + t.day + " at " + t.hour + ":" + t.min + ":" + (int)t.second, 10, 450);
}

void addNewTopic (){
    noStroke();
    fill(#FFFFFF);
    rect(10, height-90, 480, 40, 25);

    frames++;
    if (frames % 30 == 0) cursor = !cursor;

  
    textSize(20);
    if (typedName.userTyped.isEmpty()) {
      fill(#898686);
      text("Please type in topic and press Enter.", 20, height-60);
      fill(#000000);
      if(cursor) text("|", 20, height-60);
    } else {
      fill(#000000);
      if (cursor) text(typedName.userTyped + "|", 20, height-60);
      else text(typedName.userTyped + "|", 20, height-60);
    }
  }


void mousePressed() {
  if (screen == 0) {
    for (int i = 0; i < dash.length; i++) {
      Button b = dash[i];
      if (mouseX >= b.x-(b.diameter/2) && mouseX <= b.x+(b.diameter/2) && mouseY >= b.y-(b.diameter/2) && mouseY <= b.y+(b.diameter/2)) {
        buttonPressed = i;
      } 
    }
    
    for (int k = 0; k < tasks.size(); k++) {
        if (mouseX >= 10 && mouseX <= 590 && mouseY >= 150+(80*k) && mouseY <= 225+(80*k)) {
          selectedTask = k;
          screen = 2;
        }
      }

    if (buttonPressed == 0) {
      adding = !adding;
      
    } else if (buttonPressed == 1) {
      refresh();
    }

    buttonPressed = -1;
  }

  if (screen == 2) {
    if (mouseX >= 25 && mouseX <= 100 && mouseY >= 90 && mouseY <= 165) {
      screen = 0;
    } else if (mouseX >= 125 && mouseX <= 200 && mouseY >= 90 && mouseY <= 165) {
      tasks.remove(selectedTask);
      screen = 0;
    } else if (mouseX >= 225 && mouseX <= 300 && mouseY >= 90 && mouseY <= 165) {
      Task selected = tasks.get(selectedTask);
      selected.retentionRate = 100;
      selected.objTime = time;
      selected.review();
    }
  }
}

void keyPressed() {
  if (adding) {
    if (key == ENTER || key == RETURN  || key == TAB ||keyCode == LEFT) {
      // move down a field
        screen = 0;
        Task add = new Task(typedName.userTyped); 
        tasks.add(add);
        adding = false;
        typedName.userTyped = "";
    } else if (key == BACKSPACE) {
      String currTyping = typedName.userTyped;
      if (currTyping.length() > 0) currTyping = currTyping.substring(0, currTyping.length() - 1);
      typedName.userTyped = currTyping;
    } else {
      typedName.userTyped += key;
    }
  }
}
