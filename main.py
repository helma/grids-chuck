#!/usr/bin/env python2
import random, math, time
import pygame
import pygame.midi
from nodes import *

pygame.midi.init() 
midiin = pygame.midi.Input(5)
midiout = pygame.midi.Output(4)

class Grids:

    channel = 11
    instruments = [0,1,2]
    #notes = [[37,1],[38,2],[39,3]]
    notes = [37,38,39]
    #accents = [53,55,57]
    cc_x = 71
    cc_y = 72
    cc_chaos = 73
    cc_fill = [74,75,76]

    def __init__(self,nodes):
        self.x = 50
        self.y = 17
        self.ticks = 0
        self.step = 0
        self.chaos = 0.0
        self.perturbations = [random.random(),random.random(),random.random()]
        self.fill = [86,4,34]
        self.running = False
        self.playing = []
        
        self.drum_map = [
            [ nodes[10], nodes[8], nodes[0], nodes[9], nodes[11] ],
            [ nodes[15], nodes[7], nodes[13], nodes[12], nodes[6] ],
            [ nodes[18], nodes[14], nodes[4], nodes[5], nodes[3] ],
            [ nodes[23], nodes[16], nodes[21], nodes[1], nodes[2] ],
            [ nodes[24], nodes[19], nodes[17], nodes[20], nodes[22] ]
        ]

    def read_drum_map(self,instrument):

        i = int(math.floor(self.x*3.0 / 127)) #scaling??
        j = int(math.floor(self.y*3.0 / 127))

        # retrieve the 4 nodes surrounding the selected zone
        a_map = self.drum_map[i][j]
        b_map = self.drum_map[i + 1][j]
        c_map = self.drum_map[i][j + 1]
        d_map = self.drum_map[i + 1][j + 1]

        # calculate position in each node
        offset = (instrument * 32) + self.step

        # retrieve value from each node
        a = a_map[offset]
        b = b_map[offset]
        c = c_map[offset]
        d = d_map[offset]

        #print instrument
        #print a,b,c,d

        # calculate (interpolate) Density
        return ((a*self.x+b*(127-self.x))*self.y + (c*self.x+d*(127-self.x)) * (127-self.y))/127/127

    def evaluate_drums(self):
      for i in self.instruments:
          # At the beginning of a pattern, decide on perturbation levels.
          if (self.step == 0):
              self.perturbations = [random.random(),random.random(),random.random()]

          level = self.read_drum_map(i)
          #print level
          if (level < 255 - self.chaos * self.perturbations[i]):
              level += self.perturbations[i]
          else:
              level = 255

          threshold = self.fill[i]
          if (level > threshold): # play drum
            if (level > 192): # play accent
              midiout.note_on(self.notes[i],100,self.channel-1)
              #self.play(self.notes[i],127)
            else:
              midiout.note_on(self.notes[i],50,self.channel-1)
              #self.play(self.notes[i],50)

            self.playing.append(self.notes[i])
            #print(self.notes[i],self.channel)

    def play(self,note,level):
      # TODO fix: play in threads or play @ clock ticks
      midiout.note_on(note, level, 2)
      time.sleep(.1)
      midiout.note_off(note, level, 2)

grids = Grids(nodes)

while True:
  if midiin.poll():
    event = midiin.read(1)[0][0]
    # http://www.midi.org/techspecs/midimessages.php
    # TODO: fix start/stop/cont (OT Specs)
    #print event
    if event[0] == 250: # start
      grids.ticks = 0
      grids.step = 0
      grids.running = True
    elif event[0] == 251: # continue
      grids.running = True
    elif event[0] == 252: # stop
      grids.running = False
    elif grids.running: 
      if event[0] == 248: # clock
        grids.ticks = (grids.ticks + 1) % ( 32 * 6 )
        if ((grids.ticks % 6) == 0): # 16th
          #print "-"
          #print grids.step
          #print "-"
          grids.evaluate_drums()
        elif ((grids.ticks % 6) == 5): # 16th
          grids.step = (grids.step+1)%32
          for n in grids.playing:
            midiout.note_off(n, 0, grids.channel-1)
    # cc updates
    elif event[0] == 175+grids.channel: # cc
      if event[1] == grids.cc_x:
        grids.x = event[2]
      elif event[1] == grids.cc_y:
        grids.y = event[2]
      elif event[1] == grids.cc_chaos:
        grids.chaos = event[2]
      elif event[1] == grids.cc_fill[0]:
        grids.fill[0] = event[2]
      elif event[1] == grids.cc_fill[1]:
        grids.fill[1] = event[2]
      elif event[1] == grids.cc_fill[2]:
        grids.fill[2] = event[2]

      #else:
        #print event

del midiin
del midiout
pygame.midi.quit()

