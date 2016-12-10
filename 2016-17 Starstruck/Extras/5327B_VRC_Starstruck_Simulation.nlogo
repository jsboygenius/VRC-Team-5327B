breed [perimeters perimeter]
breed [fences fence]
breed [tape tape-sing]
breed [poles pole]


breed [robots robot]
breed [bases base]
breed [dumpers dumper]
breed [intakes intake]

breed [cubes cube]
breed [stars star]

breed [robotSketches robotSketch]
breed [frames frame]

globals [
  cstep
  time
  timing?
  BlueScore
  RedScore
  running?
  BlueLoad
  RedLoad
  robotsketch_array
  robot_array
  frames_array
  currFrame
  lastTimeFramed
  TURN_SCALE
  DRIVE_SCALE
]

frames-own [
  frameID
  currentrobot_array
  robotXs
  robotYs
  robotHs
  robotDumps
  robotCaps
  robotEls
  starXs
  starYs
  cubeXs
  cubeYs
  bScore
  rScore
  bLoad
  rLoad
]

stars-own [
  destinationX
  destinationY
  counted?
  inplay?
  status
  ownerID
]

cubes-own [
  destinationX
  destinationY
  counted?
  inplay?
  status
  ownerID
]

robotSketches-own [
  ID
  fdbkdrive_speed
  sidedrive_speed
  intake_type
  intake_reach
  intake_capacity
  dumper_side
  dumper_range
  hang_type
]

robots-own [
  robotID
  robotSketchID
  startingTile
  alliance
  elevation
  current_capacity
  dumpPos
  intaking?
]

bases-own [
  baseID
]

dumpers-own [
  dumperID
]

intakes-own [
  intakeID
]

to startup
  hardreset
end

to reset-field
  clear-drawing
  ask robots
  [
    set current_capacity []
    set elevation "None"
  ]
  set lasttimeframed -5
  set currFrame 0
  set frames_array []
  set timing? false
  set running? false
  set blueLoad 1
  set redLoad 1
  set cstep -1
  set time 0
  set BlueScore 0
  set RedScore 0
  set TURN_SCALE 0.05
  set DRIVE_SCALE 1
  clear-output
  resetbots
  reset-frames
  create-fences 2
  [
    set heading 0
    setxy 23.5 23.25
    set size 47
    set shape "fence"
    set color white
  ]
  ask one-of fences
  [
    repeat 50
    [
      set ycor ycor + 0.01
      stamp
    ]
  ]
  
  ask cubes
  [
    die
  ]
  ask stars
  [
    die
  ]
  create-cubes 2
  [
    set heading 45
    set shape "square"
    set color orange
    set size 7.5
    setxy 23.5 11.5
  ]
  ask one-of cubes
  [
    set ycor 35.5
  ]
  create-stars 2
  [
    set heading 90
    set shape "starstruckstar"
    set color yellow
    set size 10
    setxy 3.5 3.5
  ]
  ask one-of stars 
  [
    set xcor 19.5
    hatch 1
    repeat 2
    [
      set xcor xcor + 4
      hatch 1
    ]
    set xcor 43.5
  ]
  ask stars
  [
    hatch 1
    set ycor 43.5
  ]
  create-stars 1
  [
    set heading 90
    set shape "starstruckstar"
    set color yellow
    set size 10
    setxy 2 23.5
    hatch 1
    repeat 2
    [
      set xcor xcor + 5
      hatch 1
    ]
    set xcor 17.5
    hatch 1
    repeat 3
    [
      set xcor xcor + 4
      hatch 1
    ]
    set xcor 45
    repeat 2
    [
      hatch 1
      set xcor xcor - 5
    ]
  ]
  ask stars [
    set inplay? true
    set status "On Field"
   ]
  ask cubes [
    set inplay? true
    set status "On Field"
    ]
  create-stars 4
  [
    set heading 90
    set shape "starstruckstar"
    set color yellow
    set size 0
    set inplay? false
    set status "Preload"
  ]
  create-cubes 2
  [
    set heading 45
    set shape "square"
    set color orange
    set size 0
    setxy 23.5 11.5
    set inplay? false
    set status "Driver Load"
  ]
end

to hardreset
  ca
  reset-ticks
  reset-field
  set robotsketch_array []
  set robot_array []
  set frames_array []
  ask patches
  [
    set pcolor grey
  ]
  ask patches with [pycor < 8 and ((pxcor >= 8 and pxcor < 16) or (pxcor >= 32 and pxcor < 40)) ]
  [
    set pcolor blue
  ]
  ask patches with [pycor >= 40 and ((pxcor >= 8 and pxcor < 16) or (pxcor >= 32 and pxcor < 40)) ]
  [
    set pcolor red
  ]
  create-perimeters 4
  [
    set color black
    set shape "line"
    set size 96
    set heading 0
    setxy 47.4 23.5
  ]
  ask one-of perimeters
  [
    setxy -0.4 23.5
  ]
  ask one-of perimeters with [xcor = 47.4]
  [
    set heading 90
    setxy 23.5 -0.4
  ]
  ask one-of perimeters with [xcor = 47.4]
  [
    set heading 90
    setxy 23.5 47.4
  ]
  create-tape 4
  [
    set heading 0
    setxy 23.5 23
    set size 47
    set shape "fence"
    set color white
  ]
  ask one-of tape with [ycor = 23] 
  [
    set ycor 24
  ]
  ask one-of tape with [ycor = 23]
  [
    set ycor 11.5 
  ]
  ask one-of tape with [ycor = 23]
  [
    set ycor 35.5
  ]
  create-poles 1
  [
    set heading 0
    set color red
    setxy 46.75 46.75
    set shape "circle 2"
    set size 1.5
    hatch 1
    set color blue
    set ycor 0.25
  ]
  
end

to up
  if running?
  [
    ask robots with [startingtile = robotbeingdriven and elevation = "None"] [
      let checkID robotsketchID
      set xcor (xcor + (sin(heading) * 0.5 * first([fdbkdrive_speed] of robotsketches with [ID = checkID]))) 
      set ycor (ycor + (cos(heading) * 0.5 * first([fdbkdrive_speed] of robotsketches with [ID = checkID])))    
    ]
    rebuildbots
  ]
end

to down
  if running?
  [
    ask robots with [startingtile = robotbeingdriven and elevation = "None"] [
      let checkID robotsketchID
      set xcor (xcor - (sin(heading) * 0.5 * first([fdbkdrive_speed] of robotsketches with [ID = checkID]))) 
      set ycor (ycor - (cos(heading) * 0.5 * first([fdbkdrive_speed] of robotsketches with [ID = checkID])))
    ]
    rebuildbots
  ]
end

to rturn
  if running?
  [
    ask robots with [startingtile = robotbeingdriven and elevation = "None"]  [
      let checkID robotsketchID
      set heading (heading + 10 * first([fdbkdrive_speed] of robotsketches with [ID = checkID]))
    ]
    rebuildbots
  ]
end

to lturn
  if running?
  [
    ask robots with [startingtile = robotbeingdriven and elevation = "None"]  [
      let checkID robotsketchID
      set heading (heading - 10 * first([fdbkdrive_speed] of robotsketches with [ID = checkID]))
    ]
    rebuildbots
  ]
end

to strafeR
  if running?
  [
    ask robots with [startingtile = robotbeingdriven and elevation = "None"]  [
      let checkID robotsketchID
      set xcor (xcor + (sin(heading + 90) * 0.5 * first([sidedrive_speed] of robotsketches with [ID = checkID]))) 
      set ycor (ycor + (cos(heading + 90) * 0.5 * first([sidedrive_speed] of robotsketches with [ID = checkID])))
    ]
    rebuildbots
  ]
end

to strafeL
  if running?
  [
    ask robots with [startingtile = robotbeingdriven and elevation = "None"]  [
      let checkID robotsketchID
      set xcor (xcor - (sin(heading + 90) * 0.5 * first([sidedrive_speed] of robotsketches with [ID = checkID]))) 
      set ycor (ycor - (cos(heading + 90) * 0.5 * first([sidedrive_speed] of robotsketches with [ID = checkID])))
    ]
    rebuildbots
  ]
end

to do_intake
  if running?
  [
    ask robots with [startingtile = robotbeingdriven and elevation = "None"]  [
      set intaking? not intaking?
      let newOwnerID robotID
      ifelse intaking?
      [
      ask stars in-cone 12 60
      [
        set status "intaken"
        set ownerID newOwnerID
      ]
      ask cubes in-cone 12 60
      [
        set status "intaken"
        set ownerID newOwnerID
      ]
      ]
      [
        ask stars with[ownerID = newOwnerID and status = "intaken"]
        [
          set status "on ground"
        ]
        ask cubes with[ownerID = newOwnerID and status = "intaken"]
        [
          set status "on ground"
        ]
      ]
      
    ]
    rebuildbots
  ]
end

to do_dump
 if running?
  [
    ask robots with [startingtile = robotbeingdriven and elevation = "None"]  [
      let newOwnerID robotID
      let newDesX xcor - 17 * dx
      let newDesY ycor - 17 * dy
      ask stars with [ownerID = newOwnerID and status = "intaken"]
      [
        set destinationX newDesX + random 5
        set destinationY newDesY + random 5
        set status "in air"
        set ownerID newOwnerID
      ]
      ask cubes with [ownerID = newOwnerID and status = "intaken"]
      [
        set destinationX newDesX + random 5
        set destinationY newDesY + random 5
        set status "in air"
        set ownerID newOwnerID
      ]
      
    ]
    rebuildbots
  ]
end

to resetbots
  ask robots [
    set heading 0
    ifelse(startingTile = "Alliance Blue")
    [
      setxy 11.5 3.5
      set alliance "Blue"
    ]
    [
      ifelse(startingTile = "Hang Blue")
      [
        setxy 35.5 3.5
        set alliance "Blue"
      ]
      [
        ifelse(startingTile = "Alliance Red")
        [
          setxy 11.5 43.5
          set alliance "Red"
        ]
        [
          setxy 35.5 43.5
          set alliance "Red"
        ]
      ]
    ]
    set elevation "None"
  ]
  rebuildbots
end

to reset-frames
  set frames_array []
  ask frames [
    die
  ]
end

to rebuildbots
  ask intakes [
    let checkID intakeID
    set heading first([heading] of robots with [robotID = checkID])
    set size 15
    setxy first([xcor] of robots with [robotID = checkID]) first([ycor] of robots with[robotID = checkID])
  ]
  ask bases [
    let checkID baseID
    set heading first([heading] of robots with [robotID = checkID])
    set size 15
    setxy first([xcor] of robots with [robotID = checkID]) first([ycor] of robots with[robotID = checkID])
  ]
  ask dumpers [
    let checkID dumperID
    set heading first([heading] of robots with [robotID = checkID])
    set size 15
    setxy first([xcor] of robots with [robotID = checkID]) first([ycor] of robots with[robotID = checkID])
  ]
end

to robotsketchcreate
  let robot_name user-input "Please name the new sketch."
  while [ position robot_name robotsketch_array != false]
  [
    set robot_name user-input "Name already used. Please name the new sketch"
  ]
  set robotsketch_array lput robot_name robotsketch_array
  create-robotsketches 1 [
    set size 0
    set ID robot_name
  ]
  ask robotsketches with [ID = robot_name]
  [
    set fdbkdrive_speed read-from-string(user-input "What speed in fps can your robot move forwards and backwards? (Enter 0 if cannot move fd/bk)") / 2
    set sidedrive_speed read-from-string(user-input "What speed in fps can your robot move sideways? (Enter 0 if cannot move sideways)") / 2
    set intake_type user-one-of "What is your intake type?" ["Claw" "Fork" "Side Rollers"]
    set intake_reach read-from-string(user-input "How many feet in front of the robot is your intake reach?") / 2
    set intake_capacity read-from-string(user-input "How many stars can your intake hold? (Enter 0 if cannot hold)")
    set dumper_side user-one-of "Which side of the robot do you score from" ["Front" "Back"]
    set dumper_range read-from-string(user-input "How many feet beyond the fence can your dumper throw?") / 2
    set hang_type user-one-of "What hang mechanism do you have?" ["None" "Low" "High"]
  ]
  user-message (word "Robot sketch " robot_name " created! (You still need to click Add Robot to add this robot to the field.)")
end

to deletesketch
  let sketch-to-be-deleted user-one-of "Which sketch would you like to delete?" robotsketch_array
  set robotsketch_array remove sketch-to-be-deleted robotsketch_array
  ask robotsketches with [ID = sketch-to-be-deleted]
  [
    die
  ]
end

to importrobotsketch
  let newsketch_array read-from-string user-input "Please enter the exported sketch you would like to import:"
  set robotsketch_array lput first newsketch_array robotsketch_array
  create-robotsketches 1 [
    set ID item 0 newsketch_array
    set fdbkdrive_speed item 1 newsketch_array
    set sidedrive_speed item 2 newsketch_array
    set intake_type item 3 newsketch_array
    set intake_reach item 4 newsketch_array
    set intake_capacity item 5 newsketch_array
    set dumper_side item 6 newsketch_array
    set dumper_range item 7 newsketch_array
    set hang_type item 8 newsketch_array
    set size 0
  ]
end

to exportrobotsketch
  let sketchToExport user-one-of "Which sketch would you like to export?" robotsketch_array
  let exportArray (list
    first([ID] of robotsketches with [ID = sketchToExport]) 
    first([fdbkdrive_speed] of robotsketches with [ID = sketchToExport])
    first([sidedrive_speed] of robotsketches with [ID = sketchToExport])
    first([intake_type] of robotsketches with [ID = sketchToExport])
    first([intake_reach] of robotsketches with [ID = sketchToExport])
    first([intake_capacity] of robotsketches with [ID = sketchToExport])
    first([dumper_side] of robotsketches with [ID = sketchToExport])
    first([dumper_range] of robotsketches with [ID = sketchToExport])
    first([hang_type] of robotsketches with [ID = sketchToExport])
    )
  write exportArray
end

to addrobottofield
  create-robots 1 [
    set intaking? false
    set dumpPos "low"
    set shape "square"
    set heading 0
    set size 7.5
    let desiredrobotID user-input "Enter a name for this robot: (MUST be unique)"
    ask robots with [robotID = desiredrobotID] [die]
    set robot_array remove desiredrobotID robot_array
    set robotID desiredrobotID
    set robot_array lput robotID robot_array
    set robotsketchID user-one-of "Which sketch is this robot based off of?" robotsketch_array
    set startingTile user-one-of "Which starting tile?" ["Alliance Red" "Hang Pole Red" "Alliance Blue" "Hang Pole Blue"]
    set elevation "None"
    set current_capacity [0 0]
    ifelse(startingTile = "Alliance Blue")
    [
      setxy 11.5 3.5
      set alliance "Blue"
    ]
    [
      ifelse(startingTile = "Hang Pole Blue")
      [
        setxy 35.5 3.5
        set alliance "Blue"
      ]
      [
        ifelse(startingTile = "Alliance Red")
        [
          setxy 11.5 43.5
          set alliance "Red"
        ]
        [
          setxy 35.5 43.5
          set alliance "Red"
        ]
      ]
    ]
    set color (position robotID robot_array + 1) * 20 + 5
  ]
  create-intakes 1 [
    set intakeID last robot_array
    set shape (word "intake" first([intake_type] of robotsketches with [ID = first ([robotSketchID] of robots with [robotID = last robot_array])]))
    set heading 0
    set size 15
    setxy first([xcor] of robots with [robotID = last robot_array]) first([ycor] of robots with[robotID = last robot_array])
  ]
  create-bases 1 [
    set baseID last robot_array
    ifelse (first([fdbkdrive_speed] of robotsketches with [ID = first([robotSketchID] of robots with [robotID = last robot_array])]) = 0)
    [
      set shape "driveblank"
    ]
    [
      ifelse (first([sidedrive_speed] of robotsketches with [ID = first([robotSketchID] of robots with [robotID = last robot_array])]) = 0)
      [
        set shape "drivetank"
      ]
      [
        set shape "drivex"
      ]
    ]
    set heading 0
    set size 15
    setxy first([xcor] of robots with [robotID = last robot_array]) first([ycor] of robots with[robotID = last robot_array])
  ]
  create-dumpers 1 [
    set dumperID last robot_array
    set shape "dumperdown"
    set heading 0
    set size 15
    setxy first([xcor] of robots with [robotID = last robot_array]) first([ycor] of robots with[robotID = last robot_array])
  ]
  user-message "Robot Added!"
end

to robotdelete
  let robot-to-be-deleted user-one-of "Which robot would you like to delete?" robot_array
  set robot_array remove robot-to-be-deleted robot_array
  ask robots with [robotID = robot-to-be-deleted]
  [
    die
  ]
  ask intakes with [intakeID = robot-to-be-deleted]
  [
    die
  ]
  ask dumpers with [dumperID = robot-to-be-deleted]
  [
    die
  ]
  ask bases with [baseID = robot-to-be-deleted]
  [
    die
  ]
end


to deleteFrame
  let frameToBeDel user-one-of "Please select a frame to delete:" frames_array
  set frames_array remove frameToBeDel frames_array
  ask frames with [frameID = frameToBeDel]
  [
    die
  ]
end

to add-frame
  create-frames 1 [
    set size 0
    set frameID user-input "Please name this frame: "
    let framesRand length frames_array
    let framesCheck false
    if frameID = ""
    [
      set framesCheck true
    ]
    while [not(position frameID frames_array = false and frameID != "")]
    [
      ifelse framesCHeck
      [
        set frameID word "Frame" framesRand
        set framesRand framesRand + 1
      ]
      [
        set frameID user-input "Invalid frame name. Please name this frame:"
      ]
    ]
    set frames_array lput frameID frames_array
    let temprobotarray []
    let temprobotXarray []
    let temprobotYarray []
    let temprobotHarray []
    let temprobotCAParray []
    let temprobotELarray []
    let temprobotDUMParray []
    let tempstarXarray []
    let tempstarYarray []
    let tempcubeXarray []
    let tempcubeYarray []
    let counter 0
    while [counter < length robot_array]
    [
      ask robots with [robotID = item counter robot_array] [
        set temprobotarray lput robotID temprobotarray
        set temprobotXarray lput xcor temprobotXarray
        set temprobotYarray lput ycor temprobotYarray
        set temprobotHarray lput heading temprobotHarray
        set temprobotCAParray lput current_capacity temprobotCAParray
        set temprobotELarray lput elevation temprobotELarray
        set temprobotDUMParray lput dumpPos temprobotDUMParray
      ]
      set counter counter + 1
    ]
    set counter 0
    ask stars [set counted? false]
    while [counter < 24]
    [
      ask one-of stars with [counted? = false]
      [
        set counted? true
        ifelse inplay?
        [
          set tempstarXarray lput xcor tempstarXarray
          set tempstarYarray lput ycor tempstarYarray
        ]
        [
          set tempstarXarray lput "off" tempstarXarray
          set tempstarYarray lput "off" tempstarYarray
        ]
      ]
      set counter counter + 1
    ]
    set counter 0
    ask cubes [set counted? false]
    while [counter < 4]
    [
      ask one-of cubes with [counted? = false]
      [
        set counted? true
        ifelse inplay?
        [
          set tempcubeXarray lput xcor tempcubeXarray
          set tempcubeYarray lput ycor tempcubeYarray
        ]
        [
          set tempcubeXarray lput "off" tempcubeXarray
          set tempcubeYarray lput "off" tempcubeYarray
        ]
      ]
      set counter counter + 1
    ]
    set currentrobot_array temprobotarray
    set robotXs temprobotXarray
    set robotYs temprobotYarray
    set robotHs temprobotHarray
    set robotCAPs temprobotCAParray
    set robotELs temprobotElarray
    set robotDUMPs temprobotDUMParray
    set starXs tempstarXarray
    set starYs tempstarYarray
    set cubeXs tempcubeXarray
    set cubeYs tempcubeYarray
    set bscore blueScore
    set rscore redScore
    set bload blueload
    set rload redload
  ]
end

to dispFrame [frameBeingDisp]
  let actualFrame one-of frames with [frameID = frameBeingDisp]
  ask robots [
    pen-down
    set pen-size 10
    let indexInArray position robotID robot_array
    setxy item indexInArray [robotXs] of actualFrame item indexInArray [robotYs] of actualFrame
    set heading item indexinarray [robotHs] of actualFrame
    set current_capacity item indexinarray [robotcaps] of actualFrame
    set elevation item indexinarray [robotEls] of actualFrame
    pen-up    
  ]
  rebuildbots
  let counter 0
  let tempstarXs [starXs] of actualFrame
  let tempstarYs [starYs] of actualFrame
  foreach sort-on [who] (stars with [inplay? = true])
  [
    while [first(tempstarXs) = "off"]
      [
        set tempstarXs but-first tempstarXs
        set tempstarYs but-first tempstarYs
      ]
    if [inplay?] of ? = true
      [
        ask ?
        [
          set xcor first(tempstarXs)
          set ycor first(tempstarYs)
        ]
      ]
    set tempstarXs but-first tempstarXs
    set tempstarYs but-first tempstarYs
  ]
end

to showFrame
  let frameToBeDisp user-one-of "Please select a frame to display:" frames_array
  dispFrame frametobedisp
end

to nextframe
  carefully [
    set currframe min list (currFrame + 1) (length frames_array - 1)
  ]
  [
    set currframe 0
  ]dispFrame item currFrame frames_array
end

to previousframe
  carefully[
    set currframe max list (currFrame - 1) (0)
  ]
  [
    set currframe 0
  ]
  dispFrame item currFrame frames_array
end

to go
  if running?
  [
    ask robots
    [
      if (xcor < 3)
      [
        set xcor 3
      ]
      if (ycor < 3)
      [
        set ycor 3
      ]
      if (xcor > 44)
      [
        set xcor 44
      ]
      if (ycor > 20)
      [
        set ycor 20
      ]
      
    ]
    rebuildbots
    ask stars [
  ifelse (status = "in air")
      [
        facexy destinationx destinationy
        let stepDistance 0.02
        if stepDistance > distancexy destinationx destinationy
        [
          set stepDistance distancexy destinationx destinationy
        ]
        fd stepDistance
        if distancexy destinationx destinationy < 0.5
        [
          set status "on ground"
        ]
      ]
      [
        if (status = "intaken")
        [
          let checkID ownerID
          setxy ([xcor] of one-of robots with [robotID = checkID] + 5 * [dx] of one-of robots with [robotID = checkID]) ([ycor] of one-of robots with [robotID = checkID] + 5 * [dy] of one-of robots with [robotID = checkID])
          set heading  who * 10
        ]
      ] 
    ]
    ask cubes [
      ifelse (status = "in air")
      [
        facexy destinationx destinationy
        let stepDistance 0.02
        if stepDistance > distancexy destinationx destinationy
        [
          set stepDistance distancexy destinationx destinationy
        ]
        fd stepDistance
        if distancexy destinationx destinationy < 0.5
        [
          set status "on ground"
        ]
      ]
      [
        if (status = "intaken")
        [
          let checkID ownerID
          setxy ([xcor] of one-of robots with [robotID = checkID] + 5 * [dx] of one-of robots with [robotID = checkID]) ([ycor] of one-of robots with [robotID = checkID] + 5 * [dy] of one-of robots with [robotID = checkID])
        ]
      ] 
      
    ]
    every 1 
    [
      set bluescore 0
      set redscore 0
      ask stars with [ycor > 23.5]
      [
        set bluescore bluescore + 1
      ]
      ask stars with [ycor > 35.5 or distance one-of tape with [ycor = 35.5] < 2]
      [
        set bluescore bluescore + 1
      ]
      ask stars with [ycor < 23.5]
      [
        set redscore redscore + 1
      ]
      ask stars with [ycor < 11.5 or distance one-of tape with [ycor = 11.5] < 2]
      [
        set redscore redscore + 1
      ]
      ask cubes with [ycor > 23.5]
      [
        set bluescore bluescore + 2
      ]
      ask cubes with [ycor > 35.5 or distance one-of tape with [ycor = 35.5] < 2]
      [
        set bluescore bluescore + 2
      ]
      ask cubes with [ycor < 23.5]
      [
        set redscore redscore + 2
      ]
      ask cubes with [ycor < 11.5 or distance one-of tape with [ycor = 11.5] < 2]
      [
        set redscore redscore + 2
      ]
    ]
    ifelse not Practice?
    [
      commentary
    ]
    [
      if cstep < 4
      [
        output-print "Practice! No timer and unlimited frames creation,"
        output-print "but rules are still enforced"
      ]
      set time 90
      set cstep 4
    ]
    if timing?
    [
      set time timer
      if time >= lasttimeframed + 2
      [
        set lasttimeframed lasttimeframed + 2
        create-frames 1 [
          set size 0
          set frameID word "Frame" lasttimeframed
          
          set frames_array lput frameID frames_array
          let temprobotarray []
          let temprobotXarray []
          let temprobotYarray []
          let temprobotHarray []
          let temprobotCAParray []
          let temprobotELarray []
          let temprobotDUMParray []
          let tempstarXarray []
          let tempstarYarray []
          let tempcubeXarray []
          let tempcubeYarray []
          let counter 0
          while [counter < length robot_array]
          [
            ask robots with [robotID = item counter robot_array] [
              set temprobotarray lput robotID temprobotarray
              set temprobotXarray lput xcor temprobotXarray
              set temprobotYarray lput ycor temprobotYarray
              set temprobotHarray lput heading temprobotHarray
              set temprobotCAParray lput current_capacity temprobotCAParray
              set temprobotELarray lput elevation temprobotELarray
              set temprobotDUMParray lput dumpPos temprobotDUMParray
            ]
            set counter counter + 1
          ]
          set counter 0
          ask stars [set counted? false]
          while [counter < 24]
          [
            ask one-of stars with [counted? = false]
            [
              set counted? true
              ifelse inplay?
              [
                set tempstarXarray lput xcor tempstarXarray
                set tempstarYarray lput ycor tempstarYarray
              ]
              [
                set tempstarXarray lput "off" tempstarXarray
                set tempstarYarray lput "off" tempstarYarray
              ]
            ]
            set counter counter + 1
          ]
          set counter 0
          ask cubes [set counted? false]
          while [counter < 4]
          [
            ask one-of cubes with [counted? = false]
            [
              set counted? true
              ifelse inplay?
              [
                set tempcubeXarray lput xcor tempcubeXarray
                set tempcubeYarray lput ycor tempcubeYarray
              ]
              [
                set tempcubeXarray lput "off" tempcubeXarray
                set tempcubeYarray lput "off" tempcubeYarray
              ]
            ]
            set counter counter + 1
          ]
          set currentrobot_array temprobotarray
          set robotXs temprobotXarray
          set robotYs temprobotYarray
          set robotHs temprobotHarray
          set robotCAPs temprobotCAParray
          set robotELs temprobotElarray
          set robotDUMPs temprobotDUMParray
          set starXs tempstarXarray
          set starYs tempstarYarray
          set cubeXs tempcubeXarray
          set cubeYs tempcubeYarray
          set bscore blueScore
          set rscore redScore
          set bload blueload
          set rload redload
        ]
      ]
      ask robots [
        pu
      ]
      wait 0.01
    ]
      ]
end
  

to commentary
end

to generateCode
  file-close-all
  file-open user-new-file
  let fileName user-input "Enter a name for this routine:"
  file-print "//Automatically generated code via VRC 5327B Starstruck Simulation"
  file-print (word "void " fileName "()")
  file-print "{"
  let currentFrameCode 1
  let initialX 0
  let initialY 0
  let initialH 0
  let endX 0
  let endY 0
  let endH 0
  let desiredRobotIndex 0
  ask robots with [startingtile = robotbeingdriven]
  [
    set desiredRobotIndex position robotID robot_array
  ]
  ask frames with [frameID = item 0 frames_array]
    [
      set endX item desiredRobotIndex robotXs
      set endY item desiredRobotIndex robotYs
      set endH item desiredRobotIndex robotHs
    ]
  while [currentFrameCode < length frames_array]
  [
    set initialX endX
    set initialY endY
    set initialH endH
    ask frames with [frameID = item currentFrameCode frames_array]
    [
      file-print word "  //" frameID
      set endX item desiredRobotIndex robotXs
      set endY item desiredRobotIndex robotYs
      set endH item desiredRobotIndex robotHs
    ]
    if endH != initialH
    [
      let turn abs(TURN_SCALE * (initialH - endH))
      ifelse initialH < endH
      [
        file-print (word "  ABase(0, 0, 127, " round(turn) ");")
      ]
      [
        file-print (word "  ABase(0, 0, -127, " round(turn) ");")
      ]
    ]
    if endX != initialX or endY != initialY
    [
      let distanceToTravel sqrt((endX - initialX) ^ 2 + (endY - initialY) ^ 2)
      let straight distanceToTravel * DRIVE_SCALE
      let xcomp endX - initialX
      let ycomp endY - initialY
      let angle (atan xcomp ycomp) - initialH
      let xpower round(127 * cos(angle))
      let ypower round(127 * sin(angle)) 
      file-print (word "  ABase(" xpower ", " ypower ", 0, " round(straight) ");")
    ]
    set currentFrameCode currentFrameCode + 1
  ]
  file-print "}"
  file-close-all
end
@#$#@#$#@
GRAPHICS-WINDOW
482
10
1068
617
-1
-1
12.0
1
10
1
1
1
0
0
0
1
0
47
0
47
0
0
1
ticks
120.0

BUTTON
121
208
184
241
Up
up
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
121
241
184
274
Down
down
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
184
241
247
274
Right
strafeR
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
58
241
121
274
Left
strafeL
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
184
208
247
241
RTurn
rturn
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

BUTTON
58
208
121
241
LTurn
lturn
NIL
1
T
OBSERVER
NIL
Q
NIL
NIL
1

BUTTON
58
273
153
306
Intake
do_intake
NIL
1
T
OBSERVER
NIL
J
NIL
NIL
1

BUTTON
152
273
247
306
Dump/Launch
do_dump
NIL
1
T
OBSERVER
NIL
K
NIL
NIL
1

CHOOSER
58
318
196
363
RobotBeingDriven
RobotBeingDriven
"Alliance Red" "Hang Pole Red" "Alliance Blue" "Hang Pole Blue"
2

BUTTON
195
318
288
363
Reset Field
reset-field\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
288
318
384
363
Start Match
if(running? = false)\n[\nset running? True\n]\ngo
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1144
107
1290
140
Import Robot Sketch
importrobotsketch
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1144
41
1290
74
Create Robot Sketch
robotSketchCreate\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1144
74
1290
107
Delete Robot Sketch
deleteSketch\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1144
140
1290
173
Export Robot Sketch
exportRobotSketch\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1305
41
1409
74
Add Robot
addrobottofield\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1305
74
1409
107
Delete Robot
robotdelete
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1305
107
1409
140
HARD RESET
hardreset\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1144
185
1410
230
Robot Sketches
robotsketch_array
17
1
11

MONITOR
1144
230
1409
275
Robots
robot_array
17
1
11

BUTTON
1144
286
1249
319
Add Frame
add-frame\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1249
286
1354
319
Delete Frame
deleteframe\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1144
319
1249
352
Display Frame
showFrame
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1249
319
1354
352
Reset Frames
reset-frames\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1144
364
1354
409
Frames
frames_array
17
1
11

MONITOR
1362
363
1445
408
Current Frame
currFrame
17
1
11

BUTTON
1144
457
1261
490
Previous Frame
previousframe\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1144
424
1261
457
Next Frame
nextframe
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1261
424
1378
457
Import Match Film
NIL
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1261
457
1378
490
Export Match Film
NIL
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1144
490
1378
523
Generate ROBOTC Code
generateCode\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
58
375
163
408
Practice?
Practice?
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

both
true
0
Rectangle -2674135 true false 120 195 180 210
Rectangle -2674135 true false 120 90 180 105

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

driveblank
true
0

drivetank
true
0
Rectangle -14835848 true false 90 90 105 120
Rectangle -14835848 true false 90 180 105 210
Rectangle -14835848 true false 195 90 210 120
Rectangle -14835848 true false 195 180 210 210
Rectangle -16777216 false false 90 90 105 120
Rectangle -16777216 false false 195 90 210 120
Rectangle -16777216 false false 195 180 210 210
Rectangle -16777216 false false 90 180 105 210

drivex
true
0
Polygon -14835848 true false 90 120 105 135 135 105 120 90 90 120
Polygon -14835848 true false 210 120 195 135 165 105 180 90 210 120
Polygon -14835848 true false 90 180 105 165 135 195 120 210 90 180
Polygon -14835848 true false 210 180 195 165 165 195 180 210 210 180
Polygon -16777216 false false 90 180 105 165 135 195 120 210
Polygon -16777216 false false 90 120 105 135 135 105 120 90
Polygon -16777216 false false 210 120 195 135 165 105 180 90
Polygon -16777216 false false 210 180 195 165 165 195 180 210

dumperdown
true
0
Rectangle -8630108 true false 105 105 120 210
Rectangle -8630108 true false 180 105 195 210
Rectangle -8630108 true false 105 105 195 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fence
true
0
Line -7500403 true 0 150 300 150

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

front
true
0
Rectangle -2674135 true false 120 105 180 120

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

intakeclaw
true
0
Rectangle -13840069 true false 135 90 165 105
Line -13840069 false 75 15 135 90
Line -13840069 false 225 15 165 90

intakefork
true
0
Rectangle -13840069 true false 105 90 195 105
Line -13840069 false 105 15 105 90
Line -13840069 false 135 15 135 90
Line -13840069 false 165 15 165 90
Line -13840069 false 195 15 195 90

intakeside rollers
true
0
Rectangle -13840069 true false 105 90 195 105
Line -13840069 false 120 60 105 90
Line -13840069 false 180 60 195 90
Circle -13840069 true false 105 45 30
Circle -13840069 true false 165 45 30

launcher
true
0
Circle -2674135 true false 103 103 92
Rectangle -1184463 true false 135 60 165 165

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

perimeter
true
0
Rectangle -7500403 true true 0 135 300 165

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

plaunchback
true
0
Rectangle -8630108 true false 165 135 195 195
Polygon -13345367 true false 165 150 180 165 195 150 180 135 165 150
Rectangle -16777216 false false 165 135 195 195

plaunchfront
true
0
Rectangle -8630108 true false 165 105 195 165
Polygon -13345367 true false 165 150 180 135 195 150 180 165 165 150
Rectangle -16777216 false false 165 105 195 165

plaunchnone
true
0

pole
true
0
Circle -7500403 false true 135 135 30

robot
true
0
Polygon -16777216 true false 75 105 105 75 120 90 90 120
Polygon -16777216 true false 75 105 105 75 120 90 90 120
Polygon -16777216 true false 195 75 225 105 210 120 180 90
Polygon -16777216 true false 180 210 210 180 225 195 195 225
Polygon -16777216 true false 105 225 75 195 90 180 120 210
Polygon -7500403 true true 90 120 90 180 120 210 135 180 135 165 165 165 165 180 180 210 210 180 210 120 180 90 165 120 165 135 135 135 135 120 120 90
Rectangle -2674135 true false 135 90 165 105

rollerback
true
0
Polygon -10899396 true false 105 210 105 195 195 195 195 210 105 210
Rectangle -16777216 false false 105 195 195 210

rollerboth
true
0
Polygon -10899396 true false 105 210 105 195 195 195 195 210 105 210
Polygon -10899396 true false 105 105 105 90 195 90 195 105 105 105
Rectangle -16777216 false false 105 195 195 210
Rectangle -16777216 false false 105 90 195 105

rollerfront
true
0
Polygon -10899396 true false 105 90 105 105 195 105 195 90 105 90
Rectangle -16777216 false false 105 90 195 105

rollers
true
0
Rectangle -13840069 true false 105 135 135 165
Rectangle -13840069 true false 165 135 195 165
Circle -13840069 true false 165 150 30
Circle -13840069 true false 165 120 30
Circle -13840069 true false 105 150 30
Circle -13840069 true false 105 120 30

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

slaunchback
true
0
Rectangle -5825686 true false 105 135 135 195
Polygon -13345367 true false 135 150 120 165 105 150 120 135 135 150
Rectangle -16777216 false false 105 135 135 195

slaunchfront
true
0
Rectangle -5825686 true false 105 105 135 165
Polygon -13345367 true false 135 150 120 135 105 150 120 165 135 150
Rectangle -16777216 false false 105 105 135 165

slaunchnone
true
0

square
true
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

starstruckstar
true
0
Polygon -1184463 true false 165 165 150 225 135 165 90 105 150 135 210 105 165 165
Polygon -1184463 true false 135 135 150 75 165 135 210 195 150 165 90 195 135 135

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
