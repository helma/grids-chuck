#!/usr/bin/env python2
import random, math, time
import pygame
import pygame.midi
#import random, fnmatch, time

pygame.midi.init() 
midiout = pygame.midi.Output(2)
midiout.note_on(53, 100, 2)
time.sleep(.25)
midiout.note_off(53, 100, 2)

del midiout
pygame.midi.quit()
